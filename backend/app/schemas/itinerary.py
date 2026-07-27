from datetime import time, datetime, date

from pydantic import BaseModel


class ItineraryItemBase(BaseModel):
    place_id: int | None = None
    day_number: int
    start_time: time | None = None
    end_time: time | None = None
    note: str | None = None
    transport_mode: str | None = None
    sort_order: int = 1


class ItineraryItemCreate(ItineraryItemBase):
    pass


class ItineraryItemResponse(ItineraryItemBase):
    id: int
    created_at: datetime

    class Config:
        from_attributes = True


# ================================================================================================


class ItineraryBase(BaseModel):
    title: str
    description: str | None = None
    start_date: date | None = None
    end_date: date | None = None
    num_people: int | None = None


class ItineraryCreate(ItineraryBase):
    items: list[ItineraryItemCreate] = []


class ItineraryUpdate(BaseModel):
    title: str | None = None
    description: str | None = None
    start_date: date | None = None
    end_date: date | None = None
    num_people: int | None = None


class ItineraryResponse(ItineraryBase):
    id: int
    user_id: int
    trip_request_id: int | None = None
    share_code: str | None = None
    option_number: int | None = None
    created_at: datetime
    updated_at: datetime
    items: list[ItineraryItemResponse] = []

    class Config:
        from_attributes = True
