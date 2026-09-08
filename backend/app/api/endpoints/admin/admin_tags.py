from fastapi import APIRouter, status, Depends

from app.api.deps import get_current_admin, get_db, InterestTagServiceDep
from app.models import User
from app.schemas.interest_tag import InterestTagResponse, InterestTagCreate, InterestTagUpdate

router = APIRouter()


@router.post('/', response_model=InterestTagResponse, status_code=status.HTTP_201_CREATED)
def create_tag(payload: InterestTagCreate, service: InterestTagServiceDep ,admin: User = Depends(get_current_admin)):
    return service.create(payload)


@router.put('/{tag_id}', response_model=InterestTagResponse)
def update_tag(tag_id: int, payload: InterestTagUpdate, service: InterestTagServiceDep ,admin: User = Depends(get_current_admin)):
    return service.update(tag_id, payload)


@router.delete('/{tag_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_tag(tag_id: int, service: InterestTagServiceDep ,admin: User = Depends(get_current_admin)):
    service.delete(tag_id)
