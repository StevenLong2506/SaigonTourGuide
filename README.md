# SaigonTourGuide

Hệ thống gợi ý địa điểm du lịch tích hợp AI cho TP. Hồ Chí Minh: chatbot tư vấn theo phương pháp RAG (Retrieval-Augmented Generation) và tính năng tự động tạo lịch trình du lịch (AI itinerary generation). Dự án là đồ án ngành của sinh viên Trường Đại học Mở TP.HCM.

RAG chatbot hoạt động theo luồng: câu hỏi người dùng → tạo embedding bằng SentenceTransformer → truy vấn tương đồng (vector similarity search) trên bảng địa điểm đã được embed trong PostgreSQL/pgvector → chỉ lấy các địa điểm liên quan làm ngữ cảnh → gửi cho Gemini sinh câu trả lời tiếng Việt.

Hệ thống gồm 3 thành phần độc lập, giao tiếp qua REST API:

| Thành phần | Vai trò | Công nghệ |
|---|---|---|
| [`backend/`](backend) | REST API, RAG chatbot, sinh lịch trình, xác thực, quản trị | FastAPI, PostgreSQL + pgvector, SQLAlchemy, Alembic |
| [`mobile/`](mobile) | Ứng dụng di động cho người dùng cuối (khách du lịch) | Flutter (Dart) |
| [`admin-web/`](admin-web) | Trang quản trị (địa điểm, danh mục, đánh giá, người dùng, thống kê) | Next.js, React, Ant Design |

## Mục lục

