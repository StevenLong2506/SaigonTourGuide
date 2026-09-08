from fastapi import APIRouter, status, Depends

from app.api.deps import VisitedPlaceServiceDep, get_current_user
from app.models import User
from app.schemas.visited_place import VisitedPlaceResponse, VisitedPlaceCreate

router = APIRouter()

@router.post('', response_model=VisitedPlaceResponse, status_code=status.HTTP_201_CREATED)
def add_visited(payload: VisitedPlaceCreate, service: VisitedPlaceServiceDep, user: User = Depends(get_current_user)):
    return service.add_visited(user_id=user.id, payload=payload)

@router.get('', response_model=list[VisitedPlaceResponse])
def list_visited(service: VisitedPlaceServiceDep , user: User=Depends(get_current_user)):
    return service.list_visited(user_id=user.id)

@router.delete('/{place_id}', status_code=status.HTTP_204_NO_CONTENT)
def remove_visited(service: VisitedPlaceServiceDep,place_id:int, user:User=Depends(get_current_user)):
    service.remove_visited(user_id=user.id, place_id=place_id)