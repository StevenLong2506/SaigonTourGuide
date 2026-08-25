from datetime import datetime

from pydantic import BaseModel, field_validator


class ChatRequest(BaseModel):
    message: str
    session_id: int | None = None
    ward: str | None = None
    max_price: int | None = None

    @field_validator('message')
    @classmethod
    def message_not_empty(cls, msg: str):
        msg=msg.strip()
        if not msg:
            raise ValueError('Tin nhắn không được để trống')
        return msg


class ChatPlaceCard(BaseModel):
    id: int
    name: str
    ward: str
    average_rating: float | None = None

    class Config:
        from_attributes = True


class ChatResponse(BaseModel):
    session_id: int
    answer: str
    places: list[ChatPlaceCard]


class ChatMessageResponse(BaseModel):
    id: int
    user_role: str
    content: str
    created_at: datetime

    class Config:
        from_attributes = True


class ChatSessionResponse(BaseModel):
    id: int
    title: str|None
    created_at: datetime
    updated_at: datetime

    class Config:
        from_attributes=True


class ChatSessionDetailResponse(ChatSessionResponse):
    messages: list[ChatMessageResponse]