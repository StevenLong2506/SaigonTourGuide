from fastapi import APIRouter, Depends
from fastapi.params import Query
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.models.enums import AgeGroup, PlaceSortBy
from app.schemas.place import PlaceSummaryResponse, PlaceResponse, PlaceSearchResponse, WardCountResponse
from app.service.place_service import PlaceService

router = APIRouter()


@router.get('/search', response_model=PlaceSearchResponse)
def search_places(q: str | None = Query(default=None, max_length=200, description='Từ khóa: tên / mô tả / địa chỉ'),
                  category_ids: list[int] | None = Query(default=None, description='Lọc theo danh mục'),
                  tag_ids: list[int] | None = Query(default=None, description='Lọc theo tag sở thích'),
                  ward: str | None = Query(default=None, description='Phường / xã'),
                  price_min: float | None = Query(default=None, ge=0),
                  price_max: float | None = Query(default=None, ge=0),
                  min_rating: float | None = Query(default=None, ge=0, le=5),
                  age_group: AgeGroup | None = Query(default=None, description='Nhóm tuổi phù hợp'),
                  min_suitability: int | None = Query(default=None, ge=1, le=5,
                                                      description='Độ phù hợp tối thiểu 1-5 sao'),
                  is_featured: bool | None = None,
                  sort_by: PlaceSortBy = PlaceSortBy.POPULAR,
                  skip: int = Query(default=0, ge=0),
                  limit: int = Query(default=20, ge=1, le=100),
                  db: Session = Depends(get_db)):
    return PlaceService(db).search(
        q=q, category_ids=category_ids, tag_ids=tag_ids, ward=ward, price_min=price_min,
        price_max=price_max, min_rating=min_rating, age_group=age_group, min_suitability=min_suitability,
        is_featured=is_featured, sort_by=sort_by, skip=skip, limit=limit,
    )


@router.get('/wards', response_model=list[WardCountResponse])
def list_wards(db: Session = Depends(get_db)):
    return PlaceService(db).list_wards()


@router.get('/', response_model=list[PlaceSummaryResponse])
def list_places(skip: int = 0, limit: int = Query(default=20, le=100),
                ward: str | None = None, is_featured: bool | None = None,
                db: Session = Depends(get_db)):
    return PlaceService(db).list_active(skip=skip, limit=limit, ward=ward, is_featured=is_featured)


@router.get('/{place_id}', response_model=PlaceResponse)
def get_place(place_id: int, db: Session = Depends(get_db)):
    return PlaceService(db).get_active(place_id)
