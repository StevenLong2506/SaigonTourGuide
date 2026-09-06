"""drop reviewembedding and dailystat

Revision ID: b7c4e1d90a35
Revises: f3a91c7b2e64
Create Date: 2026-09-04 00:00:00.000000

Gỡ hai bảng chưa có luồng nghiệp vụ nào ghi dữ liệu vào:
  - reviewembedding: không có code nào sinh embedding cho review,
    chatbot chỉ truy hồi trên placeembedding.
  - dailystat: trang thống kê của admin đếm trực tiếp từ place / review /
    users / favorite nên không đọc bảng này.

Việc drop table sẽ tự động xoá các index kèm theo
(idx_reviewembedding_vector, ix_reviewembedding_place_id,
ix_reviewembedding_review_id, ix_dailystat_place_id).
"""
from typing import Sequence, Union

import sqlalchemy as sa
from alembic import op
from pgvector.sqlalchemy import VECTOR

# revision identifiers, used by Alembic.
revision: str = 'b7c4e1d90a35'
down_revision: Union[str, Sequence[str], None] = 'f3a91c7b2e64'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_table('reviewembedding')
    op.drop_table('dailystat')


def downgrade() -> None:
    op.create_table(
        'dailystat',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('stat_date', sa.Date(), nullable=False),
        sa.Column('place_id', sa.Integer(), nullable=False),
        sa.Column('view_count', sa.Integer(), server_default='0', nullable=False),
        sa.Column('favorite_count', sa.Integer(), server_default='0', nullable=False),
        sa.Column('review_count', sa.Integer(), server_default='0', nullable=False),
        sa.Column('search_count', sa.Integer(), server_default='0', nullable=False),
        sa.ForeignKeyConstraint(['place_id'], ['place.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('stat_date', 'place_id'),
    )
    op.create_index('ix_dailystat_place_id', 'dailystat', ['place_id'])

    op.create_table(
        'reviewembedding',
        sa.Column('id', sa.Integer(), autoincrement=True, nullable=False),
        sa.Column('place_id', sa.Integer(), nullable=False),
        sa.Column('review_id', sa.Integer(), nullable=False),
        sa.Column('chunk_text', sa.Text(), nullable=False),
        sa.Column('chunk_index', sa.Integer(), server_default='0', nullable=False),
        sa.Column('embedding', VECTOR(768), nullable=False),
        sa.Column('created_at', sa.TIMESTAMP(), server_default=sa.text('now()'), nullable=False),
        sa.ForeignKeyConstraint(['place_id'], ['place.id'], ondelete='CASCADE'),
        sa.ForeignKeyConstraint(['review_id'], ['review.id'], ondelete='CASCADE'),
        sa.PrimaryKeyConstraint('id'),
        sa.UniqueConstraint('chunk_index', 'review_id'),
    )
    op.create_index('ix_reviewembedding_review_id', 'reviewembedding', ['review_id'])
    op.create_index('ix_reviewembedding_place_id', 'reviewembedding', ['place_id'])
    op.create_index(
        'idx_reviewembedding_vector', 'reviewembedding', ['embedding'],
        postgresql_using='hnsw', postgresql_ops={'embedding': 'vector_cosine_ops'},
    )
