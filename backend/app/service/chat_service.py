from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app import settings
from app.models import User
from app.models.enums import MessageRole
from app.repository.chat_repository import ChatRepository
from app.repository.user_repository import UserRepository
from app.schemas.chat import ChatRequest
from app.service.rag_service import answer_question


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
    def __init__(self, db: Session):
        self.db = db
        self.repo = ChatRepository(db)
        self.user_repo = UserRepository(db)

    def send_message(self, payload: ChatRequest, user_id: int):
        if payload.session_id:
            session = self.repo.get_session(session_id=payload.session_id, user_id=user_id)
            if not session:
                raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy phiên chat')
        else:
            session = self.repo.create_session(user_id=user_id, title=payload.message[:50])

        self.repo.add_message(session_id=session.id, role=MessageRole.USER, content=payload.message)

        user = self.user_repo.get_full(user_id)
        profile_text = _build_profile_text(user)
        try:
            result = answer_question(
                db=self.db, query=payload.message, user_profile=profile_text, ward=payload.ward,
                max_price=payload.max_price,
            )
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

        self.repo.add_message(session_id=session.id, role=MessageRole.ASSISTANT, content=result['answer'],
                              model_used=settings.CHAT_MODEL)
        self.repo.touch_session(session)

        return {'session_id': session.id, 'answer': result['answer'], 'places': result['places']}

    def list_sessions(self, user_id: int):
        return self.repo.get_sessions_by_user(user_id=user_id)

    def get_session_detail(self, session_id: int, user_id: int):
        session = self.repo.get_session(session_id=session_id, user_id=user_id)
        if not session:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy phiên chat')
        return session
