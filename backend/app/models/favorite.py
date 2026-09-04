from sqlalchemy import Column, Integer, ForeignKey, TIMESTAMP, func, Index

from app.db.base import Base


class Favorite(Base):
    __tablename__ = 'favorite'
    user_id = Column(Integer, ForeignKey("users.id", ondelete='CASCADE'), primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), primary_key=True)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    # PK (user_id, place_id) đã phủ chiều user_id; chiều place_id cần cho
    # get_top_places() outerjoin Favorite và cho ON DELETE CASCADE của place
    __table_args__ = (
        Index('ix_favorite_place_id', 'place_id'),
    )