from sqlalchemy import Column, Integer, String, TIMESTAMP, func
from sqlalchemy.orm import relationship

from app.db.base import Base


class InterestTag(Base):
    __tablename__ = 'interesttag'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), nullable=False, unique=True)
    created_at = Column(TIMESTAMP, server_default=func.now(), nullable=False)

    user_interests = relationship('UserInterest', backref='tag', lazy=True)
    place_tags = relationship('PlaceTag', backref='tag', lazy=True)
