from sqlalchemy import Column, Integer, ForeignKey, Enum, Text, String, TIMESTAMP, func

from app.db.base import Base
from app.models.enums import UserRole, MessageRole


class ChatMessage(Base):
    __tablename__ = 'chatmessage'

    id = Column(Integer, primary_key=True, autoincrement=True)
    session_id = Column(Integer, ForeignKey('chatsession.id', ondelete='CASCADE'), nullable=False)
    user_role = Column(Enum(MessageRole, native_enum=False), nullable=False)
    content = Column(Text, nullable=False)
    model_used = Column(String(100))
    token_used = Column(Integer, server_default="0")
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())