from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db
from app.api.helpers import get_category_or_404
from app.repository.category_repository import CategoryRepository
from app.schemas.category import CategoryResponse

router = APIRouter()


@router.get('/{category_id}',response_model=CategoryResponse)
def get_category(category_id:int, db:Session=Depends(get_db)):
    repo = CategoryRepository(db)
    cate = get_category_or_404(repo, category_id)
    return cate

@router.get('/', response_model=list[CategoryResponse])
def list_categories(skip:int=0, limit: int = 100, db: Session=Depends(get_db)):
    return CategoryRepository(db).get_all(skip=skip,limit=limit)

