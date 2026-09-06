from sqlalchemy import Column, Integer, ForeignKey, SmallInteger, Time, Text, String, func, TIMESTAMP, Index
from sqlalchemy.orm import relationship

from app.db.base import Base


class ItineraryItem(Base):
    __tablename__='itineraryitem'
    id = Column(Integer, primary_key=True, autoincrement=True)
    itinerary_id = Column(Integer, ForeignKey("itinerary.id", ondelete="CASCADE"), nullable=False)
    place_id = Column(Integer, ForeignKey("place.id", ondelete="SET NULL"))
    day_number = Column(SmallInteger, nullable=False)
    start_time = Column(Time)
    end_time = Column(Time)
    note = Column(Text)
    transport_mode = Column(String(20))
    sort_order = Column(SmallInteger, nullable=False, server_default="1")
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ = (
        # relationship items: ORDER BY day_number, sort_order
        Index('ix_itineraryitem_itinerary_day_sort', 'itinerary_id', 'day_number', 'sort_order'),
        Index('ix_itineraryitem_place_id', 'place_id'),
    )

    place = relationship("Place", lazy=True)