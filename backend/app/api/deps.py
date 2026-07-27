from typing import Generator

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.orm import Session

from app.core.security import decode_access_token
from app.db.session import SessionLocal
from app.models import User
from app.models.enums import UserRole
from app.repository.token_black_list_repository import TokenBlackListRepository
from app.repository.user_repository import UserRepository


def get_db() -> Generator:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()


oauth2_scheme = OAuth2PasswordBearer(tokenUrl='auth/login')


def get_token_payload(token: str = Depends(oauth2_scheme), db: Session = Depends(get_db)) -> dict:
    credentials_error = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail='Không xác thực được, vui lòng đăng nhập lại',
        headers={'WWW-Authenticate': 'Bearer'},
    )

    try:
        payload = decode_access_token(token)
    except JWTError:
        raise credentials_error

    if payload.get('sub') is None:
        raise credentials_error

    jti = payload.get('jti')
    if jti and TokenBlackListRepository(db).is_blacklisted(jti):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail='Phiên đăng nhập đã kết thúc, vui lòng đăng nhập lại',
                            headers={'WWW-Authenticate': 'Bearer'},
                            )
    return payload


def get_current_user(payload: dict = Depends(get_token_payload), db: Session = Depends(get_db)) -> User:
    credentials_error = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail='Không xác thực được, vui lòng đăng nhập lại',
        headers={'WWW-Authenticate': 'Bearer'},
    )

    repo = UserRepository(db)
    user = repo.get_by_id(int(payload.get('sub')))
    if user is None:
        raise credentials_error
    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail='Tài khoản đã bị khóa')
    return user


def get_current_admin(current_user: User = Depends(get_current_user)) -> User:
    if (current_user.user_role != UserRole.ADMIN):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail='Yêu cầu quyền admin',
        )

    return current_user


def get_optional_user(db: Session = Depends(get_db),
                      token: str | None = Depends(
                          OAuth2PasswordBearer(tokenUrl='auth/login', auto_error=False))) -> User | None:
    if not token:
        return None
    try:
        payload=decode_access_token(token)
        jti=payload.get('jti')
        if jti and TokenBlackListRepository(db).is_blacklisted(jti):
            return None
        user_id=payload.get('sub')
        if user_id is None:
            return None

        user = UserRepository(db).get_by_id(int(user_id))
        return user if user and user.is_active else None
    except JWTError:
        return None
