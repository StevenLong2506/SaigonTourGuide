from datetime import date, datetime

from pydantic import BaseModel, EmailStr, Field
from sqlalchemy import Boolean

from app.models.enums import TravelStyle, BudgetLevel, Gender
from app.schemas.interest_tag import InterestTagResponse


class UserTravelProfileBase(BaseModel):
    travel_style: TravelStyle | None = None
    budget_level: BudgetLevel | None = None
    with_children: bool | None = None
    with_elderly: bool | None = None


class UserTravelProfileUpdate(UserTravelProfileBase):
    pass

class UserTravelProfileResponse(UserTravelProfileBase):
    updated_at: datetime

    class Config:
        from_attributes = True


class UserInterestBase(BaseModel):
    tag_id: int
    priority: int = Field(default=1, ge=1, le=3)

class UserInterestCreate(UserInterestBase):
    pass

class UserInterestsUpdate(BaseModel):
    interests: list[UserInterestCreate]

class UserInterestResponse(BaseModel):
    priority: int
    tag: InterestTagResponse
    
    class Config:
        from_attributes = True


class UserBase(BaseModel):
    name: str
    email: EmailStr
    phone: str = Field(min_length=10)
    date_of_birth: date
    gender: Gender


class UserRegister(UserBase):
    username: str = Field(min_length=6)
    password: str = Field(min_length=6)


class UserLogin(BaseModel):
    identifier: str = Field(min_length=6)
    password: str = Field(min_length=6)


class ChangePasswordRequest(BaseModel):
    old_password: str = Field(min_length=6)
    new_password: str = Field(min_length=6)


class UserUpdate(BaseModel):
    name: str | None = None
    email: EmailStr | None = None
    phone: str | None = Field(default=None, min_length=10)
    date_of_birth: date | None = None
    avatar: str | None = None
    gender: Gender | None = None


class UserResponse(UserBase):
    id: int
    username: str
    avatar: str | None = None
    user_role: str
    created_at: datetime
    travel_profile: UserTravelProfileResponse | None = None
    interests: list[UserInterestResponse] = []

    class Config:
        from_attributes = True