- [Tính năng chính](#tính-năng-chính)
- [Cấu trúc thư mục](#cấu-trúc-thư-mục)
- [Yêu cầu môi trường](#yêu-cầu-môi-trường)
- [Cài đặt & chạy dự án](#cài-đặt--chạy-dự-án)
  - [1. Backend (FastAPI)](#1-backend-fastapi)
  - [2. Admin Web (Next.js)](#2-admin-web-nextjs)
  - [3. Mobile App (Flutter)](#3-mobile-app-flutter)
- [Biến môi trường](#biến-môi-trường)

## Tính năng chính

**Người dùng (mobile app)**
- Đăng ký / đăng nhập, quản lý hồ sơ và sở thích du lịch (travel profile, interest tags)
- Tìm kiếm, xem chi tiết địa điểm (địa chỉ, giờ mở cửa, giá vé, hình ảnh, đánh giá)
- Đánh giá địa điểm (review), lưu địa điểm yêu thích, đánh dấu đã ghé thăm
- Chatbot tư vấn du lịch theo RAG: chỉ trả lời dựa trên dữ liệu địa điểm thực có trong hệ thống, không bịa thông tin
- Tự động sinh lịch trình du lịch nhiều ngày bằng AI (dựa trên sở thích, khu vực, ngân sách), có thể chia sẻ lịch trình qua mã share code

**Quản trị viên (admin web)**
- Quản lý địa điểm, danh mục, thẻ (tags), đánh giá, người dùng
- Xem thống kê hệ thống (dashboard, biểu đồ)

**Backend**
- REST API cho cả hai client trên, xác thực JWT, phân quyền admin/user
- Sinh vector embedding cho địa điểm (pgvector) phục vụ tìm kiếm ngữ nghĩa và RAG
- Tích hợp Google Gemini để sinh câu trả lời chatbot và lịch trình
- Lưu ảnh qua Cloudinary




## Cấu trúc thư mục

```
SaigonTourGuide/
├── backend/                 # FastAPI REST API
│   ├── app/
│   │   ├── api/endpoints/   # Router: auth, places, reviews, chat, itinerary, favorite,...
│   │   │   └── admin/       # Router riêng cho admin (places, categories, tags, reviews, stats, users)
│   │   ├── core/            # Cấu hình, bảo mật (JWT, hash password)
│   │   ├── db/               # Kết nối DB, base model
│   │   ├── models/           # SQLAlchemy models (Place, User, Review, Itinerary, Chat,...)
│   │   ├── repository/       # Tầng truy vấn dữ liệu
│   │   ├── schemas/          # Pydantic schemas (request/response)
│   │   └── service/           # Business logic (rag_service, itinerary_service,...)
│   └── migrations/           # Alembic migrations
├── admin-web/                # Next.js admin dashboard
│   └── src/
│       ├── app/(admin)/      # Các trang: places, categories, tags, reviews, users
│       ├── component/         # UI components (bao gồm chart)
│       ├── context/           # React context (auth,...)
│       └── lib/                # API client (axios)
└── mobile/                    # Flutter app
    └── lib/
        ├── core/               # API client, config, theme, token storage
        ├── model/              # Data model
        ├── provider/           # State management (Provider)
        ├── screen/             # Màn hình: home, chatbot, itinerary, favorite, profile,...
        └── widget/             # UI components dùng lại
```

## Yêu cầu môi trường

- Python 3.13
- Node.js 20+ và npm
- Flutter SDK 3.44+ (Dart ^3.12)
- PostgreSQL với extension [`pgvector`](https://github.com/pgvector/pgvector)
- API key Google Gemini (`GEMINI_API_KEY`)
- Tài khoản Cloudinary (lưu trữ ảnh)

## Cài đặt & chạy dự án

### 1. Backend (FastAPI)

```bash
cd backend
python -m venv .venv
source .venv/bin/activate      # Windows: .venv\Scripts\activate
pip install -r requirements.txt
```

Tạo file `.env` trong `backend/` theo mẫu ở phần [Biến môi trường](#biến-môi-trường), sau đó chạy migration và khởi động server:

```bash
alembic upgrade head
uvicorn app.main:app --reload
```

API mặc định chạy tại `http://localhost:8000`, tài liệu Swagger tại `http://localhost:8000/docs`.

### 2. Admin Web (Next.js)

```bash
cd admin-web
npm install
```

Tạo file `.env.local` với biến `NEXT_PUBLIC_API_URL` trỏ về backend (ví dụ `http://localhost:8000`), sau đó:

```bash
npm run dev
```

Truy cập tại `http://localhost:3000`.

### 3. Mobile App (Flutter)

```bash
cd mobile
flutter pub get
flutter run --dart-define=API_BASE_URL=http://localhost:8000
```

Nếu không truyền `API_BASE_URL`, app mặc định gọi `http://localhost:8000` (xem [`lib/core/config.dart`](mobile/lib/core/config.dart)). Khi chạy trên thiết bị/máy ảo thật, cần đổi thành địa chỉ IP máy chạy backend.

## Biến môi trường

**`backend/.env`**

| Biến | Mô tả |
|---|---|
| `DATABASE_URL` | Chuỗi kết nối PostgreSQL |
| `SECRET_KEY` | Khóa bí mật để ký JWT |
| `ALGORITHM` | Thuật toán JWT (ví dụ `HS256`) |
| `ACCESS_TOKEN_EXPIRE_MINUTES` | Thời gian hết hạn access token (phút) |
| `BACKEND_CORS_ORIGINS` | Danh sách origin được phép CORS, phân cách bởi dấu phẩy |
| `CLOUDINARY_CLOUD_NAME` / `CLOUDINARY_API_KEY` / `CLOUDINARY_API_SECRET` | Thông tin tài khoản Cloudinary |
| `EMBEDDING_MODEL` | Tên model SentenceTransformer dùng để tạo embedding địa điểm |
| `EMBEDDING_DIM` | Số chiều của vector embedding |
| `GEMINI_API_KEY` | API key Google Gemini |
| `CHAT_MODEL` | Tên model Gemini dùng cho chatbot / sinh lịch trình |
| `RAG_TOP_K` | Số địa điểm liên quan nhất lấy làm ngữ cảnh cho RAG |

**`admin-web/.env.local`**

| Biến | Mô tả |
|---|---|
| `NEXT_PUBLIC_API_URL` | URL của backend API |


