from fastapi import APIRouter, Depends, status, UploadFile, File

from app.api.deps import UserServiceDep, get_current_user
from app.models import User
from app.schemas.user import UserResponse, UserUpdate, ChangePasswordRequest, UserInterestsUpdate, UserInterestResponse, \
    UserTravelProfileUpdate, UserTravelProfileResponse

router = APIRouter()


@router.put('/me', response_model=UserResponse)
def update_profile(payload: UserUpdate, service: UserServiceDep, current_user: User = Depends(get_current_user)):
    return service.update_profile(current_user, payload)


@router.post('/me/change-password', status_code=status.HTTP_204_NO_CONTENT)
def change_password(payload: ChangePasswordRequest, service: UserServiceDep,
                    current_user: User = Depends(get_current_user)):
    service.change_password(current_user, payload.old_password, payload.new_password)


@router.put('/me/interests', response_model=list[UserInterestResponse])
def set_interests(payload: UserInterestsUpdate, service: UserServiceDep,
                  current_user: User = Depends(get_current_user)):
    return service.set_interests(current_user, payload.interests)


@router.put('/me/travel-profile', response_model=UserTravelProfileResponse)
def set_travel_profile(payload: UserTravelProfileUpdate, service: UserServiceDep, current_user: User = Depends(get_current_user)):
    return service.set_travel_profile(current_user, payload)


@router.post('/me/avatar', response_model=UserResponse)
def upload_avatar(service: UserServiceDep, file: UploadFile = File(...),
                  current_user: User = Depends(get_current_user)):
    return service.upload_avatar(current_user, file)
