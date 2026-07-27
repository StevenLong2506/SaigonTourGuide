from enum import Enum


class Gender(str, Enum):
    MALE = 'MALE'
    FEMALE = "FEMALE"
    OTHER = "OTHER"


class UserRole(str, Enum):
    ADMIN = 'ADMIN'
    USER = 'USER'


class BudgetLevel(str, Enum):
    LOW = 'LOW'
    MEDIUM = 'MEDIUM'
    HIGH = 'HIGH'


class TravelStyle(str, Enum):
    SOLO = 'SOLO'
    COUPLE = 'COUPLE'
    FAMILY = 'FAMILY'
    GROUP = 'GROUP'


class PlaceStatus(str, Enum):
    ACTIVE = "ACTIVE"
    CLOSED = "CLOSED"
    PENDING = "PENDING"


class AgeGroup(str, Enum):
    CHILDREN = 'CHILDREN'
    TEENAGER = 'TEENAGER'
    YOUNG_ADULT = 'YOUNG_ADULT'
    ADULT = 'ADULT'
    MIDDLE_AGE = 'MIDDLE_AGE'
    SENIOR = 'SENIOR'

class ReviewStatus(str, Enum):
    APPROVED ='APPROVED'
    PENDING = "PENDING"
    REJECTED = 'REJECTED'

class VisitedPlaceSource(str, Enum):
    MANUAL = 'MANUAL'

class MessageRole(str, Enum):
    USER = "USER"
    ASSISTANT = "ASSISTANT"
    SYSTEM = "SYSTEM"

class TopPlaceOrderBy(str,Enum):
    VIEWS='VIEWS'
    RATING='RATING'
    REVIEWS='REVIEWS'
    FAVORITES='FAVORITES'


class PlaceSortBy(str, Enum):
    POPULAR='POPULAR'
    RATING = 'RATING'
    NEWEST = 'NEWEST'
    PRICE_ASC = 'PRICE_ASC'
    PRICE_DESC = 'PRICE_DESC'