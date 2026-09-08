from fastapi import APIRouter
from app.api.deps import InterestTagServiceDep
from app.schemas.interest_tag import InterestTagResponse

router = APIRouter()


@router.get('/', response_model=list[InterestTagResponse])
def list_tags( service: InterestTagServiceDep,skip: int = 0, limit: int = 100):
    return service.list_all(skip=skip, limit=limit)


@router.get('/{tag_id}', response_model=InterestTagResponse)
def get_tag(tag_id: int, service: InterestTagServiceDep):
    return service.get(tag_id)
