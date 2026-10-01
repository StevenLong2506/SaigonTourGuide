import logging
from typing import Generator, Annotated

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer
from jose import JWTError
from sqlalchemy.orm import Session

from app.core.security import decode_access_token
from app.db.session import SessionLocal
from app.db.uow import UnitOfWork
from app.models import User
from app.models.enums import UserRole
from app.repository.category_repository import CategoryRepository
from app.repository.chat_repository import ChatRepository
from app.repository.favorite_repository import FavoriteRepository
from app.repository.interest_tag_repository import InterestTagRepository
from app.repository.itinerary_repository import ItineraryRepository
from app.repository.place_embedding_repository import PlaceEmbeddingRepository
from app.repository.place_repository import PlaceRepository
from app.repository.review_repository import ReviewRepository
from app.repository.search_log_repository import SearchLogRepository
from app.repository.stat_repository import StatRepository
from app.repository.token_black_list_repository import TokenBlackListRepository
from app.repository.trip_request_repository import TripRequestRepository
from app.repository.user_repository import UserRepository
from app.repository.visited_place_repository import VisitedPlaceRepository
from app.service.auth_service import AuthService
from app.service.category_service import CategoryService
from app.service.chat_service import ChatService
from app.service.favorite_service import FavoriteService
from app.service.interest_tag_service import InterestTagService
from app.service.itinerary_service import ItineraryService
from app.service.place_service import PlaceService
from app.service.rag_service import RagService
from app.service.review_service import ReviewService
from app.service.stat_service import StatService
from app.service.upload_image_service import UploadImageService
from app.service.user_service import UserService
from app.service.visited_place_service import VisitedPlaceService

logger = logging.getLogger(__name__)

def get_db() -> Generator:
    with SessionLocal() as session:
        try:
            yield session
        finally:
            if session.info.get('pending_writes') or session.new or session.dirty or session.deleted:
                logger.error('Request kết thúc với dữ liệu đã flush nhưng chưa commit: '
                                 'có service ghi DB mà quên bọc `with uow.transaction()`')


oauth2_scheme = OAuth2PasswordBearer(tokenUrl='auth/login')
DbSessionDep = Annotated[Session, Depends(get_db)]


def get_category_repository(db: DbSessionDep) -> CategoryRepository:
    return CategoryRepository(db)


def get_interest_tag_repository(db: DbSessionDep) -> InterestTagRepository:
    return InterestTagRepository(db)


def get_review_repository(db: DbSessionDep) -> ReviewRepository:
    return ReviewRepository(db)


def get_favorite_repository(db: DbSessionDep) -> FavoriteRepository:
    return FavoriteRepository(db)


def get_visited_place_repository(db: DbSessionDep) -> VisitedPlaceRepository:
    return VisitedPlaceRepository(db)


def get_place_repository(db: DbSessionDep) -> PlaceRepository:
    return PlaceRepository(db)


def get_search_log_repository(db: DbSessionDep) -> SearchLogRepository:
    return SearchLogRepository(db)


def get_stat_repository(db: DbSessionDep) -> StatRepository:
    return StatRepository(db)


def get_trip_request_repository(db: DbSessionDep) -> TripRequestRepository:
    return TripRequestRepository(db)


def get_itinerary_repository(db: DbSessionDep) -> ItineraryRepository:
    return ItineraryRepository(db)


def get_place_embedding_repository(db: DbSessionDep) -> PlaceEmbeddingRepository:
    return PlaceEmbeddingRepository(db)


def get_token_black_list_repository(db: DbSessionDep) -> TokenBlackListRepository:
    return TokenBlackListRepository(db)


def get_user_repository(db: DbSessionDep) -> UserRepository:
    return UserRepository(db)


def get_chat_repository(db: DbSessionDep) -> ChatRepository:
    return ChatRepository(db)


CateRepoDep = Annotated[CategoryRepository, Depends(get_category_repository)]
InterestTagRepoDep = Annotated[InterestTagRepository, Depends(get_interest_tag_repository)]
ReviewRepoDep = Annotated[ReviewRepository, Depends(get_review_repository)]
FavoriteRepositoryDep = Annotated[FavoriteRepository, Depends(get_favorite_repository)]
VisitedPlaceRepositoryDep = Annotated[VisitedPlaceRepository, Depends(get_visited_place_repository)]
PlaceRepoDep = Annotated[PlaceRepository, Depends(get_place_repository)]
SearchLogRepoDep = Annotated[SearchLogRepository, Depends(get_search_log_repository)]
StatRepoDep = Annotated[StatRepository, Depends(get_stat_repository)]
TripRequestRepoDep = Annotated[TripRequestRepository, Depends(get_trip_request_repository)]
ItineraryRepoDep = Annotated[ItineraryRepository, Depends(get_itinerary_repository)]
PlaceEmbeddingRepoDep = Annotated[PlaceEmbeddingRepository, Depends(get_place_embedding_repository)]
TokenBlackListRepoDep = Annotated[TokenBlackListRepository, Depends(get_token_black_list_repository)]
UserRepoDep = Annotated[UserRepository, Depends(get_user_repository)]
ChatRepoDep = Annotated[ChatRepository, Depends(get_chat_repository)]


def get_uow(db: DbSessionDep) -> UnitOfWork:
    return UnitOfWork(db)


UowDep = Annotated[UnitOfWork, Depends(get_uow)]


def get_rag_service(repo: PlaceEmbeddingRepoDep, uow: UowDep) -> RagService:
    return RagService(repo, uow)


RagServiceDep = Annotated[RagService, Depends(get_rag_service)]


