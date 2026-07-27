from fastapi import HTTPException, Depends
from starlette import status

from app.api.deps import get_current_user
from app.models import User
from app.repository.category_repository import CategoryRepository

from app.repository.interest_tag_repository import InterestTagRepository
from app.repository.place_repository import PlaceRepository
from app.repository.review_repository import ReviewRepository


def get_place_or_404(repo: PlaceRepository, place_id: int):
    place = repo.get_full(place_id)
    if place is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail='Địa điểm không tồn tại')
    return place


def get_tags_or_404(repo: InterestTagRepository, tag_id:int):
    tag = repo.get_by_id(tag_id)
    if tag is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Tag không tồn tại')

    return tag


def get_review_or_404(repo: ReviewRepository, review_id: int):
    review = repo.get_by_id(review_id)
    if review is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail='Đánh giá không tồn tại')

    return review


def get_own_review_or_403(repo: ReviewRepository, review_id: int, user: User = Depends(get_current_user)):
    review = get_review_or_404(repo, review_id)
    if review.user_id != user.id:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail='Bạn không có quyền với đánh giá này')
    return review


def get_category_or_404(repo: CategoryRepository, cate_id:int):
    cate = repo.get_by_id(cate_id)
    if cate is None:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND,
                            detail='Danh mục không tồn tại')
    return cate
