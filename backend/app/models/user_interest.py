from sqlalchemy import Column, Integer, ForeignKey, SmallInteger, Index

from app.db.base import Base


class UserInterest(Base):
    __tablename__ = 'userinterest'
    user_id = Column(Integer, ForeignKey('users.id', ondelete='CASCADE'), primary_key=True)
    tag_id = Column(Integer, ForeignKey('interesttag.id', ondelete='CASCADE'), primary_key=True)
    priority = Column(SmallInteger, nullable=False, server_default="1")

    # PK (user_id, tag_id) đã phủ chiều user_id, chiều tag_id cần index riêng
    __table_args__ = (
        Index('ix_userinterest_tag_id', 'tag_id'),
    )