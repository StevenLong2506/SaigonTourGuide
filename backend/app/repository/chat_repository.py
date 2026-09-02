from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models import ChatSession, ChatMessage
from app.models.enums import MessageRole
from app.repository.base import BaseRepository


class ChatRepository(BaseRepository[ChatSession]):
    def __init__(self, db: Session):
        super().__init__(ChatSession, db)

    def create_session(self, user_id: int, title: str | None = None) -> ChatSession:
        return self.create(ChatSession(user_id=user_id, title=title))

    def get_session(self, session_id: int, user_id: int) -> ChatSession | None:
        return self.db.query(ChatSession).filter_by(id=session_id, user_id=user_id).first()

    def get_sessions_by_user(self, user_id: int) -> list[ChatSession]:
        return self.db.query(ChatSession).filter_by(user_id=user_id).order_by(ChatSession.updated_at.desc()).all()

    def add_message(self, session_id:int, role: MessageRole, content: str, model_used: str|None=None) -> ChatMessage:
        msg = ChatMessage(session_id=session_id, model_used=model_used, content=content, user_role=role)
        return self.create(msg)

    def touch_session(self, session: ChatSession):
        session.updated_at=func.now()
        self.db.commit()


