from fastapi import APIRouter

from app.api.deps import CateServiceDep
from app.schemas.category import CategoryResponse

router = APIRouter()


@router.get('/{category_id}', response_model=CategoryResponse)
def get_category(category_id: int, service: CateServiceDep):
    return service.get(category_id=category_id)


@router.get('/', response_model=list[CategoryResponse])
def get_categories(service: CateServiceDep, skip: int = 0, limit: int = 100):
    return service.list_all(skip=skip, limit=limit)
