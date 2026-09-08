from fastapi import APIRouter, status, Depends

from app.api.deps import get_current_user, ItineraryServiceDep
from app.models import User
from app.schemas.itinerary import ItineraryResponse, ItineraryCreate, ItineraryUpdate, ItineraryShareResponse, \
    TripRequestCreate

router = APIRouter()


@router.post('', response_model=ItineraryResponse, status_code=status.HTTP_201_CREATED)
def create_itinerary(payload: ItineraryCreate, service: ItineraryServiceDep, user: User = Depends(get_current_user)):
    return service.create(user_id=user.id, data=payload)


@router.get('', response_model=list[ItineraryResponse])
def list_itineraries( service: ItineraryServiceDep,user: User = Depends(get_current_user)):
    return service.list_mine(user_id=user.id)


@router.get('/{itinerary_id}', response_model=ItineraryResponse)
def get_itinerary(itinerary_id: int, service: ItineraryServiceDep, user: User = Depends(get_current_user)):
    return service.get_owned(itinerary_id=itinerary_id, user_id=user.id)


@router.patch('/{itinerary_id}', response_model=ItineraryResponse)
def update_itinerary(itinerary_id: int, service: ItineraryServiceDep, payload: ItineraryUpdate, user: User = Depends(get_current_user)):
    return service.update(itinerary_id=itinerary_id, user_id=user.id, data=payload)


@router.delete('/{itinerary_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_itinerary(itinerary_id: int, service: ItineraryServiceDep, user: User = Depends(get_current_user)):
    service.delete(itinerary_id=itinerary_id, user_id=user.id)


@router.post('/{itinerary_id}/share', response_model=ItineraryShareResponse)
def share_itinerary(itinerary_id: int, service: ItineraryServiceDep, user: User = Depends(get_current_user)):
    return service.share(itinerary_id=itinerary_id, user_id=user.id)

@router.delete('/{itinerary_id}/share', status_code=status.HTTP_204_NO_CONTENT)
def unshare_itinerary(itinerary_id: int, service: ItineraryServiceDep, user: User = Depends(get_current_user)):
    service.unshare(itinerary_id=itinerary_id, user_id=user.id)


@router.get('/shared/{share_code}', response_model=ItineraryResponse)
def get_shared_itinerary(share_code: str, service: ItineraryServiceDep):
    return service.get_shared(code=share_code)


@router.post('/generate', response_model=ItineraryResponse, status_code=status.HTTP_201_CREATED)
def generate_itinerary(payload: TripRequestCreate, service: ItineraryServiceDep, user: User=Depends(get_current_user)):
    return service.generate_from_request(user_id=user.id, payload=payload)