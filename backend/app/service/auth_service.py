from datetime import datetime, timezone

from fastapi import HTTPException, status
from sqlalchemy.orm import Session

from app.core.security import verify_password, create_access_token
from app.repository.token_black_list_repository import TokenBlackListRepository
from app.repository.user_repository import UserRepository
from app.schemas.user import UserRegister, UserLogin


class AuthService:
    def __init__(self, db: Session):
        self.db = db
        self.user_repo = UserRepository(db)
        self.blacklist_repo = TokenBlackListRepository(db)

    def register(self, payload: UserRegister):
        if self.user_repo.get_by_username(payload.username):
            raise HTTPException(status_code=400, detail='Username đã tồn tại')
        if self.user_repo.get_by_email(payload.email):
            raise HTTPException(status_code=400, detail='Email đã tồn tại')

        try:
            return self.user_repo.create_user(payload)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))

    def login(self, payload: UserLogin):
        user = self.user_repo.get_by_username(payload.identifier) or self.user_repo.get_by_email(payload.identifier)

        if not user or not verify_password(payload.password, user.hash_password):
            raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED, detail='Sai thông tin đăng nhập')
        if not user.is_active:
            raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail='Tài khoản đã bị khóa')

        token = create_access_token(user_id=user.id, role=user.user_role)
        return {'access_token': token, 'token_type': 'bearer'}

    def logout(self, token_payload: dict):
        jti = token_payload.get('jti')
        if not jti:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Token không hợp lệ để đăng xuất')

        exp = token_payload.get('exp')
        expires_at = (datetime.fromtimestamp(exp, tz=timezone.utc).replace(tzinfo=None) if exp
                     else datetime.now(timezone.utc).replace(tzinfo=None))

        self.blacklist_repo.revoke(jti=jti, user_id=int(token_payload['sub']), expires_at=expires_at)
        self.blacklist_repo.purge_expired()

        return {'message': 'Đăng xuất thành công'}

    def get_me(self, user_id: int):
        return self.user_repo.get_full(user_id)
