from sqlalchemy.orm import Session

from app.models import TripRequest
from app.repository.base import BaseRepository


class TripRequestRepository(BaseRepository[TripRequest]):
    def __init__(self, db: Session):
        super().__init__(TripRequest, db)

    def create_trip_request(self, user_id:int, raw_query: str, duration_day: int|None):
        trip = TripRequest(user_id=user_id, raw_query=raw_query, duration_day=duration_day)
        return self.create(trip)