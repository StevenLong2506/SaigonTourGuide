from datetime import date, datetime

from pydantic import BaseModel, Field

from app.models.enums import ReviewStatus


class ReviewBase(BaseModel):
    rating: int = Field(ge=1, le=5)
    title: str | None = None
    content: str | None = None
    visit_date: date | None = None


class ReviewCreate(ReviewBase):
    pass

class ReviewUpdate(BaseModel):
    rating: int | None = Field(default=None, ge=1, le=5)
    title: str | None = None
    content: str | None = None
    visit_date: date | None = None

class ReviewResponse(ReviewBase):
    id: int
    place_id: int
    user_id: int
    status: ReviewStatus
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ReviewStatusUpdate(BaseModel):
    status: ReviewStatus