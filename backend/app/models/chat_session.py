from sqlalchemy import Column, Integer, ForeignKey, String, TIMESTAMP, func, Index, text
from sqlalchemy.orm import relationship

from app.db.base import Base


class ChatSession(Base):
    __tablename__ = 'chatsession'

    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    title = Column(String(255))
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    updated_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ = (
        # get_sessions_by_user(): filter user_id + ORDER BY updated_at DESC
        Index('ix_chatsession_user_updated', 'user_id', text('updated_at DESC')),
    )

    messages = relationship('ChatMessage',
                            backref='session',
                            cascade="all, delete-orphan",
                            order_by="ChatMessage.created_at",
                            lazy=True)