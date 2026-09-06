from pydantic import BaseModel


class OverviewResponse(BaseModel):
    total_places: int
    active_places: int
    pending_places: int
    featured_places: int
    total_reviews: int
    pending_reviews: int
    total_users: int
    total_views: int
    average_rating: float


class TopPlaceResponse(BaseModel):
    id: int
    name: str
    ward: str
    total_views: int
    total_reviews: int
    average_rating: float
    favorite_count: int
