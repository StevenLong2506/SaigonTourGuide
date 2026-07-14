from fastapi import APIRouter

router = APIRouter()

@router.get('/')
def get_cates():
    return {'message': 'Hello World'}
