from sqlalchemy import Column, Integer, ForeignKey, DECIMAL

from app.db.base import Base


class PlaceTag(Base):
    __tablename__ = 'placetag'
    tag_id = Column(Integer, ForeignKey('interesttag.id', ondelete='CASCADE'), primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), primary_key=True)
    relevance = Column(DECIMAL(3,2), server_default="1.0", nullable=False)