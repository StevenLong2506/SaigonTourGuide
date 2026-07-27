from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.api.helpers import get_tags_or_404
from app.repository.interest_tag_repository import InterestTagRepository
from app.schemas.interest_tag import InterestTagResponse

router = APIRouter()


@router.get('/', response_model=list[InterestTagResponse])
def list_tags(skip:int=0, limit:int=100, db:Session=Depends(get_db)):
    return InterestTagRepository(db).get_all(skip=skip, limit=limit)

@router.get('/{tag_id}', response_model=InterestTagResponse)
def get_tag(tag_id: int, db: Session=Depends(get_db)):
    repo = InterestTagRepository(db)
    return get_tags_or_404(repo, tag_id)