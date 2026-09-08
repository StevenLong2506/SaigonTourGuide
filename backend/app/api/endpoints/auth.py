from fastapi import APIRouter, status, Depends

from app.api.deps import AuthServiceDep, get_current_user, get_token_payload
from app.models import User
from app.schemas.user import UserResponse, UserRegister, UserLogin

router = APIRouter()


@router.post('/logout', status_code=status.HTTP_200_OK)
def logout(service: AuthServiceDep ,payload: dict = Depends(get_token_payload)):
    return service.logout(payload)


@router.post('/register', response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(payload: UserRegister, service: AuthServiceDep):
    return service.register(payload)


@router.post('/login')
def login(payload: UserLogin, service: AuthServiceDep):
    return service.login(payload)


@router.get('/me', response_model=UserResponse)
def get_me(service: AuthServiceDep, current_user: User = Depends(get_current_user)):
    return service.get_me(current_user.id)
