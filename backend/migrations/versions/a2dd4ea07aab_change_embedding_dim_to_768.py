"""change embedding dim to 768

Revision ID: a2dd4ea07aab
Revises: 0826c3246091
Create Date: 2026-07-27 21:10:09.600785

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa
from pgvector.sqlalchemy import VECTOR

# revision identifiers, used by Alembic.
revision: str = 'a2dd4ea07aab'
down_revision: Union[str, Sequence[str], None] = '0826c3246091'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.execute('DROP INDEX IF EXISTS idx_placeembedding_vector')
    op.execute('DROP INDEX IF EXISTS idx_reviewembedding_vector')

    op.execute('TRUNCATE TABLE placeembedding')
    op.execute('TRUNCATE TABLE reviewembedding')

    op.alter_column('placeembedding', 'embedding', type_=VECTOR(768), existing_nullable=False)
    op.alter_column('reviewembedding', 'embedding', type_=VECTOR(768), existing_nullable=False)

    op.create_index(op.f('idx_placeembedding_vector'), 'placeembedding', ['embedding'],
                    unique=False, postgresql_ops={'embedding': 'vector_cosine_ops'}, postgresql_using='hnsw')
    op.create_index(op.f('idx_reviewembedding_vector'), 'reviewembedding', ['embedding'],
                    unique=False, postgresql_ops={'embedding': 'vector_cosine_ops'}, postgresql_using='hnsw')


def downgrade() -> None:
    """Downgrade schema."""
    op.execute('DROP INDEX IF EXISTS idx_placeembedding_vector')
    op.execute('DROP INDEX IF EXISTS idx_reviewembedding_vector')
    op.execute('TRUNCATE TABLE placeembedding')
    op.execute('TRUNCATE TABLE reviewembedding')
    op.alter_column('placeembedding', 'embedding', type_=VECTOR(1536), existing_nullable=False)
    op.alter_column('reviewembedding', 'embedding', type_=VECTOR(1536), existing_nullable=False)
    op.create_index(op.f('idx_placeembedding_vector'), 'placeembedding', ['embedding'],
                    unique=False, postgresql_ops={'embedding': 'vector_cosine_ops'}, postgresql_using='hnsw')
    op.create_index(op.f('idx_reviewembedding_vector'), 'reviewembedding', ['embedding'],
                    unique=False, postgresql_ops={'embedding': 'vector_cosine_ops'}, postgresql_using='hnsw')
