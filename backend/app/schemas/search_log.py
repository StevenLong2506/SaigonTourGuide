from datetime import datetime
from typing import Any

from pydantic import BaseModel


class SearchLogResponse(BaseModel):
    id: int
    user_id: int | None = None
    query_text: str
    filters: dict[str, Any] | None = None
    result_count: int | None = None
    created_at: datetime

    class Config:
        from_attributes = True