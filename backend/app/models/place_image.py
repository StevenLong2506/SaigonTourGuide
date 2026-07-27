from sqlalchemy import Column, Integer, ForeignKey, String, Boolean, TIMESTAMP, func

from app.db.base import Base


class PlaceImage(Base):
    __tablename__ = 'placeimage'
    id = Column(Integer, autoincrement=True, primary_key=True)
    place_id = Column(Integer, ForeignKey('place.id', ondelete="CASCADE"))
    img_url = Column(String(500), nullable=False)
    caption = Column(String(255))
    is_primary = Column(Boolean, nullable=False, server_default="false")
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())