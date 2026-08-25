from datetime import datetime, timedelta

from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models import SearchLog
from app.repository.base import BaseRepository


class SearchLogRepository(BaseRepository[SearchLog]):
    def __init__(self, db: Session):
        super().__init__(SearchLog, db)

    def create_log(self, query_text: str, filters: dict | None = None, result_count: int | None = None,
                   user_id: int | None = None):
        log = SearchLog(user_id=user_id, query_text=query_text, filters=filters, result_count=result_count)
        return self.create(log)

    def _aggregate(self, limit: int, days: int | None, only_zero: bool):
        kw = func.lower(func.trim(SearchLog.query_text))
        q = self.db.query(kw.label('keyword'), func.count(SearchLog.id).label('count'))
        if only_zero:
            q = q.filter(SearchLog.result_count == 0)

        if days:
            q = q.filter(SearchLog.created_at >= datetime.utcnow() - timedelta(days=days))

        return q.group_by(kw).order_by(func.count(SearchLog.id).desc()).limit(limit).all()


    def popular_keywords(self, limit: int=20, days:int|None=None):
        return self._aggregate(limit=limit, days=days, only_zero=False)

    def zero_result_keywords(self, limit: int=20, days:int|None=None):
        return self._aggregate(limit=limit, days=days, only_zero=True)
