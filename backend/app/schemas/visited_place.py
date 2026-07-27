from datetime import date, datetime

from pydantic import BaseModel

from app.models.enums import VisitedPlaceSource
from app.schemas.place import PlaceResponse


class VisitedPlaceCreate(BaseModel):
    place_id: int
    visited_at: date | None = None

class VisitedPlaceResponse(BaseModel):
    id: int
    visited_at: date | None = None
    source: VisitedPlaceSource
    created_at: datetime
    place: PlaceResponse

    class Config:
        from_attributes = True