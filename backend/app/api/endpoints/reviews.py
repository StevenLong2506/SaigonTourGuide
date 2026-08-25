from datetime import date

from fastapi import APIRouter, status, Depends, Form, UploadFile, File, Query
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_user
from app.models import User
from app.schemas.review import ReviewResponse, ReviewUpdate
from app.service.review_service import ReviewService

router = APIRouter()


@router.post('/', response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
def create_review(place_id: int = Form(...), rating: int = Form(..., ge=1, le=5),
                  title: str | None = Form(default=None),
                  content: str | None = Form(default=None),
                  visit_date: date | None = Form(default=None),
                  files: list[UploadFile] = File(default=[]),
                  user: User = Depends(get_current_user),
                  db: Session = Depends(get_db)):
    return ReviewService(db).create(place_id=place_id, rating=rating, title=title, content=content,
                                    visit_date=visit_date, files=files, user_id=user.id)


@router.get('/place/{place_id}', response_model=list[ReviewResponse])
def list_reviews_by_place(place_id: int, skip: int = 0, limit: int = Query(default=20, le=100),
                          db: Session = Depends(get_db)):
    return ReviewService(db).list_by_place(place_id, skip=skip, limit=limit)


@router.get('/{review_id}', response_model=ReviewResponse)
def get_review(review_id: int, db: Session = Depends(get_db)):
    return ReviewService(db).get(review_id)


@router.patch('/{review_id}', response_model=ReviewResponse)
def update_review(review_id: int, payload: ReviewUpdate, user: User = Depends(get_current_user),
                  db: Session = Depends(get_db)):
    return ReviewService(db).update_own(review_id, payload, user)


@router.delete('/{review_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_review(review_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    ReviewService(db).delete_own(review_id, user)
