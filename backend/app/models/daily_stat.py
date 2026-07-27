from sqlalchemy import Column, Integer, Date, ForeignKey, UniqueConstraint
from sqlalchemy.orm import relationship

from app.db.base import Base


class DailyStat(Base):
    __tablename__ = 'dailystat'
    id = Column(Integer, autoincrement=True, primary_key=True)
    stat_date = Column(Date, nullable=False)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), nullable=False)
    view_count = Column(Integer, nullable=False, server_default="0")
    favorite_count = Column(Integer, nullable=False, server_default="0")
    review_count = Column(Integer, nullable=False, server_default="0")
    search_count = Column(Integer, nullable=False, server_default="0")
    __table_args__ = (
        UniqueConstraint("stat_date", "place_id"),
    )

    place = relationship("Place", lazy=True)