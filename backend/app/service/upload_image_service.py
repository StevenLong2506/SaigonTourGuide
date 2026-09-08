import cloudinary.uploader
from fastapi import UploadFile, HTTPException, status

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










def delete_image(public_id: str) -> None:
    cloudinary.uploader.destroy(public_id)

class UploadImageService:
    def __init__(self, place_repo: PlaceRepository, user_repo: UserRepository):
        self.place_repo=place_repo
        self.user_repo=user_repo

    def upload_user_avatar(self, file: UploadFile, user: User):
        url = upload_image_to_cloudinary(file, folder='avatars', public_id=f'user_{user.id}')
        return self.user_repo.update_avatar(user, url)

    def upload_place_images(self, place: Place, files: list[UploadFile]):
        has_primary = any(img.is_primary for img in place.images)
        add_imgs = []
        for i, file in enumerate(files):
            url = upload_image_to_cloudinary(file, folder=f'places/{place.id}')
            make_primary = not has_primary and i == 0
            add_imgs.append(PlaceImageCreate(img_url=url, is_primary=make_primary))

        return self.place_repo.add_images(place, add_imgs)

    def upload_review_images(self, files: list[UploadFile], place_id: int):
        return [upload_image_to_cloudinary(file, folder=f'reviews/{place_id}') for file in files]