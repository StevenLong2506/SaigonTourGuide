import logging

import cloudinary.uploader
from fastapi import UploadFile, HTTPException, status

ALLOWED_CONTENT_TYPES = {
    'image/jpeg', 'image/png', 'image/jpg',
}
MAX_FILE_SIZE_MB = 5
logger = logging.getLogger(__name__)


def validate_image(file: UploadFile):
    if file.content_type not in ALLOWED_CONTENT_TYPES:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Chỉ chấp nhận ảnh JPEG/JPG, PNG')
    if file.size is not None and file.size > MAX_FILE_SIZE_MB * 1024 * 1024:
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST,
                            detail=f'Ảnh không được vượt quá {MAX_FILE_SIZE_MB} MB')


def upload_image_to_cloudinary(file: UploadFile, folder: str, public_id: str | None = None):
    validate_image(file)

    res = cloudinary.uploader.upload(
        file.file,
        folder=folder,
        public_id=public_id,
        overwrite=True,
        resource_type='image'
    )
    return res['secure_url'], res['public_id']


def delete_image(public_id: str) -> None:
    cloudinary.uploader.destroy(public_id)


class UploadImageService:

    @staticmethod
    def delete_images(public_ids: list[str]) -> None:
        for pid in public_ids:
            try:
                cloudinary.uploader.destroy(pid)
            except Exception:
                logger.exception('Không xóa được ảnh Cloudinary %s', pid)

    def _upload_many(self, files: list[UploadFile], folder: str) -> list[tuple[str, str]]:
        uploaded: list[tuple[str, str]] = []
        try:
            for file in files:
                uploaded.append(upload_image_to_cloudinary(file=file, folder=folder))
        except Exception as e:
            self.delete_images([pid for _, pid in uploaded])
            raise
        return uploaded

    def upload_user_avatar(self, file: UploadFile, user_id: int) -> tuple[str, str]:
        return upload_image_to_cloudinary(file, folder='avatars', public_id=f'user_{user_id}')

    def upload_place_images(self, place_id: int, files: list[UploadFile]) -> list[tuple[str, str]]:
        return self._upload_many(files=files, folder=f'places/{place_id}')

    def upload_review_images(self, files: list[UploadFile], place_id: int) -> list[tuple[str, str]]:
        return self._upload_many(files=files, folder=f'reviews/{place_id}')
