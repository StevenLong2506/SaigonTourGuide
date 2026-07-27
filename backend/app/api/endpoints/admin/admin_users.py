from fastapi import Depends, APIRouter
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.models import User
from app.repository.user_repository import UserRepository
from app.schemas.user import UserResponse


router = APIRouter()

@router.get('/', response_model=list[UserResponse])
def list_users(skip: int = 0, limit: int = 100, admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return UserRepository(db).list_full(skip=skip, limit=limit)


