from sqlalchemy import Integer, Column, ForeignKey, Enum, TIMESTAMP, func, Boolean

from app.db.base import Base
from app.models.enums import TravelStyle, BudgetLevel


class UserTravelProfile(Base):
    __tablename__ = 'usertravelprofile'
    user_id = Column(Integer, ForeignKey('users.id', ondelete='CASCADE'), primary_key=True)
    travel_style = Column(Enum(TravelStyle, native_enum=False))
    budget_level = Column(Enum(BudgetLevel, native_enum=False))
    with_children = Column(Boolean, nullable=False, server_default="false")
    with_elderly = Column(Boolean, nullable=False, server_default="false")
    updated_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

