from fastapi import Depends, APIRouter
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.models import User
from app.schemas.user import UserResponse, UserStatusUpdate
from app.service.user_service import UserService

router = APIRouter()


@router.get('/', response_model=list[UserResponse])
def list_users(skip: int = 0, limit: int = 100, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return UserService(db).admin_list(skip=skip, limit=limit)

@router.patch('/{user_id}/status', response_model=UserResponse)
def update_user_status(user_id: int, payload: UserStatusUpdate,
                       admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return UserService(db).set_active(user_id=user_id, payload=payload, current_admin_id=admin.id)