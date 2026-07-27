from decimal import Decimal

from sqlalchemy import select, and_, or_, func
from sqlalchemy.orm import Session, selectinload

from app.models import Place, PlaceCategory, PlaceTag, PlaceAgeGroup, PlaceImage, Category, InterestTag
from app.models.enums import PlaceStatus, AgeGroup, PlaceSortBy
from app.repository.base import BaseRepository
from app.schemas.place import PlaceCreate, PlaceUpdate, PlaceTagCreate, PlaceAgeGroupCreate, PlaceImageCreate


class PlaceRepository(BaseRepository[Place]):
    def __init__(self, db: Session):
        super().__init__(Place, db)

    def query_full(self):
        return self.db.query(Place).options(
            selectinload(Place.categories).selectinload(PlaceCategory.category),
            selectinload(Place.tags).selectinload(PlaceTag.tag),
            selectinload(Place.age_groups),
            selectinload(Place.images),
        )

    def get_full(self, place_id: int) -> Place | None:
        return self.query_full().filter_by(id=place_id).first()

    def list_full(self, skip: int = 0, limit: int = 100, status: PlaceStatus | None = None,
                  district: str | None = None, is_featured: bool | None = None) -> list[Place]:
        q = self.query_full()
        if status is not None:
            q = q.filter_by(status=status)
        if district is not None:
            q = q.filter_by(district=district)
        if is_featured is not None:
            q = q.filter_by(is_featured=is_featured)

        return q.order_by(Place.created_at.desc()).offset(skip).limit(limit).all()

    def count(self, status: PlaceStatus | None = None) -> int:
        q = self.db.query(Place)
        if status is not None:
            q = q.filter_by(status=status)
        return q.count()

    def get_by_name(self, name: str) -> Place | None:
        return self.db.query(Place).filter_by(name=name).first()

    def get_by_district(self, district: str) -> list[Place]:
        return self.db.query(Place).filter_by(district=district).all()

    def check_cates(self, cate_ids) -> set[int]:
        ids = set(cate_ids or [])
        if not ids:
            return ids

        q = self.db.query(Category.id).filter(Category.id.in_(ids)).all()
        found = {r[0] for r in q}
        missing = ids - found
        if missing:
            raise ValueError(f'category_id không tồn tại: {sorted(missing)}')
        return ids

    def check_tags(self, tags: list[PlaceTagCreate]) -> dict[int, object]:
        dedup = {t.tag_id: t.relevance for t in (tags or [])}
        if not dedup:
            return dedup
        q = self.db.query(InterestTag.id).filter(InterestTag.id.in_(dedup.keys())).all()
        found = {r[0] for r in q}
        missing = set(dedup) - found
        if missing:
            raise ValueError(f'tag_id không tồn tại: {sorted(missing)}')

        return dedup

    @staticmethod
    def dedup_age_groups(age_groups: list[PlaceAgeGroupCreate]) -> dict:
        return {a.age_group: a.suitability for a in (age_groups or [])}

    @staticmethod
    def normalize_images(images: list[PlaceImageCreate]) -> list[PlaceImageCreate]:
        if not images:
            return []
        primary_idx = next((i for i, img in enumerate(images) if img.is_primary), 0)
        for i, img in enumerate(images):
            img.is_primary = (i == primary_idx)

        return images

    @staticmethod
    def check_price_and_time(price_min, price_max, opening_time, closing_time):
        if price_min is not None and price_max is not None and price_min > price_max:
            raise ValueError('price_min không được lớn hơn price_max')
        if opening_time is not None and closing_time is not None and opening_time == closing_time:
            raise ValueError('opening_time và closing_time không được trùng nhau')

    def create_place(self, payload: PlaceCreate, created_by: int) -> Place:

        cate_ids = self.check_cates(payload.category_ids)
        tags = self.check_tags(payload.tags)
        age_groups = self.dedup_age_groups(payload.age_groups)
        images = self.normalize_images(payload.images)
        self.check_price_and_time(payload.price_min, payload.price_max, payload.opening_time, payload.closing_time)

        new_place = Place(
            name=payload.name,
            description=payload.description,
            address=payload.address,
            district=payload.district,
            ward=payload.ward,
            link_google_map=payload.link_google_map,
            phone=payload.phone,
            website=payload.website,
            price_min=payload.price_min,
            price_max=payload.price_max,
            opening_time=payload.opening_time,
            closing_time=payload.closing_time,
            open_days=payload.open_days,
            is_featured=payload.is_featured,
            status=payload.status,
            created_by=created_by,
        )

        self.db.add(new_place)
        self.db.flush()

        for category_id in cate_ids:
            self.db.add(PlaceCategory(place_id=new_place.id, category_id=category_id))

        for tag_id, relevance in tags.items():
            self.db.add(PlaceTag(place_id=new_place.id, tag_id=tag_id, relevance=relevance))

        for age_group, suitability in age_groups.items():
            self.db.add(PlaceAgeGroup(place_id=new_place.id, age_group=age_group, suitability=suitability))

        for img in images:
            self.db.add(PlaceImage(place_id=new_place.id, img_url=img.img_url,
                                   caption=img.caption, is_primary=img.is_primary))

        self.db.commit()
        return self.get_full(new_place.id)

    def update_place(self, place: Place, payload: PlaceUpdate) -> Place:
        data = payload.model_dump(exclude_unset=True)
        cate_ids = data.pop('category_ids', None)
        tags = data.pop('tags', None)
        age_groups = data.pop('age_groups', None)

        self.check_price_and_time(
            data.get('price_min', place.price_min),
            data.get('price_max', place.price_max),
            data.get('opening_time', place.opening_time),
            data.get('closing_time', place.closing_time),
        )

        for field, value in data.items():
            setattr(place, field, value)

        if cate_ids is not None:
            ids = self.check_cates(cate_ids)
            self.db.query(PlaceCategory).filter_by(place_id=place.id).delete(synchronize_session=False)
            for cate_id in ids:
                self.db.add(PlaceCategory(place_id=place.id, category_id=cate_id))

        if tags is not None:
            checked = self.check_tags([PlaceTagCreate(**t) for t in tags])
            self.db.query(PlaceTag).filter_by(place_id=place.id).delete(synchronize_session=False)
            for tag_id, relevance in checked.items():
                self.db.add(PlaceTag(place_id=place.id, tag_id=tag_id, relevance=relevance))

        if age_groups is not None:
            groups = self.dedup_age_groups([PlaceAgeGroupCreate(**a) for a in age_groups])
            self.db.query(PlaceAgeGroup).filter_by(place_id=place.id).delete(synchronize_session=False)
            for age_group, suitability in groups.items():
                self.db.add(PlaceAgeGroup(place_id=place.id, age_group=age_group, suitability=suitability))

        self.db.commit()

        return self.get_full(place.id)

    def set_status(self, place: Place, status: PlaceStatus) -> Place:
        place.status = status
        self.db.commit()
        return self.get_full(place.id)

    def set_featured(self, place: Place, is_featured: bool) -> Place:
        place.is_featured = is_featured
        self.db.commit()
        return self.get_full(place.id)

    def increment_view(self, place: Place) -> None:
        place.total_views = (place.total_views or 0) + 1
        self.db.commit()

    def get_image(self, place_id: int, img_id: int) -> PlaceImage | None:
        return self.db.query(PlaceImage).filter_by(id=img_id, place_id=place_id).first()

    def add_images(self, place: Place, images: list[PlaceImageCreate]) -> Place:
        has_primary = any(img.is_primary for img in place.images)
        for img in images:
            make_primary = img.is_primary or not has_primary
            if make_primary:
                self.db.query(PlaceImage).filter_by(place_id=place.id).update(
                    {PlaceImage.is_primary: False}, synchronize_session=False
                )
                has_primary = True
            self.db.add(PlaceImage(place_id=place.id, img_url=img.img_url,
                                   caption=img.caption, is_primary=make_primary))
        self.db.commit()
        return self.get_full(place.id)

    def set_primary_image(self, place: Place, image: PlaceImage) -> Place:
        self.db.query(PlaceImage).filter_by(place_id=place.id).update(
            {PlaceImage.is_primary: False}, synchronize_session=False
        )
        image.is_primary = True
        self.db.commit()
        return self.get_full(place.id)

    def delete_image(self, place: Place, image: PlaceImage) -> Place:
        was_primary = image.is_primary
        self.db.delete(image)
        self.db.flush()
        if was_primary:
            nxt = (self.db.query(PlaceImage).filter_by(place_id=place.id).order_by(PlaceImage.id).first())
            if nxt:
                nxt.is_primary = True

        self.db.commit()
        return self.get_full(place.id)

    def to_response_data(self, place: Place) -> dict:
        data = self.model_columns_to_dict(place)
        data['categories'] = [pc.category for pc in place.categories]
        data['tags'] = place.tags
        data['age_groups'] = place.age_groups
        data['images'] = place.images
        return data

    def to_summary_data(self, place: Place) -> dict:
        primary = next((i.img_url for i in place.images if i.is_primary), None)

        data = {
            'id': place.id, 'name': place.name, 'district': place.district, 'average_rating': place.average_rating,
            'total_reviews': place.total_reviews, 'total_views': place.total_views, 'is_featured': place.is_featured,
            'status': place.status, 'primary_image': primary,
        }

        return data

    def search_filters(self, *, q=None, category_ids=None, tag_ids=None, district=None,
                       ward=None, price_min=None, price_max=None, min_rating=None, age_group=None, min_suitability=None,
                       is_featured=None, status=PlaceStatus.ACTIVE) -> list:
        conditions = []

        if status is not None:
            conditions.append(Place.status == status)

        if q and q.strip():
            pattern = f'%{q.strip}%'
            conditions.append(
                or_(Place.name.ilike(pattern),
                    Place.address.ilike(pattern),
                    Place.description.ilike(pattern),
                    ))

        if district:
            conditions.append(Place.district == district)
        if ward:
            conditions.append(Place.ward == ward)
        if is_featured is not None:
            conditions.append(Place.is_featured == is_featured)

        if price_max is not None:
            conditions.append(Place.price_min <= Decimal(str(price_max)))
        if price_min is not None:
            conditions.append(Place.price_max >= Decimal(str(price_min)))

        if min_rating is not None:
            conditions.append(Place.average_rating >= Decimal(str(min_rating)))

        if category_ids:
            conditions.append(
                select(PlaceCategory.place_id).where(
                    and_(PlaceCategory.place_id == Place.id,
                         PlaceCategory.category_id.in_(list(category_ids)))
                ).exists()
            )

        if tag_ids:
            conditions.append(
                select(PlaceTag.place_id)
                .where(and_(PlaceTag.place_id == Place.id,
                            PlaceTag.tag_id.in_(list(tag_ids))))
                .exists()
            )

        if age_group is not None:
            age_conds = [PlaceAgeGroup.place_id == Place.id, PlaceAgeGroup.age_group == age_group]

            if min_suitability is not None:
                age_conds.append(PlaceAgeGroup.suitability >= min_suitability)

            conditions.append(
                select(PlaceAgeGroup.id).where(
                    and_(*age_conds)
                ).exists()
            )

        return conditions

    def search_places(self, *, q: str | None = None, category_ids: list[int] | None = None,
                      tag_ids: list[int] | None = None,
                      district: str | None = None, ward: str | None = None, price_min=None, price_max=None,
                      min_rating=None, age_group: AgeGroup | None = None, min_suitability: int | None = None,
                      is_featured: bool | None = None, sort_by: PlaceSortBy = PlaceSortBy.POPULAR,
                      skip: int = 0, limit: int = 20, status: PlaceStatus | None = PlaceStatus.ACTIVE) -> tuple[
        list[Place], int]:
        conditions = self.search_filters(
            q=q, category_ids=category_ids, tag_ids=tag_ids, district=district, ward=ward, price_min=price_min,
            price_max=price_max, min_rating=min_rating, age_group=age_group, min_suitability=min_suitability,
            is_featured=is_featured, status=status,
        )

        total = self.db.query(func.count(Place.id)).filter(*conditions).scalar() or 0

        order_map = {
            PlaceSortBy.RATING: [Place.average_rating.desc(), Place.total_reviews.desc()],
            PlaceSortBy.NEWEST: [Place.created_at.desc()],
            PlaceSortBy.PRICE_ASC: [Place.price_min.asc()],
            PlaceSortBy.PRICE_DESC: [Place.price_max.desc()],
            PlaceSortBy.POPULAR: [Place.total_views.desc(), Place.average_rating.desc()],
        }

        order = order_map[sort_by] + [Place.id.asc()]

        places = (self.db.query(Place)
                  .options(selectinload(Place.images))
                  .filter(*conditions).order_by(*order)
                  .offset(skip).limit(limit).all())

        return places, total

    def list_districts(self, status: PlaceStatus | None = PlaceStatus.ACTIVE) -> list[dict]:
        q = self.db.query(Place.district, func.count(Place.id))

        if status is not None:
            q = q.filter_by(status=status)

        rows = q.group_by(Place.district).order_by(Place.district.asc()).all()

        return [{'district': d, 'total': c} for d, c in rows]
