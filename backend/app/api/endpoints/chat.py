from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session

from app.api.deps import get_current_user, get_db
from app.models import User
from app.schemas.chat import ChatRequest, ChatResponse, ChatSessionResponse, ChatSessionDetailResponse
from app.service.chat_service import ChatService

router = APIRouter()


@router.post('', response_model=ChatResponse)
def chat(payload: ChatRequest, user: User = Depends(get_current_user),
         db: Session = Depends(get_db)):
    return ChatService(db).send_message(payload, user_id=user.id)


@router.get('/sessions', response_model=list[ChatSessionResponse])
def list_sessions(user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return ChatService(db).list_sessions(user_id=user.id)


@router.get('/sessions/{session_id}', response_model=ChatSessionDetailResponse)
def get_session_detail(session_id: int, user: User = Depends(get_current_user), db: Session = Depends(get_db)):
    return ChatService(db).get_session_detail(session_id, user_id=user.id)
