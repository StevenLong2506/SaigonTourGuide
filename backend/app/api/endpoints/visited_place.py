from fastapi import APIRouter, status, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.models import User
from app.schemas.visited_place import VisitedPlaceResponse, VisitedPlaceCreate
from app.service.visited_place_service import VisitedPlaceService

router = APIRouter()

@router.post('', response_model=VisitedPlaceResponse, status_code=status.HTTP_201_CREATED)
def add_visited(payload: VisitedPlaceCreate, user: User = Depends(get_current_user), db: Session=Depends(get_db)):
    return VisitedPlaceService(db).add_visited(user_id=user.id, payload=payload)

@router.get('', response_model=list[VisitedPlaceResponse])
def list_visited(user: User=Depends(get_current_user), db: Session=Depends(get_db)):
    return VisitedPlaceService(db).list_visited(user_id=user.id)

@router.delete('/{place_id}', status_code=status.HTTP_204_NO_CONTENT)
def remove_visited(place_id:int, user:User=Depends(get_current_user), db: Session=Depends(get_db)):
    VisitedPlaceService(db).remove_visited(user_id=user.id, place_id=place_id)