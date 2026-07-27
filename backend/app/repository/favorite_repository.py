from sqlalchemy.orm import Session

from app.models import Favorite
from app.repository.base import BaseRepository
from app.repository.place_repository import PlaceRepository


class FavoriteRepository(BaseRepository[Favorite]):
    def __init__(self, db: Session):
        super().__init__(Favorite, db)

    def get_by_user_and_place(self, user_id: int, place_id: int) -> Favorite | None:
        return self.db.query(Favorite).filter_by(user_id=user_id, place_id=place_id).first()

    def get_by_user(self, user_id: int) -> list[Favorite]:
        return self.db.query(Favorite).filter_by(user_id=user_id).all()

    def create_favorite(self, place_id: int, user_id: int) -> Favorite:
        new_fav = Favorite(place_id=place_id, user_id=user_id)
        return self.create(new_fav)

    def delete_favorite(self, favorite: Favorite) -> None:
        self.delete(favorite)

    def to_response_data(self, favorite: Favorite) -> dict:
        place_repo = PlaceRepository(self.db)
        data = self.model_columns_to_dict(favorite)
        data['place'] = place_repo.to_response_data(favorite.place)
        return data