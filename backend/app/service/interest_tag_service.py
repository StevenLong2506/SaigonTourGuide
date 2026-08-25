from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.api.helpers import get_tags_or_404
from app.repository.interest_tag_repository import InterestTagRepository
from app.schemas.interest_tag import InterestTagCreate, InterestTagUpdate


class InterestTagService:
    def __init__(self, db: Session):
        self.db = db
        self.repo = InterestTagRepository(db)

    def list_all(self, skip: int = 0, limit: int = 100):
        return self.repo.get_all_with_usage(skip=skip, limit=limit)

    def get(self, tag_id: int):
        return get_tags_or_404(self.repo, tag_id)

    def create(self, payload: InterestTagCreate):
        if self.repo.get_by_name(payload.name):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tag đã tồn tại')
        return self.repo.create_tag(payload)

    def update(self, tag_id: int, payload: InterestTagUpdate):
        tag = get_tags_or_404(self.repo, tag_id)
        if payload.name and payload.name != tag.name and self.repo.get_by_name(payload.name):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tag đã tồn tại')
        return self.repo.update_tag(tag, payload)

    def delete(self, tag_id: int):
        tag = get_tags_or_404(self.repo, tag_id)

        used_by_place = self.repo.count_place_tag(tag_id)
        used_by_user = self.repo.count_user_interest(tag_id)

        if used_by_user:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail=f'Tag đang được dùng {used_by_user} người dùng')
        if used_by_place:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail=f'Tag đang được dùng {used_by_place} địa điểm')

        self.repo.delete(tag)


