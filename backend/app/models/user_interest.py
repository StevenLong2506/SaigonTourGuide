from sqlalchemy import Column, Integer, ForeignKey, SmallInteger

from app.db.base import Base


class UserInterest(Base):
    __tablename__ = 'userinterest'
    user_id = Column(Integer, ForeignKey('users.id', ondelete='CASCADE'), primary_key=True)
    tag_id = Column(Integer, ForeignKey('interesttag.id', ondelete='CASCADE'), primary_key=True)
    priority = Column(SmallInteger, nullable=False, server_default="1")