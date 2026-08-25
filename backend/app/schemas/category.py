from datetime import datetime

from pydantic import BaseModel


class CategoryBase(BaseModel):
    name: str
    description: str | None = None


class CategoryCreate(CategoryBase):
    parent_id: int | None = None


class CategoryUpdate(BaseModel):
    name: str | None = None
    description: str | None = None
    parent_id: int | None = None


class CategoryParentInfo(BaseModel):
    id: int
    name: str

    class Config:
        from_attributes = True


class CategoryResponse(CategoryBase):
    id: int
    parent: CategoryParentInfo | None = None
    created_at: datetime
    place_count: int = 0
    class Config:
        from_attributes = True
