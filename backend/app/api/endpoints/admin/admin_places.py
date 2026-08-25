from fastapi import Depends, APIRouter, Query, status, UploadFile, File
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.models import User
from app.models.enums import PlaceStatus
from app.schemas.place import PlaceSummaryResponse, PlaceCreate, PlaceResponse, PlaceUpdate, PlaceStatusUpdate, \
    PlaceFeaturedUpdate
from app.service.place_service import PlaceService

router = APIRouter()


@router.get('/admin/all', response_model=list[PlaceSummaryResponse])
def admin_list_places(skip: int = 0, limit: int = Query(default=20, le=100),
                      place_status: PlaceStatus | None = None,
                      ward: str | None = None,
                      category_id: int | None = None,
                      admin: User = Depends(get_current_admin),
                      db: Session = Depends(get_db)):
    return PlaceService(db).admin_list(skip=skip, limit=limit, place_status=place_status, ward=ward,
                                       category_id=category_id)


@router.post('/admin/reindex')
def reindex_places(admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return PlaceService(db).reindex_all()


@router.get('/admin/{place_id}', response_model=PlaceResponse)
def admin_get_place(place_id: int, admin: User = Depends(get_current_admin),
                    db: Session = Depends(get_db)):
    return PlaceService(db).admin_get(place_id)


@router.post('/', response_model=PlaceResponse, status_code=status.HTTP_201_CREATED)
def create_place(payload: PlaceCreate, admin: User = Depends(get_current_admin),
                 db: Session = Depends(get_db)):
    return PlaceService(db).create(payload, created_by=admin.id)


@router.patch('/{place_id}', response_model=PlaceResponse)
def update_place(place_id: int, payload: PlaceUpdate, admin: User = Depends(get_current_admin),
                 db: Session = Depends(get_db)):
    return PlaceService(db).update(place_id, payload)


@router.delete('/{place_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_place(place_id: int, admin: User = Depends(get_current_admin),
                 db: Session = Depends(get_db)):
    PlaceService(db).delete(place_id)


@router.patch('/{place_id}/status', response_model=PlaceResponse)
def update_place_status(place_id: int, payload: PlaceStatusUpdate,
                        admin: User = Depends(get_current_admin),
                        db: Session = Depends(get_db)):
    return PlaceService(db).set_status(place_id, payload)


@router.patch('/{place_id}/featured', response_model=PlaceResponse)
def update_place_featured(place_id: int, payload: PlaceFeaturedUpdate,
                          admin: User = Depends(get_current_admin),
                          db: Session = Depends(get_db)):
    return PlaceService(db).set_featured(place_id, payload)


@router.post('/{place_id}/images', response_model=PlaceResponse, status_code=status.HTTP_201_CREATED)
def add_place_images(place_id: int, files: list[UploadFile] = File(...), admin: User = Depends(get_current_admin),
                     db: Session = Depends(get_db)):
    return PlaceService(db).add_images(place_id, files)


@router.patch('/{place_id}/images/{image_id}/primary', response_model=PlaceResponse)
def set_primary_image(place_id: int, image_id: int, admin: User = Depends(get_current_admin),
                      db: Session = Depends(get_db)):
    return PlaceService(db).set_primary_image(place_id, image_id)


@router.delete('/{place_id}/images/{image_id}', response_model=PlaceResponse)
def delete_place_image(place_id: int, image_id: int, admin: User = Depends(get_current_admin),
                       db: Session = Depends(get_db)):
    return PlaceService(db).delete_image(place_id, image_id)