def get_category_service(repo: CateRepoDep, uow: UowDep) -> CategoryService:
    return CategoryService(repo, uow)


def get_interest_tag_service(repo: InterestTagRepoDep, uow: UowDep) -> InterestTagService:
    return InterestTagService(repo, uow)


def get_favorite_service(repo: FavoriteRepositoryDep, place_repo: PlaceRepoDep, uow: UowDep) -> FavoriteService:
    return FavoriteService(repo, place_repo, uow)


def get_visited_place_service(repo: VisitedPlaceRepositoryDep, place_repo: PlaceRepoDep, uow: UowDep) -> VisitedPlaceService:
    return VisitedPlaceService(repo, place_repo, uow)


def get_stat_service(repo: StatRepoDep, search_log_repo: SearchLogRepoDep, uow: UowDep) -> StatService:
    return StatService(repo, search_log_repo, uow)


StatServiceDep = Annotated[StatService, Depends(get_stat_service)]


def get_upload_service() -> UploadImageService:
    return UploadImageService()


UploadImageServiceDep = Annotated[UploadImageService, Depends(get_upload_service)]


def get_place_service(repo: PlaceRepoDep, stat_service: StatServiceDep, rag_service: RagServiceDep,
                      upload_service: UploadImageServiceDep, uow: UowDep) -> PlaceService:
    return PlaceService(repo, stat_service, rag_service, upload_service, uow)


def get_itinerary_service(repo: ItineraryRepoDep, trip_repo: TripRequestRepoDep,
                          rag_service: RagServiceDep, uow: UowDep) -> ItineraryService:
    return ItineraryService(repo, trip_repo, rag_service, uow)


def get_auth_service(user_repo: UserRepoDep, token_black_list_repo: TokenBlackListRepoDep, uow: UowDep) -> AuthService:
    return AuthService(user_repo, token_black_list_repo, uow)


def get_user_service(repo: UserRepoDep, upload_service: UploadImageServiceDep, uow: UowDep) -> UserService:
    return UserService(repo, upload_service, uow)


def get_chat_service(repo: ChatRepoDep, user_repo: UserRepoDep, rag_service: RagServiceDep, uow: UowDep) -> ChatService:
    return ChatService(repo, user_repo, rag_service, uow)


def get_review_service(repo: ReviewRepoDep, place_repo: PlaceRepoDep,
                       upload_service: UploadImageServiceDep, uow: UowDep) -> ReviewService:
    return ReviewService(repo, place_repo, upload_service, uow)


CateServiceDep = Annotated[CategoryService, Depends(get_category_service)]
InterestTagServiceDep = Annotated[InterestTagService, Depends(get_interest_tag_service)]
ReviewServiceDep = Annotated[ReviewService, Depends(get_review_service)]
FavoriteServiceDep = Annotated[FavoriteService, Depends(get_favorite_service)]
VisitedPlaceServiceDep = Annotated[VisitedPlaceService, Depends(get_visited_place_service)]
PlaceServiceDep = Annotated[PlaceService, Depends(get_place_service)]

ItineraryServiceDep = Annotated[ItineraryService, Depends(get_itinerary_service)]
AuthServiceDep = Annotated[AuthService, Depends(get_auth_service)]
UserServiceDep = Annotated[UserService, Depends(get_user_service)]
ChatServiceDep = Annotated[ChatService, Depends(get_chat_service)]


def get_token_payload(blacklist_repo: TokenBlackListRepoDep, token: str = Depends(oauth2_scheme)) -> dict:
    credentials_error = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail='Không xác thực được, vui lòng đăng nhập lại',
        headers={'WWW-Authenticate': 'Bearer'},
    )

    try:
        payload = decode_access_token(token)
    except JWTError:
        raise credentials_error

    if payload.get('sub') is None:
        raise credentials_error

    jti = payload.get('jti')
    if jti and blacklist_repo.is_blacklisted(jti):
        raise HTTPException(status_code=status.HTTP_401_UNAUTHORIZED,
                            detail='Phiên đăng nhập đã kết thúc, vui lòng đăng nhập lại',
                            headers={'WWW-Authenticate': 'Bearer'},
                            )
    return payload


def get_current_user(user_repo: UserRepoDep, payload: dict = Depends(get_token_payload)) -> User:
    credentials_error = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail='Không xác thực được, vui lòng đăng nhập lại',
        headers={'WWW-Authenticate': 'Bearer'},
    )

    user = user_repo.get_by_id(int(payload.get('sub')))
    if user is None:
        raise credentials_error
    if not user.is_active:
        raise HTTPException(status_code=status.HTTP_403_FORBIDDEN, detail='Tài khoản đã bị khóa')
    return user


def get_current_admin(current_user: User = Depends(get_current_user)) -> User:
    if (current_user.user_role != UserRole.ADMIN):
        raise HTTPException(
            status_code=status.HTTP_403_FORBIDDEN,
            detail='Yêu cầu quyền admin',
        )

    return current_user


def get_optional_user(user_repo: UserRepoDep, blacklist_repo: TokenBlackListRepoDep,
                      token: str | None = Depends(
                          OAuth2PasswordBearer(tokenUrl='auth/login', auto_error=False))) -> User | None:
    if not token:
        return None
    try:
        payload = decode_access_token(token)
        jti = payload.get('jti')
        if jti and blacklist_repo.is_blacklisted(jti):
            return None
        user_id = payload.get('sub')
        if user_id is None:
            return None

        user = user_repo.get_by_id(int(user_id))
        return user if user and user.is_active else None
    except JWTError:
        return None
