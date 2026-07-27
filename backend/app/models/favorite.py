from sqlalchemy import Column, Integer, ForeignKey, TIMESTAMP, func

from app.db.base import Base


class Favorite(Base):
    __tablename__ = 'favorite'
    user_id = Column(Integer, ForeignKey("users.id", ondelete='CASCADE'), primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), primary_key=True)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())