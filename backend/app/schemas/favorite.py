from datetime import datetime

from pydantic import BaseModel

from app.schemas.place import PlaceResponse


class FavoriteCreate(BaseModel):
    place_id: int

class FavoriteResponse(BaseModel):
    created_at: datetime
    place: PlaceResponse
    
    class Config:
        from_attributes = True
