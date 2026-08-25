from sqlalchemy.orm import Session

from app.models.enums import TopPlaceOrderBy
from app.repository.search_log_repository import SearchLogRepository
from app.repository.stat_repository import StatRepository


class StatService:
    def __init__(self, db: Session):
        self.db = db
        self.search_log_repo = SearchLogRepository(db)
        self.stat_repo = StatRepository(db)

    def get_overview(self):
        return self.stat_repo.get_overview()

    def get_top_places(self, limit: int = 10, order_by: TopPlaceOrderBy = TopPlaceOrderBy.VIEWS):
        rows = self.stat_repo.get_top_places(limit=limit, order_by=order_by)
        return [self.stat_repo.to_top_place_data(place, favorite_count) for place, favorite_count in rows]

    def log_search(self, query_text: str | None, filters: dict | None = None, result_count: int | None = None,
                   user_id: int | None = None):
        query_text = (query_text or '').strip()
        if not query_text:
            return
        try:
            self.search_log_repo.create_log(query_text=query_text, filters=filters, result_count=result_count,
                                            user_id=user_id)
        except Exception:
            self.db.rollback()


    def get_popular_keywords(self, limit:int=20, days:int|None=None):
        kw = self.search_log_repo.popular_keywords(limit, days)
        return [{'keyword': k, 'count': c} for k, c in kw]

    def get_zero_result_keywords(self, limit: int=20, days:int|None=None):
        kw = self.search_log_repo.zero_result_keywords(limit, days)
        return [{'keyword': k, 'count': c} for k, c in kw]
