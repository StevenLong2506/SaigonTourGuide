"""make place phone nullable

Revision ID: 23bd676ab460
Revises: a2dd4ea07aab
Create Date: 2026-08-05 17:52:44.797074

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '23bd676ab460'
down_revision: Union[str, Sequence[str], None] = 'a2dd4ea07aab'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    """Upgrade schema."""
    op.alter_column('place', 'phone', existing_type=sa.String(15), nullable=True)


def downgrade() -> None:
    """Downgrade schema."""
    op.execute("UPDATE place SET phone = '' WHERE phone IS NULL")
    op.alter_column('place', 'phone', existing_type=sa.String(15), nullable=False)
