from pgvector.sqlalchemy import VECTOR
from sqlalchemy import Column, Integer, ForeignKey, SmallInteger, Text, TIMESTAMP, func, UniqueConstraint, Index
from sqlalchemy.dialects.postgresql import JSONB

from app.db.base import Base


class PlaceEmbedding(Base):
    __tablename__ = 'placeembedding'

    id = Column(Integer, primary_key=True, autoincrement=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete='CASCADE'), nullable=False)
    chunk_index = Column(SmallInteger, nullable=False, server_default="0")
    chunk_text = Column(Text, nullable=False)
    embedding = Column(VECTOR(768), nullable=False)
    metadata_ = Column('metadata', JSONB)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    # UNIQUE (place_id, chunk_index) đã phủ chiều place_id
    __table_args__ = (
        UniqueConstraint('place_id', 'chunk_index'),
        # ANN cho search_similar_places(): ORDER BY embedding <=> query
        Index('idx_placeembedding_vector', 'embedding',
              postgresql_using='hnsw',
              postgresql_ops={'embedding': 'vector_cosine_ops'}),
    )