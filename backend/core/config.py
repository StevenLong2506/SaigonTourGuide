from pydantic import BaseModel
from pydantic_settings import SettingsConfigDict


class Settings(BaseModel):
    PROJECT_NAME: str = 'Sai Gon Tour Guide Management API'
    DATABASE_URL: str = 'postgresql://postgres:Abc123@@localhost:5432/SaigonTourGideDB'
    SECRET_KEY: str = 'asdoas@23124@4%&5jnasfncjaAFBVhPndjAS**09'
    ALGORITHM: str= 'HS256'
    ACCESS_TOKEN_EXPIRE_MINUTES: int = 60

settings = Settings()