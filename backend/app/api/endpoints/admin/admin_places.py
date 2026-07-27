from fastapi import Depends, APIRouter, HTTPException, Query, status, UploadFile, File
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.api.helpers import get_place_or_404
from app.models import User
from app.models.enums import PlaceStatus
from app.repository.place_repository import PlaceRepository
from app.schemas.place import PlaceSummaryResponse, PlaceCreate, PlaceResponse, PlaceUpdate, PlaceStatusUpdate, \
    PlaceFeaturedUpdate, PlaceImageCreate
from app.service.upload_image_service import upload_place_images

router = APIRouter()


@router.get('/admin/all', response_model=list[PlaceSummaryResponse])
def admin_list_places(skip: int = 0, limit: int = Query(default=20, le=100),
                      place_status: PlaceStatus | None = None,
                      district: str | None = None,
                      admin: User = Depends(get_current_admin),
                      db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    places = repo.list_full(skip=skip, limit=limit, status=place_status, district=district)

    return [repo.to_summary_data(p) for p in places]


@router.post('/', response_model=PlaceResponse, status_code=status.HTTP_201_CREATED)
def create_place(payload: PlaceCreate, admin: User = Depends(get_current_admin),
                 db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    if repo.get_by_name(payload.name):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Tên địa điểm đã tồn tại')
    try:
        place = repo.create_place(payload, created_by=admin.id)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=str(e))

    return repo.to_response_data(place)


@router.put('/{place_id}', response_model=PlaceResponse)
def update_place(place_id: int, payload: PlaceUpdate, admin: User = Depends(get_current_admin),
                 db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)
    if payload.name and payload.name != place.name and repo.get_by_name(payload.name):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Tên địa điểm đã tồn tại')
    try:
        updated = repo.update_place(place, payload)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=str(e))

    return repo.to_response_data(updated)


@router.delete('/{place_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_place(place_id: int, admin: User = Depends(get_current_admin),
                 db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)
    repo.delete(place)


@router.patch('/{place_id}/status', response_model=PlaceResponse)
def update_place_status(place_id: int, payload: PlaceStatusUpdate,
                        admin: User = Depends(get_current_admin),
                        db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)
    if place.status == payload.status:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Trùng status')
    return repo.to_response_data(repo.set_status(place, payload.status))


@router.patch('/{place_id}/featured', response_model=PlaceResponse)
def update_place_featured(place_id: int, payload: PlaceFeaturedUpdate,
                          admin: User = Depends(get_current_admin),
                          db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)
    return repo.to_response_data(repo.set_featured(place, payload.is_featured))


@router.post('/{place_id}/images', response_model=PlaceResponse, status_code=status.HTTP_201_CREATED)
def add_place_images(place_id: int, files: list[UploadFile] = File(...), admin: User = Depends(get_current_admin),
                     db: Session = Depends(get_db)):
    if not files:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Danh sách ảnh trống')

    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)
    place = upload_place_images(db=db, place=place, files=files)
    return repo.to_response_data(place)


@router.patch('/{place_id}/images/{image_id}/primary', response_model=PlaceResponse)
def set_primary_image(place_id: int, image_id: int, admin: User = Depends(get_current_admin),
                      db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)
    img = repo.get_image(place_id=place_id, img_id=image_id)
    if img is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail='Ảnh không tồn tại')
    return repo.to_response_data(repo.set_primary_image(place, img))


@router.delete('/{place_id}/images/{image_id}', response_model=PlaceResponse)
def delete_place_image(place_id: int, image_id: int, admin: User = Depends(get_current_admin),
                       db: Session = Depends(get_db)):
    repo = PlaceRepository(db)
    place = get_place_or_404(repo, place_id)
    img = repo.get_image(place_id, image_id)
    if img is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail='Ảnh không tồn tại')
    return repo.to_response_data(repo.delete_image(place, img))
