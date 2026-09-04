from sqlalchemy import Column, Integer, String, Text, DECIMAL, Time, Boolean, Enum, ForeignKey, TIMESTAMP, func, \
    Index, text
from sqlalchemy.orm import relationship

from app.db.base import Base
from app.models.enums import PlaceStatus


class Place(Base):
    __tablename__ = 'place'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(100), nullable=False)
    address = Column(String(200), nullable=False)
    description = Column(Text, nullable=False)
    ward = Column(String(50), nullable=False)
    link_google_map = Column(String(300), nullable=False)
    phone = Column(String(15))
    website = Column(String(200))
    price_min = Column(DECIMAL(12,0), nullable=False, server_default="0")
    price_max = Column(DECIMAL(12, 0), nullable=False, server_default="0")
    opening_time = Column(Time, nullable=False)
    closing_time = Column(Time, nullable=False)
    open_days = Column(String(100), nullable=False)
    average_rating = Column(DECIMAL(2,1), nullable=False, server_default="0")
    total_reviews = Column(Integer, nullable=False, server_default="0")
    total_views = Column(Integer, nullable=False, server_default="0")
    is_featured = Column(Boolean, nullable=False, server_default="false")
    status = Column(Enum(PlaceStatus, native_enum=False), server_default="ACTIVE", nullable=False)
    created_by = Column(Integer, ForeignKey("users.id", ondelete='SET NULL'))
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    updated_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    __table_args__ = (
        Index('ix_place_created_by', 'created_by'),
        Index('ix_place_name', 'name'),
        # list_full(): filter status + ORDER BY created_at DESC
        Index('ix_place_status_created_at', 'status', text('created_at DESC')),
        # search_places() theo PlaceSortBy
        Index('ix_place_status_total_views', 'status', text('total_views DESC')),
        Index('ix_place_status_rating', 'status',
              text('average_rating DESC'), text('total_reviews DESC')),
        Index('ix_place_status_price_min', 'status', 'price_min'),
        Index('ix_place_status_price_max', 'status', text('price_max DESC')),
        # filter ward + list_wards() GROUP BY ward
        Index('ix_place_status_ward', 'status', 'ward'),
        Index('ix_place_featured_status', 'status',
              postgresql_where=text('is_featured')),
        # search_places(): ILIKE '%q%' trên name/address/description
        Index('ix_place_name_trgm', 'name',
              postgresql_using='gin', postgresql_ops={'name': 'gin_trgm_ops'}),
        Index('ix_place_address_trgm', 'address',
              postgresql_using='gin', postgresql_ops={'address': 'gin_trgm_ops'}),
        Index('ix_place_description_trgm', 'description',
              postgresql_using='gin', postgresql_ops={'description': 'gin_trgm_ops'}),
    )

    categories = relationship('PlaceCategory', backref='place', lazy=True, cascade='all, delete-orphan')
    tags = relationship('PlaceTag', backref='place', lazy=True, cascade='all, delete-orphan')
    age_groups = relationship('PlaceAgeGroup', backref='place', lazy=True, cascade='all, delete-orphan')
    images = relationship('PlaceImage', backref='place', lazy=True, cascade='all, delete-orphan')
    reviews = relationship('Review', backref='place', lazy=True, cascade='all, delete-orphan')
    favorite_by = relationship("Favorite", backref="place", cascade="all, delete-orphan", lazy=True)
    visited_by = relationship("VisitedPlace", backref="place", cascade="all, delete-orphan", lazy=True)
    embeddings = relationship("PlaceEmbedding", backref="place", cascade="all, delete-orphan", lazy=True)

    @property
    def primary_image(self):
        for img in self.images:
            if img.is_primary:
                return img.img_url