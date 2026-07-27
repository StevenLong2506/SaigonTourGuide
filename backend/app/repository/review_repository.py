from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models import Review, Place
from app.models.enums import ReviewStatus
from app.repository.base import BaseRepository
from app.schemas.review import ReviewCreate, ReviewUpdate


class ReviewRepository(BaseRepository[Review]):
    def __init__(self, db: Session):
        super().__init__(Review, db)

    def get_by_place_and_user(self, place_id: int, user_id: int) -> Review | None:
        return self.db.query(Review).filter_by(place_id=place_id, user_id=user_id).first()

    def get_by_place(self, place_id: int, skip: int = 0, limit: int = 100) -> list[Review]:
        return (
            self.db.query(Review).filter(Review.place_id == place_id).offset(skip).limit(limit).all()
        )

    def list_full(self, skip: int = 0, limit: int = 100, status: ReviewStatus | None = None,
                  place_id: int | None = None) -> list[Review]:
        q = self.db.query(Review)
        if status is not None:
            q = q.filter_by(status=status)
        if place_id is not None:
            q = q.filter_by(place_id=place_id)

        return q.order_by(Review.created_at.desc()).offset(skip).limit(limit).all()

    def create_review(self, payload: ReviewCreate, place_id: int, user_id: int) -> Review:
        new_review = Review(**payload.model_dump(),
                            place_id=place_id, user_id=user_id)
        review = self.create(new_review)
        self.calculate_place_rating(place_id)
        return review

    def update_review(self, review: Review, payload: ReviewUpdate) -> Review:
        data = payload.model_dump(exclude_unset=True)
        for field, value in data.items():
            setattr(review, field, value)

        updated = self.update(review)
        self.calculate_place_rating(review.place_id)
        return updated

    def delete_review(self, review: Review) -> None:
        place_id = review.place_id
        self.delete(review)
        self.calculate_place_rating(place_id)

    def calculate_place_rating(self, place_id) -> None:
        result = (
            self.db.query(func.avg(Review.rating), func.count(Review.id))
            .filter(Review.place_id == place_id)
            .filter(Review.status == ReviewStatus.APPROVED)
            .one()
        )

        avg_rating, total = result
        place = self.db.query(Place).filter_by(id=place_id).first()
        if place:
            place.average_rating = round(avg_rating, 1) if avg_rating else 0
            place.total_reviews = total
            self.db.commit()

    def set_status(self, review: Review, status: ReviewStatus) -> Review:
       review.status=status
       self.update(review)

       self.calculate_place_rating(review.place_id)
       self.db.refresh(review)
       return review

    def count_reviews(self, status: ReviewStatus | None=None, place_id: int|None=None)-> int:
        q = self.db.query(Review)
        if status is not None:
            q=q.filter_by(status=status)
        if place_id is not None:
            q=q.filter_by(place_id=place_id)

        return q.count()