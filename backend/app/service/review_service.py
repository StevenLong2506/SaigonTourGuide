from datetime import date

from fastapi import HTTPException, UploadFile, status
from sqlalchemy.exc import IntegrityError

from app.db.uow import UnitOfWork
from app.service.helpers import get_place_or_404, get_review_or_404, get_own_review_or_403
from app.models import User
from app.models.enums import ReviewStatus
from app.repository.place_repository import PlaceRepository
from app.repository.review_repository import ReviewRepository
from app.schemas.review import ReviewCreate, ReviewUpdate, ReviewStatusUpdate
from app.service.upload_image_service import UploadImageService


class ReviewService:
    def __init__(self, repo: ReviewRepository, place_repo: PlaceRepository, upload_service: UploadImageService,
                 uow: UnitOfWork):
        self.repo = repo
        self.place_repo = place_repo
        self.upload_service = upload_service
        self.uow = uow

    def create(self, *, place_id: int, rating: int, title: str | None, content: str | None,
               visit_date: date | None, files: list[UploadFile], user_id: int):
        get_place_or_404(self.place_repo, place_id)
        if self.repo.get_by_place_and_user(place_id=place_id, user_id=user_id):
            raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Bạn đã đánh giá địa điểm này')

        self.uow.end_read()
        uploaded = self.upload_service.upload_review_images(files=files, place_id=place_id) if files else []
        imgs = [url for url, _ in uploaded]
        payload = ReviewCreate(rating=rating, title=title, content=content, visit_date=visit_date, images=imgs)

        try:
            with self.uow.transaction():
                review = self.repo.create_review(payload=payload, place_id=place_id, user_id=user_id)
        except Exception as e:
            self.upload_service.delete_images([pid for _, pid in uploaded])
            if isinstance(e, IntegrityError):
                raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Bạn đã đánh giá địa điểm này')
            raise
        return review

    def list_by_place(self, place_id: int, skip: int = 0, limit: int = 20):
        get_place_or_404(self.place_repo, place_id)
        return self.repo.list_full(skip=skip, limit=limit, status=ReviewStatus.APPROVED, place_id=place_id)

    def get(self, review_id: int):
        return get_review_or_404(self.repo, review_id)

    def update_own(self, review_id: int, payload: ReviewUpdate, user: User):
        review = get_own_review_or_403(self.repo, review_id, user=user)
        with self.uow.transaction():
            review = self.repo.update_review(review=review, payload=payload)
        return review

    def delete_own(self, review_id: int, user: User):
        review = get_own_review_or_403(self.repo, review_id, user=user)
        with self.uow.transaction():
            self.repo.delete_review(review=review)

    # ---- Admin ----
    def admin_list(self, skip: int = 0, limit: int = 20, review_status: ReviewStatus | None = None,
                   place_id: int | None = None):
        return self.repo.list_full(skip=skip, limit=limit, status=review_status, place_id=place_id)

    def admin_set_status(self, review_id: int, payload: ReviewStatusUpdate):
        review = get_review_or_404(self.repo, review_id)
        with self.uow.transaction():
            review = self.repo.set_status(review, payload.status)
        return review

    def admin_delete(self, review_id: int):
        review = get_review_or_404(self.repo, review_id)
        with self.uow.transaction():
            self.repo.delete_review(review)
