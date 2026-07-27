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

    class Config:
        from_attributes = True
