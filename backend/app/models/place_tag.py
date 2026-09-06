from sqlalchemy import Column, Integer, ForeignKey, DECIMAL, Index

from app.db.base import Base


class PlaceTag(Base):
    __tablename__ = 'placetag'
    tag_id = Column(Integer, ForeignKey('interesttag.id', ondelete='CASCADE'), primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), primary_key=True)
    relevance = Column(DECIMAL(3,2), server_default="1.0", nullable=False)

    # PK (tag_id, place_id) đã phủ chiều tag_id
    __table_args__ = (
        Index('ix_placetag_place_id', 'place_id'),
    )