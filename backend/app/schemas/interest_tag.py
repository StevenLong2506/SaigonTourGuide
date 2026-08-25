from datetime import datetime

from pydantic import BaseModel


class InterestTagBase(BaseModel):
    name: str


class InterestTagCreate(InterestTagBase):
    pass


class InterestTagUpdate(BaseModel):
    name: str | None = None


class InterestTagResponse(InterestTagBase):
    id: int
    created_at: datetime
    place_count: int = 0
    user_count: int = 0

    class Config:
        from_attributes = True
