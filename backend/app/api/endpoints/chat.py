from fastapi import APIRouter, Depends


from app.api.deps import get_current_user, ChatServiceDep
from app.models import User
from app.schemas.chat import ChatRequest, ChatResponse, ChatSessionResponse, ChatSessionDetailResponse

router = APIRouter()


@router.post('', response_model=ChatResponse)
def chat(payload: ChatRequest, service: ChatServiceDep, user: User = Depends(get_current_user)):
    return service.send_message(payload, user_id=user.id)


@router.get('/sessions', response_model=list[ChatSessionResponse])
def list_sessions(service: ChatServiceDep, user: User = Depends(get_current_user)):
    return service.list_sessions(user_id=user.id)


@router.get('/sessions/{session_id}', response_model=ChatSessionDetailResponse)
def get_session_detail(session_id: int, service: ChatServiceDep, user: User = Depends(get_current_user)):
    return service.get_session_detail(session_id, user_id=user.id)
