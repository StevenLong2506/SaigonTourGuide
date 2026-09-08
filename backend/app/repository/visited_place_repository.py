from sqlalchemy.orm import Session

from app.models import VisitedPlace
from app.models.enums import VisitedPlaceSource
from app.repository.base import BaseRepository
from app.schemas.visited_place import VisitedPlaceCreate


class VisitedPlaceRepository(BaseRepository[VisitedPlace]):
    def __init__(self, db: Session):
        super().__init__(VisitedPlace, db)

    def get_by_user_and_place(self, user_id: int, place_id: int) -> VisitedPlace | None:
        return self.db.query(VisitedPlace).filter_by(place_id=place_id, user_id=user_id).first()

    def get_by_user(self, user_id: int) -> list[VisitedPlace]:
        return self.db.query(VisitedPlace).filter_by(user_id=user_id).all()

    def get_visited_place_ids(self, user_id: int) -> list[int]:
        rows = self.db.query(VisitedPlace.place_id).filter_by(user_id=user_id).all()
        return [r[0] for r in rows]

    def create_visited_place(self, user_id: int,
                             payload: VisitedPlaceCreate,
                             source: VisitedPlaceSource = VisitedPlaceSource.MANUAL) -> VisitedPlace:
       new_visit = VisitedPlace(**payload.model_dump(), user_id=user_id, source=source)
       return self.create(new_visit)

    def delete_visited(self, visited: VisitedPlace) -> None:
        self.delete(visited)


