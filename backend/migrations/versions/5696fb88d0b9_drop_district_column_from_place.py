"""drop district column from place

Revision ID: 5696fb88d0b9
Revises: 23bd676ab460
Create Date: 2026-08-05 18:13:01.550677

"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa


# revision identifiers, used by Alembic.
revision: str = '5696fb88d0b9'
down_revision: Union[str, Sequence[str], None] = '23bd676ab460'
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.drop_column('place', 'district')


def downgrade() -> None:
     op.add_column('place', sa.Column('district', sa.String(50), nullable=False, server_default=''))
