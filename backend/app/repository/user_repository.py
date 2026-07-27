from fastapi import UploadFile, File
from sqlalchemy.orm import Session, selectinload

from app.core.security import hash_password
from app.models import User, UserInterest, InterestTag, UserTravelProfile
from app.repository.base import BaseRepository, ModelType
from app.schemas.user import UserRegister, UserUpdate, UserTravelProfileUpdate


class UserRepository(BaseRepository[User]):
    def __init__(self, db: Session):
        super().__init__(User, db)

    def get_by_id(self, user_id: int) -> User | None:
        return self.db.query(User).filter_by(id=user_id).first()

    def get_by_username(self, username: str) -> User | None:
        return (self.db.query(User)
                .filter_by(username=username).first())

    def get_by_email(self, email: str) -> User | None:
        return (self.db.query(User)
                .filter_by(email=email).first())

    def get_full(self, user_id: int) -> User | None:
        return (
            self.db.query(User).options(
                selectinload(User.travel_profile),
                selectinload(User.interests).selectinload(UserInterest.tag),
            )
            .filter_by(id=user_id).first()
        )

    def list_full(self, skip: int = 0, limit: int = 100) -> list[User]:
        return (
            self.db.query(User)
            .options(
                selectinload(User.travel_profile),
                selectinload(User.interests).selectinload(UserInterest.tag),
            )
            .offset(skip)
            .limit(limit)
            .all()
        )

    def create_user(self, user_data: UserRegister) -> User:
        new_user = User(
            name=user_data.name,
            username=user_data.username,
            hash_password=hash_password(user_data.password),
            email=user_data.email,
            phone=user_data.phone,
            date_of_birth=user_data.date_of_birth,
            gender=user_data.gender,
        )
        return self.create(new_user)

    def update_user(self, user: User, payload: UserUpdate) -> User:
        data = payload.model_dump(exclude_unset=True)
        for field, value in data.items():
            setattr(user, field, value)

        return self.update(user)

    def change_password(self, user: User, new_password: str) -> User:
        user.hash_password = hash_password(new_password)
        return self.update(user)

    def set_interests(self, user: User, interests: list[UserInterest]) -> User:
        dedup = {i.tag_id: i.priority for i in interests}

        if dedup:
            rows = (
                self.db.query(InterestTag.id)
                .filter(InterestTag.id.in_(dedup.keys())).all()
            )
            found = {r[0] for r in rows}
            missing = set(dedup) - found
            if missing:
                raise ValueError(f'tag_id không tồn tại: {sorted(missing)}')

        self.db.query(UserInterest).filter_by(user_id=user.id).delete(synchronize_session=False)

        for tag_id, priority in dedup.items():
            self.db.add(UserInterest(user_id=user.id, tag_id=tag_id, priority=priority))

        self.db.commit()

        return self.get_full(user.id)

    def set_travel_profile(self, user: User, payload: UserTravelProfileUpdate) -> UserTravelProfile:
        profile = user.travel_profile
        if profile is None:
            profile = UserTravelProfile(user_id=user.id)
            self.db.add(profile)

        data = payload.model_dump(exclude_unset=True)
        for field, value in data.items():
            setattr(profile,field,value)

        self.db.commit()
        self.db.refresh(profile)
        return profile


    def update_avatar(self, user: User, url: str) -> User:
        user.avatar=url
        self.db.commit()
        self.db.refresh(user)
        return self.get_full(user.id)