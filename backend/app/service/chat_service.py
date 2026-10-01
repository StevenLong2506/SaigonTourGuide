import logging

from fastapi import HTTPException, status

from app import settings
from app.db.uow import UnitOfWork
from app.models import User
from app.models.enums import MessageRole
from app.repository.chat_repository import ChatRepository
from app.repository.user_repository import UserRepository
from app.schemas.chat import ChatRequest
from app.service.rag_service import RagService, NO_RESULT_ANSWER

logger = logging.getLogger(__name__)


def _build_profile_text(user: User):
    parts = []
    profile = user.travel_profile
    if profile:
        if profile.travel_style:
            parts.append(f'phong cách {profile.travel_style.value}')
        if profile.budget_level:
            parts.append(f'ngân sách {profile.budget_level.value}')
        if profile.with_children:
            parts.append('đi cùng trẻ em')
        if profile.with_elderly:
            parts.append('đi cùng người lớn tuổi')

    tag_names = [u.tag.name for u in user.interests if u.tag]
    if tag_names:
        parts.append('sở thích: ' + ', '.join(tag_names))

    return '; '.join(parts) if parts else None


class ChatService:
    def __init__(self, repo: ChatRepository, user_repo: UserRepository, rag_service: RagService, uow: UnitOfWork):
        self.repo = repo
        self.user_repo = user_repo
        self.rag_service = rag_service
        self.uow = uow

    def send_message(self, payload: ChatRequest, user_id: int):
        if payload.session_id and not self.repo.get_session(session_id=payload.session_id, user_id=user_id):
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy phiên chat')
        user = self.user_repo.get_full(user_id=user_id)
        try:
            prompt, places = self.rag_service.prepare_answer(
                query=payload.message, user_profile=_build_profile_text(user), ward=payload.ward,
                max_price=payload.max_price
            )
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

        self.uow.end_read()
        if prompt is None:
            answer = NO_RESULT_ANSWER
        else:
            try:
                answer = self.rag_service.complete_answer(prompt=prompt)
            except Exception:
                logger.exception('Gọi Gemini thất bại')
                raise HTTPException(status_code=status.HTTP_503_SERVICE_UNAVAILABLE,
                                    detail='Trợ lý AI tạm thời không phản hồi, vui lòng thử lại sau.')

        with self.uow.transaction():
            session = (
                self.repo.get_session(session_id=payload.session_id, user_id=user_id) if payload.session_id else None)
            if session is None:
                session = self.repo.create_session(user_id=user_id, title=payload.message[:50])
            self.repo.add_message(session_id=session.id, role=MessageRole.USER, content=payload.message)
            self.repo.add_message(session_id=session.id, role=MessageRole.ASSISTANT, content=answer,
                                  model_used=settings.CHAT_MODEL if prompt else None)
            self.repo.touch_session(session)

        return {'session_id': session.id, 'answer': answer, 'places': places}

    def list_sessions(self, user_id: int):
        return self.repo.get_sessions_by_user(user_id=user_id)

    def get_session_detail(self, session_id: int, user_id: int):
        session = self.repo.get_session(session_id=session_id, user_id=user_id)
        if not session:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy phiên chat')
        return session
