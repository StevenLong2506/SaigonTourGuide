from collections.abc import Iterator
from contextlib import contextmanager

from sqlalchemy.orm import Session


class UnitOfWork:
    def __init__(self, session: Session):
        self._session = session
        self._active = False

    @contextmanager
    def transaction(self) -> Iterator[None]:

        if self._active:
            raise RuntimeError('Nested Transaction appear')

        self._active = True
        try:
            yield
        except BaseException:
            self._session.rollback()
            raise
        else:
            self._session.commit()
        finally:
            self._active = False

    def end_read(self) -> None:
        self._session.commit()