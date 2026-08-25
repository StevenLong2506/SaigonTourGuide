from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.models import User
from app.schemas.category import CategoryCreate, CategoryResponse, CategoryUpdate
from app.service.category_service import CategoryService

router = APIRouter()


@router.post('/', response_model=CategoryResponse, status_code=status.HTTP_201_CREATED)
def create_category(payload: CategoryCreate, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return CategoryService(db).create(payload)


@router.put('/{category_id}', response_model=CategoryResponse)
def update_category(category_id: int, payload: CategoryUpdate,
                    admin: User = Depends(get_current_admin),
                    db: Session = Depends(get_db)):
    return CategoryService(db).update(category_id, payload)


@router.delete('/{category_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_category(category_id: int, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    CategoryService(db).delete(category_id)
