from sqlalchemy.orm import Session
from sqlalchemy.sql.elements import and_

from app.models import PlaceEmbedding, Place, PlaceTag, PlaceAgeGroup
from app.models.enums import AgeGroup, PlaceStatus
from app.repository.base import BaseRepository


class PlaceEmbeddingRepository(BaseRepository[PlaceEmbedding]):
    def __init__(self, db: Session):
        super().__init__(PlaceEmbedding, db)

    def get_all_places(self):
        return self.db.query(Place).all()

    def delete_by_place(self, place_id: int):
        self.db.query(PlaceEmbedding).filter_by(place_id=place_id).delete(synchronize_session=False)

    def add_chunk(self, place_id: int, chunk_index: int, chunk_text: str,
                  embedding: list[float], metadata_: dict):
        new_chunk = PlaceEmbedding(
            place_id=place_id, chunk_index=chunk_index,
            chunk_text=chunk_text,
            embedding=embedding, metadata_=metadata_
        )
        self.db.add(new_chunk)
        return new_chunk

    def replace_place_chunk(self, place_id: int, chunk_text: str,
                            embedding: list[float], metadata: dict):
        self.delete_by_place(place_id=place_id)
        return self.add_chunk(place_id=place_id, chunk_index=0, chunk_text=chunk_text, embedding=embedding,
                              metadata_=metadata)


    def count(self):
        return self.db.query(PlaceEmbedding).count()

    def commit(self):
        self.db.commit()


    def search_similar_places(self, query_embedding: list[float],
                              top_k:int=5,
                              ward: str|None=None,
                              max_price: int|None=None,
                              min_rating: float|None=None,
                              tag_ids:list[int]|None=None,
                              age_group: AgeGroup|None=None,
                              min_suitability: int=3):

        distance = PlaceEmbedding.embedding.cosine_distance(query_embedding)

        q = (self.db.query(Place, distance.label('distance'))
             .join(PlaceEmbedding, PlaceEmbedding.place_id==Place.id)
             .filter(Place.status == PlaceStatus.ACTIVE)
             )

        if ward:
            q=q.filter_by(ward=ward)
        if max_price is not None:
            q=q.filter(Place.price_min <= max_price)
        if min_rating is not None:
            q=q.filter(Place.average_rating >= min_rating)
        if tag_ids:
            q=q.filter(Place.tags.any(PlaceTag.tag_id.in_(tag_ids)))
        if age_group:
            q=q.filter(Place.age_groups.any(
                and_(PlaceAgeGroup.age_group==age_group, PlaceAgeGroup.suitability >= min_suitability)
            ))

        return q.order_by(distance).limit(top_k).all()


