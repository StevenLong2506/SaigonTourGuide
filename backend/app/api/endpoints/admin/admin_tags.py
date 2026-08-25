from fastapi import APIRouter, status, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.models import User
from app.schemas.interest_tag import InterestTagResponse, InterestTagCreate, InterestTagUpdate
from app.service.interest_tag_service import InterestTagService

router = APIRouter()


@router.post('/', response_model=InterestTagResponse, status_code=status.HTTP_201_CREATED)
def create_tag(payload: InterestTagCreate, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return InterestTagService(db).create(payload)


@router.put('/{tag_id}', response_model=InterestTagResponse)
def update_tag(tag_id: int, payload: InterestTagUpdate, admin: User = Depends(get_current_admin),
               db: Session = Depends(get_db)):
    return InterestTagService(db).update(tag_id, payload)


@router.delete('/{tag_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_tag(tag_id: int, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    InterestTagService(db).delete(tag_id)
