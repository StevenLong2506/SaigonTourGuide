from datetime import date

from fastapi import APIRouter, status, Depends, Form, UploadFile, File, Query

from app.api.deps import ReviewServiceDep, get_current_user
from app.models import User
from app.schemas.review import ReviewResponse, ReviewUpdate

router = APIRouter()


@router.post('/', response_model=ReviewResponse, status_code=status.HTTP_201_CREATED)
def create_review(service: ReviewServiceDep,place_id: int = Form(...), rating: int = Form(..., ge=1, le=5),
                  title: str | None = Form(default=None),
                  content: str | None = Form(default=None),
                  visit_date: date | None = Form(default=None),
                  files: list[UploadFile] = File(default=[]),
                  user: User = Depends(get_current_user)):
    return service.create(place_id=place_id, rating=rating, title=title, content=content,
                                    visit_date=visit_date, files=files, user_id=user.id)


@router.get('/place/{place_id}', response_model=list[ReviewResponse])
def list_reviews_by_place(place_id: int, service: ReviewServiceDep, skip: int = 0, limit: int = Query(default=20, le=100)):
    return service.list_by_place(place_id, skip=skip, limit=limit)


@router.get('/{review_id}', response_model=ReviewResponse)
def get_review(review_id: int, service: ReviewServiceDep):
    return service.get(review_id)


@router.patch('/{review_id}', response_model=ReviewResponse)
def update_review(review_id: int, payload: ReviewUpdate, service: ReviewServiceDep,user: User = Depends(get_current_user)):
    return service.update_own(review_id, payload, user)


@router.delete('/{review_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_review(review_id: int, service: ReviewServiceDep,user: User = Depends(get_current_user)):
    service.delete_own(review_id, user)
