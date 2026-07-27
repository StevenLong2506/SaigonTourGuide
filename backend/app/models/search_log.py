from sqlalchemy import Column, Integer, ForeignKey, Text, TIMESTAMP, func
from sqlalchemy.dialects.postgresql import JSONB
from sqlalchemy.orm import relationship

from app.db.base import Base


class SearchLog(Base):
    __tablename__ = 'searchlog'
    id = Column(Integer, primary_key=True, autoincrement=True)
    user_id = Column(Integer, ForeignKey("users.id", ondelete="SET NULL"))
    query_text = Column(Text, nullable=False)
    filters = Column(JSONB)
    result_count = Column(Integer)
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    user = relationship('User', lazy=True)