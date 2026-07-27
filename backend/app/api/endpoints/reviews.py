from datetime import date

from fastapi import APIRouter, HTTPException, status, Depends, Form, UploadFile, File, Query
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.api.helpers import get_place_or_404, get_review_or_404, get_own_review_or_403
from app.models import User
from app.models.enums import ReviewStatus
from app.repository.place_repository import PlaceRepository
from app.repository.review_repository import ReviewRepository
from app.schemas.review import ReviewResponse, ReviewCreate, ReviewUpdate
from app.service.upload_image_service import upload_review_images

router = APIRouter()


@router.post('/', response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
def create_review(place_id: int = Form(...), rating: int = Form(..., ge=1, le=5),
                  title: str | None = Form(default=None),
                  content: str | None = Form(default=None),
                  visit_date: date | None = Form(default=None),
                  files: list[UploadFile] = File(default=[]),
                  user: User = Depends(get_current_user),
                  db: Session = Depends(get_db)):
    get_place_or_404(repo=PlaceRepository(db), place_id=place_id)
    review_repo = ReviewRepository(db)
    if review_repo.get_by_place_and_user(place_id=place_id, user_id=user.id):
        raise HTTPException(status_code=status.HTTP_400_BAD_REQUEST, detail='Bạn đã đánh giá địa điểm này')

    imgs = upload_review_images(files=files, place_id=place_id) if files else []
    payload = ReviewCreate(rating=rating, title=title, content=content, visit_date=visit_date, images=imgs)

    return review_repo.create_review(payload=payload, place_id=place_id, user_id=user.id)


@router.get('/place/{place_id}', response_model=list[ReviewResponse])
def list_reviews_by_place(place_id: int, skip: int = 0, limit: int = Query(default=20, le=100),
                          db: Session = Depends(get_db)):
    get_place_or_404(repo=PlaceRepository(db), place_id=place_id)
    return ReviewRepository(db).list_full(skip=skip, limit=limit, status=ReviewStatus.APPROVED, place_id=place_id)


@router.get('/{review_id}', response_model=ReviewResponse)
def get_review(review_id: int, db: Session = Depends(get_db)):
    return get_review_or_404(repo=ReviewRepository(db), review_id=review_id)


@router.patch('/{review_id}', response_model=ReviewResponse)
def update_review(review_id: int, payload: ReviewUpdate, user: User = Depends(get_current_user),
                  db: Session = Depends(get_db)):
   repo = ReviewRepository(db)
   review = get_own_review_or_403(repo=repo, review_id=review_id, user=user)
   return repo.update_review(review=review, payload=payload)


@router.delete('/{review_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_review(review_id: int, user: User = Depends(get_current_user), db: Session=Depends(get_db)):
    repo = ReviewRepository(db)
    review = get_own_review_or_403(repo=repo, review_id=review_id, user=user)
    repo.delete_review(review=review)
