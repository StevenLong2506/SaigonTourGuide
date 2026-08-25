from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.schemas.category import CategoryResponse
from app.service.category_service import CategoryService

router = APIRouter()


@router.get('/{category_id}', response_model=CategoryResponse)
def get_category(category_id: int, db: Session = Depends(get_db)):
    return CategoryService(db).get(category_id)


@router.get('/', response_model=list[CategoryResponse])
def list_categories(skip: int = 0, limit: int = 100, db: Session = Depends(get_db)):
    return CategoryService(db).list_all(skip=skip, limit=limit)
