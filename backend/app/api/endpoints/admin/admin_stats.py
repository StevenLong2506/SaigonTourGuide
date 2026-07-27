from fastapi import APIRouter, Depends, Query
from sqlalchemy.orm import Session

from app.api.deps import get_current_admin, get_db
from app.models import User
from app.models.enums import TopPlaceOrderBy
from app.repository.stat_repository import StatRepository
from app.schemas.stat import OverviewResponse, TopPlaceResponse

router = APIRouter()

@router.get('/overview', response_model=OverviewResponse)
def get_overview(admin: User = Depends(get_current_admin), db: Session = Depends(get_db)):
    return StatRepository(db).get_overview()



@router.get('/top-places', response_model=list[TopPlaceResponse])
def get_top_places(limit: int = Query(default=10, le=50), order_by: TopPlaceOrderBy = TopPlaceOrderBy.VIEWS,
                   admin: User = Depends(get_current_admin), db: Session=Depends(get_db)):
    repo = StatRepository(db)
    rows = repo.get_top_places(limit=limit,order_by=order_by)
    return [repo.to_top_place_data(place, favorite_count) for place, favorite_count in rows]