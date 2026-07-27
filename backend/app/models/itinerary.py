from sqlalchemy import Column, Integer, ForeignKey, String, Text, Date, SmallInteger, TIMESTAMP, func
from sqlalchemy.orm import relationship

from app.db.base import Base


class Itinerary(Base):
    __tablename__ = 'itinerary'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="CASCADE"), nullable=False)
    trip_request_id = Column(Integer, ForeignKey("triprequest.id", ondelete="CASCADE"))
    title = Column(String(255), nullable=False)
    description = Column(Text)
    start_date = Column(Date)
    end_date = Column(Date)
    num_people = Column(SmallInteger, nullable=False, server_default="1")
    share_code = Column(String(50), unique=True)
    option_number = Column(SmallInteger)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    updated_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    items = relationship(
        "ItineraryItem", backref="itinerary",
        cascade="all, delete-orphan",
        order_by="ItineraryItem.day_number, ItineraryItem.sort_order",
        lazy=True
    )
