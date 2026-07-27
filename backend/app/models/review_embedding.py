from pgvector.sqlalchemy import VECTOR
from sqlalchemy import Column, Integer, ForeignKey, Text, TIMESTAMP, func, UniqueConstraint
from sqlalchemy.orm import relationship

from app.db.base import Base


class ReviewEmbedding(Base):
    __tablename__ = 'reviewembedding'

    id = Column(Integer, autoincrement=True, primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), nullable=False)
    review_id = Column(Integer, ForeignKey('review.id', ondelete='CASCADE'), nullable=False)
    chunk_text = Column(Text, nullable=False)
    chunk_index = Column(Integer, nullable=False, server_default="0")
    embedding = Column(VECTOR, nullable=False)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ = (
        UniqueConstraint('chunk_index', 'review_id'),
    )

    place = relationship("Place", lazy=True)