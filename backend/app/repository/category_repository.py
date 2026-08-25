from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models import Category, PlaceCategory
from app.repository.base import BaseRepository
from app.schemas.category import CategoryCreate, CategoryUpdate


class CategoryRepository(BaseRepository[Category]):
    def __init__(self, db: Session):
        super().__init__(Category, db)

    def get_category_by_name(self, name: str) -> Category | None:
        return self.db.query(Category).filter_by(name=name).first()

    def count_place_category(self, category_id: int) -> int:
        return self.db.query(PlaceCategory).filter_by(category_id=category_id).count()

    def count_children(self, category_id: int) -> int:
        return self.db.query(Category).filter_by(parent_id=category_id).count()

    def update_category(self, category: Category, payload: CategoryUpdate) -> Category:
        if payload.parent_id is not None:
            parent = self.get_by_id(payload.parent_id)
            if parent is None:
                raise ValueError(f'parent_id={payload.parent_id} không tồn tại')

        data = payload.model_dump(exclude_unset=True)
        for field, value in data.items():
            setattr(category, field, value)

        return self.update(category)

    def create_category(self, cate_data: CategoryCreate) -> Category:
        if cate_data.parent_id is not None:
            parent = self.get_by_id(cate_data.parent_id)
            if parent is None:
                raise ValueError(f'parent_id={cate_data.parent_id} không tồn tại')

        new_cate = Category(**cate_data.model_dump())

        return self.create(new_cate)

    def get_all_with_place_count(self, skip: int = 0, limit: int = 100):
        cates = self.get_all(skip=skip, limit=limit)
        if not cates:
            return cates

        ids = [c.id for c in cates]
        counts = dict(
            self.db.query(PlaceCategory.category_id, func.count(PlaceCategory.place_id))
            .filter(PlaceCategory.category_id.in_(ids))
            .group_by(PlaceCategory.category_id)
            .all()
        )

        for c in cates:
            c.place_count = counts.get(c.id, 0)

        return cates