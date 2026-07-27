from sqlalchemy import Column, Integer, Date, String, Enum, Boolean, TIMESTAMP, func
from sqlalchemy.orm import relationship

from app.db.base import Base
from app.models.enums import Gender, UserRole


class User(Base):
    __tablename__ = 'users'
    id = Column(Integer, primary_key=True, autoincrement=True)
    name = Column(String(50), nullable=False)
    username = Column(String(20), unique=True, nullable=False)
    hash_password = Column(String(255), nullable=False)
    avatar = Column(String(255))
    email = Column(String(100), nullable=False, unique=True)
    phone = Column(String(15), nullable=False)
    date_of_birth = Column(Date, nullable=False)
    gender = Column(Enum(Gender, native_enum=False), nullable=False)
    is_active = Column(Boolean, server_default="true", nullable=False)
    user_role = Column(Enum(UserRole, native_enum=False), server_default="USER")
    created_at = Column(TIMESTAMP, nullable=False, server_default=func.now())
    updated_at = Column(TIMESTAMP, nullable=False, server_default=func.now())

    travel_profile = relationship('UserTravelProfile', backref='user',
                                  cascade='all, delete-orphan', uselist=False,
                                  lazy=True)
    interests = relationship('UserInterest', backref='user', cascade='all, delete-orphan', lazy=True)
    favorites = relationship('Favorite', backref='user', cascade='all, delete-orphan', lazy=True)
    visited_place = relationship('VisitedPlace', backref='user', cascade='all, delete-orphan', lazy=True)
    itineraries = relationship('Itinerary', backref='user', cascade='all, delete-orphan', lazy=True)
    trip_requests = relationship('TripRequest', backref='user', cascade='all, delete-orphan', lazy=True)
    chat_sessions = relationship('ChatSession', backref='user', cascade='all, delete-orphan', lazy=True)
    places_created = relationship('Place', backref='creator', lazy=True)