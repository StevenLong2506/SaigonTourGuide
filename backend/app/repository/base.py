from typing import TypeVar, Generic, Type, Optional

from sqlalchemy.exc import IntegrityError
from sqlalchemy.orm import Session

ModelType = TypeVar('ModelType')


class BaseRepository(Generic[ModelType]):
    def __init__(self, model: Type[ModelType], db: Session):
        self.model = model
        self.db = db

    def get_by_id(self, id: int) -> ModelType | None:
        return self.db.query(self.model).filter(self.model.id == id).first()

    def get_all(self, skip: int = 0, limit: int = 100) -> list[ModelType]:
        return self.db.query(self.model).offset(skip).limit(limit).all()

    def create(self, obj: ModelType) -> ModelType:
        try:
            self.db.add(obj)
            self.db.commit()
            self.db.refresh(obj)
            return obj
        except IntegrityError:
            self.db.rollback()
            raise ValueError('Lỗi tạo dữ liệu! Dữ liệu đã tồn tại hoặc vi phạm ràng buộc')


    def update(self, obj: ModelType) -> ModelType:
        try:
            self.db.commit()
            self.db.refresh(obj)
            return obj
        except IntegrityError:
            self.db.rollback()
            raise ValueError('Lỗi cập nhật dữ liệu')

    def delete(self, obj: ModelType) -> None:
        try:
            self.db.delete(obj)
            self.db.commit()
        except IntegrityError:
            self.db.rollback()
            raise ValueError('Lỗi xóa dữ liệu! Dữ liệu đang được tham chiếu ở nơi khác')

    @staticmethod
    def model_columns_to_dict(obj) -> dict:
        return {c.name: getattr(obj, c.name) for c in obj.__table__.columns}