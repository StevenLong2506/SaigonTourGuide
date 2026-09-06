from sqlalchemy import Column, Integer, ForeignKey, Index

from app.db.base import Base


class PlaceCategory(Base):
    __tablename__ = 'placecategory'
    category_id = Column(Integer, ForeignKey('category.id', ondelete='CASCADE'),primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id',ondelete='CASCADE'), primary_key=True)

    # PK (category_id, place_id) đã phủ chiều category_id
    __table_args__ = (
        Index('ix_placecategory_place_id', 'place_id'),
    )
