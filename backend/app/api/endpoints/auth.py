from datetime import datetime, timezone

from fastapi import APIRouter, status, Depends, HTTPException
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user, get_token_payload
from app.core.security import verify_password, create_access_token
from app.models import User
from app.repository.token_black_list_repository import TokenBlackListRepository
from app.repository.user_repository import UserRepository
from app.schemas.user import UserResponse, UserRegister, UserLogin

router = APIRouter()


@router.post('/logout', status_code=status.HTTP_200_OK)
def logout(payload: dict = Depends(get_token_payload), db: Session = Depends(get_db)):
    jti = payload.get('jti')
    if not jti:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Token không hợp lệ để đăng xuất')

    exp = payload.get('exp')
    expires_at = (datetime.fromtimestamp(exp, tz=timezone.utc).replace(tzinfo=None) if exp
                  else datetime.now(timezone.utc).replace(tzinfo=None))

    repo = TokenBlackListRepository(db)
    repo.revoke(jti=jti, user_id=int(payload['sub']), expires_at=expires_at)
    repo.purge_expired()

    return {
        'message': 'Đăng xuất thành công'
    }



@router.post('/register', response_model=UserResponse, status_code=status.HTTP_201_CREATED)
def register(payload: UserRegister, db: Session = Depends(get_db)):
    repo = UserRepository(db)

    if repo.get_by_username(payload.username):
        raise HTTPException(status_code=400, detail='Username đã tồn tại')
    if repo.get_by_email(payload.email):
        raise HTTPException(status_code=400, detail='Email đã tồn tại')

    return repo.create_user(payload)


@router.post('/login')
def login(payload: UserLogin, db: Session = Depends(get_db)):
    repo = UserRepository(db)
    user = repo.get_by_username(payload.identifier) or repo.get_by_email(payload.identifier)

    if not user or not verify_password(payload.password, user.hash_password):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail='Sai thông tin đăng nhập')
    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN,
                            detail='Tài khoản đã bị khóa')

    token = create_access_token(user_id=user.id, role=user.user_role)
    return {
        'access_token': token,
        'token_type': 'bearer'
    }


@router.get('/me', response_model=UserResponse)
def get_me(current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return UserRepository(db).get_full(current_user.id)
