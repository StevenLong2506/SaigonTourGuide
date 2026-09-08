from fastapi import APIRouter, Depends, status

from app.api.deps import get_current_user, FavoriteServiceDep
from app.models import User
from app.schemas.favorite import FavoriteResponse, FavoriteCreate


router = APIRouter()

@router.get('', response_model=list[FavoriteResponse])
def list_favorites( service: FavoriteServiceDep,user: User = Depends(get_current_user)):
    return service.list_favorites(user_id=user.id)

@router.post('', response_model=FavoriteResponse, status_code=status.HTTP_201_CREATED)
def add_favorite(payload: FavoriteCreate, service: FavoriteServiceDep, user: User=Depends(get_current_user)):
    return service.add_favorite(user_id=user.id, place_id=payload.place_id)


@router.delete('/{place_id}', status_code=status.HTTP_204_NO_CONTENT)
def remove_favorite(place_id: int, service: FavoriteServiceDep, user: User=Depends(get_current_user)):
    service.remove_favorite(user_id=user.id, place_id=place_id)

    