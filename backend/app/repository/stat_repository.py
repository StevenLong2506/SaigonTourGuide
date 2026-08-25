from sqlalchemy import func
from sqlalchemy.orm import Session

from app.models import DailyStat, Place, Review, User, Favorite
from app.models.enums import PlaceStatus, ReviewStatus, TopPlaceOrderBy
from app.repository.base import BaseRepository


class StatRepository(BaseRepository[DailyStat]):
    def __init__(self, db: Session):
        super().__init__(DailyStat, db)

    def count_places(self, status: PlaceStatus | None = None) -> int:
        q = self.db.query(Place)
        if status is not None:
            q = q.filter_by(status=status)

        return q.count()

    def count_featured_places(self) -> int:
        return self.db.query(Place).filter(Place.is_featured.is_(True)).count()

    def count_reviews(self, status: ReviewStatus | None = None) -> int:
        q = self.db.query(Review)
        if status is not None:
            q = q.filter_by(status=status)

        return q.count()

    def count_users(self) -> int:
        return self.db.query(User).count()

    def sum_views(self) -> int:
        total = self.db.query(func.coalesce(func.sum(Place.total_views), 0)).scalar()
        return int(total)

    def average_rating(self) -> float:
        avg = self.db.query(func.avg(Place.average_rating)).filter(Place.total_reviews > 0).scalar()
        return round(float(avg), 2) if avg else 0.0

    def get_overview(self) -> dict:
        return {
            'total_places': self.count_places(),
            'active_places': self.count_places(PlaceStatus.ACTIVE),
            'pending_places': self.count_places(PlaceStatus.PENDING),
            'featured_places': self.count_featured_places(),
            'total_reviews': self.count_reviews(),
            'pending_reviews': self.count_reviews(ReviewStatus.PENDING),
            'total_users': self.count_users(),
            'total_views': self.sum_views(),
            'average_rating': self.average_rating(),
        }

    def get_top_places(self, limit: int = 10, order_by: TopPlaceOrderBy = TopPlaceOrderBy.VIEWS) -> list[Place]:
        favorite_count = func.count(Favorite.user_id).label('favorite_count')
        order_map = {
            TopPlaceOrderBy.VIEWS: Place.total_views.desc(),
            TopPlaceOrderBy.RATING: Place.average_rating.desc(),
            TopPlaceOrderBy.REVIEWS: Place.total_reviews.desc(),
            TopPlaceOrderBy.FAVORITES: favorite_count.desc(),
        }

        return (self.db.query(Place, favorite_count)
                .outerjoin(Favorite, Favorite.place_id == Place.id)
                .group_by(Place.id).order_by(order_map[order_by])
                .limit(limit).all())


    @staticmethod
    def to_top_place_data(place: Place, favorite_count: int)-> dict:
        return {
            'id': place.id,
            'name': place.name,
            'ward': place.ward,
            'total_views':place.total_views,
            'total_reviews':place.total_reviews,
            'average_rating': float(place.average_rating),
            'favorite_count': favorite_count,
        }