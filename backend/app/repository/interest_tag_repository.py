from sqlalchemy.orm import Session

from app.models import InterestTag, PlaceTag, UserInterest
from app.repository.base import BaseRepository
from app.schemas.interest_tag import InterestTagCreate, InterestTagUpdate


class InterestTagRepository(BaseRepository[InterestTag]):
    def __init__(self, db: Session):
        super().__init__(InterestTag, db)

    def get_by_name(self, name:str) -> InterestTag | None:
        return self.db.query(InterestTag).filter_by(name=name).first()

    def create_tag(self, payload: InterestTagCreate) -> InterestTag:
        new_tag = InterestTag(**payload.model_dump())
        return self.create(new_tag)

    def update_tag(self, tag: InterestTag, payload: InterestTagUpdate) -> InterestTag:
        data = payload.model_dump(exclude_unset=True)

        for field, value in data.items():
            setattr(tag, field, value)

        return self.update(tag)

    def count_place_tag(self, tag_id:int)->int:
        return self.db.query(PlaceTag).filter_by(tag_id=tag_id).count()

    def count_user_interest(self, tag_id:int)-> int:
        return self.db.query(UserInterest).filter_by(tag_id=tag_id).count()