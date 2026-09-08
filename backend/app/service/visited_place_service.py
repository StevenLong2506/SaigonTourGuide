from fastapi import HTTPException, status

from app.repository.place_repository import PlaceRepository
from app.repository.visited_place_repository import VisitedPlaceRepository
from app.schemas.visited_place import VisitedPlaceCreate


class VisitedPlaceService:
    def __init__(self, repo: VisitedPlaceRepository, place_repo: PlaceRepository):
        self.repo = repo
        self.place_repo = place_repo

    def add_visited(self, user_id: int, payload: VisitedPlaceCreate):
        if not self.place_repo.get_by_id(payload.place_id):
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Không tìm thấy địa điểm')

        existing = self._existing_response(user_id=user_id, place_id=payload.place_id)
        if existing:
            return existing

        try:
            visited = self.repo.create_visited_place(user_id=user_id, payload=payload)
            return self._to_response_data(visited=visited)
        except ValueError:
            existing = self._existing_response(user_id=user_id, place_id=payload.place_id)
            if existing:
                return existing
            raise HTTPException(status_code=status.HTTP_409_CONFLICT, detail='Đã ghi nhận địa điểm đã xem trước đó')

    def remove_visited(self, user_id: int, place_id: int):
        visited = self.repo.get_by_user_and_place(user_id=user_id, place_id=place_id)
        if not visited:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Chưa có lịch sử xem địa điểm này')

        self.repo.delete_visited(visited=visited)

    def list_visited(self, user_id: int):
        visited_places = self.repo.get_by_user(user_id=user_id)
        return [self._to_response_data(v) for v in visited_places]

    def _existing_response(self, user_id:int, place_id: int):
        existing = self.repo.get_by_user_and_place(user_id, place_id)
        return self._to_response_data(visited=existing) if existing else None

    def _to_response_data(self, visited) -> dict:
        data = self.repo.model_columns_to_dict(visited)
        data['place'] = self.place_repo.to_response_data(visited.place)
        return data