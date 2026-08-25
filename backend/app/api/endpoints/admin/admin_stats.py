from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.models import User
from app.models.enums import TopPlaceOrderBy
from app.schemas.search_log import KeywordStatResponse
from app.schemas.stat import OverviewResponse, TopPlaceResponse
from app.service.stat_service import StatService

router = APIRouter()


@router.get('/overview', response_model=OverviewResponse)
def get_overview(admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return StatService(db).get_overview()


@router.get('/top-places', response_model=list[TopPlaceResponse])
def get_top_places(limit: int = Query(default=10, le=50), order_by: TopPlaceOrderBy = TopPlaceOrderBy.VIEWS,
                   admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return StatService(db).get_top_places(limit=limit, order_by=order_by)


@router.get('/popular-keywords', response_model=list[KeywordStatResponse])
def popular_keywords(limit: int = Query(default=20, le=100), days: int | None = Query(default=None, ge=1),
                     admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return StatService(db).get_popular_keywords(limit=limit, days=days)


@router.get('/zero-result-keywords', response_model=list[KeywordStatResponse])
def zero_default_keywords(limit: int = Query(default=20, le=100), days: int | None = Query(default=None, ge=1),
                          admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return StatService(db).get_zero_result_keywords(limit=limit, days=days)
