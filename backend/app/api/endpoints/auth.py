from fastapi import APIRouter, status, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, get_token_payload
from app.models import User
from app.schemas.user import UserResponse, UserRegister, UserLogin
from app.service.auth_service import AuthService

router = APIRouter()


@router.post('/logout', status_code=status.HTTP_200_OK)
def logout(payload: dict = Depends(get_token_payload), db: Session = Depends(get_db)):
    return AuthService(db).logout(payload)


@router.post('/register', response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(payload: UserRegister, db: Session = Depends(get_db)):
    return AuthService(db).register(payload)


@router.post('/login')
def login(payload: UserLogin, db: Session = Depends(get_db)):
    return AuthService(db).login(payload)


@router.get('/me', response_model=UserResponse)
def get_me(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return AuthService(db).get_me(current_user.id)
