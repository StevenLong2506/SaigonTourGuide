from fastapi import APIRouter, Depends, HTTPException, status, UploadFile, File
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.core.security import verify_password
from app.models import User
from app.repository.user_repository import UserRepository
from app.schemas.user import UserResponse, UserUpdate, ChangePasswordRequest, UserInterestsUpdate, UserInterestResponse, \
    UserTravelProfileUpdate, UserTravelProfileResponse
from app.service.upload_image_service import upload_user_avatar

router = APIRouter()


@router.put('/me', response_model=UserResponse)
def update_profile(payload: UserUpdate, current_user: User = Depends(get_current_user),
                   db: Session = Depends(get_db)):
    repo = UserRepository(db)
    if payload.email and payload.email != current_user.email:
        if repo.get_by_email(payload.email):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                                detail='Email đã tồn tại')
    repo.update_user(current_user, payload)
    return repo.get_full(current_user.id)


@router.post('/me/change-password', status_code=status.HTTP_204_NO_CONTENT)
def change_password(payload: ChangePasswordRequest, current_user: User = Depends(get_current_user),
                    db: Session = Depends(get_db)):
    if not verify_password(payload.old_password, current_user.hash_password):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Mật khẩu cũ không đúng')
    if payload.old_password == payload.new_password:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail='Mật khẩu mới phải khác mật khẩu cũ')

    UserRepository(db).change_password(current_user, payload.new_password)


@router.put('/me/interests', response_model=list[UserInterestResponse])
def set_interests(payload: UserInterestsUpdate,
                  current_user: User = Depends(get_current_user),
                  db: Session = Depends(get_db)):
    repo = UserRepository(db)
    try:
        user = repo.set_interests(current_user, payload.interests)
    except ValueError as e:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=str(e))

    return user.interests


@router.put('/me/travel-profile', response_model=UserTravelProfileResponse)
def set_travel_profile(payload: UserTravelProfileUpdate, current_user: User = Depends(get_current_user),
                       db: Session = Depends(get_db)):
    return UserRepository(db).set_travel_profile(current_user, payload)


@router.post('/me/avatar', response_model=UserResponse)
def upload_avatar(file: UploadFile = File(...),
                  current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return upload_user_avatar(db=db, user=current_user, file=file)


