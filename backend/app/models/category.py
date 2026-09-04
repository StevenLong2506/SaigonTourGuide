from sqlalchemy import Column, Integer, ForeignKey, TIMESTAMP, func, String, Index
from sqlalchemy.orm import relationship

from app.db.base import Base


class Category(Base):
    __tablename__ = 'category'

    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), nullable=False)
    description = Column(String(255))
    parent_id = Column(Integer, ForeignKey('category.id', ondelete='SET NULL'))
    created_at = Column(TIMESTAMP, server_default=func.now(), nullable=False)

    __table_args__ = (
        Index('ix_category_parent_id', 'parent_id'),
        Index('ix_category_name', 'name'),
    )

    parent = relationship("Category", backref='children', remote_side=[id], lazy=True)
    place_cates = relationship('PlaceCategory', backref='category',lazy=True)