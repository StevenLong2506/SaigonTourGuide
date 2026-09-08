from fastapi import HTTPException, UploadFile, status

from app.service.helpers import get_place_or_404
from app.models.enums import PlaceSortBy, PlaceStatus
from app.repository.place_repository import PlaceRepository
from app.schemas.place import PlaceCreate, PlaceUpdate, PlaceStatusUpdate, PlaceFeaturedUpdate
from app.service.rag_service import RagService
from app.service.upload_image_service import UploadImageService
from app.service.stat_service import StatService


class PlaceService:
    def __init__(self, repo: PlaceRepository, stat_service: StatService, rag_service: RagService,
                 upload_service: UploadImageService):
        self.repo = repo
        self.stat_service = stat_service
        self.rag_service = rag_service
        self.upload_service = upload_service

    def search(self, *, q, category_ids, tag_ids, ward, price_min, price_max, min_rating,
               age_group, min_suitability, is_featured, sort_by: PlaceSortBy, skip, limit):
        if price_min is not None and price_max is not None and price_min > price_max:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail='price_min không được lớn hơn price_max')

        places, total = self.repo.search_places(
            q=q, category_ids=category_ids, tag_ids=tag_ids, ward=ward, price_min=price_min,
            price_max=price_max, min_rating=min_rating, age_group=age_group, min_suitability=min_suitability,
            is_featured=is_featured, sort_by=sort_by, skip=skip, limit=limit, status=PlaceStatus.ACTIVE,
        )

        self.stat_service.log_search(
            query_text=q,
            filters={'ward': ward, 'category_ids': category_ids, 'tag_ids': tag_ids,
                     'price_min': price_min, 'price_max': price_max},
            result_count=total,
        )

        return {
            'total': total,
            'skip': skip,
            'limit': limit,
            'sort_by': sort_by,
            'items': [self.repo.to_summary_data(p) for p in places],
        }

    def list_wards(self):
        return self.repo.list_wards(status=PlaceStatus.ACTIVE)

    def list_active(self, *, skip: int, limit: int, ward: str | None, is_featured: bool | None):
        places = self.repo.list_full(skip=skip, limit=limit, status=PlaceStatus.ACTIVE,
                                     ward=ward, is_featured=is_featured)
        return [self.repo.to_summary_data(p) for p in places]

    def get_active(self, place_id: int):
        place = get_place_or_404(self.repo, place_id)
        if place.status != PlaceStatus.ACTIVE:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Địa điểm không tồn tại')
        self.repo.increment_view(place)
        return self.repo.to_response_data(place)

    # ---- Admin ----
    def admin_list(self, *, skip: int, limit: int, place_status: PlaceStatus | None, ward: str | None,
                   category_id: int | None = None):
        places = self.repo.list_full(skip=skip, limit=limit, status=place_status, ward=ward, category_id=category_id)
        return [self.repo.to_summary_data(p) for p in places]

    def admin_get(self, place_id: int):
        return self.repo.to_response_data(get_place_or_404(self.repo, place_id))

    def create(self, payload: PlaceCreate, created_by: int):
        if self.repo.get_by_name(payload.name):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tên địa điểm đã tồn tại')
        try:
            place = self.repo.create_place(payload, created_by=created_by)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

        try:
            self.rag_service.index_place(place=place)
        except Exception:
            pass

        return self.repo.to_response_data(place)

    def update(self, place_id: int, payload: PlaceUpdate):
        place = get_place_or_404(self.repo, place_id)
        if payload.name and payload.name != place.name and self.repo.get_by_name(payload.name):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tên địa điểm đã tồn tại')
        try:
            updated = self.repo.update_place(place, payload)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

        try:
            self.rag_service.index_place(place=updated)
        except Exception:
            pass

        return self.repo.to_response_data(updated)

    def delete(self, place_id: int):
        place = get_place_or_404(self.repo, place_id)
        self.repo.delete(place)

    def set_status(self, place_id: int, payload: PlaceStatusUpdate):
        place = get_place_or_404(self.repo, place_id)
        if place.status == payload.status:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Trùng status')
        return self.repo.to_response_data(self.repo.set_status(place, payload.status))

    def set_featured(self, place_id: int, payload: PlaceFeaturedUpdate):
        place = get_place_or_404(self.repo, place_id)
        return self.repo.to_response_data(self.repo.set_featured(place, payload.is_featured))

    def add_images(self, place_id: int, files: list[UploadFile]):
        if not files:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Danh sách ảnh trống')
        place = get_place_or_404(self.repo, place_id)
        place = self.upload_service.upload_place_images(place=place, files=files)
        return self.repo.to_response_data(place)

    def set_primary_image(self, place_id: int, image_id: int):
        place = get_place_or_404(self.repo, place_id)
        img = self.repo.get_image(place_id=place_id, img_id=image_id)
        if img is None:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Ảnh không tồn tại')
        return self.repo.to_response_data(self.repo.set_primary_image(place, img))

    def delete_image(self, place_id: int, image_id: int):
        place = get_place_or_404(self.repo, place_id)
        img = self.repo.get_image(place_id, image_id)
        if img is None:
            raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Ảnh không tồn tại')
        return self.repo.to_response_data(self.repo.delete_image(place, img))

    def reindex_all(self):
        total = self.rag_service.reindex_all_places()
        return {'message': f'Đã tạo embedding cho {total} địa điểm'}
