from fastapi import APIRouter, status, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.api.helpers import get_tags_or_404
from app.models import User
from app.repository.interest_tag_repository import InterestTagRepository
from app.schemas.interest_tag import InterestTagResponse, InterestTagCreate, InterestTagUpdate

router=APIRouter()


@router.post('/', response_model=InterestTagResponse, status_code=status.HTTP_201_CREATED)
def create_tag(payload: InterestTagCreate, admin:User=Depends(get_current_admin), db:Session=Depends(get_db)):
    repo = InterestTagRepository(db)
    if repo.get_by_name(payload.name):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tag đã tồn tại')
    return repo.create_tag(payload)

@router.put('/{tag_id}',response_model=InterestTagResponse)
def update_tag(tag_id:int, payload:InterestTagUpdate, admin:User=Depends(get_current_admin),
               db:Session=Depends(get_db)):
    repo=InterestTagRepository(db)
    tag = get_tags_or_404(repo,tag_id)
    if payload.name and payload.name != tag.name and repo.get_by_name(payload.name):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tag đã tồn tại')

    return repo.update_tag(tag,payload)


@router.delete('/{tag_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_tag(tag_id:int, admin:User=Depends(get_current_admin), db: Session=Depends(get_db)):
    repo = InterestTagRepository(db)
    tag =get_tags_or_404(repo,tag_id)

    used_by_place = repo.count_place_tag(tag_id)
    used_by_user=repo.count_user_interest(tag_id)

    if used_by_user:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f'Tag đang được dùng {used_by_user} người dùng'
        )
    if used_by_place:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail=f'Tag đang được dùng {used_by_place} địa điểm'
        )

    repo.delete(tag)