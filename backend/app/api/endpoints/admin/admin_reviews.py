from fastapi import APIRouter, Query, Depends, HTTPException,status
from sqlalchemy.orm import Session

from app.api.deps import get_db, get_current_admin
from app.api.helpers import get_review_or_404
from app.models import User, Review
from app.models.enums import ReviewStatus
from app.repository.review_repository import ReviewRepository
from app.schemas.review import ReviewResponse, ReviewStatusUpdate

router = APIRouter()

@router.get('/', response_model=list[ReviewResponse])
def list_reviews(skip:int=0, limit:int=Query(default=20,le=100),
                 review_status: ReviewStatus | None=None,
                 place_id:int|None=None,
                 admin:User=Depends(get_current_admin),
                 db:Session=Depends(get_db)):

   repo = ReviewRepository(db)
   reviews = repo.list_full(skip=skip, limit=limit,status=review_status,place_id=place_id)

   return reviews


@router.patch('/{review_id}/status',response_model=ReviewResponse)
def moderate_review(review_id:int, payload:ReviewStatusUpdate, admin:User=Depends(get_current_admin),
                    db:Session=Depends(get_db)):
    repo = ReviewRepository(db)
    review = get_review_or_404(repo, review_id)
    return repo.set_status(review, payload.status)

@router.delete('/{review_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_review(review_id:int, admin:User=Depends(get_current_admin), db:Session=Depends(get_db)):
    repo = ReviewRepository(db)
    review = get_review_or_404(repo, review_id)
    repo.delete_review(review)
