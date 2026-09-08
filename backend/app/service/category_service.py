from fastapi import HTTPException, status

from app.service.helpers import get_category_or_404
from app.repository.category_repository import CategoryRepository
from app.schemas.category import CategoryCreate, CategoryUpdate



class CategoryService:
    def __init__(self, repo: CategoryRepository):
        self.repo = repo

    def list_all(self, skip: int = 0, limit: int = 100):
        return self.repo.get_all_with_place_count(skip=skip, limit=limit)

    def get(self, category_id: int):
        return get_category_or_404(self.repo, category_id)

    def create(self, payload: CategoryCreate):
        if self.repo.get_category_by_name(payload.name):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tên danh mục đã tồn tại')
        try:
            return self.repo.create_category(payload)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    def update(self, category_id: int, payload: CategoryUpdate):
        cate = get_category_or_404(self.repo, category_id)
        if payload.parent_id == category_id:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail='Danh mục không thể là cha của chính nó')
        if payload.name and payload.name != cate.name and self.repo.get_category_by_name(payload.name):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Tên danh mục đã tồn tại')

        try:
            return self.repo.update_category(cate, payload)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    def delete(self, category_id: int):
        cate = get_category_or_404(self.repo, category_id)

        in_use = self.repo.count_place_category(category_id=category_id)
        has_children = self.repo.count_children(category_id)
        if in_use:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail=f'Danh mục đang được dùng bởi {in_use} địa điểm')
        if has_children:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Danh mục còn danh mục con')

        self.repo.delete(cate)
