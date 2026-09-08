from fastapi import APIRouter, Query, Depends, status

from app.api.deps import get_current_admin, ReviewServiceDep
from app.models import User
from app.models.enums import ReviewStatus
from app.schemas.review import ReviewResponse, ReviewStatusUpdate

router = APIRouter()


@router.get('/', response_model=list[ReviewResponse])
def list_reviews(service: ReviewServiceDep, skip: int = 0, limit: int = Query(default=20, le=100),
                 review_status: ReviewStatus | None = None,
                 place_id: int | None = None,
                 admin: User = Depends(get_current_admin)):
    return service.admin_list(skip=skip, limit=limit, review_status=review_status, place_id=place_id)


@router.patch('/{review_id}/status', response_model=ReviewResponse)
def moderate_review(review_id: int, payload: ReviewStatusUpdate, service: ReviewServiceDep,
                    admin: User = Depends(get_current_admin)):
    return service.admin_set_status(review_id, payload)


@router.delete('/{review_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_review(review_id: int, service: ReviewServiceDep, admin: User = Depends(get_current_admin)):
    service.admin_delete(review_id)
