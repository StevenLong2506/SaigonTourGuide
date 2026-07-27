from fastapi import APIRouter, Depends, HTTPException
from fastapi.params import Query
from sqlalchemy.orm import Session
from starlette import status

from app.api.deps import get_db
from app.api.helpers import get_place_or_404
from app.models.enums import PlaceStatus, AgeGroup, PlaceSortBy
from app.repository.place_repository import PlaceRepository
from app.schemas.place import PlaceSummaryResponse, PlaceResponse, PlaceSearchResponse, DistrictCountResponse


router = APIRouter()


@router.get('/search', response_model=PlaceSearchResponse)
def search_places(q: str | None = Query(default=None, max_length=200, description='Từ khóa: tên / mô tả / địa chỉ'),
                  category_ids: list[int] | None = Query(default=None, description='Lọc theo danh mục'),
                  tag_ids: list[int] | None = Query(default=None, description='Lọc theo tag sở thích'),
                  district: str | None = Query(default=None, description='Quận / Huyện'),
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
    if price_min is not None and price_max is not None and price_min > price_max:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='price_min không được lớn hơn price_max')

    repo = PlaceRepository(db)
    places, total = repo.search_places(
        q=q, category_ids=category_ids, tag_ids=tag_ids, district=district, ward=ward, price_min=price_min,
        price_max=price_max, min_rating=min_rating, age_group=age_group, min_suitability=min_suitability,
        is_featured=is_featured, sort_by=sort_by, skip=skip, limit=limit, status=PlaceStatus.ACTIVE,
    )

    return {
        'total': total,
        'skip': skip,
        'limit': limit,
        'sort_by': sort_by,
        'items': [repo.to_summary_data(p) for p in places],
    }


@router.get('/districts', response_model=list[DistrictCountResponse])
def list_districts(db: Session = Depends(get_db)):
    return PlaceRepository(db).list_districts(status=PlaceStatus.ACTIVE)


@router.get('/', response_model=list[PlaceSummaryResponse])
def list_places(skip: int = 0, limit: int = Query(default=20, le=100),
                district: str | None = None, is_featured: bool | None = None,
                db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    places = repo.list_full(skip=skip, limit=limit, status=PlaceStatus.ACTIVE,
                            district=district, is_featured=is_featured)
    return [repo.to_summary_data(p) for p in places]


@router.get('/{place_id}', response_model=PlaceResponse)
def get_place(place_id: int, db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)

    if place.status != PlaceStatus.ACTIVE:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail='Địa điểm không tồn tại')
    repo.increment_view(place)
    return repo.to_response_data(place)
