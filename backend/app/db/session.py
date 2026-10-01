from sqlalchemy import create_engine, event
from sqlalchemy.orm import sessionmaker, Session

from app.core.config import settings

engine = create_engine(settings.DATABASE_URL,
                       pool_size=10,
                       max_overflow=20,
                       pool_pre_ping=True,
                       pool_recycle=1800)
SessionLocal = sessionmaker(expire_on_commit=False, autoflush=False, bind=engine)


@event.listens_for(Session, 'after_flush')
def _mark_pending(session, flush_context):
    session.info['pending_writes'] = True

@event.listens_for(Session, 'after_commit')
@event.listens_for(Session, 'after_rollback')
def _clear_pending(session):
    session.info.pop('pending_writes', None)