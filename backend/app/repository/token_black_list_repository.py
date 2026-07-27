from datetime import datetime, timezone

from sqlalchemy.orm import Session

from app.models.token_blacklist import TokenBlackList
from app.repository.base import BaseRepository


class TokenBlackListRepository(BaseRepository[TokenBlackList]):
    def __init__(self, db: Session):
        super().__init__(TokenBlackList, db)

    def is_blacklisted(self, jti: str) -> bool:
        if not jti:
            return False

        return (
                self.db.query(TokenBlackList.id).filter_by(jti=jti).first() is not None
        )

    def revoke(self, jti: str, user_id: int, expires_at: datetime) -> TokenBlackList | None:
        if self.is_blacklisted(jti):
            return None

        entry = TokenBlackList(jti=jti, user_id=user_id, expires_at=expires_at)
        return self.create(entry)

    def purge_expired(self) -> int:
       now = datetime.now(timezone.utc).replace(tzinfo=None)
       deleted=(
           self.db.query(TokenBlackList).filter(TokenBlackList.expires_at < now)
           .delete(synchronize_session=False)
       )
       self.db.commit()
       return deleted