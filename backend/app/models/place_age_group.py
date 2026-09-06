from sqlalchemy import Column, Integer, ForeignKey, Enum, SmallInteger, Index

from app.db.base import Base
from app.models.enums import AgeGroup


class PlaceAgeGroup(Base):
    __tablename__ = 'placeagegroup'
    id = Column(Integer, autoincrement=True, primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete="CASCADE"))
    age_group = Column(Enum(AgeGroup, native_enum=False), nullable=False)
    suitability = Column(SmallInteger, nullable=False, server_default="3")

    # EXISTS(place_id = ? AND age_group = ? AND suitability >= ?)
    __table_args__ = (
        Index('ix_placeagegroup_place_age_suit', 'place_id', 'age_group', 'suitability'),
    )