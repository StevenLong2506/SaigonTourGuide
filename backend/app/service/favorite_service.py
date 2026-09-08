from fastapi import HTTPException, status

from app.repository.favorite_repository import FavoriteRepository
from app.repository.place_repository import PlaceRepository


class FavoriteService:
    def __init__(self, fav_repo: FavoriteRepository, place_repo: PlaceRepository):
        self.fav_repo = fav_repo
        self.place_repo = place_repo

    def add_favorite(self, user_id: int, place_id: int):
        if not self.place_repo.get_by_id(id=place_id):
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy địa điểm')
        if self.fav_repo.get_by_user_and_place(user_id=user_id, place_id=place_id):
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail='Địa điểm đã có trong danh sách yêu thích')

        try:
            favorite = self.fav_repo.create_favorite(place_id=place_id, user_id=user_id)
            return self._to_response_data(favorite=favorite)
        except ValueError:
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail='Địa điểm đã có trong danh sách yêu thích')

    def remove_favorite(self, user_id: int, place_id: int):
        favorite = self.fav_repo.get_by_user_and_place(place_id=place_id, user_id=user_id)
        if not favorite:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND)

        self.fav_repo.delete_favorite(favorite=favorite)

    def list_favorites(self, user_id: int):
        favorites = self.fav_repo.get_by_user(user_id=user_id)
        return [self._to_response_data(f) for f in favorites]

    def _to_response_data(self, favorite):
        data = self.fav_repo.model_columns_to_dict(favorite)
        data['place'] = self.place_repo.to_response_data(
            favorite.place
        )
        return data
