from sqlalchemy import Column, Integer, ForeignKey, Text, TIMESTAMP, func, Index, text
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

    __table_args__ = (
        Index('ix_searchlog_user_id', 'user_id'),
        Index('ix_searchlog_created_at', text('created_at DESC')),
        # _aggregate(): GROUP BY lower(trim(query_text)).
        # Viết đúng dạng Postgres chuẩn hoá khi lưu (trim -> TRIM(BOTH FROM ...))
        # để alembic autogenerate không hiểu nhầm là index đã đổi.
        Index('ix_searchlog_keyword', text('lower(TRIM(BOTH FROM query_text))')),
        # zero_result_keywords(): filter result_count = 0
        Index('ix_searchlog_zero_result', text('created_at DESC'),
              postgresql_where=text('result_count = 0')),
    )

    user = relationship('User', lazy=True)