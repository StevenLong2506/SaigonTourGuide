"""add performance indexes for all tables

Revision ID: f3a91c7b2e64
Revises: 5696fb88d0b9
Create Date: 2026-09-04 00:00:00.000000

Bổ sung index cho toàn bộ bảng:
  - Index cho mọi khoá ngoại (PostgreSQL KHÔNG tự tạo index cho FK).
  - Index tổ hợp bám theo filter + ORDER BY thực tế trong tầng repository.
  - Index GIN trigram cho tìm kiếm ILIKE '%...%' trên bảng place.
  - Index biểu thức / index một phần cho thống kê searchlog.
  - Bỏ ix_category_id vì trùng lặp hoàn toàn với category_pkey.

Index HNSW cho cột vector (idx_placeembedding_vector, idx_reviewembedding_vector)
đã tồn tại sẵn trong DB nên migration này không tạo lại.
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

# revision identifiers, used by Alembic.
revision: str = 'f3a91c7b2e64'
down_revision: Union[str, Sequence[str], None] = '5696fb88d0b9'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    # ------------------------------------------------------------------ #
    # Extension phục vụ tìm kiếm ILIKE '%tu khoa%'
    # ------------------------------------------------------------------ #
    op.execute('CREATE EXTENSION IF NOT EXISTS pg_trgm')

    # ------------------------------------------------------------------ #
    # category
    # ------------------------------------------------------------------ #
    # ix_category_id trùng với primary key -> chỉ tốn dung lượng và chi phí ghi
    op.drop_index('ix_category_id', table_name='category')
    op.create_index('ix_category_parent_id', 'category', ['parent_id'])
    op.create_index('ix_category_name', 'category', ['name'])

    # ------------------------------------------------------------------ #
    # userinterest / usertravelprofile
    # ------------------------------------------------------------------ #
    # PK là (user_id, tag_id) nên user_id đã được phủ, tag_id thì chưa
    op.create_index('ix_userinterest_tag_id', 'userinterest', ['tag_id'])

    # ------------------------------------------------------------------ #
    # place
    # ------------------------------------------------------------------ #
    op.create_index('ix_place_created_by', 'place', ['created_by'])
    op.create_index('ix_place_name', 'place', ['name'])

    # list_full(): filter status/ward/is_featured + ORDER BY created_at DESC
    op.create_index(
        'ix_place_status_created_at', 'place',
        ['status', sa.text('created_at DESC')],
    )
    # search_places() sort_by = POPULAR
    op.create_index(
        'ix_place_status_total_views', 'place',
        ['status', sa.text('total_views DESC')],
    )
    # search_places() sort_by = RATING
    op.create_index(
        'ix_place_status_rating', 'place',
        ['status', sa.text('average_rating DESC'), sa.text('total_reviews DESC')],
    )
    # search_places() sort_by = PRICE_ASC / PRICE_DESC
    op.create_index('ix_place_status_price_min', 'place', ['status', 'price_min'])
    op.create_index(
        'ix_place_status_price_max', 'place',
        ['status', sa.text('price_max DESC')],
    )
    # filter ward + list_wards() GROUP BY ward
    op.create_index('ix_place_status_ward', 'place', ['status', 'ward'])
    # chỉ một phần nhỏ place được gắn nổi bật -> partial index
    op.create_index(
        'ix_place_featured_status', 'place', ['status'],
        postgresql_where=sa.text('is_featured'),
    )

    # search_places(): name/address/description ILIKE '%q%'
    op.create_index(
        'ix_place_name_trgm', 'place', ['name'],
        postgresql_using='gin', postgresql_ops={'name': 'gin_trgm_ops'},
    )
    op.create_index(
        'ix_place_address_trgm', 'place', ['address'],
        postgresql_using='gin', postgresql_ops={'address': 'gin_trgm_ops'},
    )
    op.create_index(
        'ix_place_description_trgm', 'place', ['description'],
        postgresql_using='gin', postgresql_ops={'description': 'gin_trgm_ops'},
    )

    # ------------------------------------------------------------------ #
    # Bảng nối của place
    # ------------------------------------------------------------------ #
    # PK (category_id, place_id) phủ chiều category_id, thiếu chiều place_id
    op.create_index('ix_placecategory_place_id', 'placecategory', ['place_id'])
    # PK (tag_id, place_id) phủ chiều tag_id, thiếu chiều place_id
    op.create_index('ix_placetag_place_id', 'placetag', ['place_id'])
    # EXISTS(place_id = ? AND age_group = ? AND suitability >= ?)
    op.create_index(
        'ix_placeagegroup_place_age_suit', 'placeagegroup',
        ['place_id', 'age_group', 'suitability'],
    )
    op.create_index('ix_placeimage_place_id', 'placeimage', ['place_id'])

    # ------------------------------------------------------------------ #
    # review
    # ------------------------------------------------------------------ #
    op.create_index('ix_review_user_id', 'review', ['user_id'])
    # calculate_place_rating(): AVG/COUNT theo place_id + status = APPROVED
    op.create_index('ix_review_place_status', 'review', ['place_id', 'status'])
    # list_full() phía admin: filter status + ORDER BY created_at DESC
    op.create_index(
        'ix_review_status_created_at', 'review',
        ['status', sa.text('created_at DESC')],
    )

    # ------------------------------------------------------------------ #
    # favorite / visitedplace
    # ------------------------------------------------------------------ #
    # PK (user_id, place_id) phủ chiều user_id; chiều place_id cần cho
    # get_top_places() outerjoin Favorite và cho ON DELETE CASCADE của place
    op.create_index('ix_favorite_place_id', 'favorite', ['place_id'])
    op.create_index('ix_visitedplace_place_id', 'visitedplace', ['place_id'])

    # ------------------------------------------------------------------ #
    # searchlog
    # ------------------------------------------------------------------ #
    op.create_index('ix_searchlog_user_id', 'searchlog', ['user_id'])
    op.create_index(
        'ix_searchlog_created_at', 'searchlog', [sa.text('created_at DESC')],
    )
    # _aggregate(): GROUP BY lower(trim(query_text))
    op.create_index(
        'ix_searchlog_keyword', 'searchlog',
        [sa.text('lower(trim(query_text))')],
    )
    # zero_result_keywords(): filter result_count = 0
    op.create_index(
        'ix_searchlog_zero_result', 'searchlog', [sa.text('created_at DESC')],
        postgresql_where=sa.text('result_count = 0'),
    )

    # ------------------------------------------------------------------ #
    # triprequest / itinerary / itineraryitem
    # ------------------------------------------------------------------ #
    op.create_index('ix_triprequest_user_id', 'triprequest', ['user_id'])
    # get_by_user(): filter user_id + ORDER BY updated_at DESC
    op.create_index(
        'ix_itinerary_user_updated', 'itinerary',
        ['user_id', sa.text('updated_at DESC')],
    )
    op.create_index('ix_itinerary_trip_request_id', 'itinerary', ['trip_request_id'])
    # relationship items: ORDER BY day_number, sort_order
    op.create_index(
        'ix_itineraryitem_itinerary_day_sort', 'itineraryitem',
        ['itinerary_id', 'day_number', 'sort_order'],
    )
    op.create_index('ix_itineraryitem_place_id', 'itineraryitem', ['place_id'])

    # ------------------------------------------------------------------ #
    # chatsession / chatmessage
    # ------------------------------------------------------------------ #
    # get_sessions_by_user(): filter user_id + ORDER BY updated_at DESC
    op.create_index(
        'ix_chatsession_user_updated', 'chatsession',
        ['user_id', sa.text('updated_at DESC')],
    )
    # relationship messages: ORDER BY created_at
    op.create_index(
        'ix_chatmessage_session_created', 'chatmessage',
        ['session_id', 'created_at'],
    )

    # ------------------------------------------------------------------ #
    # reviewembedding / dailystat / tokenblacklist
    # ------------------------------------------------------------------ #
    # UNIQUE (chunk_index, review_id) không phủ được review_id đứng một mình
    op.create_index('ix_reviewembedding_review_id', 'reviewembedding', ['review_id'])
    op.create_index('ix_reviewembedding_place_id', 'reviewembedding', ['place_id'])
    # UNIQUE (stat_date, place_id) đã phủ stat_date, còn thiếu place_id
    op.create_index('ix_dailystat_place_id', 'dailystat', ['place_id'])
    op.create_index('ix_tokenblacklist_user_id', 'tokenblacklist', ['user_id'])


def downgrade() -> None:
    for name, table in [
        ('ix_tokenblacklist_user_id', 'tokenblacklist'),
        ('ix_dailystat_place_id', 'dailystat'),
        ('ix_reviewembedding_place_id', 'reviewembedding'),
        ('ix_reviewembedding_review_id', 'reviewembedding'),
        ('ix_chatmessage_session_created', 'chatmessage'),
        ('ix_chatsession_user_updated', 'chatsession'),
        ('ix_itineraryitem_place_id', 'itineraryitem'),
        ('ix_itineraryitem_itinerary_day_sort', 'itineraryitem'),
        ('ix_itinerary_trip_request_id', 'itinerary'),
        ('ix_itinerary_user_updated', 'itinerary'),
        ('ix_triprequest_user_id', 'triprequest'),
        ('ix_searchlog_zero_result', 'searchlog'),
        ('ix_searchlog_keyword', 'searchlog'),
        ('ix_searchlog_created_at', 'searchlog'),
        ('ix_searchlog_user_id', 'searchlog'),
        ('ix_visitedplace_place_id', 'visitedplace'),
        ('ix_favorite_place_id', 'favorite'),
        ('ix_review_status_created_at', 'review'),
        ('ix_review_place_status', 'review'),
        ('ix_review_user_id', 'review'),
        ('ix_placeimage_place_id', 'placeimage'),
        ('ix_placeagegroup_place_age_suit', 'placeagegroup'),
        ('ix_placetag_place_id', 'placetag'),
        ('ix_placecategory_place_id', 'placecategory'),
        ('ix_place_description_trgm', 'place'),
        ('ix_place_address_trgm', 'place'),
        ('ix_place_name_trgm', 'place'),
        ('ix_place_featured_status', 'place'),
        ('ix_place_status_ward', 'place'),
        ('ix_place_status_price_max', 'place'),
        ('ix_place_status_price_min', 'place'),
        ('ix_place_status_rating', 'place'),
        ('ix_place_status_total_views', 'place'),
        ('ix_place_status_created_at', 'place'),
        ('ix_place_name', 'place'),
        ('ix_place_created_by', 'place'),
        ('ix_userinterest_tag_id', 'userinterest'),
        ('ix_category_name', 'category'),
        ('ix_category_parent_id', 'category'),
    ]:
        op.drop_index(name, table_name=table)

    op.create_index('ix_category_id', 'category', ['id'])
