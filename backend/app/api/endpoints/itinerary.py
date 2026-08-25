from fastapi import APIRouter, status, Depends
from sqlalchemy.orm import Session

from app.api.deps import get_current_user, get_db
from app.models import User
from app.schemas.itinerary import ItineraryResponse, ItineraryCreate, ItineraryUpdate, ItineraryShareResponse, \
    TripRequestCreate
from app.service.itinerary_service import ItineraryService

router = APIRouter()


@router.post('', response_model=ItineraryResponse, status_code=status.HTTP_201_CREATED)
def create_itinerary(payload: ItineraryCreate, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return ItineraryService(db).create(user_id=user.id, data=payload)


@router.get('', response_model=list[ItineraryResponse])
def list_itineraries(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return ItineraryService(db).list_mine(user_id=user.id)


@router.get('/{itinerary_id}', response_model=ItineraryResponse)
def get_itinerary(itinerary_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return ItineraryService(db).get_owned(itinerary_id=itinerary_id, user_id=user.id)


@router.patch('/{itinerary_id}', response_model=ItineraryResponse)
def update_itinerary(itinerary_id: int, payload: ItineraryUpdate, user: User = Depends(get_current_user),
                     db: Session = Depends(get_db)):
    return ItineraryService(db).update(itinerary_id=itinerary_id, user_id=user.id, data=payload)


@router.delete('/{itinerary_id}', status_code=status.HTTP_204_NO_CONTENT)
def delete_itinerary(itinerary_id: int, user: User = Depends(get_current_user),
                     db: Session = Depends(get_db)):
    ItineraryService(db).delete(itinerary_id=itinerary_id, user_id=user.id)


@router.post('/{itinerary_id}/share', response_model=ItineraryShareResponse)
def share_itinerary(itinerary_id: int, user: User = Depends(get_current_user),
                     db: Session = Depends(get_db)):
    return ItineraryService(db).share(itinerary_id=itinerary_id, user_id=user.id)

@router.delete('/{itinerary_id}/share', status_code=status.HTTP_204_NO_CONTENT)
def unshare_itinerary(itinerary_id: int, user: User = Depends(get_current_user),
                     db: Session = Depends(get_db)):
    ItineraryService(db).unshare(itinerary_id=itinerary_id, user_id=user.id)


@router.get('/shared/{share_code}', response_model=ItineraryResponse)
def get_shared_itinerary(share_code: str, db: Session=Depends(get_db)):
    return ItineraryService(db).get_shared(code=share_code)


@router.post('/generate', response_model=ItineraryResponse, status_code=status.HTTP_201_CREATED)
def generate_itinerary(payload: TripRequestCreate, user: User=Depends(get_current_user), db: Session=Depends(get_db)):
    return ItineraryService(db).generate_from_request(user_id=user.id, payload=payload)