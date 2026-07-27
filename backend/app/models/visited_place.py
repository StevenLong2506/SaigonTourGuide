from sqlalchemy import Column, Integer, ForeignKey, UniqueConstraint, Enum, TIMESTAMP, func, Date

from app.db.base import Base
from app.models.enums import VisitedPlaceSource


class VisitedPlace(Base):
    __tablename__ = 'visitedplace'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), nullable=False)
    source = Column(Enum(VisitedPlaceSource, native_enum=False), server_default="MANUAL", nullable=False)
    visited_at=Column(Date)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ = (
        UniqueConstraint("user_id", "place_id"),
    )