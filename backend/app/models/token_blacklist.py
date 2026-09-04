from sqlalchemy import Integer, Column, String, ForeignKey, TIMESTAMP, func, Index

from app.db.base import Base


class TokenBlackList(Base):
    __tablename__ = 'tokenblacklist'

    id = Column(Integer, primary_key=True, autoincrement=True)
    jti = Column(String(64), nullable=False, unique=True, index=True)
    user_id = Column(Integer, ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    expires_at = Column(TIMESTAMP, nullable=False)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ =(
        Index('ix_tokenblacklist_expires_at', 'expires_at'),
        Index('ix_tokenblacklist_user_id', 'user_id'),
    )