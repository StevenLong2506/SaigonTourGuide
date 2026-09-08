from fastapi import Depends, APIRouter

from app.api.deps import get_current_admin, UserServiceDep
from app.models import User
from app.schemas.user import UserResponse, UserStatusUpdate

router = APIRouter()


@router.get('/', response_model=list[UserResponse])
def list_users(service: UserServiceDep, skip: int = 0, limit: int = 100, admin: User = Depends(get_current_admin)):
    return service.admin_list(skip=skip, limit=limit)

@router.patch('/{user_id}/status', response_model=UserResponse)
def update_user_status(user_id: int, payload: UserStatusUpdate, service: UserServiceDep,
                       admin: User = Depends(get_current_admin)):
    return service.set_active(user_id=user_id, payload=payload, current_admin_id=admin.id)