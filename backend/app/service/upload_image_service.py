import cloudinary.uploader
from cloudinary.api import resource_types
from fastapi import UploadFile, HTTPException, status
from sqlalchemy.orm import Session

from app.models import Place, User
from app.repository.place_repository import PlaceRepository
from app.repository.user_repository import UserRepository
from app.schemas.place import PlaceImageCreate

ALLOWED_CONTENT_TYPES = {
    'image/jpeg', 'image/png', 'image/jpg',
}
MAX_FILE_SIZE_MB = 5


def validate_image(file: UploadFile):
    if file.content_type not in ALLOWED_CONTENT_TYPES:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Chỉ chấp nhận ảnh JPEG/JPG, PNG')


def upload_image_to_cloudinary(file: UploadFile, folder: str, public_id: str | None = None):
    validate_image(file)

    res = cloudinary.uploader.upload(
        file.file,
        folder=folder,
        public_id=public_id,
        overwrite=True,
        resource_type='image'
    )
    return res['secure_url']


def upload_user_avatar(db: Session, file: UploadFile, user: User):
    url = upload_image_to_cloudinary(file, folder='avatars', public_id=f'user_{user.id}')
    return UserRepository(db).update_avatar(user, url)


def upload_place_images(db: Session, place: Place, files: list[UploadFile]):
    repo = PlaceRepository(db)
    has_primary = any(img.is_primary for img in place.images)
    add_imgs = []
    for i, file in enumerate(files):
        url = upload_image_to_cloudinary(file, folder=f'places/{place.id}')
        make_primary = not has_primary and i == 0
        add_imgs.append(PlaceImageCreate(img_url=url, is_primary=make_primary))

    return repo.add_images(place, add_imgs)


def upload_review_images(files: list[UploadFile], place_id: int):
    return [upload_image_to_cloudinary(file, folder=f'reviews/{place_id}') for file in files]

def delete_image(public_id: str) -> None:
    cloudinary.uploader.destroy(public_id)
