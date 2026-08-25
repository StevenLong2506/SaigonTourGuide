from sqlalchemy.orm import Session

from app.models import Itinerary, ItineraryItem, Place
from app.repository.base import BaseRepository
from app.schemas.itinerary import ItineraryCreate, ItineraryUpdate


class ItineraryRepository(BaseRepository[Itinerary]):
    def __init__(self, db: Session):
        super().__init__(Itinerary, db)

    def get_by_user(self, user_id: int) -> list[Itinerary]:
        query = self.db.query(Itinerary).filter_by(user_id=user_id)
        return query.order_by(Itinerary.updated_at.desc()).all()

    def get_owned(self, user_id: int, itinerary_id: int):
        return self.db.query(Itinerary).filter_by(id=itinerary_id, user_id=user_id).first()

    def get_share_by_code(self, code: str):
        return self.db.query(Itinerary).filter_by(share_code=code).first()

    def create_itinerary(self, user_id: int, data: ItineraryCreate, code: str | None = None,
                         trip_request_id: int | None = None):
        place_ids = {item.place_id for item in data.items if item.place_id is not None}
        if place_ids:
            found = {pid for (pid,) in self.db.query(Place.id).filter(Place.id.in_(place_ids)).all()}
            missing = place_ids - found
            if missing:
                raise ValueError(f'place_id không tồn tại: {sorted(missing)}')


        itinerary = Itinerary(
            user_id=user_id,
            trip_request_id=trip_request_id,
            title=data.title,
            description=data.description,
            start_date=data.start_date,
            end_date=data.end_date,
            num_people=data.num_people or 1,
            share_code=code
        )

        for item in data.items:
            itinerary.items.append(ItineraryItem(**item.model_dump()))

        return self.create(itinerary)

    def update_itinerary(self, itinerary: Itinerary, data: ItineraryUpdate):
        for field, value in data.model_dump(exclude_unset=True).items():
            setattr(itinerary, field, value)
        return self.update(itinerary)

    def delete_itinerary(self, itinerary: Itinerary):
        self.delete(itinerary)

    def set_share_code(self, itinerary: Itinerary, code: str):
        itinerary.share_code = code
        return self.update(itinerary)
