from sqlalchemy import Integer, Column, ForeignKey, SmallInteger, String, Text, Date, Enum, TIMESTAMP, func, \
    UniqueConstraint, Index, text
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship

from app.db.base import Base
from app.models.enums import ReviewStatus


class Review(Base):
    __tablename__ = "review"

    id = Column(Integer, primary_key=True, autoincrement=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), nullable=False)
    user_id = Column(Integer, ForeignKey('users.id', ondelete='CASCADE'), nullable=False)
    rating = Column(SmallInteger, nullable=False)
    title = Column(String(255))
    content = Column(Text)
    images = Column(JSONB)
    visit_date = Column(Date)
    status = Column(Enum(ReviewStatus, native_enum=False), server_default="APPROVED", nullable=False)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    updated_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ = (
        UniqueConstraint("place_id", "user_id"),
        Index('ix_review_user_id', 'user_id'),
        # calculate_place_rating(): AVG/COUNT theo place_id + status = APPROVED
        Index('ix_review_place_status', 'place_id', 'status'),
        # list_full() phía admin: filter status + ORDER BY created_at DESC
        Index('ix_review_status_created_at', 'status', text('created_at DESC')),
    )
    user = relationship('User', lazy=True)