from fastapi import HTTPException, UploadFile, status

from app.db.uow import UnitOfWork
from app.service.helpers import get_user_or_404
from app.core.security import verify_password
from app.models import User
from app.repository.user_repository import UserRepository
from app.schemas.user import UserUpdate, UserTravelProfileUpdate, UserStatusUpdate
from app.service.upload_image_service import UploadImageService


class UserService:
    def __init__(self, repo: UserRepository, upload_service: UploadImageService, uow: UnitOfWork):
        self.repo = repo
        self.upload_service=upload_service
        self.uow = uow

    def update_profile(self, current_user: User, payload: UserUpdate):
        if payload.email and payload.email != current_user.email:
            if self.repo.get_by_email(payload.email):
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Email đã tồn tại')

        with self.uow.transaction():
            self.repo.update_user(current_user, payload)
        return self.repo.get_full(current_user.id)

    def change_password(self, current_user: User, old_password: str, new_password: str):
        if not verify_password(old_password, current_user.hash_password):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Mật khẩu cũ không đúng')
        if old_password == new_password:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail='Mật khẩu mới phải khác mật khẩu cũ')
        with self.uow.transaction():
            self.repo.change_password(current_user, new_password)

    def set_interests(self, current_user: User, interests):
        try:
            with self.uow.transaction():
                user = self.repo.set_interests(current_user, interests)
        except ValueError as e:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail=str(e))
        return user.interests

    def set_travel_profile(self, current_user: User, payload: UserTravelProfileUpdate):
        with self.uow.transaction():
            profile = self.repo.set_travel_profile(current_user, payload)
        return profile

    def upload_avatar(self, current_user: User, file: UploadFile):
        user_id = current_user.id
        self.uow.end_read()
        url, _ = self.upload_service.upload_user_avatar(file=file, user_id=user_id)
        with self.uow.transaction():
            user = self.repo.update_avatar(current_user, url)
        return user


    # ---- Admin ----
    def admin_list(self, skip: int = 0, limit: int = 100):
        return self.repo.list_full(skip=skip, limit=limit)

    def set_active(self, user_id:int, payload: UserStatusUpdate, current_admin_id: int):
        if user_id==current_admin_id:
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail='Không thể tự khóa tài khoản của admin')

        u = get_user_or_404(self.repo, user_id)
        with self.uow.transaction():
            user = self.repo.set_active(user=u, is_active=payload.is_active)
        return user