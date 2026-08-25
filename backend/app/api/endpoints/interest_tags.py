from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.schemas.interest_tag import InterestTagResponse
from app.service.interest_tag_service import InterestTagService

router = APIRouter()


@router.get('/', response_model=list[InterestTagResponse])
def list_tags(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return InterestTagService(db).list_all(skip=skip, limit=limit)


@router.get('/{tag_id}', response_model=InterestTagResponse)
def get_tag(tag_id: int, db: Session = Depends(get_db)):
    return InterestTagService(db).get(tag_id)
