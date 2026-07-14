CREATE EXTENSION IF NOT EXISTS "vector";

-- ============================================================
-- 1. NGƯỜI DÙNG
-- ============================================================

CREATE TABLE Users (
    id                  INT PRIMARY KEY,
    name                VARCHAR(50)  NOT NULL,
    username            VARCHAR(20)  NOT NULL UNIQUE,
    hash_password       VARCHAR(255) NOT NULL,   -- 20 ký tự quá ngắn: bcrypt/argon2 hash dài ~60-100 ký tự, sẽ bị cắt mất dữ liệu
    avatar              VARCHAR(200),
    email               VARCHAR(100) NOT NULL UNIQUE,
    phone               VARCHAR(15),              
    date_of_birth       DATE NOT NULL,                     
    gender              VARCHAR(7) NOT NULL,               
    user_role           VARCHAR(20) DEFAULT 'USER' NOT NULL,
    is_active           BOOLEAN DEFAULT TRUE NOT NULL,
    created_at          TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at          TIMESTAMP DEFAULT NOW() NOT NULL,

    CONSTRAINT chk_gender CHECK (gender IN ('MALE', 'FEMALE', 'OTHER'))
);

CREATE TABLE UserTravelProfile (
    user_id             INT PRIMARY KEY,
    travel_style        VARCHAR(10),
    budget_level        VARCHAR(10),
    updated_at          TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    CONSTRAINT chk_travel_style CHECK (travel_style IN ('SOLO', 'COUPLE', 'FAMILY', 'GROUP')),
    CONSTRAINT chk_budget_level CHECK (budget_level IN ('LOW', 'MEDIUM', 'HIGH'))
);

-- ============================================================
-- 2. SỞ THÍCH
-- ============================================================

CREATE TABLE InterestTag (
    id          INT PRIMARY KEY,
    name        VARCHAR(50) NOT NULL UNIQUE,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL
);

CREATE TABLE UserInterest (
    user_id     INT NOT NULL,
    tag_id      INT NOT NULL,
    priority    SMALLINT DEFAULT 1 NOT NULL,

    PRIMARY KEY (user_id, tag_id),
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)  REFERENCES InterestTag(id) ON DELETE CASCADE
);

-- ============================================================
-- 3. DANH MỤC
-- ============================================================

CREATE TABLE Category (
    id            INT PRIMARY KEY,
    name          VARCHAR(50)  NOT NULL,
    description   VARCHAR(255),
    parent_id     INT,
    created_at    TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (parent_id) REFERENCES Category(id) ON DELETE SET NULL
);

-- ============================================================
-- 4. ĐỊA ĐIỂM DU LỊCH
-- ============================================================

CREATE TABLE Place (
    id                  INT PRIMARY KEY,
    name                VARCHAR(100) NOT NULL,
    description         TEXT NOT NULL,
    address             VARCHAR(200) NOT NULL,
    district            VARCHAR(50)  NOT NULL,
    ward                VARCHAR(50),
    link_google_map     VARCHAR(300),
    phone               VARCHAR(15),
    website             VARCHAR(200),
    price_min           DECIMAL(12,0) DEFAULT 0 NOT NULL,
    price_max           DECIMAL(12,0) DEFAULT 0 NOT NULL,
    opening_time        TIME,
    closing_time        TIME,
    open_days           VARCHAR(100),
    average_rating      DECIMAL(2,1) DEFAULT 0.0 NOT NULL,
    total_reviews       INT DEFAULT 0 NOT NULL,
    total_views         INT DEFAULT 0 NOT NULL,
    is_featured         BOOLEAN DEFAULT FALSE NOT NULL,
    status              VARCHAR(20) DEFAULT 'ACTIVE' NOT NULL,
    created_by          INT,
    created_at          TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at          TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (created_by) REFERENCES Users(id) ON DELETE SET NULL
);

