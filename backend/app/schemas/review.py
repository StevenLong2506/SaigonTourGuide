from datetime import date, datetime

from pydantic import BaseModel, Field, field_validator

from app.models.enums import ReviewStatus


class ReviewBase(BaseModel):
    rating: int = Field(ge=1, le=5)
    title: str | None = None
    content: str | None = None
    visit_date: date | None = None
    images: list[str] = []

    @field_validator('images', mode='before')
    @classmethod
    def default_images(cls, v):
        return v if v is not None else []


class ReviewCreate(ReviewBase):
    pass


class ReviewUpdate(BaseModel):
    rating: int | None = Field(default=None, ge=1, le=5)
    title: str | None = None
    content: str | None = None
    visit_date: date | None = None



class ReviewUserResponse(BaseModel):
    name: str
    avatar: str | None = None

    class Config:
        from_attributes = True

class ReviewResponse(ReviewBase):
    id: int
    place_id: int
    user_id: int
    user: ReviewUserResponse
    status: ReviewStatus
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes = True


class ReviewStatusUpdate(BaseModel):
    status: ReviewStatus


