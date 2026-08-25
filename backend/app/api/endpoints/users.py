from fastapi import APIRouter, Depends, status, UploadFile, File
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.models import User
from app.schemas.user import UserResponse, UserUpdate, ChangePasswordRequest, UserInterestsUpdate, UserInterestResponse, \
    UserTravelProfileUpdate, UserTravelProfileResponse
from app.service.user_service import UserService

router = APIRouter()


@router.put('/me', response_model=UserResponse)
def update_profile(payload: UserUpdate, current_user: User = Depends(get_current_user),
                   db: Session = Depends(get_db)):
    return UserService(db).update_profile(current_user, payload)


@router.post('/me/change-password', status_code=status.HTTP_204_NO_CONTENT)
def change_password(payload: ChangePasswordRequest, current_user: User = Depends(get_current_user),
                    db: Session = Depends(get_db)):
    UserService(db).change_password(current_user, payload.old_password, payload.new_password)


@router.put('/me/interests', response_model=list[UserInterestResponse])
def set_interests(payload: UserInterestsUpdate,
                  current_user: User = Depends(get_current_user),
                  db: Session = Depends(get_db)):
    return UserService(db).set_interests(current_user, payload.interests)


@router.put('/me/travel-profile', response_model=UserTravelProfileResponse)
def set_travel_profile(payload: UserTravelProfileUpdate, current_user: User = Depends(get_current_user),
                       db: Session = Depends(get_db)):
    return UserService(db).set_travel_profile(current_user, payload)


@router.post('/me/avatar', response_model=UserResponse)
def upload_avatar(file: UploadFile = File(...),
                  current_user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return UserService(db).upload_avatar(current_user, file)