CREATE TABLE PlaceCategory (
    place_id    INT NOT NULL,
    category_id INT NOT NULL,

    PRIMARY KEY (place_id, category_id),
    FOREIGN KEY (place_id)    REFERENCES Place(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES Category(id) ON DELETE CASCADE
);

CREATE TABLE PlaceTag (
    place_id    INT NOT NULL,
    tag_id      INT NOT NULL,
    relevance   DECIMAL(3,2) DEFAULT 1.0 NOT NULL,

    PRIMARY KEY (place_id, tag_id),
    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE,
    FOREIGN KEY (tag_id)   REFERENCES InterestTag(id) ON DELETE CASCADE
);

CREATE TABLE PlaceAgeGroup (
    id          INT PRIMARY KEY,
    place_id    INT NOT NULL,
    age_group   VARCHAR(20) NOT NULL,
    suitability SMALLINT DEFAULT 3 NOT NULL,

    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE,
    UNIQUE (place_id, age_group)
);

CREATE TABLE PlaceImage (
    id          INT PRIMARY KEY,
    place_id    INT NOT NULL,
    img_url     VARCHAR(500) NOT NULL,
    caption     VARCHAR(255),
    is_primary  BOOLEAN DEFAULT FALSE NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE
);

CREATE UNIQUE INDEX idx_one_primary_image
    ON PlaceImage (place_id)
    WHERE is_primary = TRUE;

-- ============================================================
-- 5. ĐÁNH GIÁ & TƯƠNG TÁC
-- ============================================================

CREATE TABLE Review (
    id          INT PRIMARY KEY,
    place_id    INT NOT NULL,
    user_id     INT NOT NULL,
    rating      SMALLINT NOT NULL,
    title       VARCHAR(255),
    content     TEXT,
    visit_date  DATE,
    status      VARCHAR(20) DEFAULT 'APPROVED' NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at  TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE,
    FOREIGN KEY (user_id)  REFERENCES Users(id) ON DELETE CASCADE,
    UNIQUE (place_id, user_id)
    
);

CREATE TABLE Favorite (
    user_id     INT NOT NULL,
    place_id    INT NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,

    PRIMARY KEY (user_id, place_id),
    FOREIGN KEY (user_id)  REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE
);

CREATE TABLE VisitedPlace (
    id          INT PRIMARY KEY,
    user_id     INT NOT NULL,
    place_id    INT NOT NULL,
    visited_at  DATE,
    source      VARCHAR(20) DEFAULT 'MANUAL' NOT NULL,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (user_id)  REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE,
    UNIQUE (user_id, place_id)
    
);

CREATE TABLE SearchLog (
    id            INT PRIMARY KEY,
    user_id       INT,
    query_text    TEXT NOT NULL,
    filters       JSONB,
    result_count  INT,
    created_at    TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE SET NULL
);

-- ============================================================
-- 6. LỊCH TRÌNH DU LỊCH
-- ============================================================

CREATE TABLE TripRequest (
    id              INT PRIMARY KEY,
    user_id         INT NOT NULL,
    raw_query       TEXT NOT NULL,
    duration_day    INT,
    parsed_prefs    JSONB,
    created_at      TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE Itinerary (
    id                INT PRIMARY KEY,
    user_id           INT NOT NULL,
    trip_request_id   INT,
    title             VARCHAR(255) NOT NULL,
    description       TEXT,
    start_date        DATE,
    end_date          DATE,
    num_people        SMALLINT DEFAULT 1 NOT NULL,
    share_code        VARCHAR(50) UNIQUE,
    option_number     SMALLINT,
    created_at        TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at        TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (user_id)         REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (trip_request_id) REFERENCES TripRequest(id) ON DELETE CASCADE
);

CREATE TABLE ItineraryItem (
    id              INT PRIMARY KEY,
    itinerary_id    INT NOT NULL,
    place_id        INT,
    day_number      SMALLINT NOT NULL,
    start_time      TIME,
    end_time        TIME,
    note            TEXT,
    transport_mode  VARCHAR(20),
    sort_order      SMALLINT DEFAULT 1 NOT NULL,
    created_at      TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (itinerary_id) REFERENCES Itinerary(id) ON DELETE CASCADE,
    FOREIGN KEY (place_id)     REFERENCES Place(id) ON DELETE SET NULL
);

-- ============================================================
-- 7. CHATBOT / RAG
-- ============================================================

CREATE TABLE ChatSession (
    id          INT PRIMARY KEY,
    user_id     INT NOT NULL,
    title       VARCHAR(255),
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,
    updated_at  TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE
);

CREATE TABLE ChatMessage (
    id          INT PRIMARY KEY,
    session_id  INT NOT NULL,
    role        VARCHAR(10) NOT NULL,
    content     TEXT NOT NULL,
    model_used  VARCHAR(100),
    token_used  INT,
    created_at  TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (session_id) REFERENCES ChatSession(id) ON DELETE CASCADE
);

CREATE TABLE PlaceEmbedding (
    id            INT PRIMARY KEY,
    place_id      INT NOT NULL,
    chunk_index   SMALLINT DEFAULT 0 NOT NULL,
    chunk_text    TEXT NOT NULL,
    embedding     VECTOR(1536) NOT NULL,
    metadata      JSONB,
    created_at    TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE,
    UNIQUE (place_id, chunk_index)
);

CREATE TABLE ReviewEmbedding (
    id            INT PRIMARY KEY,
    place_id      INT NOT NULL,
    review_id     INT NOT NULL,
    chunk_text    TEXT NOT NULL,
    chunk_index   SMALLINT DEFAULT 0 NOT NULL,
    embedding     VECTOR(1536) NOT NULL,
    created_at    TIMESTAMP DEFAULT NOW() NOT NULL,

    FOREIGN KEY (place_id)  REFERENCES Place(id) ON DELETE CASCADE,
    FOREIGN KEY (review_id) REFERENCES Review(id) ON DELETE CASCADE,
    UNIQUE (review_id, chunk_index)
);

-- ============================================================
-- 8. THỐNG KÊ
-- ============================================================

CREATE TABLE DailyStat (
    id              INT PRIMARY KEY,
    stat_date       DATE NOT NULL,
    place_id        INT NOT NULL,
    view_count      INT DEFAULT 0 NOT NULL,
    favorite_count  INT DEFAULT 0 NOT NULL,
    review_count    INT DEFAULT 0 NOT NULL,
    search_count    INT DEFAULT 0 NOT NULL,

    FOREIGN KEY (place_id) REFERENCES Place(id) ON DELETE CASCADE,
    UNIQUE (stat_date, place_id)
);

-- ============================================================
-- 9. INDEX BỔ SUNG
-- ============================================================

CREATE INDEX idx_place_district ON Place(district);
CREATE INDEX idx_place_status   ON Place(status);
CREATE INDEX idx_place_rating   ON Place(average_rating DESC);
CREATE INDEX idx_place_name_search ON Place USING GIN (to_tsvector('simple', name));

CREATE INDEX idx_review_place        ON Review(place_id);
CREATE INDEX idx_review_user         ON Review(user_id);
CREATE INDEX idx_favorite_place      ON Favorite(place_id);
CREATE INDEX idx_visitedplace_user   ON VisitedPlace(user_id);
CREATE INDEX idx_itineraryitem_itin  ON ItineraryItem(itinerary_id);
CREATE INDEX idx_chatmessage_session ON ChatMessage(session_id, created_at);

CREATE INDEX idx_placeembedding_vector
    ON PlaceEmbedding USING hnsw (embedding vector_cosine_ops);

CREATE INDEX idx_reviewembedding_vector
    ON ReviewEmbedding USING hnsw (embedding vector_cosine_ops);

-- ============================================================
-- 10. SEED DATA MẪU
-- ============================================================

INSERT INTO InterestTag (id, name) VALUES
    (1, 'Ẩm thực'), (2, 'Lịch sử'), (3, 'Thiên nhiên'), (4, 'Chụp ảnh'),
    (5, 'Cà phê'), (6, 'Mua sắm'), (7, 'Giải trí'), (8, 'Nghệ thuật'),
    (9, 'Tâm linh'), (10, 'Thể thao'), (11, 'Nightlife'), (12, 'Gia đình'),
    (13, 'Kiến trúc'), (14, 'Văn hóa');

INSERT INTO Category (id, name) VALUES
    (1, 'Bảo tàng'), (2, 'Di tích lịch sử'), (3, 'Công viên'), (4, 'Chùa - Đền'),
    (5, 'Quán cà phê'), (6, 'Nhà hàng'), (7, 'Trung tâm thương mại'),
    (8, 'Khu vui chơi'), (9, 'Phố đi bộ'), (10, 'Chợ truyền thống');