from sqlalchemy import Column, Integer, ForeignKey, Text, TIMESTAMP, func, Index
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship

from app.db.base import Base


class TripRequest(Base):
    __tablename__='triprequest'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    raw_query = Column(Text, nullable=False)
    duration_day = Column(Integer)
    parsed_prefs = Column(JSONB)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ = (
        Index('ix_triprequest_user_id', 'user_id'),
    )

    itineraries = relationship("Itinerary", backref="trip_request", cascade="all, delete-orphan", lazy=True)
