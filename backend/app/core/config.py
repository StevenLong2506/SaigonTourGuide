import cloudinary
from pydantic_settings import SettingsConfigDict, BaseSettings


class Settings(BaseSettings):
    model_config = SettingsConfigDict(env_file='.env', extra='ignore')

    PROJECT_NAME: str = 'Sai Gon Tour Guide Management API'
    DATABASE_URL: str
    SECRET_KEY: str
    ALGORITHM: str
    ACCESS_TOKEN_EXPIRE_MINUTES: int
    BACKEND_CORS_ORIGINS: str
    CLOUDINARY_CLOUD_NAME: str
    CLOUDINARY_API_KEY: str
    CLOUDINARY_API_SECRET: str
    EMBEDDING_MODEL: str
    EMBEDDING_DIM: int
    GEMINI_API_KEY: str
    CHAT_MODEL: str
    RAG_TOP_K: int
    @property
    def cors_origins(self)->list[str]:
        return [o.strip() for o in self.BACKEND_CORS_ORIGINS.split(',') if o.strip()]



settings = Settings()

cloudinary.config(
    cloud_name=settings.CLOUDINARY_CLOUD_NAME,
    api_key=settings.CLOUDINARY_API_KEY,
    api_secret=settings.CLOUDINARY_API_SECRET,
    secure=True,
)