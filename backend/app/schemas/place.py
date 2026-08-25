from datetime import time, datetime
from decimal import Decimal

from pydantic import BaseModel, Field

from app.models.enums import PlaceStatus, AgeGroup, PlaceSortBy
from app.schemas.category import CategoryResponse
from app.schemas.interest_tag import InterestTagResponse


class PlaceImageBase(BaseModel):
    img_url: str
    caption: str | None = None
    is_primary: bool = False


class PlaceImageCreate(PlaceImageBase):
    pass


class PlaceImageResponse(PlaceImageBase):
    id: int

    class Config:
        from_attributes = True


class PlaceTagCreate(BaseModel):
    tag_id: int
    relevance: Decimal = Field(default=Decimal('1.0'), ge=0, le=1)


class PlaceTagResponse(BaseModel):
    relevance: Decimal
    tag: InterestTagResponse

    class Config:
        from_attributes = True


class PlaceAgeGroupBase(BaseModel):
    age_group: AgeGroup
    suitability: int = Field(default=3, ge=1, le=5)


class PlaceAgeGroupCreate(PlaceAgeGroupBase):
    pass


class PlaceAgeGroupResponse(PlaceAgeGroupBase):
    class Config:
        from_attributes = True


class PlaceBase(BaseModel):
    name: str
    description: str
    address: str
    ward: str
    link_google_map: str
    phone: str | None = None
    website: str | None = None
    price_min: Decimal = Decimal("0")
    price_max: Decimal = Decimal("0")
    opening_time: time
    closing_time: time
    open_days: str


class PlaceCreate(PlaceBase):
    is_featured: bool = False
    status: PlaceStatus = PlaceStatus.ACTIVE
    category_ids: list[int] = []
    tags: list[PlaceTagCreate] = []
    age_groups: list[PlaceAgeGroupCreate] = []
    images: list[PlaceImageCreate] = []


class PlaceUpdate(BaseModel):
    name: str | None = None
    description: str | None = None
    address: str | None = None
    ward: str | None = None
    link_google_map: str | None = None
    phone: str | None = Field(default=None, min_length=10)
    website: str | None = None
    price_min: Decimal | None = None
    price_max: Decimal | None = None
    opening_time: time | None = None
    closing_time: time | None = None
    open_days: str | None = None
    is_featured: bool | None = None
    status: PlaceStatus | None = None
    category_ids: list[int] | None = None
    tags: list[PlaceTagCreate] | None = None
    age_groups: list[PlaceAgeGroupCreate] | None = None


class PlaceResponse(PlaceBase):
    id: int
    average_rating: Decimal
    total_reviews: int
    total_views: int
    is_featured: bool
    status: PlaceStatus
    created_by: int | None = None
    created_at: datetime
    updated_at: datetime

    categories: list[CategoryResponse] = []
    tags: list[PlaceTagResponse] = []
    age_groups: list[PlaceAgeGroupResponse] = []
    images: list[PlaceImageResponse] = []

    class Config:
        from_attributes = True


class PlaceStatusUpdate(BaseModel):
    status: PlaceStatus


class PlaceFeaturedUpdate(BaseModel):
    is_featured: bool


class PlaceSummaryResponse(BaseModel):
    id: int
    name: str
    address: str
    ward: str
    average_rating: Decimal
    total_reviews: int
    total_views: int
    is_featured: bool
    status: PlaceStatus
    primary_image: str | None = None
    opening_time: time
    closing_time: time

    class Config:
        from_attributes = True


class PlaceSearchResponse(BaseModel):
    total: int
    skip: int
    limit: int
    sort_by: PlaceSortBy
    items: list[PlaceSummaryResponse] = []


class WardCountResponse(BaseModel):
    ward: str
    total: int
