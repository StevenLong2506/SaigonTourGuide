from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.api.helpers import get_category_or_404
from app.models import User
from app.repository.category_repository import CategoryRepository
from app.schemas.category import CategoryCreate, CategoryResponse, CategoryUpdate

router = APIRouter()


@router.post('/', response_model=CategoryResponse, status_code=status.HTTP_201_CREATED)
def create_category(payload: CategoryCreate, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    repo = CategoryRepository(db)
    if repo.get_category_by_name(payload.name):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Tên danh mục đã tồn tại')

    try:
        cate = repo.create_category(payload)
        return cate
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.put('/{category_id}', response_model=CategoryResponse)
def update_category(category_id: int, payload: CategoryUpdate,
                    admin: User = Depends(get_current_admin),
                    db: Session = Depends(get_db)):
    repo = CategoryRepository(db)
    cate = get_category_or_404(repo, category_id)
    if payload.parent_id == category_id:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Danh mục không thể là cha của chính nó')
    if payload.name and payload.name != cate.name and repo.get_category_by_name(payload.name):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Tên danh mục đã tồn tại')

    try:
        return repo.update_category(cate,payload)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

@router.delete('/{category_id}',status_code=status.HTTP_204_NO_CONTENT)
def delete_category(category_id:int, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    repo = CategoryRepository(db)
    cate = get_category_or_404(repo,category_id)

    in_use = repo.count_place_category(category_id=category_id)
    has_children= repo.count_children(category_id)
    if in_use:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=f'Danh mục đang được dùng bởi {in_use} địa điểm')
    if has_children:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Danh mục còn danh mục con')

    repo.delete(cate)
