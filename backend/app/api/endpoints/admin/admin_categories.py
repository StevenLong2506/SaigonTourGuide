from fastapi import APIRouter, Depends, status

from app.api.deps import get_current_admin, CateServiceDep
from app.models import User
from app.schemas.category import CategoryCreate, CategoryResponse, CategoryUpdate

router = APIRouter()


@router.post('/', response_model=CategoryResponse, status_code=status.HTTP_201_CREATED)
def create_category(payload: CategoryCreate, service: CateServiceDep, admin: User = Depends(get_current_admin)):
    return service.create(payload)


@router.put('/{category_id}', response_model=CategoryResponse)
def update_category(category_id: int, payload: CategoryUpdate, service: CateServiceDep,
                    admin: User = Depends(get_current_admin)):
    return service.update(category_id, payload)


@router.delete('/{category_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_category(category_id: int, service: CateServiceDep, admin: User = Depends(get_current_admin)):
    service.delete(category_id)
