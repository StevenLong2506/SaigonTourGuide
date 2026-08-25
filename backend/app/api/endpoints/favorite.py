from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user, get_db
from app.models import User
from app.schemas.favorite import FavoriteResponse, FavoriteCreate
from app.service.favorite_service import FavoriteService

router = APIRouter()

@router.get('', response_model=list[FavoriteResponse])
def list_favorites(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return FavoriteService(db).list_favorites(user_id=user.id)

@router.post('', response_model=FavoriteResponse, status_code=status.HTTP_201_CREATED)
def add_favorite(payload: FavoriteCreate, user: User=Depends(get_current_user), db: Session=Depends(get_db)):
    return FavoriteService(db).add_favorite(user_id=user.id, place_id=payload.place_id)


@router.delete('/{place_id}', status_code=status.HTTP_204_NO_CONTENT)
def remove_favorite(place_id: int, user: User=Depends(get_current_user), db: Session=Depends(get_db)):
    FavoriteService(db).remove_favorite(user_id=user.id, place_id=place_id)

    