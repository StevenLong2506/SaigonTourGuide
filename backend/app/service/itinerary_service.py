import secrets

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.repository.itinerary_repository import ItineraryRepository
from app.repository.trip_request_repository import TripRequestRepository
from app.schemas.itinerary import ItineraryCreate, ItineraryUpdate, TripRequestCreate
from app.service import rag_service


class ItineraryService:
    def __init__(self, db: Session):
        self.db = db
        self.repo = ItineraryRepository(db)
        self.trip_repo = TripRequestRepository(db)

    def create(self, user_id: int, data: ItineraryCreate):
        try:
            return self.repo.create_itinerary(user_id=user_id, data=data)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    def get_owned(self, itinerary_id: int, user_id: int):
        itinerary = self.repo.get_owned(itinerary_id=itinerary_id, user_id=user_id)
        if not itinerary:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy lịch trình')

        return itinerary

    def list_mine(self, user_id: int):
        return self.repo.get_by_user(user_id=user_id)

    def update(self, itinerary_id: int, user_id: int, data: ItineraryUpdate):
        itinerary = self.get_owned(itinerary_id=itinerary_id, user_id=user_id)
        return self.repo.update_itinerary(itinerary=itinerary, data=data)

    def delete(self, itinerary_id: int, user_id: int):
        itinerary = self.get_owned(itinerary_id=itinerary_id, user_id=user_id)
        self.repo.delete_itinerary(itinerary=itinerary)

    def _generate_unique_share_code(self):
        for _ in range(5):
            code = secrets.token_urlsafe(8)
            if not self.repo.get_share_by_code(code=code):
                return code

        raise HTTPException(status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
                            detail='Không tạo được mã chia sẽ, thử lại!')

    def share(self, itinerary_id: int, user_id: int):
        itinerary = self.get_owned(itinerary_id=itinerary_id, user_id=user_id)
        if not itinerary.share_code:
            code = self._generate_unique_share_code()
            self.repo.set_share_code(itinerary=itinerary, code=code)

        return {
            'share_code': itinerary.share_code,
            'share_url': f'/itineraries/shared/{itinerary.share_code}'
        }

    def unshare(self, itinerary_id: int, user_id: int):
        itinerary = self.get_owned(itinerary_id=itinerary_id, user_id=user_id)

        self.repo.set_share_code(itinerary=itinerary, code=None)

    def get_shared(self, code: str):
        itinerary = self.repo.get_share_by_code(code=code)
        if not itinerary:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy lịch trình')

        return itinerary

    def generate_from_request(self, user_id: int, payload: TripRequestCreate):
        trip_req = self.trip_repo.create_trip_request(
            user_id=user_id, raw_query=payload.raw_query, duration_day=payload.duration_day
        )
        try:
            plan = rag_service.generate_itinerary_plan(
                db=self.db, query=payload.raw_query, duration_day=payload.duration_day, num_people=payload.num_people,
                ward=payload.ward, max_price=payload.max_price
            )
            return self.repo.create_itinerary(user_id=user_id, data=plan, trip_request_id=trip_req.id)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
