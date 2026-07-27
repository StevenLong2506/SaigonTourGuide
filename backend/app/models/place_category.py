from sqlalchemy import Column, Integer, ForeignKey

from app.db.base import Base


class PlaceCategory(Base):
    __tablename__ = 'placecategory'
    category_id = Column(Integer, ForeignKey('category.id', ondelete='CASCADE'),primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id',ondelete='CASCADE'), primary_key=True)
