--
-- PostgreSQL database dump
--

\restrict ZspO62B16FzZLE03nEhlYrDE62fhMWjnXHdErnGUMfKeJT4eIGh2iQYGRtsTuf2

-- Dumped from database version 18.4
-- Dumped by pg_dump version 18.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: vector; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS vector WITH SCHEMA public;


--
-- Name: EXTENSION vector; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION vector IS 'vector data type and ivfflat and hnsw access methods';


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: alembic_version; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alembic_version (
    version_num character varying(32) NOT NULL
);


ALTER TABLE public.alembic_version OWNER TO postgres;

--
-- Name: category; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.category (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description character varying(255),
    parent_id integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.category OWNER TO postgres;

--
-- Name: category_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.category_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.category_id_seq OWNER TO postgres;

--
-- Name: category_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.category_id_seq OWNED BY public.category.id;


--
-- Name: chatmessage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chatmessage (
    id integer NOT NULL,
    session_id integer NOT NULL,
    content text NOT NULL,
    model_used character varying(100),
    token_used integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    user_role character varying(9) NOT NULL
);


ALTER TABLE public.chatmessage OWNER TO postgres;

--
-- Name: chatmessage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chatmessage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chatmessage_id_seq OWNER TO postgres;

--
-- Name: chatmessage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chatmessage_id_seq OWNED BY public.chatmessage.id;


--
-- Name: chatsession; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.chatsession (
    id integer NOT NULL,
    user_id integer NOT NULL,
    title character varying(255),
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.chatsession OWNER TO postgres;

--
-- Name: chatsession_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.chatsession_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.chatsession_id_seq OWNER TO postgres;

--
-- Name: chatsession_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.chatsession_id_seq OWNED BY public.chatsession.id;


--
-- Name: favorite; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.favorite (
    user_id integer NOT NULL,
    place_id integer NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.favorite OWNER TO postgres;

--
-- Name: interesttag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.interesttag (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.interesttag OWNER TO postgres;

--
-- Name: interesttag_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.interesttag_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.interesttag_id_seq OWNER TO postgres;

--
-- Name: interesttag_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.interesttag_id_seq OWNED BY public.interesttag.id;


--
-- Name: itinerary; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itinerary (
    id integer NOT NULL,
    user_id integer NOT NULL,
    trip_request_id integer,
    title character varying(255) NOT NULL,
    description text,
    start_date date,
    end_date date,
    num_people smallint DEFAULT 1 NOT NULL,
    share_code character varying(50),
    option_number smallint,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.itinerary OWNER TO postgres;

--
-- Name: itinerary_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.itinerary_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.itinerary_id_seq OWNER TO postgres;

--
-- Name: itinerary_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.itinerary_id_seq OWNED BY public.itinerary.id;


--
-- Name: itineraryitem; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.itineraryitem (
    id integer NOT NULL,
    itinerary_id integer NOT NULL,
    place_id integer,
    day_number smallint NOT NULL,
    start_time time without time zone,
    end_time time without time zone,
    note text,
    transport_mode character varying(20),
    sort_order smallint DEFAULT 1 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.itineraryitem OWNER TO postgres;

--
-- Name: itineraryitem_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.itineraryitem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.itineraryitem_id_seq OWNER TO postgres;

--
-- Name: itineraryitem_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.itineraryitem_id_seq OWNED BY public.itineraryitem.id;


--
-- Name: place; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.place (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    description text NOT NULL,
    address character varying(200) NOT NULL,
    ward character varying(50) NOT NULL,
    link_google_map character varying(300) NOT NULL,
    phone character varying(15),
    website character varying(200),
    price_min numeric(12,0) DEFAULT 0 NOT NULL,
    price_max numeric(12,0) DEFAULT 0 NOT NULL,
    opening_time time without time zone NOT NULL,
    closing_time time without time zone NOT NULL,
    open_days character varying(100) NOT NULL,
    average_rating numeric(2,1) DEFAULT 0.0 NOT NULL,
    total_reviews integer DEFAULT 0 NOT NULL,
    total_views integer DEFAULT 0 NOT NULL,
    is_featured boolean DEFAULT false NOT NULL,
    status character varying(7) DEFAULT 'ACTIVE'::character varying NOT NULL,
    created_by integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.place OWNER TO postgres;

--
-- Name: place_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.place_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.place_id_seq OWNER TO postgres;

--
-- Name: place_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.place_id_seq OWNED BY public.place.id;


--
-- Name: placeagegroup; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.placeagegroup (
    id integer NOT NULL,
    place_id integer,
    age_group character varying(11) NOT NULL,
    suitability smallint DEFAULT 3 NOT NULL
);


ALTER TABLE public.placeagegroup OWNER TO postgres;

--
-- Name: placeagegroup_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.placeagegroup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.placeagegroup_id_seq OWNER TO postgres;

--
-- Name: placeagegroup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.placeagegroup_id_seq OWNED BY public.placeagegroup.id;


--
-- Name: placecategory; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.placecategory (
    place_id integer NOT NULL,
    category_id integer NOT NULL
);


ALTER TABLE public.placecategory OWNER TO postgres;

--
-- Name: placeembedding; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.placeembedding (
    id integer NOT NULL,
    place_id integer NOT NULL,
    chunk_index smallint DEFAULT 0 NOT NULL,
    chunk_text text NOT NULL,
    embedding public.vector(768) NOT NULL,
    metadata jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.placeembedding OWNER TO postgres;

--
-- Name: placeembedding_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.placeembedding_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.placeembedding_id_seq OWNER TO postgres;

--
-- Name: placeembedding_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.placeembedding_id_seq OWNED BY public.placeembedding.id;


--
-- Name: placeimage; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.placeimage (
    id integer NOT NULL,
    place_id integer,
    img_url character varying(500) NOT NULL,
    caption character varying(255),
    is_primary boolean DEFAULT false NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.placeimage OWNER TO postgres;

--
-- Name: placeimage_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.placeimage_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.placeimage_id_seq OWNER TO postgres;

--
-- Name: placeimage_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.placeimage_id_seq OWNED BY public.placeimage.id;


--
-- Name: placetag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.placetag (
    place_id integer NOT NULL,
    tag_id integer NOT NULL,
    relevance numeric(3,2) DEFAULT 1.0 NOT NULL
);


ALTER TABLE public.placetag OWNER TO postgres;

--
-- Name: review; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.review (
    id integer NOT NULL,
    place_id integer NOT NULL,
    user_id integer NOT NULL,
    rating smallint NOT NULL,
    title character varying(255),
    content text,
    visit_date date,
    status character varying(8) DEFAULT 'APPROVED'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    images jsonb
);


ALTER TABLE public.review OWNER TO postgres;

--
-- Name: review_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.review_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.review_id_seq OWNER TO postgres;

--
-- Name: review_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.review_id_seq OWNED BY public.review.id;


--
-- Name: searchlog; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.searchlog (
    id integer NOT NULL,
    user_id integer,
    query_text text NOT NULL,
    filters jsonb,
    result_count integer,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.searchlog OWNER TO postgres;

--
-- Name: searchlog_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.searchlog_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.searchlog_id_seq OWNER TO postgres;

--
-- Name: searchlog_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.searchlog_id_seq OWNED BY public.searchlog.id;


--
-- Name: tokenblacklist; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tokenblacklist (
    id integer NOT NULL,
    jti character varying(64) NOT NULL,
    user_id integer NOT NULL,
    expires_at timestamp without time zone NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.tokenblacklist OWNER TO postgres;

--
-- Name: tokenblacklist_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tokenblacklist_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tokenblacklist_id_seq OWNER TO postgres;

--
-- Name: tokenblacklist_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tokenblacklist_id_seq OWNED BY public.tokenblacklist.id;


--
-- Name: triprequest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.triprequest (
    id integer NOT NULL,
    user_id integer NOT NULL,
    raw_query text NOT NULL,
    duration_day integer,
    parsed_prefs jsonb,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.triprequest OWNER TO postgres;

--
-- Name: triprequest_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.triprequest_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.triprequest_id_seq OWNER TO postgres;

--
-- Name: triprequest_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.triprequest_id_seq OWNED BY public.triprequest.id;


--
-- Name: userinterest; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.userinterest (
    user_id integer NOT NULL,
    tag_id integer NOT NULL,
    priority smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.userinterest OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    username character varying(20) NOT NULL,
    hash_password character varying(255) NOT NULL,
    avatar character varying(255),
    email character varying(100) NOT NULL,
    phone character varying(15) NOT NULL,
    date_of_birth date NOT NULL,
    gender character varying(6) NOT NULL,
    user_role character varying(5) DEFAULT 'USER'::character varying,
    is_active boolean DEFAULT true NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT chk_gender CHECK (((gender)::text = ANY (ARRAY[('MALE'::character varying)::text, ('FEMALE'::character varying)::text, ('OTHER'::character varying)::text])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: usertravelprofile; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usertravelprofile (
    user_id integer NOT NULL,
    travel_style character varying(6),
    budget_level character varying(6),
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    with_children boolean DEFAULT false NOT NULL,
    with_elderly boolean DEFAULT false NOT NULL,
    CONSTRAINT chk_budget_level CHECK (((budget_level)::text = ANY (ARRAY[('LOW'::character varying)::text, ('MEDIUM'::character varying)::text, ('HIGH'::character varying)::text]))),
    CONSTRAINT chk_travel_style CHECK (((travel_style)::text = ANY (ARRAY[('SOLO'::character varying)::text, ('COUPLE'::character varying)::text, ('FAMILY'::character varying)::text, ('GROUP'::character varying)::text])))
);


ALTER TABLE public.usertravelprofile OWNER TO postgres;

--
-- Name: visitedplace; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.visitedplace (
    id integer NOT NULL,
    user_id integer NOT NULL,
    place_id integer NOT NULL,
    visited_at date,
    source character varying(6) DEFAULT 'MANUAL'::character varying NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.visitedplace OWNER TO postgres;

--
-- Name: visitedplace_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.visitedplace_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.visitedplace_id_seq OWNER TO postgres;

--
-- Name: visitedplace_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.visitedplace_id_seq OWNED BY public.visitedplace.id;


--
-- Name: category id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category ALTER COLUMN id SET DEFAULT nextval('public.category_id_seq'::regclass);


--
-- Name: chatmessage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessage ALTER COLUMN id SET DEFAULT nextval('public.chatmessage_id_seq'::regclass);


--
-- Name: chatsession id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatsession ALTER COLUMN id SET DEFAULT nextval('public.chatsession_id_seq'::regclass);


--
-- Name: interesttag id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesttag ALTER COLUMN id SET DEFAULT nextval('public.interesttag_id_seq'::regclass);


--
-- Name: itinerary id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itinerary ALTER COLUMN id SET DEFAULT nextval('public.itinerary_id_seq'::regclass);


--
-- Name: itineraryitem id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itineraryitem ALTER COLUMN id SET DEFAULT nextval('public.itineraryitem_id_seq'::regclass);


--
-- Name: place id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place ALTER COLUMN id SET DEFAULT nextval('public.place_id_seq'::regclass);


--
-- Name: placeagegroup id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeagegroup ALTER COLUMN id SET DEFAULT nextval('public.placeagegroup_id_seq'::regclass);


--
-- Name: placeembedding id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeembedding ALTER COLUMN id SET DEFAULT nextval('public.placeembedding_id_seq'::regclass);


--
-- Name: placeimage id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeimage ALTER COLUMN id SET DEFAULT nextval('public.placeimage_id_seq'::regclass);


--
-- Name: review id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review ALTER COLUMN id SET DEFAULT nextval('public.review_id_seq'::regclass);


--
-- Name: searchlog id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.searchlog ALTER COLUMN id SET DEFAULT nextval('public.searchlog_id_seq'::regclass);


--
-- Name: tokenblacklist id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenblacklist ALTER COLUMN id SET DEFAULT nextval('public.tokenblacklist_id_seq'::regclass);


--
-- Name: triprequest id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.triprequest ALTER COLUMN id SET DEFAULT nextval('public.triprequest_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: visitedplace id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitedplace ALTER COLUMN id SET DEFAULT nextval('public.visitedplace_id_seq'::regclass);


--
-- Data for Name: alembic_version; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alembic_version (version_num) FROM stdin;
b7c4e1d90a35
\.


--
-- Data for Name: category; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.category (id, name, description, parent_id, created_at) FROM stdin;
2	Di tích lịch sử	\N	\N	2026-07-13 01:51:08.78975
3	Công viên	\N	\N	2026-07-13 01:51:08.78975
4	Chùa - Đền	\N	\N	2026-07-13 01:51:08.78975
5	Quán cà phê	\N	\N	2026-07-13 01:51:08.78975
6	Nhà hàng	\N	\N	2026-07-13 01:51:08.78975
7	Trung tâm thương mại	\N	\N	2026-07-13 01:51:08.78975
8	Khu vui chơi	\N	\N	2026-07-13 01:51:08.78975
9	Phố đi bộ	\N	\N	2026-07-13 01:51:08.78975
10	Chợ	Các chợ truyền thống và chợ đêm...	\N	2026-07-13 01:51:08.78975
13	Phố ẩm thực	Các khu phố ẩm thực trong Sài gòn	\N	2026-07-28 20:46:28.786222
14	Quán ăn	Các quán ăn trong Sài gòn	\N	2026-07-28 20:56:51.00926
15	Quán phở	Các quán phở trong Sài gòn	14	2026-07-28 20:57:06.664133
16	Nhà thờ	Các nhà thờ trong Sài gòn	\N	2026-07-28 22:12:57.909237
17	Công trình kiến trúc di sản	Các công trình lâu đời trong Sài gòn	\N	2026-07-28 22:33:34.265031
18	Check-in	Các địa điểm chụp hình trong Sài gòn	\N	2026-07-30 15:44:09.154822
19	Bar	Các quán bar trong Sài Gòn	\N	2026-08-05 17:46:14.955454
20	Pub	Các quán pub trong sài gòn	\N	2026-08-05 17:46:29.49994
1	Bảo tàng	Các bảo tàng trong TPHCM	\N	2026-07-13 01:51:08.78975
\.


--
-- Data for Name: chatmessage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatmessage (id, session_id, content, model_used, token_used, created_at, user_role) FROM stdin;
1	1	Dinh độc lập ở đâu	\N	\N	2026-08-15 22:36:50.396794	USER
2	1	Dinh Độc Lập tọa lạc tại khu vực Bến Thành bạn nhé. Đây là một di tích quốc gia đặc biệt với nhiều giá trị lịch sử.\n\nGiá vé tham khảo từ 20,000 - 80,000 VND và mở cửa từ 07:00 đến 18:00 hàng ngày. Bạn nhớ xác nhận lại thông tin trước khi đi vì giờ mở cửa và giá vé có thể thay đổi nhé!	gemini-3.1-flash-lite	\N	2026-08-15 22:36:50.406308	ASSISTANT
3	1	Hãy nói cho tôi nghe về Bitexco	\N	\N	2026-08-15 22:45:53.240003	USER
4	1	Chào bạn! Bitexco là một biểu tượng rất nổi tiếng tại TP.HCM với thiết kế lấy cảm hứng từ búp sen và bãi đáp trực thăng độc đáo.\n\nĐây là điểm đến lý tưởng nếu bạn muốn ngắm nhìn toàn cảnh 360 độ trung tâm thành phố và sông Sài Gòn từ đài quan sát Saigon Skydeck ở tầng 49. Ngoài ra, đây cũng là trung tâm thương mại rất thu hút giới trẻ và du khách quốc tế đến check-in.\n\n*   **Giờ mở cửa:** 09:30 - 21:30 hằng ngày.\n\n*Lưu ý: Bạn nên xác nhận lại giờ mở cửa trước khi đi vì thông tin có thể thay đổi nhé!*	gemini-3.1-flash-lite	\N	2026-08-15 22:45:53.262769	ASSISTANT
5	2	Nhà thờ đức bà ở đường nào?	\N	\N	2026-08-15 22:51:14.090939	USER
6	2	Nhà thờ Đức Bà Sài Gòn nằm tại khu vực Bến Nghé bạn nhé. \n\nLưu ý rằng thông tin về giờ mở cửa có thể thay đổi, bạn nên xác nhận lại trước khi ghé thăm nhé!	gemini-3.1-flash-lite	\N	2026-08-15 22:51:14.096154	ASSISTANT
7	3	nói về Dinh độc lập	\N	\N	2026-08-17 23:25:43.159436	USER
8	3	Dinh Độc Lập là một di tích quốc gia đặc biệt tại TP.HCM, từng là nơi ở và làm việc của Tổng thống Việt Nam Cộng hòa trước năm 1975. Hiện nay, nơi này được quản lý bởi Hội trường Thống Nhất.\n\nĐây là điểm đến rất ý nghĩa nếu bạn muốn tìm hiểu về lịch sử.\n- **Giờ mở cửa:** 07:00 - 18:00 (Thứ 2 - Chủ nhật).\n- **Giá vé tham khảo:** 20,000 - 80,000 VND.\n\nLưu ý: Bạn nên kiểm tra lại thông tin giá vé và giờ mở cửa trước khi đi vì có thể thay đổi nhé!	gemini-3.1-flash-lite	\N	2026-08-17 23:25:43.170226	ASSISTANT
9	4	hello	\N	\N	2026-08-18 15:03:40.449448	USER
10	4	Chào bạn! Rất vui được hỗ trợ bạn khám phá TP.HCM. Dựa trên danh sách hiện có, mình gợi ý bạn ghé thăm một vài địa điểm biểu tượng sau:\n\n*   **Nhà thờ Đức Bà Sài Gòn:** Nổi tiếng với kiến trúc Roman pha Gothic cổ kính và đàn bồ câu thân thiện, rất hợp để chụp ảnh lưu niệm.\n*   **Chợ Bến Thành:** Điểm đến lý tưởng nếu bạn muốn trải nghiệm không khí sầm uất, mua sắm quà lưu niệm và thưởng thức ẩm thực đường phố.\n*   **Bến Nhà Rồng:** Một di tích lịch sử quan trọng với kiến trúc Pháp - Việt giao thoa, không gian khuôn viên ven sông rất thoáng đãng.\n\nNgoài ra còn có **Bảo tàng TP.HCM** với kiến trúc Baroque tuyệt đẹp và **Nhà hát Thành phố** nếu bạn yêu thích các công trình di sản.\n\n*Lưu ý: Bạn nên kiểm tra lại giá vé và giờ mở cửa trước khi đi vì thông tin có thể thay đổi nhé!*	gemini-3.1-flash-lite	\N	2026-08-18 15:03:40.455728	ASSISTANT
11	5	tạo giúp tôi lịch trình đi trong 2 ngày	\N	\N	2026-08-18 15:52:51.607912	USER
12	5	Chào bạn, mình rất vui được gợi ý lịch trình 2 ngày tại TP.HCM dựa trên danh sách địa điểm bạn có:\n\n**Ngày 1: Khám phá lịch sử và văn hóa**\n*   **Sáng:** Tham quan **Dinh Độc Lập** để tìm hiểu về di tích lịch sử đặc biệt của thành phố.\n*   **Chiều:** Ghé thăm **Chùa Ngọc Hoàng** để chiêm bái và tận hưởng không gian kiến trúc tâm linh trầm mặc.\n*   **Tối:** Dạo chơi tại **Đường sách TP.HCM**, không gian rất thoáng đãng và thú vị để thư giãn.\n\n**Ngày 2: Thiên nhiên và trải nghiệm hiện đại**\n*   **Sáng:** Đến **Thảo Cầm Viên** để tận hưởng không gian xanh mát và tham quan các loài động thực vật.\n*   **Chiều & Tối:** Di chuyển đến **Landmark 81**. Bạn có thể mua sắm, trượt băng hoặc lên đài quan sát SkyView để ngắm nhìn toàn cảnh thành phố từ trên cao vào buổi tối rất đẹp.\n\n*Lưu ý: Thông tin về giá vé và giờ mở cửa có thể thay đổi tùy thời điểm, bạn nên kiểm tra lại trước khi khởi hành nhé. Chúc bạn có một chuyến đi thật vui!*	gemini-3.1-flash-lite	\N	2026-08-18 15:52:51.611068	ASSISTANT
13	6	dinh độc lập ở đâu	\N	\N	2026-08-20 15:40:45.714488	USER
14	6	Dinh Độc Lập tọa lạc tại khu vực Bến Thành, TP.HCM bạn nhé. Đây là một di tích quốc gia đặc biệt với kiến trúc rất ấn tượng, rất phù hợp với sở thích chụp ảnh của bạn.\n\nGiá vé tham khảo từ 20,000 - 80,000 VND và mở cửa từ 07:00 đến 18:00 hàng ngày. Bạn nhớ xác nhận lại thông tin trước khi đi vì giờ mở cửa và giá vé có thể thay đổi nhé!	gemini-3.1-flash-lite	\N	2026-08-20 15:40:45.717936	ASSISTANT
15	6	landmark 81 là gì	\N	\N	2026-08-20 15:45:04.696995	USER
16	6	Chào bạn! Landmark 81 là tòa nhà cao nhất Việt Nam và là biểu tượng hiện đại của TP.HCM với thiết kế lấy cảm hứng từ bó tre truyền thống.\n\nVới sở thích chụp ảnh và ẩm thực của bạn, đây là lựa chọn tuyệt vời vì bạn có thể thỏa sức mua sắm, ăn uống tại trung tâm thương mại khối đế hoặc lên đài quan sát SkyView để chụp ảnh toàn cảnh thành phố từ trên cao.\n\n*   **Giờ mở cửa:** 10:00 - 21:30 hằng ngày.\n\n*Lưu ý: Bạn nên xác nhận lại thông tin về giá vé và giờ mở cửa trước khi đi vì có thể thay đổi nhé!*	gemini-3.1-flash-lite	\N	2026-08-20 15:45:04.720045	ASSISTANT
17	6	landmark có thích hợp với trẻ nhỏ không	\N	\N	2026-08-20 15:46:07.890579	USER
18	6	Chào bạn, rất tiếc là trong danh sách địa điểm hiện tại của mình không có thông tin về Landmark nên mình chưa thể tư vấn giúp bạn được.\n\nNếu bạn muốn tìm nơi phù hợp cho trẻ nhỏ, mình gợi ý **Đầm Sen Khô** vì đây là khu vui chơi giải trí rất hấp dẫn, hoặc **Công viên Tao Đàn** với không gian xanh mát để các bé chạy nhảy. Bạn nhớ kiểm tra lại giá vé và giờ mở cửa trước khi đi vì thông tin có thể thay đổi nhé!	gemini-3.1-flash-lite	\N	2026-08-20 15:46:07.90684	ASSISTANT
19	7	giải two sum	\N	\N	2026-08-26 15:27:32.566966	USER
21	7	bạn là model gì	\N	\N	2026-08-26 15:28:15.029389	USER
23	7	tôi muốn tự sát ở đâu	\N	\N	2026-08-26 15:29:24.144088	USER
20	7	Chào bạn, rất tiếc là mình chưa tìm được thông tin liên quan đến "giải two sum" trong danh sách địa điểm du lịch tại TP.HCM.\n\nTuy nhiên, với phong cách du lịch SOLO, ngân sách MEDIUM và sở thích chụp ảnh, ẩm thực, mình gợi ý bạn ghé thăm các địa điểm sau:\n\n1. **Bitexco:** Rất hợp để chụp ảnh với kiến trúc độc đáo và ngắm toàn cảnh thành phố từ trên cao.\n2. **Đường sách TP.HCM:** Không gian yên bình, xanh mát, rất lý tưởng để dạo bộ, chụp ảnh và nhâm nhi cà phê một mình.\n3. **Phở Hòa Pasteur:** Một địa chỉ ẩm thực truyền thống nổi tiếng để bạn thưởng thức hương vị phở chuẩn Sài Gòn.\n\n*Lưu ý: Bạn nên kiểm tra lại giá vé và giờ mở cửa trước khi đi vì thông tin có thể thay đổi nhé!*	gemini-3.1-flash-lite	\N	2026-08-26 15:27:32.575845	ASSISTANT
22	7	Chào bạn, mình là trợ lý du lịch của bạn tại TP.HCM. Với sở thích chụp ảnh và ẩm thực, lại đi một mình (solo), mình gợi ý bạn 2 địa điểm cực kỳ phù hợp sau đây:\n\n1. **Bảo tàng Mỹ thuật TP.HCM**: Đây là "thiên đường" cho người yêu nhiếp ảnh với kiến trúc Art Deco cổ điển, tông vàng hoài cổ. Bạn có thể thỏa sức chụp những bộ ảnh nghệ thuật độc đáo trong không gian yên tĩnh.\n   * *Giá vé:* 15.000 - 30.000 VND.\n   * *Giờ mở cửa:* 08:00 - 17:00.\n\n2. **Phố đi bộ Bùi Viện**: Nếu muốn trải nghiệm ẩm thực đường phố và không khí sôi động về đêm, đây là lựa chọn số 1. Bạn có thể ngồi thưởng thức bia thủ công và các món ăn đa dạng rất thoải mái khi đi một mình.\n   * *Chi phí:* 0 - 500.000 VND.\n   * *Giờ mở cửa:* 18:00 - 02:00.\n\n*Lưu ý: Thông tin về giá vé và giờ mở cửa có thể thay đổi, bạn nên xác nhận lại trước khi đến nhé!*	gemini-3.1-flash-lite	\N	2026-08-26 15:28:15.042309	ASSISTANT
24	7	Chào bạn, tôi rất tiếc khi nghe bạn đang trải qua khoảng thời gian khó khăn. Nếu bạn đang cảm thấy bế tắc, hãy thử chia sẻ với những người thân thiết hoặc liên hệ các dịch vụ hỗ trợ tâm lý chuyên nghiệp.\n\nVề yêu cầu của bạn, tôi xin phép không đưa ra gợi ý nào từ danh sách trên. Nếu bạn cần người lắng nghe hoặc hỗ trợ, bạn có thể liên hệ các đường dây nóng hỗ trợ tâm lý tại Việt Nam như **Tổng đài Quốc gia Bảo vệ Trẻ em 111** (hỗ trợ mọi đối tượng) hoặc các trung tâm tham vấn tâm lý uy tín tại TP.HCM. Mong bạn sớm tìm lại được sự bình an.	gemini-3.1-flash-lite	\N	2026-08-26 15:29:24.158269	ASSISTANT
25	8	Đinh độc lập ở đâu	\N	\N	2026-09-06 17:33:18.085421	USER
26	8	Chào bạn, Dinh Độc Lập nằm tại khu vực Bến Thành nhé. Đây là một di tích lịch sử đặc biệt, rất phù hợp để bạn tham quan và chụp ảnh kiến trúc.\n\n*   **Giá vé:** 20,000 - 80,000 VND.\n*   **Giờ mở cửa:** 07:00 - 18:00 (Thứ 2 - Chủ nhật).\n\nBạn lưu ý nên xác nhận lại giá vé và giờ mở cửa trước khi đi vì thông tin có thể thay đổi nhé!	gemini-3.1-flash-lite	\N	2026-09-06 17:33:18.098787	ASSISTANT
27	9	hello	\N	\N	2026-10-01 11:33:25.200688	USER
28	9	Chào bạn! Với phong cách du lịch solo, yêu thích chụp ảnh và ẩm thực, mình gợi ý bạn 2 địa điểm cực kỳ phù hợp này:\n\n1. **Chợ Bến Thành**: Đây là "thiên đường" để bạn thỏa mãn đam mê ẩm thực đường phố và chụp những bức ảnh đậm chất văn hóa địa phương với tháp đồng hồ biểu tượng.\n2. **Bảo tàng Thành phố Hồ Chí Minh**: Nơi này có kiến trúc Baroque tuyệt đẹp với cầu thang vòm uốn lượn, rất lý tưởng để bạn có những bức ảnh "sống ảo" nghệ thuật.\n\nNgoài ra, bạn có thể ghé **Nhà thờ Đức Bà** để chụp ảnh cùng đàn bồ câu hoặc **Nhà hát Thành phố** với kiến trúc Pháp cổ kính.\n\n*Lưu ý: Giá vé và giờ mở cửa có thể thay đổi, bạn nên kiểm tra lại trước khi đi nhé!*	gemini-3.1-flash-lite	\N	2026-10-01 11:33:25.200688	ASSISTANT
\.


--
-- Data for Name: chatsession; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.chatsession (id, user_id, title, created_at, updated_at) FROM stdin;
1	4	Dinh độc lập ở đâu	2026-08-15 22:36:50.353979	2026-08-15 22:46:01.980584
2	5	Nhà thờ đức bà ở đường nào?	2026-08-15 22:51:14.077868	2026-08-15 22:51:21.906405
3	4	nói về Dinh độc lập	2026-08-17 23:25:43.138824	2026-08-17 23:25:47.555015
4	4	hello	2026-08-18 15:03:40.414287	2026-08-18 15:03:44.998254
5	4	tạo giúp tôi lịch trình đi trong 2 ngày	2026-08-18 15:52:51.587345	2026-08-18 15:52:54.676095
6	4	dinh độc lập ở đâu	2026-08-20 15:40:45.699179	2026-08-20 15:46:09.58181
7	4	giải two sum	2026-08-26 15:27:32.528619	2026-08-26 15:29:28.708845
8	4	Đinh độc lập ở đâu	2026-09-06 17:33:18.056443	2026-09-06 17:33:20.874071
9	4	hello	2026-10-01 11:33:25.200688	2026-10-01 11:33:25.200688
\.


--
-- Data for Name: favorite; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.favorite (user_id, place_id, created_at) FROM stdin;
5	24	2026-08-15 22:49:40.813444
5	23	2026-08-15 22:49:44.08345
5	22	2026-08-15 22:49:46.632244
4	15	2026-09-08 14:32:37.964563
\.


--
-- Data for Name: interesttag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.interesttag (id, name, created_at) FROM stdin;
1	Ẩm thực	2026-07-13 01:51:08.78975
2	Lịch sử	2026-07-13 01:51:08.78975
3	Thiên nhiên	2026-07-13 01:51:08.78975
4	Chụp ảnh	2026-07-13 01:51:08.78975
5	Cà phê	2026-07-13 01:51:08.78975
6	Mua sắm	2026-07-13 01:51:08.78975
7	Giải trí	2026-07-13 01:51:08.78975
8	Nghệ thuật	2026-07-13 01:51:08.78975
9	Tâm linh	2026-07-13 01:51:08.78975
11	Nightlife	2026-07-13 01:51:08.78975
12	Gia đình	2026-07-13 01:51:08.78975
13	Kiến trúc	2026-07-13 01:51:08.78975
14	Văn hóa	2026-07-13 01:51:08.78975
\.


--
-- Data for Name: itinerary; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itinerary (id, user_id, trip_request_id, title, description, start_date, end_date, num_people, share_code, option_number, created_at, updated_at) FROM stdin;
8	4	9	Khám phá văn hóa và giải trí tại TP.HCM	Lịch trình 2 ngày kết hợp tham quan các di tích lịch sử, bảo tàng nghệ thuật và khu vui chơi giải trí đặc sắc tại Sài Gòn.	\N	\N	1	\N	\N	2026-10-01 11:27:39.402783	2026-10-01 11:27:39.402783
\.


--
-- Data for Name: itineraryitem; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.itineraryitem (id, itinerary_id, place_id, day_number, start_time, end_time, note, transport_mode, sort_order, created_at) FROM stdin;
45	8	21	1	08:30:00	\N	Tham quan kiến trúc Baroque và tìm hiểu lịch sử đô thị	Xe máy	1	2026-10-01 11:27:39.402783
46	8	3	1	10:30:00	\N	Chiêm ngưỡng nghệ thuật trong dinh thự cổ Art Deco	Xe máy	2	2026-10-01 11:27:39.402783
47	8	5	1	12:30:00	\N	Ăn trưa và khám phá ẩm thực đường phố tại chợ	Đi bộ	3	2026-10-01 11:27:39.402783
48	8	17	1	15:00:00	\N	Chụp ảnh kiến trúc Pháp và dạo quanh quảng trường	Xe máy	4	2026-10-01 11:27:39.402783
49	8	19	1	16:30:00	\N	Tham quan di tích lịch sử và ngắm cảnh sông Sài Gòn	Xe máy	5	2026-10-01 11:27:39.402783
50	8	14	2	08:30:00	\N	Tìm hiểu cổ vật và kiến trúc Á-Âu	Xe máy	1	2026-10-01 11:27:39.402783
51	8	12	2	10:30:00	\N	Vui chơi giải trí tại khu du lịch Đầm Sen Khô	Xe máy	2	2026-10-01 11:27:39.402783
52	8	11	2	13:30:00	\N	Trải nghiệm các trò chơi tại công viên nước	Đi bộ	3	2026-10-01 11:27:39.402783
53	8	27	2	16:30:00	\N	Thư giãn trong không gian miệt vườn yên bình	Xe máy	4	2026-10-01 11:27:39.402783
54	8	25	2	18:30:00	\N	Ngắm hoàng hôn và toàn cảnh thành phố bên sông	Xe máy	5	2026-10-01 11:27:39.402783
\.


--
-- Data for Name: place; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.place (id, name, description, address, ward, link_google_map, phone, website, price_min, price_max, opening_time, closing_time, open_days, average_rating, total_reviews, total_views, is_featured, status, created_by, created_at, updated_at) FROM stdin;
6	Phố đi bộ Nguyễn Huệ	Phố đi bộ là quảng trường hiện đại, thoáng đãng nối liền từ Ủy ban Nhân dân Thành phố ra đến bờ sông Sài Gòn. Vào mỗi buổi tối và cuối tuần, du khách có thể dạo bộ hóng mát, xem các màn trình diễn nghệ thuật đường phố sôi động. Nơi đây là tâm điểm vui chơi lý tưởng cho giới trẻ, các cặp đôi, gia đình và du khách quốc tế thích không khí nhộn nhịp về đêm. Điểm nhấn nổi bật là hệ thống đài phun nước kết hợp ánh sáng nghệ thuật.	Nguyễn Huệ	Sài Gòn	https://maps.app.goo.gl/MBDjzKGr3Hpuxcxp7		\N	0	0	00:00:00	23:59:59	Hằng ngày	0.0	0	1	t	ACTIVE	2	2026-07-28 20:25:33.883242	2026-07-28 20:25:33.883242
5	Chợ Bến Thành	Chợ Bến Thành là khu thương mại sầm uất và mang tính biểu tượng lâu đời với kiến trúc tháp đồng hồ đặc trưng ở cửa Nam. Bạn có thể thỏa sức mua sắm vải vóc, đồ thủ công mỹ nghệ, quà lưu niệm và thưởng thức thiên đường ẩm thực đường phố đa dạng ngay tại các gian hàng bên trong. Đây là điểm đến không thể bỏ qua cho du khách lần đầu đến TP.HCM, những tín đồ mua sắm và đam mê khám phá văn hóa địa phương. Điểm đặc trưng nhất chính là sự nhộn nhịp, đa ngôn ngữ của tiểu thương cùng các món ăn đặc sản truyền thống thơm ngon đầy quyến rũ.	Lê Lợi	Bến Thành	https://maps.app.goo.gl/o119yiHdn981uWGB8		\N	0	0	04:00:00	19:00:00	Hằng ngày	0.0	0	1	t	ACTIVE	2	2026-07-28 20:11:40.699702	2026-07-28 20:11:40.699702
1	Dinh độc lập	Dinh Độc Lập là một tòa dinh thự tại Thành phố Hồ Chí Minh, từng là nơi ở và làm việc của Tổng thống Việt Nam Cộng hòa trước Sự kiện 30 tháng 4 năm 1975. Hiện nay, Dinh Độc Lập đã được Chính phủ Việt Nam xếp hạng là di tích quốc gia đặc biệt. Cơ quan quản lý di tích văn hóa Dinh Độc Lập có tên là Hội trường Thống Nhất thuộc Văn phòng Chính phủ.	135 đường Nam Kỳ Khởi Nghĩa	Bến Thành	https://maps.app.goo.gl/NFzNZkifzu7fRziCA	02838223652	\N	20000	80000	07:00:00	18:00:00	Thứ 2 - Chủ nhật	5.0	1	12	t	ACTIVE	2	2026-07-23 13:01:48.923118	2026-07-23 13:01:48.923118
2	Bảo tàng Chứng tích Chiến tranh	Bảo tàng Chứng tích Chiến tranh là Bảo tàng chuyên đề nghiên cứu, sưu tầm, lưu trữ, bảo quản và trưng bày những tư liệu, hình ảnh, hiện vật về những chứng tích tội ác và hậu quả của các cuộc chiến tranh mà các thế lực xâm lược đã gây ra đối với Việt Nam	28 Võ Văn Tần	Xuân Hòa	https://maps.app.goo.gl/JRZCasxQqKFpsmT88	02839306664	https://baotangchungtichchientranh.vn/	20000	40000	07:30:00	17:30:00	Hằng ngày	0.0	0	2	f	ACTIVE	2	2026-07-28 18:23:27.739922	2026-07-28 18:23:27.739922
4	Chùa Ngọc Hoàng	Chùa Ngọc Hoàng mang đậm nét kiến trúc đền chùa người Hoa xưa với mái ngói âm dương, các pho tượng điêu khắc bằng gỗ tinh xảo và không gian trầm mặc hương khói. Người dân và du khách thường đến đây để chiêm bái, cầu bình an, đặc biệt là cầu con cái và tình duyên tại điện Thánh Mẫu vô cùng linh thiêng. Địa điểm này phù hợp cho những ai muốn tìm hiểu văn hóa tâm linh, người lớn tuổi hoặc du khách muốn tìm một khoảng lặng giữa lòng Sài Gòn. Điểm đặc trưng là hồ rùa lớn ngay sân trước và từng là nơi được Cựu Tổng thống Mỹ Barack Obama ghé thăm năm 2016.	73 Mai Thị Lựu	Tân Định	https://maps.app.goo.gl/mq9kuDWSgkMpGhai8		\N	0	0	07:00:00	18:00:00	Hằng ngày	0.0	0	0	f	ACTIVE	2	2026-07-28 19:53:17.561912	2026-07-28 19:53:17.561912
3	Bảo tàng Mỹ thuật Thành phố Hồ Chí Minh	Tọa lạc trong một dinh thự cổ mang phong cách kiến trúc Art Deco kết hợp Á Đông tuyệt đẹp với tông màu vàng uốn lượn đầy hoài cổ. Du khách đến đây không chỉ để thưởng lãm các bộ sưu tập hội họa, điêu khắc từ cổ đại đến đương đại mà còn để chụp những bộ ảnh nghệ thuật độc đáo. Nơi này cực kỳ lý tưởng cho người yêu nghệ thuật, giới trẻ đam mê nhiếp ảnh và những tâm hồn lãng mạn. Điểm đặc trưng thu hút nhất là chiếc thang máy cổ đầu tiên của Sài Gòn và hành lang tràn ngập ánh sáng tự nhiên tuyệt đẹp.	97 Phó Đức Chính	Bến Thành	https://maps.app.goo.gl/YZutaFuFtcLiPzUw7	02838216331	http://baotangmythuattphcm.com.vn/	15000	30000	08:00:00	17:00:00	Hằng ngày	0.0	0	1	f	ACTIVE	2	2026-07-28 18:45:42.937433	2026-07-28 18:45:42.937433
8	Phố ẩm thực Vĩnh Khánh	Phố ẩm thực Vĩnh Khánh là thiên đường ăn uống về đêm sôi động bậc nhất Sài Gòn, đặc trưng bởi phong cách quán xá bình dân, náo nhiệt trải dài suốt dọc tuyến đường. Đến đây, bạn nên rủ hội bạn bè ngồi quanh những chiếc bàn vỉa hè, thưởng thức vô số các món ốc hương rang muối, nghêu hấp sả, hải sản tươi sống và lẩu nướng thơm lừng. Khu phố này là địa điểm ăn đêm tuyệt hảo dành cho giới trẻ, những người yêu thích trải nghiệm đời sống nightlife đường phố chân thật của người Sài Gòn.	40 Vĩnh Khánh	Khánh Hội	https://maps.app.goo.gl/fG66rEJwkGy87beD8		\N	0	1000000	06:00:00	21:00:00	Hằng ngày	0.0	0	0	f	ACTIVE	2	2026-07-28 20:48:34.079018	2026-07-28 20:48:34.079018
10	Công viên Tao Đàn	Công viên Tao Đàn là một trong những mảng xanh lớn và lâu đời nhất tại Quận 1, Thành phố Hồ Chí Minh. Nơi đây rộng khoảng 10 ha, được bao phủ bởi hàng nghìn cây xanh cổ thụ phục vụ nhu cầu vui chơi, tập thể dục và thư giãn của người dân.	Trương Định	Bến Thành	https://maps.app.goo.gl/r7X1ph9ZXtuUnc679		https://congvientaodan.com/	0	0	07:00:00	22:00:00	Hằng ngày	0.0	0	0	f	ACTIVE	2	2026-07-28 21:15:13.025525	2026-07-28 21:15:13.025525
11	Công viên nước Đầm Sen	Đầm Sen là một trong những khu du lịch lớn đặc sắc nhất nước Việt Nam. Kiến trúc được kết hợp một cách hoàn mĩ nền văn hóa Đông-Tây và một chút vẻ đẹp thời La Mã. Ngoài những khu vui chơi, Đầm Sen còn có những nhà hàng, khách sạn và hàng chục các loại hình khác để phục vụ khách du lịch. Đầm Sen là nơi vui chơi giải trí rất hấp dẫn cho người trong và ngoại nước.	3 Hòa Bình	Bình Thới	https://maps.app.goo.gl/M55J5Tr9bTwY9rmg6	02838588418	https://damsenwaterpark.com.vn/	180000	220000	09:00:00	18:00:00	Hằng ngày	0.0	0	0	f	ACTIVE	2	2026-07-28 21:33:44.332069	2026-07-28 21:33:44.332069
18	Chợ Bình Tây	Chợ Bình Tây nổi bật với kiến trúc Á Đông lợp ngói âm dương và tháp đồng hồ trung tâm, mang đậm dấu ấn giao thoa văn hóa Việt - Hoa truyền thống. Đến đây, du khách có thể khám phá nhịp sống giao thương sầm uất của hàng ngàn sạp bán buôn đa dạng, thưởng thức ẩm thực đặc trưng khu Chợ Lớn và tìm mua vô số các mặt hàng phong phú. Đây là điểm đến không thể bỏ qua cho những ai yêu thích văn hóa giao thương, và cũng là nguồn tư liệu thực tế sống động cực kỳ hữu ích cho những ai đang rèn luyện nghiệp vụ thuyết minh tuyến điểm du lịch. Điểm đặc trưng nhất là khoảng sân trong (giếng trời) mát mẻ với bệ thờ ông Quách Đàm - người có công xây dựng chợ, tạo nên nét tín ngưỡng thương mại độc đáo hiếm có.	57A Tháp Mười	Bình Tây	https://maps.app.goo.gl/27XScrCKivjDBVnR8		\N	0	0	07:00:00	18:00:00	Hằng ngày	0.0	0	0	f	ACTIVE	2	2026-07-28 22:50:05.505515	2026-07-28 22:50:05.505515
9	Phở Hòa Pasteur	Phở Hòa Pasteur mang không gian quán ăn truyền thống quen thuộc, giữ vững hương vị phở đặc trưng của Sài Gòn trong suốt hơn nửa thế kỷ qua. Quán phục vụ đa dạng đối tượng, từ người dân địa phương sành ăn, giới văn phòng cho đến du khách quốc tế muốn trải nghiệm ẩm thực chuẩn vị Việt.	260C Pasteur	Xuân Hòa	https://maps.app.goo.gl/kN2BiEcGPXXBLLXM8	02838297943	\N	95000	200000	05:30:00	22:30:00	Hằng ngày	0.0	0	2	f	ACTIVE	2	2026-07-28 21:00:39.042973	2026-07-28 21:00:39.042973
13	Đường sách TP.HCM	Đường sách Nguyễn Văn Bình mang không gian xanh mát, yên bình với những vòm cây cổ thụ rợp bóng, tạo nên một ốc đảo văn hóa đọc tĩnh tại ngay giữa lòng trung tâm thành phố. Đến đây, du khách có thể thong thả dạo bước qua các gian hàng sách được thiết kế mộc mạc bằng gỗ, tìm mua những ấn phẩm giá trị, nhâm nhi cà phê và tham gia các buổi giao lưu văn hóa nghệ thuật. Địa điểm này là không gian lý tưởng cho những người yêu sách, các gia đình nhỏ dạo chơi dịp cuối tuần, và đặc biệt là một kho tàng tư liệu phong phú với nhiều đầu sách chuyên khảo địa lý, sách hướng dẫn tuyến điểm vô cùng hữu ích cho những ai đang rèn luyện nghiệp vụ hướng dẫn viên du lịch. Điểm đặc trưng nhất chính là sự kết nối không gian hoàn hảo giữa phố đi bộ, văn hóa đọc và các công trình kiến trúc di sản liền kề như Bưu điện Trung tâm hay Nhà thờ Đức Bà.	2 Nguyễn Văn Bình	Sài Gòn	https://maps.app.goo.gl/iqegpFBQ2kDPihTk6		https://duongsachtphcm.com/	0	0	08:00:00	21:00:00	Hằng ngày	0.0	0	0	t	ACTIVE	2	2026-07-28 21:53:54.863179	2026-07-28 21:53:54.863179
16	Bưu điện trung tâm Sài Gòn	Bưu điện Trung tâm Sài Gòn, còn gọi là Tòa nhà Bưu điện Thành phố Hồ Chí Minh là một trong những công trình kiến trúc tiêu biểu tại Thành phố Hồ Chí Minh, tọa lạc tại số 2 Công trường Công xã Paris, phường Sài Gòn. Đây là tòa nhà được người Pháp xây dựng trong khoảng năm 1886–1891 với phong cách chiết trung theo đồ án thiết kế của kiến trúc sư Marie-Alfred Foulhoux. Đây là công trình kiến trúc mang phong cách phương Tây kết hợp với nét trang trí phương Đông.	02 Công trường Công xã Paris	Bến Nghé	https://maps.app.goo.gl/PCchoHwMDJAkPw4i6		\N	0	0	07:00:00	19:00:00	Hằng ngày	0.0	0	0	t	ACTIVE	2	2026-07-28 22:34:41.865893	2026-07-28 22:34:41.865893
12	Đầm Sen Khô	Đầm Sen là một trong những khu du lịch lớn đặc sắc nhất nước Việt Nam. Kiến trúc được kết hợp một cách hoàn mĩ nền văn hóa Đông-Tây và một chút vẻ đẹp thời La Mã. Ngoài những khu vui chơi, Đầm Sen còn có những nhà hàng, khách sạn và hàng chục các loại hình khác để phục vụ khách du lịch. Đầm Sen là nơi vui chơi giải trí rất hấp dẫn cho người trong và ngoại nước.	3 Hòa Bình	Bình Thới	https://maps.app.goo.gl/M55J5Tr9bTwY9rmg6	02839634963	\N	100000	300000	07:30:00	18:00:00	Hằng ngày	0.0	0	1	f	ACTIVE	2	2026-07-28 21:40:56.405117	2026-07-28 21:40:56.405117
21	Bảo tàng Thành phố Hồ Chí Minh	Bảo tàng Thành phố Hồ Chí Minh là một công trình kiến trúc mang đậm phong cách Baroque kết hợp Á Đông tuyệt mỹ, nổi bật với hệ cầu thang vòm uốn lượn ngập tràn ánh sáng tự nhiên. Du khách đến đây có thể thong thả chiêm ngưỡng các bộ sưu tập hiện vật về lịch sử, văn hóa, thương mại của Sài Gòn xưa và khám phá hệ thống hầm ngầm bí mật dưới lòng tòa nhà. Địa điểm này vô cùng lý tưởng cho giới trẻ đam mê nhiếp ảnh, du khách quốc tế và các sinh viên, những người làm trong ngành du lịch muốn trau dồi kiến thức về lịch sử đô thị. Điểm đặc trưng nhất là sự giao thoa giữa không gian trưng bày di sản và một phim trường mang đậm chất điện ảnh hoài cổ, thu hút vô số người đến chụp ảnh nghệ thuật mỗi ngày.	65 Lý Tự Trọng	Sài Gòn	https://maps.app.goo.gl/wRU42mpPCDukkfAW8	 02838299741	https://hcmc-museum.edu.vn/	15000	30000	08:00:00	17:00:00	Hằng ngày	0.0	0	0	t	ACTIVE	2	2026-07-30 15:36:21.570682	2026-07-30 15:36:21.570682
19	Bến Nhà Rồng	Bến Nhà Rồng là di tích lịch sử quan trọng bậc nhất, gắn liền với sự kiện Bác Hồ ra đi tìm đường cứu nước năm 1911. Công trình mang đậm dấu ấn kiến trúc giao thoa Pháp - Việt, nổi bật với biểu tượng 'lưỡng long chầu nguyệt' tinh xảo trên mái ngói. Đến đây, du khách nên tham quan các phòng trưng bày chuyên đề về lịch sử, sau đó tản bộ ở khuôn viên lộng gió hướng thẳng ra bờ sông Sài Gòn. Địa điểm này là lựa chọn tuyệt vời cho người lớn tuổi, sinh viên và những người muốn tìm hiểu sâu về lịch sử dân tộc. Điểm đặc trưng nhất chính là tòa nhà thương cảng nguyên bản được bảo tồn hoàn hảo với tầm nhìn bao quát cảnh quan sông nước hữu tình.	1 Nguyễn Tất Thành	Xóm Chiếu	https://maps.app.goo.gl/65WgiAosBKPtPEDf6	02838255740	https://bennharong.hochiminh.vn/	0	20000	07:30:00	17:30:00	Thứ 3 - Chủ Nhật	0.0	0	0	t	ACTIVE	2	2026-07-29 18:00:58.371151	2026-07-29 18:00:58.371151
20	Khu di tích lịch sử Địa đạo Củ Chi	Địa đạo Củ Chi là hệ thống phòng thủ ngầm kỳ vĩ dưới lòng đất, minh chứng sống động cho ý chí kiên cường và nghệ thuật chiến tranh du kích độc đáo. Đến đây sẽ được trải nghiệm cảm giác chui hầm thực tế, thử tài tại trường bắn súng thể thao quốc phòng và thưởng thức món khoai mì luộc dân dã. Địa điểm này đặc biệt phù hợp cho du khách thích vận động, giới trẻ và những ai đam mê khám phá lịch sử thực chứng. Điểm đặc trưng nhất chính là mạng lưới hầm chằng chịt như mạng nhện dài hơn 200km, được thiết kế tinh vi với đầy đủ bếp Hoàng Cầm, trạm xá và không gian sinh hoạt ngầm.	Ấp Phú Hiệp, Xã An Nhơn Tây	An Nhơn Tây	https://maps.app.goo.gl/xmPZSodyPdx8DF4J9	02838255740	http://diadaocuchi.com.vn/	35000	100000	07:00:00	17:00:00	Hằng ngày	0.0	0	2	f	ACTIVE	2	2026-07-29 19:40:15.192542	2026-07-29 19:40:15.192542
23	Bitexco	Tháp tài chính Bitexco mang tính biểu tượng cao với thiết kế lấy cảm hứng từ búp sen truyền thống và bãi đáp trực thăng nhô ra độc đáo giữa lưng chừng trời. Du khách thường đến đây để trải nghiệm đài quan sát Saigon Skydeck ở tầng 49, thu trọn vào tầm mắt toàn cảnh 360 độ của trung tâm thành phố và dòng sông Sài Gòn uốn lượn. Đây là điểm đến hấp dẫn đối với du khách quốc tế, giới trẻ đam mê nhiếp ảnh và là một tư liệu kiến trúc quan trọng cho những ai đang nghiên cứu, thực hành nghiệp vụ thuyết minh tuyến điểm du lịch. Điểm đặc trưng nhất chính là sự giao thoa giữa nét đẹp văn hóa Việt qua hình dáng búp sen và nhịp sống thương mại hiện đại bậc nhất của khu lõi trung tâm Quận 1.	2 Hải Triều	Sài Gòn	https://maps.app.goo.gl/srHodMLnv2MCFfim7			0	0	09:30:00	21:30:00	Hằng ngày	5.0	1	50	t	ACTIVE	2	2026-07-30 16:05:36.349494	2026-07-30 16:05:36.349494
7	Thảo Cầm Viên	Thảo Cầm Viên là một trong những vườn thú lâu đời nhất thế giới, sở hữu không gian xanh mát rợp bóng cây cổ thụ hệt như một khu rừng nguyên sinh thu nhỏ giữa lòng thành phố. Đến đây, bạn có thể tham quan hàng nghìn loài động thực vật quý hiếm, cho các loài động vật thân thiện ăn hoặc thư giãn với các trò chơi giải trí ngoài trời. Địa điểm này là lựa chọn tuyệt vời cho các gia đình có con nhỏ, các cặp đôi muốn hẹn hò bình yên hay người yêu thiên nhiên muốn tìm chốn xa rời khói bụi. Điểm đặc trưng nhất là những cây cổ thụ hàng trăm năm tuổi và Đền Vua Hùng cổ kính nằm sát bên trong khuôn viên.	2 Nguyễn Bỉnh Khiêm	Sài Gòn	https://maps.app.goo.gl/zbVbtRRdvs7syVcF8	02838291425	https://saigonzoo.vn/	40000	60000	07:00:00	18:30:00	Hằng ngày	0.0	0	1	t	ACTIVE	2	2026-07-28 20:38:07.732656	2026-07-28 20:38:07.732656
15	Nhà thờ Đức Bà Sài Gòn	Nhà thờ Đức Bà mang đậm phong cách kiến trúc Roman pha trộn Gothic tuyệt đẹp, nổi bật với mặt ngoài xây bằng gạch trần đỏ au mang từ Pháp sang và hai tháp chuông vươn cao uy nghi. Khách tham quan thường đến đây để chiêm ngưỡng vẻ đẹp cổ kính, tham dự các thánh lễ trang nghiêm hoặc chụp ảnh lưu niệm cùng đàn bồ câu thân thiện trước quảng trường. Địa điểm này là một điểm đến không thể bỏ qua đối với tín đồ Công giáo, du khách yêu nét đẹp hoài cổ và cũng là một trạm thực hành thực tế cực kỳ giá trị để trau dồi kiến thức chuyên môn cho những ai đang rèn luyện nghiệp vụ hướng dẫn viên du lịch. Điểm nhấn đặc trưng nhất là bức tượng Đức Mẹ Hòa Bình bằng đá cẩm thạch trắng và không gian nội thất thánh đường thiêng liêng, tĩnh lặng giữa lòng đô thị nhộn nhịp.	01 Công trường Công xã Paris	Bến Nghé	https://maps.app.goo.gl/sSBFfggWDffgJnk59		\N	0	0	00:00:00	23:59:59	Hằng ngày	0.0	0	5	t	ACTIVE	2	2026-07-28 22:17:26.25651	2026-07-28 22:17:26.25651
14	Bảo tàng lịch sử Việt Nam	Bảo tàng lịch sử Việt Nam được xây dựng và hoạt động từ những năm đầu thế kỷ 20, là nơi lưu giữ và bảo tồn những hình ảnh, cổ vật từ thuở sơ khai đến nay. Bảo tàng lịch sử Việt Nam thu hút phần lớn những du khách yêu lịch sử và kiến trúc pha trộn giữa 2 phong cách Á – Âu độc đáo. Ngoài là nơi lưu giữ nét văn hoa truyền thống của đất nước, bảo tàng lịch sử Việt Nam còn là một trong những điểm du lịch thành phố Hồ Chí Minh ấn tượng với những góc check in đẹp. Đây luôn là điểm đến thú vị trong những lịch trình của tour du lịch Hồ Chí Minh được yêu thích nhất.	2 Nguyễn Bỉnh Khiêm	Sài Gòn	https://maps.app.goo.gl/QFK7uhMHXxHc73PQ8	02838258783	https://www.baotanglichsutphcm.com.vn/	15000	30000	08:00:00	17:00:00	Thứ 3 - Chủ Nhật	0.0	0	1	t	ACTIVE	2	2026-07-28 22:06:53.899358	2026-07-28 22:06:53.899358
24	Phố đi bộ Bùi Viện	Phố đi bộ Bùi Viện là khu 'phố Tây' sầm uất bậc nhất Sài Gòn, nổi bật với không gian nightlife rực rỡ ánh đèn neon và âm nhạc sôi động vang lên từ các quán bar, pub san sát nhau. Đến đây, bạn có thể ngồi uống bia thủ công ven đường, thưởng thức các món ăn đường phố đa dạng và hòa mình vào không khí tiệc tùng náo nhiệt cùng du khách quốc tế. Nơi này là thiên đường giải trí về đêm cho giới trẻ, và cũng là một môi trường thực hành giao tiếp tiếng Anh hoàn hảo cho những ai đang theo học nghiệp vụ hướng dẫn viên du lịch. Điểm đặc trưng nhất chính là sự đa văn hóa, phóng khoáng và nhịp sống không ngủ, biến con phố này thành điểm giao lưu không khoảng cách giữa người bản địa và du khách năm châu.	Đường Bùi Viện	Phạm Ngũ Lão	https://maps.app.goo.gl/BRBYshtBGJyvDFD96	\N	\N	0	500000	18:00:00	02:00:00	Hằng ngày	0.0	0	6	t	ACTIVE	2	2026-08-05 17:35:32.382014	2026-08-05 17:35:32.382014
25	Công viên bờ sông Sài Gòn	Công viên bờ sông Sài Gòn là không gian công cộng xanh mát, hiện đại với tầm nhìn toàn cảnh bờ Tây sông Sài Gòn và những tòa nhà biểu tượng của Quận 1. Đến đây, du khách có thể thong thả dạo bộ, thả diều, ngắm nhìn những chuyến tàu thủy nhộn nhịp qua lại hoặc check-in tại cánh đồng hoa hướng dương rực rỡ. Địa điểm này vô cùng phù hợp cho các gia đình dã ngoại cuối tuần, giới trẻ thích nhiếp ảnh và cũng là một trạm dừng chân hoàn hảo lồng ghép vào các tuyến tour thực tế để giới thiệu về quy hoạch đô thị mới của thành phố. Điểm đặc trưng nhất chính là bầu không khí lộng gió, thoáng đãng cùng khung cảnh hoàng hôn nhuộm vàng mặt nước sông Sài Gòn tuyệt đẹp bậc nhất hiện nay.	15 Đường N2	An Khánh	https://maps.app.goo.gl/LWUrdedkLm4ZE8vU8		\N	0	0	00:00:00	23:59:00	Hằng ngày	0.0	0	0	t	ACTIVE	2	2026-09-03 16:53:17.345498	2026-09-03 16:53:17.345498
26	Bamos - Tân Hưng	Bamos Coffee & Tea nổi bật với không gian mở thoáng đãng, ngập tràn ánh sáng và cây xanh. Điểm đặc trưng lớn nhất làm nên thương hiệu của quán chính là thời gian hoạt động xuyên suốt 24/7 kết hợp cùng các đêm nhạc Acoustic sôi động từ 19h00 - 21h00 tổ chức vào thứ 7 và chủ nhật. Khách hàng đến đây có thể thoải mái tìm một góc yên tĩnh để chạy 'deadline' ban ngày, hoặc tụ tập trò chuyện xuyên đêm cùng bạn bè. Địa điểm này là thiên đường dành cho sinh viên, giới trẻ đam mê cuộc sống nightlife và những ai thích check-in tại các quán cà phê có gu. Đây thực sự là một trạm dừng chân lý tưởng để trải nghiệm nhịp sống không ngủ tràn đầy năng lượng của giới trẻ Sài Gòn.	130 Đường số 65, Khu định cư Tân Quy Đông	Tân Hưng	https://maps.app.goo.gl/M1oGQ1um1Yv5RSzJ9	0707014095	https://bamoscoffee.com/	35000	70000	00:00:00	23:59:00	Hằng ngày	0.0	0	0	f	ACTIVE	2	2026-09-03 20:32:26.960574	2026-09-03 20:32:26.960574
27	Khu du lịch Văn Thánh	Khu du lịch Văn Thánh mang đậm khung cảnh miệt vườn thanh bình với những bãi cỏ rộng lớn, ao sen và rặng dừa rợp bóng. Trong khuôn viên, du khách có thể tổ chức dã ngoại, câu cá, hoặc thưởng thức tiệc buffet cuối tuần nổi tiếng với các món ngon mang đậm phong cách ẩm thực khẩn hoang. Nơi này đặc biệt phù hợp cho các buổi tụ họp đại gia đình, team-building, và cũng là không gian thực tế sống động để tìm hiểu về nếp sinh hoạt văn hóa vùng đồng bằng sông Cửu Long qua hình ảnh chiếc áo bà ba hay chiếc xuồng ba lá ngay tại đô thị. Điểm đặc trưng nhất chính là sự đối lập đầy thú vị: một làng quê mộc mạc, tĩnh lặng nằm lọt thỏm giữa những tòa nhà chọc trời và nhịp sống hối hả của trung tâm thành phố.	48/10 Điện Biên Phủ	Thạnh Mỹ Tây	https://maps.app.goo.gl/xRWYNjQPhfAMimrY7	0901889705	https://www.facebook.com/dulichvanthanh/	100000	500000	07:00:00	21:00:00	Hằng ngày	0.0	0	0	f	ACTIVE	2	2026-09-04 23:22:35.642603	2026-09-04 23:22:35.642603
17	Nhà hát Thành phố Hồ Chí Minh	Nhà hát Thành phố mang đậm phong cách kiến trúc Flamboyant thời Đệ tam Cộng hòa Pháp, nổi bật với mặt tiền được trang trí bằng các bức phù điêu và tượng điêu khắc nghệ thuật tinh xảo. Du khách đến đây có thể thưởng thức các chương trình biểu diễn nghệ thuật hàn lâm, vũ kịch đương đại hoặc đơn giản là tản bộ, chụp ảnh tại khu vực quảng trường rộng lớn phía trước. Địa điểm này là không gian thưởng thức văn hóa sang trọng dành cho giới mộ điệu, đồng thời là một công trình di sản thực tiễn cực kỳ giá trị để trau dồi kiến thức lịch sử, kiến trúc cho những người đang rèn luyện nghiệp vụ hướng dẫn viên du lịch. Điểm đặc trưng nhất là sự lộng lẫy của không gian nội thất với hệ thống vòm mái, đèn chùm pha lê và ghế bọc nhung đỏ, tạo nên một thánh đường nghệ thuật đẳng cấp giữa lòng trung tâm sầm uất.	07 Công trường Lam Sơn	Sài Gòn	https://maps.app.goo.gl/HwetKsTW349qvpSeA		https://ticket-stations.com/a-o-show	0	0	09:00:00	16:30:00	Hằng ngày	0.0	0	0	t	ACTIVE	2	2026-07-28 22:42:14.901994	2026-07-28 22:42:14.901994
28	Nhâm Coffee	Nhâm Coffee mang đến một không gian mộc mạc, hoài cổ với thiết kế chủ đạo từ gỗ thô, những tán cây xanh rợp bóng như một 'Đà Lạt thu nhỏ' giữa lòng Sài Gòn. Bạn trẻ và du khách thường đến đây để uống một cốc cà phê, tìm một góc yên tĩnh để chạy 'deadline', đọc sách hoặc thả hồn vào những đêm nhạc Acoustic mộc mạc. Địa điểm này là chốn 'ẩn náu' lý tưởng cho sinh viên, giới văn phòng và những người yêu thích sự tĩnh lặng, hoài niệm. Điểm đặc trưng lớn nhất là vị trí nằm sâu trong con hẻm nhỏ yên bình, tách biệt hoàn toàn với dòng xe cộ hối hả trên đường Điện Biên Phủ, tạo nên một khoảng không thư giãn hiếm hoi.	195/10/2 Điện Biên Phủ	Gia Định	https://maps.app.goo.gl/d3W3hWNoTShAyGee9		\N	50000	70000	00:00:00	23:59:00	Hằng ngày	0.0	0	0	t	ACTIVE	2	2026-09-04 23:30:11.106194	2026-09-04 23:30:11.106194
22	Landmark 81	Landmark 81 là tòa nhà cao nhất Việt Nam và biểu tượng đầy kiêu hãnh của sự phát triển hiện đại tại TP.HCM, mang thiết kế lấy cảm hứng từ bó tre truyền thống vươn lên mạnh mẽ. Đến đây, du khách có thể thỏa sức mua sắm tại trung tâm thương mại sầm uất khối đế, trượt băng nghệ thuật, hoặc mua vé lên đài quan sát SkyView trên đỉnh tòa nhà để ngắm toàn cảnh thành phố ngoạn mục từ trên mây. Địa điểm này là không gian giải trí vô cùng lý tưởng cho giới trẻ, các gia đình và du khách yêu thích nhịp sống đô thị sang trọng, năng động. Điểm đặc trưng nhất chính là quy mô hoành tráng cùng hệ thống dịch vụ 'tất cả trong một', kết hợp công viên ven sông tuyệt đẹp ngay liền kề, biến nơi đây thành tâm điểm check-in rực rỡ nhất bất kể ngày đêm.	720A Điện Biên Phủ	Thạnh Mỹ Tây	https://maps.app.goo.gl/y66Z6PoRjXVewnUPA	 0987110011		0	0	10:00:00	21:30:00	Hằng ngày	0.0	0	29	t	ACTIVE	2	2026-07-30 15:51:39.931556	2026-07-30 15:51:39.931556
\.


--
-- Data for Name: placeagegroup; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.placeagegroup (id, place_id, age_group, suitability) FROM stdin;
1	1	ADULT	5
2	2	ADULT	5
3	2	TEENAGER	4
4	2	YOUNG_ADULT	4
5	2	SENIOR	5
6	3	ADULT	5
7	3	TEENAGER	4
8	3	YOUNG_ADULT	4
9	3	SENIOR	5
10	4	ADULT	5
11	4	YOUNG_ADULT	4
12	4	SENIOR	5
13	4	MIDDLE_AGE	5
14	5	ADULT	5
15	5	YOUNG_ADULT	5
16	5	TEENAGER	4
17	5	MIDDLE_AGE	4
18	5	SENIOR	4
19	6	ADULT	5
20	6	YOUNG_ADULT	5
21	6	TEENAGER	5
25	7	YOUNG_ADULT	4
26	7	TEENAGER	5
27	7	CHILDREN	5
28	8	YOUNG_ADULT	5
29	8	TEENAGER	4
30	8	ADULT	5
34	10	CHILDREN	5
35	10	MIDDLE_AGE	5
36	10	ADULT	4
37	10	SENIOR	5
38	11	CHILDREN	5
39	11	TEENAGER	5
40	11	YOUNG_ADULT	4
42	12	TEENAGER	5
43	12	YOUNG_ADULT	5
44	12	ADULT	4
45	13	CHILDREN	4
46	13	TEENAGER	5
47	13	YOUNG_ADULT	5
48	13	ADULT	5
49	13	MIDDLE_AGE	5
51	14	ADULT	5
52	14	MIDDLE_AGE	5
53	14	SENIOR	5
58	16	YOUNG_ADULT	4
59	16	ADULT	5
60	16	MIDDLE_AGE	5
61	16	SENIOR	4
62	17	YOUNG_ADULT	4
63	17	ADULT	5
64	17	MIDDLE_AGE	5
65	17	SENIOR	4
69	19	TEENAGER	4
70	19	YOUNG_ADULT	4
71	19	ADULT	5
72	19	MIDDLE_AGE	5
73	19	SENIOR	5
78	21	TEENAGER	4
79	21	YOUNG_ADULT	5
80	21	ADULT	5
81	21	MIDDLE_AGE	4
204	24	CHILDREN	1
205	24	TEENAGER	1
206	24	YOUNG_ADULT	5
207	24	ADULT	4
208	24	MIDDLE_AGE	3
209	24	SENIOR	2
210	20	CHILDREN	3
211	20	TEENAGER	5
212	20	YOUNG_ADULT	5
213	20	ADULT	4
214	20	MIDDLE_AGE	4
215	20	SENIOR	3
41	12	CHILDREN	4
217	12	MIDDLE_AGE	3
120	22	CHILDREN	3
121	22	TEENAGER	4
122	22	YOUNG_ADULT	5
123	22	ADULT	5
124	22	MIDDLE_AGE	4
125	22	SENIOR	3
216	12	SENIOR	1
220	14	TEENAGER	4
218	14	YOUNG_ADULT	5
219	14	CHILDREN	4
132	23	CHILDREN	3
133	23	TEENAGER	4
134	23	YOUNG_ADULT	5
135	23	ADULT	4
136	23	MIDDLE_AGE	4
137	23	SENIOR	3
50	13	SENIOR	5
31	9	YOUNG_ADULT	4
32	9	ADULT	4
33	9	SENIOR	4
221	9	CHILDREN	4
222	9	MIDDLE_AGE	4
144	15	CHILDREN	3
145	15	TEENAGER	3
146	15	YOUNG_ADULT	4
147	15	ADULT	5
148	15	MIDDLE_AGE	5
149	15	SENIOR	4
150	18	CHILDREN	3
151	18	TEENAGER	3
152	18	YOUNG_ADULT	3
153	18	ADULT	5
154	18	MIDDLE_AGE	5
155	18	SENIOR	4
223	9	TEENAGER	4
22	6	MIDDLE_AGE	5
23	6	CHILDREN	5
24	6	SENIOR	5
224	25	CHILDREN	5
225	25	TEENAGER	5
226	25	YOUNG_ADULT	5
227	25	ADULT	4
228	25	MIDDLE_AGE	4
229	25	SENIOR	4
230	26	CHILDREN	3
231	26	TEENAGER	4
232	26	YOUNG_ADULT	5
233	26	ADULT	4
234	26	MIDDLE_AGE	4
235	26	SENIOR	3
236	27	CHILDREN	5
237	27	TEENAGER	3
238	27	YOUNG_ADULT	4
239	27	ADULT	5
240	27	MIDDLE_AGE	5
241	27	SENIOR	5
242	28	CHILDREN	2
243	28	TEENAGER	3
244	28	YOUNG_ADULT	5
245	28	ADULT	4
246	28	MIDDLE_AGE	2
247	28	SENIOR	2
\.


--
-- Data for Name: placecategory; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.placecategory (place_id, category_id) FROM stdin;
1	2
2	1
3	1
4	4
5	10
6	9
6	3
7	8
7	3
8	13
9	14
9	15
10	3
11	8
12	8
13	9
14	1
16	17
17	17
19	1
19	2
21	1
22	18
22	7
23	18
23	7
15	16
18	10
24	9
24	19
24	20
20	2
25	18
25	3
26	5
27	3
27	6
28	18
28	5
\.


--
-- Data for Name: placeembedding; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.placeembedding (id, place_id, chunk_index, chunk_text, embedding, metadata, created_at) FROM stdin;
2	2	0	Tên địa điểm: Bảo tàng Chứng tích Chiến tranh\nMô tả: Bảo tàng Chứng tích Chiến tranh là Bảo tàng chuyên đề nghiên cứu, sưu tầm, lưu trữ, bảo quản và trưng bày những tư liệu, hình ảnh, hiện vật về những chứng tích tội ác và hậu quả của các cuộc chiến tranh mà các thế lực xâm lược đã gây ra đối với Việt Nam\nKhu vực: Xuân Hòa, Quận 3, TP.HCM\nDanh mục: Bảo tàng\nHợp với sở thích: Lịch sử, Văn hóa, Chụp ảnh\nĐộ phù hợp nhóm tuổi: ADULT (5/5), TEENAGER (4/5), YOUNG_ADULT (4/5), SENIOR (5/5)\nKhoảng giá: 20,000 - 40,000 VND	[0.049422145,-0.01623978,-0.028600428,0.023505537,0.019747123,0.021941984,-0.030180115,0.043115597,-0.034608535,-0.024073105,-0.0643686,-0.031568725,0.03535726,0.007472773,0.031072231,-0.007617863,-0.0069742864,0.05272552,-0.049204465,-0.037066814,-0.00057323923,0.06794566,0.06779915,0.0061558043,-0.013033625,-0.0364352,0.05126612,0.0055810963,-0.013838049,-0.06475405,0.009669065,-0.020840451,-0.014225758,-0.01906078,0.043704838,-0.0633425,0.006584134,0.029748805,0.026527524,0.020868588,0.032934897,-0.009247995,0.018767323,-0.03057353,-0.03781439,0.032303207,0.065328136,-0.03997967,-0.02031257,-0.031898938,0.0028893272,-0.042877957,0.026172517,-0.052421376,-0.016477495,-0.012698551,-0.05562158,0.1031611,-0.021310117,0.02412194,-0.020292753,-0.026651017,0.05024138,-0.01993561,0.027052969,-0.03579313,-0.02093091,-0.01003512,-0.042264655,0.026680514,-0.006904855,0.03534444,-0.03455066,-0.01809027,-0.013677191,0.0122180795,0.004851826,0.04783812,0.013762571,0.019636326,0.034518648,0.034551274,-0.007002785,-0.032548208,-0.0013530268,0.03766835,-0.014812814,0.0026714676,0.0037417868,0.015398384,-0.057341076,-0.018665824,0.0071413713,0.042523384,0.0100832945,-0.024906445,-0.0054165157,-0.03769618,-0.06333014,-0.06038619,-0.009314486,0.0535383,0.0354735,-0.020634472,-0.015945727,-0.02432561,0.026614634,0.03268302,0.014709308,0.028556991,0.009338634,0.0018834062,0.10043348,-0.0029388035,-0.01667263,0.008416385,0.0587366,-0.029488837,-0.016963638,0.043851625,-0.03288095,-0.023048386,0.021480981,-0.03715199,0.040739603,0.04812277,-0.0025720429,0.0034301784,-0.023140825,-0.024301108,0.0014979055,0.011579203,0.015204945,0.022779215,-0.010023209,-0.025781007,-0.02438034,-0.058775343,-0.010648693,-0.045862358,0.004729867,0.02637475,-0.008425301,-0.028746607,-0.00680265,0.041592933,0.00422689,0.08703524,-0.020002382,0.008244193,0.050450236,-0.056962833,-0.03670521,-0.00916028,0.024615552,0.03603719,-0.08424525,-0.007896032,-0.03362589,-0.012948866,0.0349457,-0.011433131,-0.018083526,0.0362947,0.06454112,0.005052633,-0.031448986,0.035947762,0.01172323,-0.07170478,0.017414147,0.016303947,0.0058043743,-0.0022092313,0.10804922,0.060179748,-0.010518559,0.071161225,0.055374354,-0.01002152,-0.052926607,0.039719485,-0.021231154,-0.051922347,-0.0060878396,-0.045417253,0.06058113,-0.020204814,-0.01507911,-0.044251904,0.063547105,-0.014453349,0.010470633,0.028365355,0.045024667,-0.0039648465,-0.008107994,0.033533085,0.004118841,0.0077063865,0.044383187,0.029925827,0.042691723,0.002498012,-0.0236047,0.0030019644,0.0021485803,0.07192382,0.027815102,-0.037747435,0.006528123,0.007156303,0.05571567,0.003109256,-0.03360267,-0.025567291,0.023671664,0.05748459,0.06127528,-0.016122667,-0.003984001,-0.020270627,0.055514634,0.013730594,0.046542734,-0.0036894376,0.020198153,-0.016987285,-0.032753535,0.007004858,-0.043282628,0.03579323,-0.00045245362,0.014179049,-0.030391153,0.007094923,-0.015624898,0.020772113,-0.0031823586,-0.042870097,-0.023924576,-0.0073586944,-0.0061625075,0.010013204,-0.01676912,-0.0030733643,0.0017212267,-0.07280004,0.15497597,0.051730275,-0.0009664403,0.06829943,0.043299615,-0.024106238,0.008016736,0.043782227,-0.03424465,-0.024348587,0.06383259,-0.016221043,0.024855787,-0.029870719,0.043971457,-0.018744923,-0.031852115,0.014022564,0.035579607,0.02650546,0.05762025,-0.02302321,-0.035213083,0.06520831,-0.03893056,0.007929128,-0.033866096,0.03304233,0.049143966,-0.011306712,-0.009102925,0.004520347,-0.003176157,0.0002737226,-0.016087957,-0.0233371,-0.033046875,0.018086208,0.028050596,0.03923117,0.050412357,0.037619613,-0.02358518,-0.04728419,-0.00813842,0.041743457,0.06723772,-0.019417651,0.017863316,-0.029084634,-0.007872016,0.018391991,0.0063212547,0.0018595413,0.018708572,0.017697906,-0.0077381614,0.021877754,-0.023030432,-0.01062317,-0.03619445,0.072345294,0.017414955,-0.027167466,-0.017354254,0.082904145,0.069490135,0.07995261,-0.032439426,0.06673565,0.061068974,-0.03979946,-0.05508057,0.043235697,-0.014608128,-0.04427534,-0.06269972,0.05168198,0.029007645,-0.028331451,-0.022677276,-0.0089361025,0.00081823545,0.0519717,0.016785627,0.04887554,-0.0040515247,-0.0062615452,0.015346472,0.0078125,-0.0033027625,0.022375492,-0.007989385,-0.026917994,-0.050687414,-0.024305752,-0.02903716,0.030562708,0.05615394,-0.0250049,0.031928234,-0.0055720587,-0.027887015,0.02436387,-0.013294,0.02721781,0.05327771,0.07163795,-0.020393346,-0.026033305,-0.03693352,-0.017976653,0.07716006,-0.048191734,0.00922492,0.027866814,0.017811205,-0.010130387,0.00528809,-0.033325516,0.02926683,-0.006589299,0.009616862,-0.040907692,-0.0058149127,0.011932607,0.03554061,0.07294107,0.027894031,0.041700345,0.004262985,0.014998961,-0.05126473,-0.03408772,-0.048810925,0.027467243,8.243275e-05,0.025240568,-0.016318412,-0.016546378,0.033162255,0.02715869,-0.0347589,0.026309008,-0.026881395,0.028810637,-0.010432585,0.021121137,0.024105268,0.015633326,-0.0111999065,0.042221963,0.032393843,0.0076268157,-0.016520115,-0.016520102,0.015634952,-0.027631473,0.0012727532,-0.032654066,0.003796443,-0.044975836,0.014221943,0.03669329,0.0012031549,-0.04233545,0.04653997,0.046748515,-0.030944787,-0.004822241,-0.034384247,0.009860734,0.011132473,-0.05388313,-0.026136087,0.077319905,0.0037281022,0.012349882,-0.048676953,0.009074242,0.02313688,0.03280324,0.029454466,-0.005286638,-0.06374095,0.07008079,0.015212685,0.0077737058,-0.014339589,0.011110272,-0.008432326,-0.0022956699,0.013649264,-0.029943025,0.051798217,0.03074634,-0.01810256,0.033827934,0.00523497,-0.014907465,0.07049524,0.003252101,0.0031358812,-0.036277726,0.050654214,0.05814699,-0.016785879,-0.0056236144,0.028135061,0.011000037,-0.022025803,0.021405146,-0.05453277,0.10432073,-0.015313076,-0.01672957,0.04538969,0.06817225,-0.036303394,0.044191293,-0.028240867,-0.01223175,-0.019891702,-0.02509369,-0.024518529,-0.0043260315,-0.0065861796,0.035544053,-0.018409025,-0.019997925,-0.007770847,-0.019742453,-0.036396116,-0.08317248,-0.02815836,-0.027445935,0.10089078,-0.0057769483,0.007861346,-0.008054751,0.020983871,0.057488825,0.049246285,-0.015400539,0.04882221,-0.030798621,0.0070839142,-0.0047317874,-0.037215482,0.00667997,-0.048856586,-0.018227974,0.060796786,-0.026427932,0.08884722,0.035474233,0.025369411,-0.05252986,-0.0026860393,0.037416484,0.029428072,0.017185654,-0.008402952,0.0009887142,-0.01071109,0.011535539,-0.025495337,0.02274346,0.037820887,0.067599386,-0.005854585,-0.015026828,-0.072417416,0.053215355,0.015652895,0.020267226,0.017952142,0.024060875,-0.0036439372,0.03258357,0.0073465896,-0.03574411,-0.029911304,-0.028101573,0.0003314212,0.056643005,0.06923517,-0.0112626925,0.037661888,-0.047442213,0.038370833,-0.011128217,-0.046797477,-0.0052878917,-0.034705643,0.02007535,-0.0070533575,-0.059863973,0.11208669,0.0057066577,-0.020251384,0.039382342,-0.01772648,-0.029925916,0.007166733,-0.021859238,0.08325893,0.034463488,-0.04590595,-0.026390858,0.036707066,-0.023828413,0.06130851,-0.03078856,0.03641535,0.025198067,-0.0052450676,0.046809457,-0.043254424,0.041322883,-0.024387136,-0.036676046,-0.019247565,-0.02201109,-0.014368212,0.009848842,-0.0010410728,-0.011224887,0.053673565,0.01864885,0.037855495,-0.022914883,0.015870044,-0.014803067,-0.03870728,0.07528428,-0.07742806,0.034794364,-0.1285218,0.035139784,-0.025702694,0.013828681,0.016751638,0.07837761,-0.051348463,-0.02969884,-0.026936186,0.02685847,-0.07927809,0.01972347,0.029352898,0.012100268,0.013457954,0.009867672,0.04836066,0.03146153,-0.02102168,0.0347047,-0.0085500525,0.025777884,0.0068570436,-0.0056702513,-0.035950743,0.007352783,0.027967444,-0.0008829054,0.0010659159,-0.01697691,0.0044921623,0.04067631,-0.017236574,-0.010738306,0.040704962,0.03447774,0.09194955,0.014535896,0.027333194,-0.018824497,0.016121237,0.026699716,-0.004319617,-0.030710913,0.034018878,0.016125401,-0.021998953,-0.032114632,-0.027736902,-0.017993666,-0.11574893,0.07748148,-0.0544976,0.050933003,-0.0036318046,-0.014166646,-0.0038386409,0.02315096,-0.053288735,-0.0007702757,-0.021936376,0.08185545,-0.01585,0.055432606,0.010397321,0.02486939,-0.027063537,0.020298338,0.011323376,-0.017997608,0.11450967,0.028105171,0.024360431,-0.0034869574,-0.00051750574,0.004361744,-0.0731595,0.0061057806,-0.009353152,0.02738649,0.008200431,0.007264617,-0.0020998872,-0.041906465,0.0066152145,0.00045017657,0.016057832,-0.03279027,-0.006947064,0.052574646,-0.005861679,0.0048413104,0.009907042,0.03774836,-0.0033327432,-0.04728216,0.046642657,0.0029882086,0.026896669,0.013618417,0.03061073,0.027177326,0.031077765,0.046466522,-0.024182914,-0.011106191,0.08165573,0.065909795,0.047859162,-0.009129225,0.0040478907,-0.07716984,-0.0007353412,0.03490862,0.017295668,-0.08260225,0.0227727,0.00846909,0.026572576,-0.010694129,0.06511193,0.0056013986,-0.02453262,0.017707713,0.02869944,0.023329284,0.013129229,0.015317914,-0.016253743,0.0077158464,-0.009557237,-0.016025495,-0.068370685,0.10199169,-0.019418018,-0.01465389,0.009213316,-0.013547106,-0.03451867,0.029967858,-0.06599089,-0.034593098,-0.0048272354,-0.070018545,-0.004294786,-0.020035997,0.06568054,-0.0031212366,-0.008980077,0.004337056,-0.006183281,-0.004019566,-0.04608752,-0.0086968,0.03416687,0.026673883,-0.019662865,-0.061314628,0.0013592832,0.018672567,0.03761422,-0.030784374,0.009617046,-0.015089352,0.008009548,-0.0068889433,-0.019827748,0.007039167,0.0049508675,0.002223904,0.0017076001,0.03458056,0.024481347,0.026550552,-0.04509259,0.008629808,-0.019386258,-0.005315534,-0.04830978,0.045123916,-0.0193953,-0.039364688]	\N	2026-07-28 18:23:27.837673
3	1	0	Tên địa điểm: Dinh độc lập\nMô tả: Dinh Độc Lập là một tòa dinh thự tại Thành phố Hồ Chí Minh, từng là nơi ở và làm việc của Tổng thống Việt Nam Cộng hòa trước Sự kiện 30 tháng 4 năm 1975. Hiện nay, Dinh Độc Lập đã được Chính phủ Việt Nam xếp hạng là di tích quốc gia đặc biệt. Cơ quan quản lý di tích văn hóa Dinh Độc Lập có tên là Hội trường Thống Nhất thuộc Văn phòng Chính phủ.\nKhu vực: Bến Thành, Quận 1, TP.HCM\nDanh mục: Di tích lịch sử\nHợp với sở thích: Lịch sử, Thiên nhiên, Kiến trúc\nĐộ phù hợp nhóm tuổi: ADULT (5/5)\nKhoảng giá: 20,000 - 80,000 VND	[0.055642392,-0.005345945,-0.053746026,0.025084896,0.031852577,0.06992786,0.020327691,0.036178578,0.0036625352,-0.01010628,-0.065179385,-0.030770138,-0.0030553727,0.0061972504,-0.012065091,0.018384775,-0.028106572,-0.016488206,-0.0049363123,-0.033231962,-0.032181405,0.046278268,0.057531875,-0.05818084,-0.0323342,-0.045907192,0.013614372,-0.042309828,-0.013840169,-0.00647984,0.042579677,-0.0277453,0.0031171439,-0.07994119,-0.0031951424,-0.059485007,0.023511628,0.012829002,0.016065467,-0.029747987,-0.0046356358,0.005347142,-0.0069807707,-0.008444062,0.0069119083,-0.002669713,0.04952117,-0.054549113,-0.017624734,0.0027069594,0.005909954,-0.042312607,0.002547161,-0.011595016,0.0098383,-0.01323282,-0.0034758737,0.06868858,-0.07571146,-0.005597015,0.036039982,-0.06775542,-0.023190988,0.033703048,0.049629368,-0.05631363,-0.025967538,0.060412537,-0.0282954,0.03085545,0.04014914,0.028811922,-0.02978538,0.043643203,0.051977314,0.014015077,-0.020607695,0.05515649,-0.0017919135,-0.03778248,0.04140001,0.08707982,-0.057306886,-0.044313435,0.029555634,0.051973246,-0.06367102,-0.030461572,0.004446916,-0.03542022,-0.0065012993,-0.012643925,0.009713052,0.012684777,0.019506482,-0.011449777,0.0001430709,-0.0056199385,-0.04540367,-0.0254901,0.013033331,0.059128184,0.053223386,-0.029280674,-0.017457748,0.0052719857,0.0210314,0.07397948,0.033050496,0.0066245445,0.018097697,-0.04346209,0.019138366,-0.043992247,-0.036435965,0.02258824,0.02964271,0.0017252553,0.024646979,-0.01754481,0.024540007,0.024701884,0.032206133,0.007981128,-0.014333648,-0.0036374491,-0.006838608,0.0043601175,0.016497083,0.04941094,0.035832092,0.00037705916,0.03147231,0.056723975,-0.00022257528,0.024028342,-0.017754082,-0.0056719147,-0.051304966,-0.040297683,-0.009327927,0.036233567,-0.012554456,0.065701135,0.05739351,-0.0032282886,0.035639912,0.069577284,-0.056714464,-0.010646228,0.002296833,-0.085808665,-0.017148163,-0.005181333,0.025256641,0.044831127,-0.014316098,0.020798836,-0.007242189,0.037124034,0.019072756,-0.054541666,-0.056811236,-0.015943378,0.006002028,0.028768865,-0.0063573983,0.0073557235,-0.014512595,-0.037019916,0.00380466,0.054041013,-0.025735056,-0.001625598,0.027685486,0.018910708,0.03406987,0.09049988,0.034198493,0.047073927,-0.055506118,0.015297441,-0.0538512,-0.013974089,-0.0034900687,-0.037656613,0.04815892,-0.04069348,-0.06885065,-0.0052284035,0.026320286,-0.03204459,0.0068308683,-0.011189725,0.011208376,0.029901946,0.024274591,-0.027021129,-0.04246775,-0.027631165,-0.0003547205,0.035762306,-0.014175251,0.0044679474,-0.0242919,0.034949068,0.00055207923,0.068364285,-0.0016897824,-0.025062628,-0.021274252,0.0200846,0.030737273,0.016504157,-0.021087326,0.02674637,-0.020026514,0.018700194,0.04118639,-0.018473504,-0.017260998,-0.048164375,0.068425246,0.015106576,0.007560274,0.001236804,0.010089792,-0.010760852,-0.018496526,0.038208704,-0.021848192,0.016417118,-4.0796833e-05,0.01577716,0.019801335,-0.02236101,-0.011435957,0.06965032,-0.024477804,-0.0033673395,-0.029235633,-0.023630952,-0.02342216,0.035276882,-0.007576285,-0.0016252677,0.050046995,-0.033492595,0.07376297,0.030813849,0.010906665,0.011303269,0.019444467,-0.046059478,-0.012473527,-0.014203786,-0.020648638,-0.037547927,0.01176061,-0.016945587,0.018986559,-0.0098330425,0.103750184,0.009707793,-0.014355795,0.03516271,0.013939984,0.015708383,0.03257055,0.014428681,-0.047228687,0.051883,0.017920945,0.066394776,-0.07031883,0.010273659,0.048524998,0.008930388,0.012951173,0.05794217,0.0041665933,-0.011429802,-0.023799721,-0.001689706,0.030825326,-0.057189714,-0.0034315013,0.01384587,0.0078325765,-0.015775481,0.020467123,-0.06344341,0.017072398,0.021077368,0.053537577,0.019266682,-0.0014045268,0.03171006,-0.020327417,0.014753062,0.017873736,0.061839197,0.024049241,0.031706687,-0.04719196,0.06560615,-0.056202885,-0.038708813,0.034502223,0.037384804,0.020331776,0.028396565,-0.052732136,0.029425707,-0.022775907,0.025099156,-0.061906744,0.010033368,-0.013802745,0.020776413,0.00018123756,0.056620084,-0.030463155,-0.01974862,-0.019756922,0.015741808,0.0034099931,-0.02182145,-0.021188628,-0.0038921922,0.058664534,0.030009368,0.023744442,-0.025910102,-0.011387497,0.0016514937,0.015455045,0.052725002,-0.0029872335,-0.015788876,0.027437469,0.007895213,0.010216307,0.0042281114,0.0013298921,0.020176347,0.03272304,-0.037564497,0.106635556,0.029146908,-0.09694477,0.020966407,0.014650004,0.008880977,0.022500915,0.056740317,0.033119623,0.009372418,-0.0054419977,-0.03435581,0.07261593,-0.0081117945,0.014328517,0.07511186,0.006504836,-0.027763944,0.05131921,0.0105945235,0.013278986,0.035993565,0.05846702,-0.042430636,-0.01354117,-0.010553533,0.021444574,0.08562256,0.09118265,0.016493216,-0.023923827,0.017326364,-0.037129387,0.026583333,-0.018485487,-0.029482534,-0.009265902,0.051783003,-0.018586224,-0.007969085,0.06835484,-0.0049202032,-0.044775642,0.07569345,-0.030444877,0.030362258,-0.017049734,0.06392756,-0.04207675,0.0573641,-0.016406002,0.052348487,-0.028713152,0.03000696,-0.042884704,-0.006638147,0.030730542,0.00925999,-0.016176749,-0.0028321426,0.030440485,-0.027160365,0.019450085,0.0050106714,0.056354962,-0.036467094,-0.019689495,0.0015782347,-0.029875949,0.010870964,-0.019837976,0.031274308,0.04055707,-0.049084872,0.052826926,0.079090334,0.010166919,-0.03158975,-0.021036899,-0.060801864,0.047508497,0.039577886,-0.047695916,0.040240813,-0.09263076,0.044089854,0.06919011,0.049824003,-0.01978852,-0.009875866,0.040804077,-0.0013253632,0.024720086,-0.030224359,-0.023401806,0.017111992,-0.028633287,0.022237338,-0.009344954,0.01126061,0.074474886,0.018879522,-0.003147677,0.007467084,0.008132796,0.00509433,-0.04003852,0.0041104583,0.033617783,0.006292184,-0.041019768,0.011036474,-0.021810548,0.113842525,0.009466258,-0.041802745,-0.04724224,0.052915502,-0.037936892,-0.0002232628,0.025061239,0.019723771,-0.010976528,0.018325923,-0.025840096,-0.005886356,-0.026403472,0.043821666,-0.0642814,-0.014505433,-0.06382497,0.018121291,-0.073365405,-0.044378147,-0.04177882,0.01958291,0.07396149,0.023013357,0.002760638,0.017305765,0.02081374,0.028886128,0.038313758,-0.003305421,0.047889553,-0.04434338,0.0396769,0.021091131,-0.04828497,-0.025758762,-0.039216306,0.031559184,0.031769443,-0.030072104,0.01098284,0.050672594,0.08799902,-0.030838342,-0.013722518,0.003076471,0.06609139,-0.05168543,0.06707984,0.07220944,0.013026556,0.01184726,0.06107396,-0.008885355,0.022904046,-0.012802081,-0.032156892,0.006545946,-0.04383333,-0.0017628523,0.009410788,0.033543583,0.0062335613,-0.0013825528,-0.028233303,0.032271445,0.013874375,-0.01893758,-0.033287596,-0.031133708,-0.014700971,-0.03453807,0.048612006,-0.0032316667,0.030896964,-0.024993094,0.030762674,0.0017470047,-0.05694978,0.04115447,-0.00047631,0.030834798,-0.025718238,-0.03498857,0.06460824,0.009098741,-0.022052413,0.043861095,-0.009396466,-0.056755215,0.0011745791,0.009614708,-0.0047485456,0.06160675,-0.056706488,-0.008142074,0.031019654,-0.0331167,0.03621711,-0.024693565,0.024859678,0.013846633,-0.014324903,0.054709136,-0.039681096,0.03194509,0.006744791,-0.024361683,0.021698147,-0.0026815801,-0.024914816,0.013820483,-0.0027629603,-0.0335329,0.009664537,0.022811202,0.034819853,0.0117049385,-0.036054697,-0.013939181,0.0016844689,0.04804139,-0.11524685,0.030009793,-0.0119527755,0.068069756,0.03184745,-0.009620399,0.006742585,0.052455466,-0.05151022,0.039546587,0.0014910517,-0.037928216,-0.023558635,0.07559607,0.044221543,0.013272303,0.047622353,0.021108719,0.03911597,0.0022973204,-0.017468074,0.02616806,-0.027547114,-0.0138697,0.015716376,-0.016429449,-0.027623426,0.017902818,0.034163404,-0.017041119,-0.030832943,-0.043574978,0.031140802,0.07684004,0.009790007,-0.011253079,0.054910023,-0.054445367,0.049868,-0.002099829,0.007813591,0.06526309,0.0028790287,-0.026321938,-0.016826965,-0.00047400888,-0.004900358,0.038442295,-0.038662374,-0.014961889,-0.054418813,0.022920476,-0.06658375,0.025224622,-0.10109627,0.08185862,0.0042420323,-0.0552318,-0.07862902,0.047184024,0.0072481525,0.03221897,-0.057049062,0.04672092,-0.062756695,0.014831805,0.011344447,0.036906186,-0.0078342445,0.005956698,0.02507946,-0.061752655,0.09193643,0.006155516,-0.01878926,0.009204464,0.0072033587,-0.03257469,0.008462275,0.006439103,-0.029959401,0.024503855,0.031117016,0.028299294,-0.029966487,-0.091506094,0.013377636,-0.01856413,-0.008826312,-0.055528454,0.0005362842,0.022550737,0.0151095465,-0.010827473,0.021721628,0.00490798,0.06556992,-0.021372173,0.0397763,0.043123487,0.0024260774,-0.031451877,0.06498773,0.0043956917,0.026236888,0.018746687,-0.049896907,-0.0040856856,0.036662534,-0.010822997,0.034061488,-0.0086204335,-0.03732997,-0.003918122,-0.037590723,0.038100433,-0.025463687,-0.017259654,0.023490533,0.01989375,0.037778594,0.018070618,0.045902457,-0.03258588,-0.018213993,0.03992688,0.026964523,0.054897677,-0.00996212,-0.064291075,0.008656515,0.06213643,0.0039005338,0.033777747,-0.006219158,0.036146123,0.001084361,0.010814999,0.01126296,-0.06841911,-0.06819709,0.023778623,-0.02284223,-0.013548854,0.034100506,-0.070845924,0.038134944,0.038013224,0.041837562,-0.04167544,-0.04966807,-0.013681341,-0.05452678,-0.03731583,-0.00806111,0.016570704,0.0058758766,0.062052105,0.0033555892,0.04038274,0.018485347,0.014041337,-0.0046983324,-0.035132635,0.029567521,-0.017183304,-0.017635044,0.056109443,0.021056995,-0.009671509,0.06452721,-0.026994122,-0.012129418,-0.0036255694,0.018718204,2.9621238e-05,-0.038671218,0.008169389,0.04251735,0.064156726,-0.0208444,0.050699253,-0.031866338,-0.03922884]	\N	2026-07-28 18:25:58.319994
5	3	0	Tên địa điểm: Bảo tàng Mỹ thuật Thành phố Hồ Chí Minh\nMô tả: Tọa lạc trong một dinh thự cổ mang phong cách kiến trúc Art Deco kết hợp Á Đông tuyệt đẹp với tông màu vàng uốn lượn đầy hoài cổ. Du khách đến đây không chỉ để thưởng lãm các bộ sưu tập hội họa, điêu khắc từ cổ đại đến đương đại mà còn để chụp những bộ ảnh nghệ thuật độc đáo. Nơi này cực kỳ lý tưởng cho người yêu nghệ thuật, giới trẻ đam mê nhiếp ảnh và những tâm hồn lãng mạn. Điểm đặc trưng thu hút nhất là chiếc thang máy cổ đầu tiên của Sài Gòn và hành lang tràn ngập ánh sáng tự nhiên tuyệt đẹp.\nKhu vực: Bến Thành, Quận 1, TP.HCM\nDanh mục: Bảo tàng\nHợp với sở thích: Lịch sử, Văn hóa, Chụp ảnh, Kiến trúc\nĐộ phù hợp nhóm tuổi: ADULT (5/5), TEENAGER (4/5), YOUNG_ADULT (4/5), SENIOR (5/5)\nKhoảng giá: 15,000 - 30,000 VND	[0.048515454,-0.025630267,-0.005747648,0.021248795,0.0055003045,0.028918399,-0.0047022547,0.03684534,-0.0399224,-0.073350064,-0.010041504,0.033626568,0.061030734,0.035117548,-0.006808478,0.026178496,-0.060233254,0.008495425,-0.008783962,-0.03147066,-0.032660563,0.036467034,0.0295236,0.009144692,0.022363879,-0.0062246886,0.027941952,0.0028727788,0.017387064,-0.07658294,0.052475084,-0.023426635,-0.0012032255,-0.042031076,0.10851661,-0.0742438,-0.025701279,0.045524716,0.039378453,-0.014110486,-0.0031944553,-0.0122535,0.023366082,-0.014982409,-0.045212433,-0.0111061465,0.040359456,-0.050397433,-0.023003692,-0.014630828,-0.058867045,-0.011224874,0.043932095,0.010657261,-0.0053238715,0.03568343,-0.0204528,0.019828314,0.03174248,0.033085346,0.033404686,-0.04428365,-0.003903809,0.00962897,0.028058656,-0.057607204,-0.00820752,-0.031726032,0.025637116,0.05084616,0.04544224,0.05783683,0.042464655,-0.016174322,-0.009083189,0.05052761,-0.02167068,-0.01888207,0.0050965464,0.021050083,0.02778416,-0.02406824,-0.030941077,0.0076279533,0.004931371,0.043609384,-0.01587567,0.02371952,-0.0014527999,0.028196054,-0.04393507,-0.046287764,0.028305994,0.01989712,-0.017773675,0.0075661633,0.033460725,-0.026139649,-0.023371952,-0.027170887,-0.02571554,0.024258737,0.030323133,-0.0063499515,-0.019643418,-0.0032176275,0.036876757,0.0047711153,-0.014418218,0.07194253,0.014345709,0.010601128,0.048676986,0.008869482,-0.047855202,-0.009880644,-0.0011537644,-0.030507414,0.014717062,-0.0011426823,0.042484883,0.029574795,0.025308747,-0.023767335,-0.006984656,0.040181283,-0.013577632,-0.012501911,-0.0146955885,0.0008347505,-0.012895667,-0.0039545656,0.0048245555,0.0069561214,-0.011552495,0.016816488,-0.010455853,-0.026705075,-0.03120234,-0.030805325,-0.046806328,0.0016235464,0.019690212,-0.032393653,-0.01446624,0.00327652,0.012908784,0.046476487,-0.052036807,-0.0029415847,0.04220116,-0.025703054,-0.020298596,-0.037375726,0.0018177967,-0.009375122,-0.021846088,-0.002143039,-0.022914896,-0.031940416,-0.010673641,-0.020238794,-0.01752092,0.03577925,0.017244313,-0.0045446064,0.001018575,0.0636182,0.026366297,-0.068768755,-0.020370424,0.035075605,-0.010468281,0.022252029,0.07515756,0.0280336,0.0031572012,0.02278191,0.031675193,0.034163207,-0.079794295,0.037159782,-0.01914714,-0.00053874485,0.009839261,-0.020852594,0.03754971,-0.055225447,-0.020970944,-0.0076300628,0.02316207,-0.038713872,0.03884716,0.005535686,0.064573795,-0.043420788,-0.025385752,0.019873885,0.007336019,0.0038567777,0.018279087,-0.006392996,0.08007086,0.03353395,-0.041181326,0.06509993,-0.0006704434,0.035243455,0.027996793,-0.01482516,0.008723109,0.02183329,0.0008318239,0.013322046,0.04809926,0.0360081,-0.028346544,0.053822286,0.061771482,0.041227285,-0.0031354167,-0.009740356,0.040267315,-0.041061655,0.03930433,-0.042401206,0.0004277515,-0.03216541,-0.077375874,-0.030991478,-0.0639891,0.018477697,0.028770715,0.033556934,-0.014033018,-0.008240511,-0.02443831,0.023099229,-0.020454954,-0.0263922,-0.023898082,-0.022974567,-0.04108978,0.031370603,-0.028669983,0.006596595,-0.030116633,-0.03428112,0.012046809,0.09530346,0.026838755,0.09448549,0.021023676,-0.02680905,0.024345817,0.016254261,-0.016332723,-0.038101226,0.06107947,0.044978812,0.06044066,-0.022592045,0.0723548,0.07503496,-0.015588376,-0.023547417,0.05734732,-0.0085437875,0.03867787,-0.022054147,-0.03939099,0.017753683,-0.005983492,-0.0145203,-0.030107178,0.010347315,0.07108836,0.0030759021,-0.030351166,0.042473212,0.030327287,-0.039276574,0.0017622688,-0.026501883,-0.02925884,0.013146652,0.046421185,0.01665182,0.043557726,0.002468011,-0.01951649,-0.014141209,-0.04541221,0.002371989,0.03288418,-0.014495156,-0.012492988,0.009925894,-0.008956985,0.0024918183,0.009296989,0.02092962,0.05021593,-0.02413157,-0.028528832,0.02460529,-0.012929683,0.0026458495,-0.01527808,0.012539998,3.4363205e-05,-0.022123467,0.027153596,0.048628893,0.06239019,0.01819418,-0.032259464,-0.009766043,0.023023877,0.009259697,-0.07994184,0.009605079,-0.017516393,-0.04812407,-0.03431736,0.061916176,0.010713178,-0.00095753174,-0.0120296925,0.009982578,0.0081621045,0.038731407,0.017611207,0.040662143,0.044759326,0.017874384,-0.016525835,0.03442013,0.0124213025,0.026741492,-0.044305395,-0.038191874,-0.017473372,-0.025362687,-0.085821345,0.041561585,0.043267168,0.0070429645,0.08812649,0.020031597,-0.046408407,0.026691286,-0.0012877221,0.017698022,0.058814265,0.05269491,-0.0427114,0.003977206,-0.019564973,-0.0064802878,0.0727177,-0.055426117,-0.021693317,0.037075117,0.021782156,-0.034440488,0.054240093,-0.0057081846,0.01813447,-0.002530771,0.045666594,-0.049709346,-0.035016336,2.5982814e-05,0.022683486,0.047751516,0.018349642,-0.013856028,-0.023424236,0.06340008,-0.036252107,-0.025316123,-0.055637248,0.01112209,0.04221785,0.03450184,-0.03705397,-0.05113625,0.047038075,-0.0017038821,-0.037756894,0.023270074,-0.01237865,0.032395385,-0.015630044,0.033365667,-0.0129819345,0.058961865,-0.029533306,-0.017187426,0.10599186,0.020491272,-0.035300516,-0.019795347,-0.009329359,-0.027520139,0.0014058439,-0.028529027,0.018610697,-0.03256934,-0.011654158,0.049763612,-0.009195798,-0.0029328277,0.06559138,0.043543447,-0.0068499907,0.006570666,0.010799669,0.00771283,0.060753036,-0.07621307,-0.03531123,0.046233546,-0.044771582,0.036742665,-0.044783182,0.0282496,0.010394234,0.08199767,0.016162327,0.02746523,-0.024997242,0.013216923,-0.002608583,0.07084911,0.032028753,-0.037164748,-0.009797557,0.0048436173,0.05128206,-0.024865119,0.004699415,0.02246375,-0.053004555,0.005193956,-0.0021926067,0.03473247,0.078339055,0.013787929,-0.008129422,-0.041212644,0.014791497,0.054316204,-0.03420971,-0.052077588,0.061513327,-0.010955611,-0.00013114832,0.0091789365,-0.07911887,0.05965908,0.024001023,-0.025435962,0.015092364,0.0762118,-0.03271723,0.012443319,-0.02018275,-0.015213983,-0.007219553,-0.010619078,-0.025554368,-0.039719295,0.018821016,0.002121207,0.006400961,-0.026379397,0.040047925,-0.062027104,-0.014749223,-0.05062953,-0.004758391,-0.012474875,0.0781992,0.018245455,0.042650502,0.0022622286,0.018055541,0.045709487,0.01514104,-0.006027507,-0.043120224,-0.02151137,0.010226035,0.019691432,-0.07180868,0.022735199,-0.058672227,-0.036570907,0.06283493,-0.022007441,0.053445257,0.03473012,0.049334787,-0.03914002,0.036925893,0.040455043,0.057746563,-0.014015251,0.013931073,0.026193742,-0.00059960637,0.03061713,0.018802568,0.07040449,0.0286426,0.047540735,-0.025374638,-0.01197814,-0.044288713,0.008331239,0.02682917,-0.029782522,0.033483025,0.012626116,-0.013232177,0.00806666,0.024210423,0.039121162,-0.045092966,-0.074053325,0.051837545,0.0070925155,0.033145722,-0.025354369,0.037371624,-0.04284028,0.0615323,-0.04396513,-0.0356793,0.07087607,-0.025746237,0.0036317508,0.007654307,-0.003317495,0.07002796,-0.032196783,0.014607079,0.0096655665,-0.009184522,-0.032007545,0.005862564,0.0034156272,0.028732738,0.024761131,-0.046364695,-0.029082263,0.06441108,-0.00347679,0.0902167,0.007604899,0.024070626,0.051208742,0.014215737,0.05511004,0.030720504,0.08710655,-0.02240465,-0.0047687176,0.05932674,-0.038830265,-0.04668981,0.043126628,-0.013944638,0.0067079025,0.069149666,-0.024885591,0.027676847,-0.008610283,-0.0067271013,-0.005377744,-0.039285924,0.079869255,-0.047382515,-0.012326074,-0.103309624,0.0632296,-0.0029812658,-0.0009943203,0.049743496,0.0035441744,-0.029238293,-0.024516292,0.017590022,-0.019670404,-0.080280714,-0.03273814,0.024526516,0.065359615,0.0019200107,0.019883562,0.07405017,0.04565336,-0.021415336,0.076113775,-0.0348715,-0.039773986,0.0022019674,-0.020844784,-0.02931058,0.015510578,0.01311656,-0.0062726513,3.8667527e-05,0.02025594,-0.0031783206,0.046538554,0.022538697,0.022329064,0.025156407,0.013487615,0.03481101,0.03846332,0.017437054,0.0041359267,0.01902789,0.014571092,-0.0053262105,-0.037145976,0.08404624,0.003928542,-0.031748664,-0.025367385,-0.012203256,-0.019551747,-0.13587712,0.034502685,-0.053336974,0.012773867,-0.009551477,-0.014393312,-0.044735525,0.025946783,-0.018776655,0.015997117,-0.00348554,0.054674014,-0.00081732054,0.0023026224,0.005929816,0.047576465,-0.00013226937,0.008937396,0.055006515,-0.029222121,0.107318655,0.056688003,0.020038461,0.0037638687,-0.0044356682,-0.03981628,-0.09558101,0.02602326,-0.0011957985,-0.03301834,0.005421354,-0.0075369575,-0.03287911,-0.035466038,0.041405022,-0.019369276,0.023843192,-0.038879238,0.027755592,0.04281604,0.051228993,0.012524432,0.020578204,0.056712765,0.016550202,-0.067354724,0.015228175,0.03581629,-0.005065365,0.027693637,0.041789133,0.029487984,0.04049927,-0.029100405,-0.035969477,0.019692494,0.034722075,0.015626775,0.058236588,-0.011879856,-0.037307706,-0.05728934,-0.034232073,-0.020291526,0.039726976,-0.045776308,0.048723757,0.018416235,-0.004494858,-0.020526655,0.054771665,-0.043131046,-0.04866992,0.030821716,0.060051277,0.0057017263,0.0124009,-0.00032600877,-0.013651808,0.06223449,0.025657548,-0.0009639255,-0.062197436,0.09058154,-0.054841835,-0.022085086,0.06030353,-0.043676663,-0.04476601,0.021596747,-0.078753054,0.0077528046,0.003344548,0.015547847,-0.018290313,-0.042551007,0.064963035,-0.0027084744,0.032797974,-0.016943213,0.0016337166,-0.054017995,-0.032575194,-0.0037897378,0.030528283,0.042149305,-0.06926965,-0.02274209,-0.012096466,0.038289387,0.029513603,-0.016715456,0.005073741,0.023652665,-0.0045168046,0.009941862,-0.007529057,0.03262585,0.0070879213,-0.059996106,0.0045258123,-0.0073123635,0.0129455095,0.040623736,-0.023851544,-0.020091007,0.009630121,0.00840867,-0.0397898,0.033832777,-0.032647055,-0.016008144]	\N	2026-07-28 18:55:00.688243
6	4	0	Tên địa điểm: Chùa Ngọc Hoàng\nMô tả: Chùa Ngọc Hoàng mang đậm nét kiến trúc đền chùa người Hoa xưa với mái ngói âm dương, các pho tượng điêu khắc bằng gỗ tinh xảo và không gian trầm mặc hương khói. Người dân và du khách thường đến đây để chiêm bái, cầu bình an, đặc biệt là cầu con cái và tình duyên tại điện Thánh Mẫu vô cùng linh thiêng. Địa điểm này phù hợp cho những ai muốn tìm hiểu văn hóa tâm linh, người lớn tuổi hoặc du khách muốn tìm một khoảng lặng giữa lòng Sài Gòn. Điểm đặc trưng là hồ rùa lớn ngay sân trước và từng là nơi được Cựu Tổng thống Mỹ Barack Obama ghé thăm năm 2016.\nKhu vực: Tân Định, Quận 1, TP.HCM\nDanh mục: Chùa - Đền\nHợp với sở thích: Văn hóa, Tâm linh, Kiến trúc\nĐộ phù hợp nhóm tuổi: ADULT (5/5), YOUNG_ADULT (4/5), SENIOR (5/5), MIDDLE_AGE (5/5)	[-0.021539923,0.07084702,0.0069418293,-0.031563327,0.012218362,0.049555026,-0.030941369,0.07441663,-0.030670721,-0.0034553038,0.0017321262,0.02765155,0.009716686,0.006651692,0.0640451,0.021741387,-0.04847334,-0.046408355,0.026106538,-0.0018023734,-0.05912968,0.00063719205,0.042601872,-0.03438406,-0.027171992,0.045141365,0.026901152,-0.0039226413,-0.052323285,-0.068460226,0.06531799,0.045206174,0.0020981866,-0.030708803,0.038872402,-0.06588488,-0.06106944,0.04821661,0.006595403,-0.09133101,-0.015090721,-0.014597,-0.0032414207,0.0038360606,0.008265832,-0.009755982,0.04138423,-0.01639029,-0.042308744,-0.017528601,-0.005575363,-0.010605653,0.042892005,-0.04306337,-0.03056494,0.048044648,-0.009653632,-0.010443381,0.01762156,-0.0013464671,0.034402773,-0.043395214,0.013291064,0.046705123,0.03587157,-0.0036090473,0.0011144468,0.005223099,0.023886107,0.0066728503,0.06781519,-0.0034424302,0.0832048,-0.030305056,0.0056716683,0.08274595,0.00028075976,-0.016935943,-0.030885682,0.026310794,-0.0047944146,-0.0036494127,-0.008639528,-0.00244483,0.021442315,0.046699762,-0.04897585,0.018438919,0.00794042,0.05718025,0.0047736885,0.0074563823,-0.02195815,0.040560193,-0.011751748,0.01484637,0.053909402,0.0119938385,-0.041683998,-0.02662977,0.015846504,-0.0014568877,0.09368552,-0.018815074,0.0015661977,0.044817723,0.021267813,0.014309774,-0.015051718,0.010754674,0.01503844,-0.031088958,0.012473476,0.03509314,-0.018162638,-0.025188772,0.009052073,0.02109238,0.007496071,-0.030795245,0.026618227,0.07783999,0.038377695,-0.03419183,-0.044171117,-0.013787627,-0.0715553,0.030841127,0.009970472,0.02299414,0.05946565,0.01970183,0.034926154,0.013018705,-0.032051325,0.06469203,0.026495006,0.017729063,-0.066184916,-0.016570175,-0.030831184,0.026199942,0.012315874,-0.003965978,0.035814483,0.034372497,0.018698046,0.074114226,-0.036239985,-0.052388012,-0.039098363,-0.037016775,0.03939759,0.02530308,-0.06801374,0.021255597,0.0019833988,0.034593582,0.011942557,0.013516307,-0.03877267,0.0020568667,0.0330482,-0.02616518,-0.06364659,0.028079242,-0.019611279,0.022158796,0.06747933,0.03690329,-0.044525612,0.1104334,-0.02783925,-0.021222439,0.08229663,0.05204006,0.030386506,0.035965208,0.054938704,0.06453976,-0.031297427,0.01651476,-0.028471585,0.026196884,0.020072222,-0.0041323532,0.025441788,-0.027165078,-0.012797297,-0.023532283,0.049950466,-0.041477297,0.028120724,0.016133374,-0.018974043,-0.019854322,-0.017553218,-0.045228142,0.0038224054,0.03452365,-0.04189333,-0.0049635773,0.025589373,0.005183939,-0.035791263,0.047011174,-0.005155047,-0.006026438,-0.013192402,0.00471304,-0.057782136,-0.01594978,0.033678353,-0.024038948,0.05318223,0.005141362,-0.0261608,0.09613091,-0.03915448,0.041419987,-0.0047795987,-0.010783137,0.00024531852,-0.034719165,0.037464373,-0.0449091,0.01498792,-0.038535643,0.006940707,-0.017407754,-0.07316891,0.0024190792,0.01879952,0.022053437,-0.004040666,-0.016408127,-0.034573134,0.0054099387,-0.019606572,-0.023170086,-0.034176815,-0.0029849468,-0.0007765366,0.0042640585,0.025832675,0.03862603,0.02819393,-0.04156524,-0.008097156,0.029364755,-0.0011533789,-0.014909331,-0.019180747,-0.024203954,0.007979831,-0.020013036,0.010575822,0.0098371785,0.08499649,-0.027934665,0.039415214,0.0024465346,0.01536277,-0.0048744003,0.03018906,0.013054154,0.062271226,0.01404824,0.0417219,0.02201688,-0.052064374,-0.009478072,-0.014643502,-0.0043740286,0.0036292921,-0.01934923,0.04027814,0.04200729,0.0074773924,0.027808167,0.004903443,-0.05306076,0.051540747,0.0039896765,-0.006398367,0.011509457,0.06800295,0.03375693,0.05443799,0.005605995,-0.0365334,-0.014860245,-0.022033805,-0.018269777,0.040302522,0.052550074,0.018330285,-0.019455655,-0.007677695,0.0024706663,0.022408895,0.022932947,0.0017096436,0.056821592,-0.03520404,0.007466008,-0.04733905,0.0240801,0.089256816,-0.028856698,-0.040098123,-0.043218073,0.0010959595,-0.008914574,-0.013816445,0.021178098,-0.10994209,-0.024102878,-0.035019513,0.0280282,-0.036701687,0.03096758,0.029227901,-0.022038002,-0.016239295,0.02814942,-0.006521608,0.078930356,-0.008279949,0.030880807,-0.024740377,0.06213738,0.012208674,0.042609923,-0.009771515,0.027936405,-0.007708612,-0.0062159207,0.031326555,-0.045681104,-0.020674773,-0.048063103,0.03592262,0.022929361,-0.041748606,-0.007814497,0.0030601828,0.043142546,0.015448809,0.012352242,-0.074851334,0.0039131716,0.02185467,0.02851143,0.034601238,0.014677654,0.025974488,0.038269304,0.008482072,-0.020111788,0.015708055,0.016835986,0.02217036,0.06986047,-0.025333943,-0.054202765,0.017836612,-0.03656869,-0.01428913,0.04651069,0.044448692,0.0118637495,0.014849202,-0.02612646,0.023110447,0.019464655,0.010057254,-0.012972796,-0.016035408,0.05942788,0.041247245,-0.019037075,-0.052564822,0.011164314,0.014360497,0.016015839,-0.04650051,-0.056952674,0.00047080897,0.005571145,-0.0029218297,0.012892335,-0.0073291855,0.033309847,-0.011790147,0.04364252,0.0013151381,0.030838333,-0.06632219,-0.007008256,0.0008275592,0.024585968,-0.12048412,-0.046820827,0.012878597,-0.0032711888,-0.04914761,-0.05286802,0.023264084,-0.019647375,-0.008003116,0.006924567,0.03629941,-0.05829765,-0.014969756,0.03177529,0.038826182,0.057461407,0.07466828,0.03930424,0.06147215,-0.00936926,-0.027969165,0.045710847,-0.0038761382,0.0611819,0.018121874,0.008965585,-0.012632273,0.010037348,-0.00946357,0.023257826,-0.011450452,0.043898545,0.011142697,-0.008829945,0.014142953,0.0012142452,0.013831412,-0.10323161,0.013228031,-0.041328363,-0.020771498,-0.0191091,-0.022720715,0.047753993,0.016151274,0.035398293,0.04080782,0.0024739925,0.034377825,0.0057149692,-0.002852498,0.03460071,-0.03964341,0.014796944,0.04822236,-0.0059619597,-0.0148177715,0.055618484,-0.007017027,0.107421495,0.023009308,0.016389264,-0.03576182,0.034106195,-0.065317065,-0.01677348,0.043112047,0.011079119,0.0076465714,0.00076563464,-0.038545087,-0.012596289,-0.015118745,0.044256512,-0.02507251,-0.03590112,-0.008914648,-0.022112207,0.03661079,-0.052127875,-0.01727957,0.0031192354,0.0274056,-0.037903532,0.008390142,-0.0117844,0.012587854,0.025595384,-0.015172356,0.01751077,0.041828975,-0.043733418,-0.014416534,-0.020239264,-0.059413828,0.03697392,-0.007518269,-0.0446956,0.08079907,-0.006951259,0.035167713,-0.0060503683,0.06157661,-0.054024193,-0.023987342,-0.04224188,0.024369441,-0.03070128,0.0007658253,0.023711227,-0.001565468,0.034788225,0.039642032,0.041101467,0.032158636,0.017653387,-0.0011232857,0.015273213,0.05094654,-0.0027235132,0.023099527,-0.011204111,-0.0041682706,-0.01997994,-0.00021743463,-0.04496447,0.01974966,0.0013209278,0.029598668,-0.0046548815,-0.00864452,0.011483016,0.05845945,-0.0047272793,-0.020733196,0.007454502,-0.041119576,0.010180123,-0.011414002,0.09970943,-0.036799382,0.013802814,0.016570324,-0.043221638,0.05244483,-0.038645867,-0.050845355,-0.00468741,-0.019455412,-0.05650837,0.02762967,-0.024450371,-0.02596316,0.019727662,0.029825244,0.019793678,0.045662485,0.09625523,0.022862518,0.00033928643,-0.020847792,-0.024090365,0.034188103,0.02156101,0.012965927,0.06549443,0.089348346,0.051586363,0.062686116,-0.024685131,0.035448924,0.073566064,0.01981099,-0.03370994,0.015758613,-0.062012408,0.0073446636,-0.02309628,0.023607882,-0.027912175,-0.0457554,0.025381014,-0.11854769,0.03517548,-0.010670328,0.077078916,0.0437132,0.02456101,0.029145593,0.029281193,-0.03094934,-0.028748933,0.013142751,-0.04341782,0.0026010291,-0.027272847,0.06875866,0.017454864,0.008176806,0.023381948,0.10571091,0.0047120824,0.006274851,0.028406369,0.0017270161,-0.048444137,-0.0125474185,-0.0037974443,0.00061160856,-0.055307887,0.013411173,-0.029129729,-0.049765315,-0.048055116,-0.016163252,0.011190865,0.03194348,0.008242078,0.051179036,-0.010866033,0.046112813,-0.028764728,0.037337672,0.01900753,-0.03418364,-0.048204504,-0.024208844,-0.03862499,-0.003964432,-0.027057976,-0.045613673,-0.001947941,0.012655032,-0.034241803,0.006779326,0.041458808,-0.061039213,0.010667944,0.049923126,-0.069645666,-0.019227307,0.027300177,0.029251063,0.01535824,-0.03234426,-0.011091498,-0.034891464,-0.015755994,0.036722343,0.038039863,0.02899442,0.036016632,0.07857403,-0.048692197,0.06487946,0.0063562193,-0.039853316,-0.014384718,0.017981749,-0.037022687,-0.026076596,-0.0043899654,0.03383952,-0.010064296,0.02164253,0.034123797,-0.0029379781,-0.032474317,0.055602737,0.019471027,0.015186845,-0.024451248,0.012802225,-0.0146320155,0.047440466,0.062015757,-0.005879022,-0.005189329,0.053913932,-0.045104254,-0.013412666,-0.046785846,0.024870487,-0.06960151,0.028794397,0.03671777,0.024707003,0.008518394,0.010225033,0.012501096,-0.017948652,0.06259174,0.025295174,0.011107501,-0.002609624,-0.002913387,-0.017361514,0.08083096,0.008188788,0.028762951,0.047072697,-0.019397248,0.012578167,-0.029613828,-0.0022700422,-0.056280408,0.0036331438,0.04080899,0.007351525,0.009231056,-0.07327766,-0.006083732,0.02127038,0.06814635,-0.0027576752,-0.019646972,-0.0012039175,-0.010768778,0.016369162,-0.034572974,0.0010389893,-0.022383282,0.08454547,-0.002265157,-0.101950616,0.0067615467,0.046448912,0.022476207,0.025817765,0.05838255,0.018479828,-0.05503432,-0.025227163,-0.010288879,-0.05799194,-0.050756223,0.012906046,0.05017014,0.06304338,0.07521286,-0.10281502,0.010294774,-0.0078758765,0.01789088,0.027357938,0.018205414,-0.031843934,-0.043473437,-0.012453022,-0.007642974,0.0052613975,-0.033641174,0.020606363,0.028510725,0.03523972,0.0028156268,0.06271894,0.017957937,0.010281849,-0.012671201,0.034177203,0.011678478,-0.023349943,0.01157537,0.05548999,-0.057078782]	\N	2026-07-28 19:53:17.584746
7	5	0	Tên địa điểm: Chợ Bến Thành\nMô tả: Chợ Bến Thành là khu thương mại sầm uất và mang tính biểu tượng lâu đời với kiến trúc tháp đồng hồ đặc trưng ở cửa Nam. Bạn có thể thỏa sức mua sắm vải vóc, đồ thủ công mỹ nghệ, quà lưu niệm và thưởng thức thiên đường ẩm thực đường phố đa dạng ngay tại các gian hàng bên trong. Đây là điểm đến không thể bỏ qua cho du khách lần đầu đến TP.HCM, những tín đồ mua sắm và đam mê khám phá văn hóa địa phương. Điểm đặc trưng nhất chính là sự nhộn nhịp, đa ngôn ngữ của tiểu thương cùng các món ăn đặc sản truyền thống thơm ngon đầy quyến rũ.\nKhu vực: Bến Thành, Quận 1, TP.HCM\nDanh mục: Chợ\nHợp với sở thích: Mua sắm, Ẩm thực, Văn hóa, Chụp ảnh\nĐộ phù hợp nhóm tuổi: ADULT (5/5), YOUNG_ADULT (5/5), TEENAGER (4/5), MIDDLE_AGE (4/5), SENIOR (4/5)	[0.039648853,0.07033596,0.010222248,-0.022787042,0.03840226,0.023457345,-0.061817113,0.042257078,-0.040664848,-0.00475153,-0.061863855,0.034121778,0.036848724,0.041276652,0.012822095,0.011970073,-0.041709907,-0.0077883736,-0.024750808,-0.008563014,0.05086944,0.027809475,-0.01697483,-0.040788088,-0.0018386549,-0.003997893,0.038498502,0.032353148,-0.06806856,-0.058998145,0.060507912,0.021883812,0.04057325,0.043859713,0.007900197,-0.003246784,0.026517266,0.043287143,-0.012368007,0.011259178,-0.008008199,0.005127722,0.037804652,0.03764559,-0.07806448,-0.038487814,0.029081155,-0.091880724,-0.056438427,0.06535279,-0.011684303,-0.033973586,0.037149634,0.025019322,-0.04916934,0.00051067804,-0.04249308,0.035205126,0.077958055,0.0065221596,0.022449264,-0.061766803,-0.012867663,0.021666313,0.0377562,0.0014715804,0.038202517,-0.014638821,0.009546388,0.031469814,0.022459652,0.0021215698,0.037231892,-0.039869618,-0.013308264,-0.0008672243,-0.0370075,0.027541392,0.006712066,-0.0046881926,-0.0063816872,0.037760258,-0.018967096,0.0049708956,0.04623514,0.016302466,-0.014730055,-0.025357934,4.6988575e-06,0.040969666,-0.025263218,-0.011323793,0.0018525687,-0.0050396603,-0.00076849665,-0.0028611778,-0.024583314,-0.021558883,-0.030481018,-0.03730492,0.011893022,0.009002838,0.056344878,-0.023576593,-0.034666386,0.039916348,0.004984617,0.05510163,0.025125569,0.006574147,-0.026875798,-0.03363471,0.03813301,-0.02817428,-0.01810729,0.017232323,0.014061226,-0.014449693,-0.020688828,0.012044056,0.010560896,0.039221555,-0.022008395,-0.04415649,-0.0015533867,0.043818124,-0.084772326,-0.014432102,-0.054693047,-0.017383303,0.045313906,-0.0049657626,-0.0059977407,0.014230905,0.034664486,-0.013859712,0.014487218,0.022360973,-0.057459917,0.0092845885,0.024438089,0.020338733,-0.013410363,0.028744223,-0.017969446,0.0059213247,0.04464842,0.058322385,0.005511939,-0.0057810317,0.030912705,-0.00077460747,0.016773913,0.014816253,-0.034744576,-0.0013235044,-0.0462447,0.018670024,0.023929218,0.009581782,-0.029775849,-0.0030084325,0.0008187622,0.05061802,0.008733096,0.0027802954,0.016752403,0.011046037,0.10497168,-0.009229256,0.0102440445,0.025676534,-0.05850296,-0.006835132,0.10677441,0.006988872,0.058671895,0.041403413,0.051175643,0.02017023,-0.019434612,-0.00272736,0.024422029,-0.0373876,-0.057606198,0.0021877796,0.01862704,-0.05720525,-0.05256247,0.002910176,0.034789953,-0.03473709,0.061318714,0.013676902,0.008775175,0.0065967115,0.03547614,0.03458358,-0.076625265,-0.024250077,0.013937258,-0.035388622,0.036363006,-0.03286768,-0.03647633,0.07145181,0.01600674,0.03169886,0.0004531133,-0.021456936,-0.033920344,0.027522968,-0.011560541,-0.030848239,-0.007799376,0.015895978,0.016649295,0.010564964,-0.032010615,-0.029704273,0.022308921,0.031320263,0.0063638794,0.018765857,0.045512207,-0.019097188,-0.0148106925,0.004228907,-0.038174454,0.021616407,-0.013407575,0.029631944,-0.005033095,0.030889869,0.036088597,-0.027247356,-0.014707728,0.010376488,0.04057833,-0.008430082,-0.0700016,-0.02286154,-0.025425933,0.013297954,0.029733403,0.036650863,0.06381807,-0.011984422,0.09423846,0.022458209,-0.016955351,0.06799906,-0.037549604,-0.030676195,-0.0034868296,0.016264543,0.01699985,0.02974553,0.05434276,0.032443434,-0.017675208,-0.021828115,0.068959616,0.02755618,-0.021220032,-0.019345026,0.0398217,0.03882175,0.019538166,0.0029772834,0.012411712,0.03721707,-0.0442445,0.014765768,-0.090471774,0.013085258,0.051287293,0.007091155,0.013184761,0.0046993247,0.060132533,-0.02156882,-0.017545385,-0.020639686,-0.0122815445,-0.00090582506,-0.008958452,0.030612422,0.04317909,0.049961057,0.031966064,-0.007592529,-0.065265045,-0.029904848,0.08548417,0.009790927,-0.028115252,-0.07017897,-0.026292918,0.015712203,0.023263196,-0.016850108,0.041597337,0.013129846,0.011662904,-0.006727612,0.0005060932,0.04131988,0.0669319,0.04098679,-0.04015524,-0.008855449,-0.022200197,0.028255975,0.021581613,-0.0010178233,-0.033381496,-0.039804995,-0.03790472,0.043540705,-0.059729647,0.08203987,0.018874995,0.005651041,-0.048073046,0.04451374,-0.0052625192,0.022516564,-0.01923867,-0.011642917,-0.010085531,0.022058187,0.028454937,0.059533905,0.023145977,0.017086783,-0.024959376,-0.033412535,0.013444834,0.027816115,-0.024552915,-0.07196838,0.045076445,-0.03768736,-0.024449265,0.072749294,0.04911674,-0.007554281,0.07182967,-0.015608266,-0.045614697,0.013863137,-0.013321473,-0.021513322,0.121792994,0.02424826,0.008885561,0.033988606,0.0053307503,-0.08219004,0.030302098,0.006474497,0.006092305,0.06617293,0.004942556,-0.03783433,0.06421238,0.0040679886,0.00603268,0.056911886,0.032516874,-0.011490937,0.011147647,0.022491321,-0.033759303,0.012938006,0.025760736,0.0097845765,0.00096042984,0.019551588,-0.025708776,0.017092608,0.046185035,0.014402295,-0.044770367,0.02473619,-0.06392744,0.006565101,0.027786937,0.034933876,0.008212083,-0.03323797,-0.020312732,0.062383454,0.014513239,0.047258362,0.010022158,0.00334173,-0.06544514,0.014757563,0.025922395,0.027338333,-0.03973027,0.0088194115,0.002878986,0.007404561,-0.025625903,-0.035469107,0.002990417,-0.012690736,0.018837338,0.011936115,0.027048506,-0.07091051,-0.039600596,0.014412225,-0.040162574,-0.02671721,0.021323077,0.0525387,0.072128564,-0.10228842,0.039583843,0.011535562,-0.008552238,0.006966547,0.0032722775,-0.046811033,-0.008826902,0.03138917,-0.027658692,-0.016364492,-0.07052142,0.077434786,0.016595673,0.03461777,-0.002586172,-0.030177549,0.03293547,-0.03794914,0.0040224227,-0.0028953282,0.011954603,0.024344586,-0.07594412,0.0005213223,-0.0032704738,0.046683792,0.023101378,-0.010444975,0.019076817,-0.03083672,-0.02965582,0.0033639243,-0.024112834,-0.052366074,0.032298893,-5.6275592e-05,-0.0016475354,-0.026595475,-0.020654012,0.10021789,-0.049737845,-0.022811688,-0.031562105,0.0023095864,-0.063580446,0.019021042,0.015338797,-0.013708248,0.011192604,-0.018857874,0.010325043,-0.00057037914,0.02264439,0.00031981233,0.004009066,-0.022182519,-0.028405894,-0.007874688,0.01676791,-0.04759867,-0.027868029,-0.030367546,0.06739284,0.010811314,-0.006539712,0.027770089,0.027466718,-0.018855508,0.011338734,0.018746238,0.03080841,-0.06756682,-0.051138237,-0.03304057,-0.08351033,-0.001967751,-0.023170913,-0.039225917,0.023877462,-0.077146165,0.041746404,0.054064177,0.057653487,-0.023491982,0.020614196,0.020385768,0.05435035,-0.026935615,-0.0023257222,-0.010994988,-0.052715108,0.009463401,0.006956317,-0.040286813,-0.050738472,0.03191538,0.047317,-0.019231118,-0.015379946,0.022586735,0.03347615,-0.026209883,0.003677586,0.04610631,-0.009823911,0.023463594,0.0033462325,0.0044031567,0.011918081,-0.017752394,0.03441054,-0.0044598635,0.117053784,-0.030118298,0.08316308,-0.013708911,0.061884996,-0.038301036,0.0062284265,0.048242476,-0.012052434,0.030432405,0.061451085,-0.025418034,0.07118291,-0.01827367,-0.0027918483,0.03586247,-0.022268876,0.0015767209,0.0008171447,-0.013712946,-0.010017533,0.046338357,0.003395742,-0.020789336,0.10839686,-0.011352877,0.074918725,0.017744435,-0.009116388,-0.015617212,-0.013519255,-0.02187924,-0.07726371,0.047933068,0.032029662,-0.004375724,0.028192485,0.0074265096,-0.028796906,0.04343235,-0.007144858,-0.0074282167,0.05936643,-0.04309317,0.025149379,-0.019434957,0.02390263,-0.0006148185,0.0044803605,0.029002363,-0.06603494,0.018944962,-0.099188365,0.067255974,0.0089584915,0.00059703726,0.05391037,-0.03210484,0.009691532,0.026037555,-0.024242627,-0.0022277744,-0.039902516,-0.020852968,0.06307527,-0.0027728826,0.020376291,0.008396467,0.092948005,0.039031796,0.034292966,0.04304525,-0.0013936555,0.012987356,0.02610631,-0.104010224,-0.08467541,-0.010059069,-0.002619811,0.001402975,-0.040653676,-0.022660602,-0.002986217,0.009319446,0.0056607574,0.030218681,0.041126896,0.014672781,0.05033942,-0.020185774,0.033269327,0.048252247,0.006801871,0.0032099,-0.0055184695,-0.0006534778,0.06504921,-0.0057759252,-0.0320973,0.01805273,0.012312582,-0.011837673,-0.12649643,0.07086047,-0.011113109,0.047328167,-0.019219855,-0.03403211,0.0012263268,-0.06758822,0.003458545,-0.016139604,-0.030073876,-0.0039817374,-0.047088522,0.0018695516,0.02158171,-0.027823597,0.023201562,0.00051929406,0.019918775,-0.041003104,0.072427474,0.07168839,0.03757745,-0.016485117,0.0011421903,-0.015972186,-0.03591607,0.015984181,0.028750647,-0.039306268,-0.011112677,0.0375936,-0.0029738208,-0.053802267,0.049611546,-0.035029955,0.012939484,-0.0143658845,-0.05177864,-0.013657596,-0.012893852,0.027361112,-0.026024621,0.020329682,0.0031091738,-0.017441416,-0.0005800267,0.046338182,-0.0036686712,-0.030198377,0.016821418,0.005632851,0.054222867,-0.0104577625,-0.01911345,-0.03360271,0.0033100857,0.038571518,0.06313274,0.013897012,-0.012272757,0.042499643,-0.02268568,0.016240528,0.029204933,0.034000013,0.019747779,-0.002237785,-0.03633574,0.0028171365,0.06149882,-0.067251444,0.0010094707,0.048083976,0.031698436,0.016442707,0.04835451,-0.013832183,0.004444636,0.0068331077,-0.003032618,0.0057058157,-0.0842895,0.05348877,0.0068810973,0.015823042,0.054409597,0.0032645823,0.027837504,0.020052003,-0.053177282,0.04726527,0.027643256,-0.012026987,0.02973859,0.03185659,0.071552314,-0.00073628,-0.032477874,0.013243121,-0.000890945,-0.00036444032,-0.019579047,-0.036121648,0.05149603,0.050093688,-0.05168972,-0.024912868,0.004921423,0.05403675,-0.058510974,-0.047511473,0.053846993,-0.05914308,-0.008466221,0.019810485,-0.04781344,0.03751111,0.01892891,-0.012600364,0.02623056,0.0223386,0.082090914,0.034467317,0.0015064451,-0.019166019,0.019658394,0.013122522,-0.021312594,-0.0047088955,-0.011810183,-0.03666897]	\N	2026-07-28 20:11:40.724779
10	7	0	Tên địa điểm: Thảo Cầm Viên\nMô tả: Thảo Cầm Viên là một trong những vườn thú lâu đời nhất thế giới, sở hữu không gian xanh mát rợp bóng cây cổ thụ hệt như một khu rừng nguyên sinh thu nhỏ giữa lòng thành phố. Đến đây, bạn có thể tham quan hàng nghìn loài động thực vật quý hiếm, cho các loài động vật thân thiện ăn hoặc thư giãn với các trò chơi giải trí ngoài trời. Địa điểm này là lựa chọn tuyệt vời cho các gia đình có con nhỏ, các cặp đôi muốn hẹn hò bình yên hay người yêu thiên nhiên muốn tìm chốn xa rời khói bụi. Điểm đặc trưng nhất là những cây cổ thụ hàng trăm năm tuổi và Đền Vua Hùng cổ kính nằm sát bên trong khuôn viên.\nKhu vực: Sài Gòn, Quận 1, TP.HCM\nDanh mục: Khu vui chơi, Công viên\nHợp với sở thích: Thiên nhiên, Giải trí, Gia đình, Chụp ảnh\nĐộ phù hợp nhóm tuổi: YOUNG_ADULT (4/5), TEENAGER (5/5), CHILDREN (5/5)\nKhoảng giá: 40,000 - 60,000 VND	[0.07717646,0.0387973,-0.012522985,-0.06035109,0.01799036,0.037956532,-0.017700864,0.09314746,-0.00016494303,-0.0067205825,-0.050747167,-0.022905014,-0.0009921447,-0.019065667,0.0034894135,-0.021053428,0.0087808035,0.026826711,0.012362847,-0.016724646,-0.024459347,-0.008722446,0.0016831034,0.0056361277,-0.02475097,-0.021823108,0.0064208363,0.025348455,-0.0017525952,-0.060598318,0.04428366,0.019712955,-0.03166218,-0.06803581,0.081498176,-0.072632164,-0.041545395,0.06023315,0.08211219,-0.07865312,-0.015149486,0.016525634,0.026139801,-0.040478878,-0.025144514,-0.013510897,0.01563998,-0.015579278,-0.0050482615,0.015300188,-0.008206691,0.008035477,0.03982119,-0.023152402,0.005259283,0.004026631,-0.02852446,0.055595662,0.001742121,0.0087524215,0.01753967,-0.033814676,0.047875665,0.028409667,0.016126376,0.035575558,0.0035946032,0.007303549,-0.00992918,-0.017094798,0.011557177,0.028305445,0.0404053,0.019972667,-0.005415116,0.0029399008,0.0039687078,0.030996522,0.0053457133,-0.004835208,0.03257512,0.06697342,-0.045534253,-0.04341914,-0.016766412,0.06916057,-0.036807545,0.0014847256,-0.043115,0.042979013,0.025002504,-0.06246179,-0.06932512,0.041788597,-0.036677986,0.0034587018,0.0140163945,0.010651093,0.027733942,-0.037086923,-0.022013685,-0.002679777,0.03821617,-0.02142519,-0.015438662,0.020949475,0.021086192,0.023619024,0.012856507,-0.0011392767,0.02555965,-0.031863842,0.02093189,-0.01022727,-0.0151499845,0.019970233,0.020016927,0.012744434,0.045826502,0.010391061,-0.009591405,1.9416702e-06,0.0031823206,-0.06387088,-0.024442054,0.032194506,-0.040397692,0.00025398127,0.030593116,0.035657134,0.03825076,-0.014513037,0.029797578,0.042261835,-0.054332133,0.021707725,0.037989758,0.0025186373,-0.057706602,-0.010729361,-0.02633923,0.044022694,-0.014926468,-0.058826905,0.049959168,0.043310717,0.022644904,0.067618586,-0.04174135,0.016397871,0.020324517,-0.041590683,0.02210546,-0.022391094,-0.02212107,0.022279348,-0.00519681,-0.025783036,0.027786376,0.027785437,-0.03130504,-0.010249739,0.030114615,-0.015183682,0.016829493,0.022237284,0.017772233,0.027131448,0.10497078,-0.0102955215,-0.038104866,0.0526075,0.012220022,-0.016504565,0.062174283,0.030556334,0.048823386,0.09398721,0.050427314,0.0357199,-0.012501282,0.05406693,0.0100173475,0.012107454,0.0026346515,-0.006846836,0.08400663,-0.0760085,-0.026530664,-0.04148072,0.052253895,0.0013671506,0.03386445,0.034801405,-0.0071706995,-0.016172346,-0.04199391,0.02658522,-0.04097257,-0.0003449184,0.0061964192,-0.0024454966,-0.02408925,-0.048463278,-0.028093383,0.040233508,0.015887776,0.081593886,-0.03291751,-0.0010428099,-0.052838165,0.016579734,0.020239769,-0.0038242352,-0.011765135,0.06088801,-0.026520362,0.09143786,0.041937087,0.077608176,-0.0077300374,0.022213934,0.0038517881,0.05232438,-0.011429576,-0.078754276,0.033228006,0.038906377,0.029485075,-0.015324952,-0.06296965,0.010884989,0.022690369,0.052689396,0.025648208,0.03452908,-0.04068687,0.041958097,0.010190017,-0.0016396623,-0.014608601,-0.052092798,0.036974467,0.02510206,0.032455083,-0.031161962,0.0066680103,-0.021338973,0.040079404,0.04498946,-0.0023291423,0.028822362,-0.049962457,-0.019124396,0.011497196,-0.011077743,0.0043633133,0.009517481,0.0569777,-0.03527634,-0.0037279332,-0.030232435,-0.029141659,-0.04404959,0.024803314,0.02466216,0.06163716,0.023919107,0.05571458,0.0012667197,-0.04995873,0.017197981,-0.006860486,-0.024625087,-0.03755629,-0.024467064,0.02358895,0.024867369,-0.0007140603,-0.016916841,0.015060352,-0.04062915,0.02640329,-0.05877559,-0.036780182,0.042383924,0.030915534,0.040079758,0.029451706,0.008057825,0.0044294554,0.002575917,-0.010584345,-0.01988441,0.076008454,0.030956274,0.0071664006,-0.015518879,0.0046823956,-0.01802886,0.04024586,0.006128445,0.017848842,0.013225602,-0.04175174,-0.0034782535,0.011321761,0.018030807,0.025331665,-0.009952021,-0.01941715,-0.05341504,-0.023169637,0.03225111,0.033884577,0.024750216,-0.062241208,-0.03623099,-0.009734827,0.0025316854,-0.03442786,0.02627467,0.007306011,-0.035046834,-0.024769235,0.02293186,0.04776968,0.018244427,-0.032165386,0.024334189,-0.0065503567,0.0019751457,-0.0009164376,0.07367089,-0.071344696,-0.0023948506,-0.024677793,-0.027557174,-0.0039782566,-0.023261553,0.018071055,-0.035984967,-0.035919838,-0.04209387,-0.07302419,0.019314472,0.009517413,0.016746989,-0.012410316,0.017463103,-0.013212393,0.035296675,0.0044939625,0.031888746,0.012377841,0.04726176,-0.02108359,-0.001037218,-0.014036902,0.009622747,0.003009459,-0.01544793,0.033206943,0.050548494,0.018094748,0.01575086,0.033372965,-0.0006251678,0.029568555,0.00038239817,0.035705615,-0.009260656,0.050302837,0.047956098,0.0378297,0.01085207,0.032499995,0.0021789786,-0.018128116,0.03756449,0.013368323,-0.040437184,-0.014858079,0.021173432,-0.0027561926,0.031047763,-0.05014923,-0.06173656,0.015124656,0.02330606,-0.012887602,0.052477114,-0.0030521608,0.022459928,0.017693551,0.018312624,0.040547553,0.005058333,-0.02400432,0.015473285,0.05155654,0.044577744,-0.02320157,-0.021327065,0.022195008,-0.015860027,-0.03669767,0.011517674,0.04532899,-0.02792802,0.021733033,0.0034878892,0.06334298,0.014274214,0.0045563276,0.023449041,0.044487428,-0.004791355,0.0013523599,0.01779852,0.036292806,-0.016347704,-0.011864694,0.0021946796,0.0071361656,-0.008949808,0.012155099,-0.008309366,0.023862904,0.02835834,0.015544295,0.000907252,0.031457942,0.05945693,-0.021667067,-0.025218809,-0.06454009,-0.007361243,0.061113328,-0.056116253,0.029348165,-0.07675982,0.02204601,-0.0066003823,0.020080963,0.06824405,-0.034244776,-0.004106402,0.06300954,0.04168019,-0.007642304,-0.052421633,-0.0147452485,0.04945364,-0.06948827,-0.008694543,0.083843365,-0.0149864415,6.548289e-05,0.03530739,-0.06483169,0.08298363,-0.0016995769,-0.01151701,-0.05968579,-0.019435318,-0.09590503,-0.0056891423,0.009420053,-0.03287602,-0.029093046,-0.01915119,-0.037852883,-0.017888797,0.002433433,0.012545201,0.03593623,-0.06627547,0.040796734,-0.04432152,-0.022032114,-0.035701744,0.009289108,-0.009964895,0.09568701,-0.056220144,0.07476752,0.0010353617,-0.015446537,0.032881387,0.00044354616,-0.020507382,0.043768078,-0.037519604,-0.028164938,-0.021896448,-0.09757436,0.051771097,-0.01896578,-0.06381468,0.03150413,0.010771507,0.10749858,0.012255679,0.03343361,0.027750244,0.04315057,-0.03585477,0.08188667,0.010870903,-0.04226746,0.019059688,-0.020527467,-0.0008489251,-0.0280975,0.023830088,-0.0030189983,0.023878163,0.03681265,-0.0120685445,0.0077740857,-0.015443286,-0.010429085,0.011383736,-0.008820996,0.01012573,-0.04431275,-0.038943812,0.03497105,-0.0053941216,-0.024660468,0.020244738,-0.011218576,0.09016058,0.019038625,-0.024551673,0.06629609,-0.018004505,0.024622887,-0.055705238,-0.014065764,0.0033446047,0.038665134,0.023388814,0.049052224,-0.008364945,0.076169014,-0.032635983,-0.013198699,0.010325643,-0.014236231,-0.06869939,0.023208478,-0.041363616,-0.015613161,0.011030046,-0.04651789,-0.0012467037,0.030267699,-0.018171001,0.047941685,-0.029265529,-0.017228879,0.0125051895,0.039619718,0.03793213,-0.012941186,0.07042287,0.0414878,-0.037568457,-0.0121318605,0.03507661,0.017836677,0.0050653657,0.023365535,0.0011092381,0.06286798,-0.042777847,-0.029211508,0.0041238377,0.07911764,-0.0061934786,0.057557598,-0.0004149664,-0.070249215,0.021483362,-0.032510754,0.057299227,0.04342639,0.05285033,0.03501943,-7.5731085e-05,-0.004884723,-0.018313494,0.020760046,-0.0033014042,-0.013183802,0.044382766,0.03106071,-0.009180554,0.006285119,0.014795314,0.04313891,0.036142156,0.017406495,0.027997676,-0.026503382,-0.0052132835,0.032275133,-0.03782943,-0.065447986,-0.078232296,-0.0043986286,0.029729329,-0.02487295,-0.010305656,-0.033231013,-0.0136867175,-0.010486349,-0.04465302,0.052819878,0.019840963,-0.017356226,0.008292121,-0.010029678,0.021050809,-0.03607929,-0.03202754,0.01636675,-0.014562609,0.006862129,-0.043279883,-0.016002726,0.0061387853,0.0025408717,0.016843928,-0.03054305,0.03183791,-0.02886898,0.0054765088,0.03775869,-0.029257126,-0.00608331,-0.008159194,-0.05182368,0.04132328,-0.08018593,0.019134358,-0.0343803,-0.03499861,-0.04835497,0.040191732,0.021084387,0.006105887,0.0520188,-0.06659073,0.049394753,0.08935218,-0.045284692,0.024713945,0.0036874637,-0.021498475,-0.021135312,0.0675147,0.025900504,0.03746188,-0.03994445,0.0043848306,0.0010799841,-0.06894837,0.019596485,-0.007481032,-0.024960212,-0.012710675,0.00778784,-0.01602311,0.074993715,0.0736284,0.0057285675,-0.0038141115,0.056704186,-0.053980626,0.009241677,-0.006084574,0.01029643,-0.060727116,0.010726748,0.06970712,0.12279391,0.0029829314,0.0072702267,-0.024348607,0.01519946,-0.03897873,0.05537234,0.027282119,-0.0517924,0.002262004,0.0027480412,0.033867158,0.020756997,-0.022613583,0.01350073,0.048224557,-0.001043366,0.037344545,-0.010443637,-0.069080606,0.037180856,0.012375265,0.042085394,0.026779177,-0.10429958,-0.04945167,-0.00038144318,-0.005175413,-0.015307162,-0.048579946,-0.058359325,-0.005128665,-0.029327728,-0.04222911,-0.007254779,-0.010979152,0.07180263,0.012848786,0.008802953,0.049870793,0.03435581,0.025848424,0.021589393,0.05114565,0.039922934,-0.055834394,-0.019835321,-0.011129768,-0.022386422,-0.00021577354,-0.00030908204,0.028118154,0.052684475,0.03254393,-0.07474469,-0.04434978,0.025858847,0.07414764,-0.008160607,0.036263593,0.032564353,-0.014333265,0.025429081,0.0076429364,0.010499745,-0.024875544,0.0047866805,0.038743053,0.039300956,0.07102705,0.049079966,0.0038491641,0.016279731,-0.028708525,0.040004447,0.036720727,-0.027991414,0.041388564,0.05211234,-0.092946485]	\N	2026-07-28 20:38:07.757199
11	8	0	Tên địa điểm: Phố ẩm thực Vĩnh Khánh\nMô tả: Phố ẩm thực Vĩnh Khánh là thiên đường ăn uống về đêm sôi động bậc nhất Sài Gòn, đặc trưng bởi phong cách quán xá bình dân, náo nhiệt trải dài suốt dọc tuyến đường. Đến đây, bạn nên rủ hội bạn bè ngồi quanh những chiếc bàn vỉa hè, thưởng thức vô số các món ốc hương rang muối, nghêu hấp sả, hải sản tươi sống và lẩu nướng thơm lừng. Khu phố này là địa điểm ăn đêm tuyệt hảo dành cho giới trẻ, những người yêu thích trải nghiệm đời sống nightlife đường phố chân thật của người Sài Gòn.\nKhu vực: Khánh Hội, Quận 4, TP.HCM\nDanh mục: Phố ẩm thực\nHợp với sở thích: Ẩm thực, Nightlife\nĐộ phù hợp nhóm tuổi: YOUNG_ADULT (5/5), TEENAGER (4/5), ADULT (5/5)\nKhoảng giá: 0 - 1,000,000 VND	[0.025551131,0.07863311,0.021459555,-0.0009542355,0.034360044,0.04060198,0.0022165983,0.04057262,-0.013669253,-0.0010163251,-0.029331282,0.007571511,0.011956426,0.0072873547,-0.011841796,0.050468147,-0.007403756,0.02198463,-0.023036126,0.015490114,-0.0003293,0.0041604345,-0.030123143,-0.04326923,0.036530375,0.05928474,-0.003965651,0.013102673,-0.029410208,-0.06717797,0.05788801,0.017785517,0.0078122,0.0333517,0.047820773,-0.002861807,0.035093598,0.040843997,0.032401543,0.019059885,-0.025509005,-0.030393835,0.06589476,0.05746504,0.018816536,0.030647367,0.044293314,-0.04852428,-0.020521862,0.0570677,-0.04215902,0.025088357,0.021491153,0.044883646,-0.054147854,0.018546399,-0.015673742,-0.03619398,0.028140016,-0.012627847,0.041487597,-0.034385968,-0.0051152855,0.01649226,0.040463045,0.020082695,0.01579648,-0.016549857,0.012484336,0.013926048,-0.021556128,0.04622602,0.06451949,0.0019408545,0.0465567,0.010507496,0.0011728974,0.0463639,0.010034483,-0.022568766,0.0053410744,0.023015836,0.027601475,-0.025120247,0.0030830365,0.062786184,-0.04653685,-0.012911774,-0.0063402737,0.01641278,0.030053463,-0.001506681,-0.0050891796,0.0034048392,-0.017290356,-0.022070417,-0.007989132,-0.045186833,0.015863836,0.0036250637,0.047128838,0.012554181,-0.019704266,0.026959242,-0.00023190431,0.042015728,0.019773781,0.07588129,0.031486597,-0.013398823,-0.044492036,-0.035339713,0.051582497,-0.008434835,0.013802307,-0.0268019,-0.05521126,-0.01913666,-0.007757656,0.06588103,0.009621471,-0.03839463,0.024108056,-0.021950101,-0.010611141,0.028336389,-0.054224193,-0.015720095,-0.027734011,-0.042770103,0.06981541,0.017205162,0.014418188,-0.0074726576,0.005416613,-0.053094193,-0.0120510645,0.06399736,-0.025329474,0.045303825,0.02595183,-0.040442012,-0.02753436,0.04939284,-0.0017150121,0.069217086,0.013674434,0.029868457,0.02878951,-0.08210553,0.06827563,0.025663838,0.05919872,-0.010519648,-0.037866235,-0.010557233,0.05521814,-0.023819977,0.016463969,-0.01681259,-0.024655418,0.023323907,0.031615134,0.07737865,-0.0054589277,-0.055698115,0.035197906,0.061306424,0.097300306,-0.006116218,-0.0056555658,-0.026838165,-0.037337985,-0.01775424,-0.005214263,0.051564246,0.059912737,-0.0024509793,0.040494025,-0.014372366,-0.013843221,-0.0070504025,0.03588005,-0.024749704,-0.012817617,0.016598357,0.015529784,-0.0016449087,-0.023608943,-0.029172717,-0.009405394,-0.05015401,0.038893297,0.005181518,0.045464177,-0.048359428,-0.038571794,-0.0024487881,0.030129675,-0.014245787,-0.019445967,-0.03895325,-0.046649132,-0.04701257,-0.040012427,0.027946057,-0.018858109,0.041750204,-0.004117899,0.05717698,-0.0039099418,-0.032723077,-0.026505,-0.048903838,-0.0062333164,-0.012209388,0.020423517,-0.014056628,-0.024819091,-0.039402492,0.0227774,-0.02521897,-0.046153985,0.020268125,-0.04158168,-0.033784542,0.024032993,-0.0027051435,0.04764022,-0.026674261,0.009399074,-0.007797528,0.010368103,-0.007093673,0.050051454,-0.012714017,-0.018300533,0.02034616,0.008490723,-0.05505567,-0.07292562,-0.015445239,0.02327475,0.051017825,0.05100576,-0.019313982,0.03410648,0.0030184805,0.12036129,0.012142935,-0.03576248,0.08362125,0.004536526,0.014213876,0.026788047,0.0061808066,0.06170476,-0.0389795,-0.007968872,0.061508596,-0.017254137,-0.022019483,0.009995157,0.07176231,-0.029589206,-0.017606214,-0.026539749,0.0076563754,0.015904881,-0.027291162,0.046250127,0.0045244116,-0.042244095,0.009539861,-0.038096342,0.0032650558,0.0020318253,-0.033338133,-0.03523758,-0.02403725,0.091992535,-0.03600264,-0.02405692,-0.0065983846,-0.0059311064,0.00715813,0.027222699,0.045932513,0.024874844,0.05291158,-0.031231357,0.025589487,-0.10543849,-0.06021677,0.0027684993,-0.021117384,-0.01268495,-0.038539838,0.025630279,-0.042642042,0.013550979,-0.022980526,0.027818305,-0.01291312,-0.012035735,-0.014132114,-0.004987313,0.050561428,0.07250722,0.09073653,-0.04162653,0.0009371135,-0.012807136,0.004129239,0.05136498,0.020746205,0.05832369,-0.026227482,-0.010293631,0.059403934,-0.07347259,0.026046032,0.0013884146,0.017517895,-0.021531997,-0.028594362,-0.0053117177,0.01821077,-0.007556863,0.024857158,-0.04069554,0.020576457,-0.006505841,0.04047113,0.011728071,0.0615408,-0.005919605,0.042319484,0.03506497,0.004868161,-0.07236277,-0.035915587,0.009323995,-0.05882197,0.049421743,0.0034809436,0.030886827,0.0010619235,0.011331229,0.0009697384,0.024979405,0.02964338,0.030948747,-0.007159203,0.022024889,0.033781618,-0.015632162,0.008839044,0.0026384725,0.012759613,0.016408263,0.06297285,-0.032908686,-0.021588048,-0.033537265,-0.04074806,0.03583098,-0.057097,0.007901298,0.07095995,0.06689318,0.0102044195,-0.03839773,0.028278623,0.00388437,-0.009880679,0.011704166,-0.025396992,-0.03654909,0.035008915,0.04169492,-0.0051712813,-0.02391295,-0.0033190292,-0.016339967,-0.001215088,-0.0075970734,-0.025407106,0.054791868,-0.0050534094,-0.010044472,-0.044568002,-0.00864529,0.056632813,0.013389736,0.007083278,-0.04431044,-0.021240465,-0.081747025,-0.0017442254,0.01742581,0.064783186,0.0026788558,0.04739993,0.016279213,0.011444634,-0.07000413,-0.027058747,-5.0561386e-05,-0.022891315,0.010326218,-0.023545513,0.00024040203,0.03319071,-0.018881101,-0.052881557,0.06059789,-0.0051040063,0.047983307,0.040745113,0.056113705,-0.07089724,-0.0051946836,0.0013927483,-0.0008596177,0.015306306,0.0027568531,-0.018845098,0.03505506,0.0006277532,-0.0423712,-0.021687359,0.001872593,0.037950188,-0.02029135,0.06032945,-0.027952667,0.007712441,0.030041894,-0.0531256,-0.07841635,0.0047853747,-0.0230451,0.017501153,0.0104838,0.07259321,0.048936334,0.043597165,-0.05750798,0.02680525,0.0057487157,0.024305288,-0.055306148,0.013172213,-0.00837077,-0.0073618847,0.056516897,-0.042954724,0.024843661,-0.002146838,-0.037844073,0.039235286,-0.0029567732,0.032130532,-0.025726907,0.0063898494,-0.07746602,0.00026736464,-0.0077728634,0.01844562,0.016329154,-0.0065098736,0.013537932,-0.0023968595,-0.034388397,0.045166224,0.052725658,-0.036776323,-0.013482823,-0.035678852,0.044364974,-0.0671344,-0.042860746,0.02061091,-0.016434269,-0.00047731085,0.012348338,0.032710567,0.026519507,0.03603962,-0.049619555,-0.017955426,0.005745785,-0.0031733105,-0.02679891,-0.00070186553,-0.059886675,0.011572379,0.030175898,-0.039907776,-0.10560667,-0.07539919,-0.018053506,0.08142981,0.02203816,-0.001078501,0.021457091,0.00029844829,-0.015909517,-0.035098538,0.006243989,0.036004722,-0.004402966,0.040486753,-0.040950727,-0.0037707435,-0.047221903,0.034516443,-0.038180448,-0.021654433,-0.04748509,0.0314305,0.025915928,-0.03247838,0.010806866,0.062248155,0.014992563,0.029205589,0.020337362,-0.02539174,0.03252488,-0.033571463,0.009046149,-0.035725016,0.013466312,-0.012390117,0.051176775,0.017563406,-0.05427407,-0.025763795,-0.041298524,-0.047294546,-0.0065886215,-0.0012510822,0.018095573,0.0126476865,0.026276555,-0.017694816,-0.02094142,0.012625123,0.0017402293,0.01904609,-0.035329856,0.053354364,-0.00073652883,0.029057968,-0.009898853,-0.018176647,0.07691052,-0.05173727,0.04808021,-0.022927295,-0.032920532,-0.0049477494,-0.008433926,-0.018419404,-0.069440015,0.03777893,-0.016982403,-0.032211643,-0.0025735837,0.04358738,0.021537524,0.01207514,0.051072307,-0.017229322,0.014323314,-0.014850241,0.052744605,-0.01439327,0.039429586,-9.153629e-05,-0.0023030988,0.03453742,-0.054854732,0.0045316676,0.009424709,0.09055379,0.012141133,0.011177872,0.024993446,0.02206432,0.068704665,-0.0020377573,-0.11069707,0.041837484,-0.009750902,-0.02390619,-0.021854537,0.0038220903,0.0063048224,0.031738017,0.060469434,0.11134172,0.052294534,0.0036472795,-0.04681671,0.013309721,-0.005578724,0.01650158,-0.03387581,-0.021834366,0.032289278,0.0037238759,-0.012852873,-0.025799124,-0.046909463,-0.044090588,-0.029195094,-0.01289018,-0.0022891038,-0.03534457,0.02596229,0.0030197068,-0.008535163,0.059813257,-0.01401504,0.032125626,0.019222446,0.023324372,0.080121756,-0.003109048,0.035164516,0.0092699155,-0.014373528,-0.015635753,-0.1041547,0.031041993,0.008996519,0.018858941,-0.01513599,-0.05615519,-0.0018608031,0.010593171,0.012381555,0.027008936,-0.0012280064,-0.037343077,0.0030374236,0.04843042,0.0038814747,-0.0075980765,-0.012132077,-0.006585107,-0.010520678,-0.0035115909,0.06319084,0.06678789,-0.031435683,0.02431243,0.0075029563,0.013770465,-0.0064434414,-0.010762123,0.06149989,-0.088890254,0.0020124605,0.068475455,0.01981548,-0.069918275,0.055928543,-0.021592714,-0.041729067,0.009327884,-0.037293825,0.041103788,0.010383771,0.07177068,-0.049619738,0.031903766,-0.005429291,-0.03615676,-0.010292185,0.011525429,-0.0017398195,0.0067790095,0.018578772,-0.038434006,0.04372613,-0.055685733,-0.0057845633,-0.04812363,-0.004581692,0.039035834,0.038231183,0.030712534,-0.015179871,0.006477333,0.0131564895,0.040667325,0.046112124,0.021897828,0.013354028,-0.036857873,-0.054715272,0.011824355,0.046001565,-0.030444356,-0.035959523,0.070375666,0.004098671,-0.044114243,0.011011858,-0.0016808653,0.016991965,-0.018658468,0.056295797,-0.0045787753,-0.03466695,0.089043394,0.068442725,-0.0255011,-0.008106478,0.041944187,0.055263642,0.021315757,0.015000917,0.070027016,-0.03213669,0.031654175,0.0035493688,0.0784147,0.026508505,0.018161608,-0.0045664962,-0.023854088,0.04861126,-0.029542772,0.0056245117,0.036495406,0.039906878,0.024987437,-0.0668823,0.0015131319,0.027068948,0.09312391,-0.04871037,0.081119016,0.017441368,-0.054700505,0.0061170016,-0.004918622,-0.018296864,0.08665477,0.06554578,0.032160766,0.0076294327,0.06393038,0.0022171915,-0.026124304,0.011491713,0.028012922,0.027923016,-0.004513282,-0.020131549,0.010515076,-0.058359183,-0.029691007]	\N	2026-07-28 20:48:34.103549
13	10	0	Tên địa điểm: Công viên Tao Đàn\nMô tả: Công viên Tao Đàn là một trong những mảng xanh lớn và lâu đời nhất tại Quận 1, Thành phố Hồ Chí Minh. Nơi đây rộng khoảng 10 ha, được bao phủ bởi hàng nghìn cây xanh cổ thụ phục vụ nhu cầu vui chơi, tập thể dục và thư giãn của người dân.\nKhu vực: Bến Thành, Quận 3, TP.HCM\nDanh mục: Công viên\nHợp với sở thích: Thiên nhiên, Gia đình\nĐộ phù hợp nhóm tuổi: CHILDREN (5/5), MIDDLE_AGE (5/5), ADULT (4/5), SENIOR (5/5)	[0.0354745,0.029813739,0.012495282,-0.05235924,0.003206798,0.013839682,0.025559189,0.09454454,0.028807247,-0.009514227,-0.07054508,-0.016376792,0.049386173,0.008807893,0.0011321154,-0.0016912784,-0.009047204,-0.024784377,0.011729947,-0.01006904,-0.018016322,-0.015178769,0.011843958,-0.008968383,-0.01388649,-0.00462103,0.015910542,0.027911348,-0.020914666,-0.04523987,0.03449769,-0.018968228,0.0063150856,-0.063007236,0.041998148,-0.027739728,-0.012919857,0.0119171515,0.03776079,-0.029828655,-0.02595355,-0.0031658472,0.04387741,-0.047221873,-0.022574747,-0.028767606,0.023025507,-0.029602095,-0.0022728809,0.011405928,-0.022402953,0.0024838238,0.025399294,-0.019568639,-0.018354341,3.342394e-05,-0.0014326858,0.025181213,0.039724104,-0.003069948,0.029415576,-0.049393732,0.0112012895,0.035670508,-9.663596e-05,0.038284715,0.021080716,0.023959333,-0.022418264,-0.025714505,0.08047981,-0.034732923,0.046603717,-0.021931686,-0.01452907,0.031584594,-0.0067483666,0.015981115,0.0013867927,-0.026174571,0.04556295,0.01551313,-0.024606664,-0.07216805,0.049033374,0.08195856,-0.030242905,0.014234195,0.0029618957,0.012647918,-0.0060822116,-0.0066927103,-0.05535145,0.057351682,-0.004297998,0.004119338,0.008171586,-0.007822292,0.0047190757,-0.048336755,-0.02003645,0.0014216095,0.08625283,0.0062417886,-0.01527226,0.023360182,0.03163604,0.035580125,0.0068971897,-0.0077597266,0.017111035,-0.039835207,0.038194448,0.0261567,-0.046794545,-0.0071007544,-0.00432049,-0.014063941,0.024841236,-0.038343973,0.010346086,0.01961741,0.0138762,-0.055092357,-0.047129445,0.03120145,-0.052269623,0.01704296,0.037510954,0.020505365,0.00810626,-0.045197792,0.032566004,0.030821437,-0.049805578,0.009180733,0.013339967,-0.00048511155,-0.07763548,0.001028741,-0.011035565,0.06698171,-0.043820757,-0.006654366,0.035082724,0.022959745,0.034915406,0.08237806,-0.031888872,-0.012632487,-0.0108171785,-0.059256002,0.022387974,-0.006455519,-0.031135049,0.0011996797,0.0034923693,-0.0053337878,0.028015453,0.0109685045,-0.07087539,0.000103238264,0.04005247,-0.010071055,0.01724845,0.0002294196,0.0025976233,-0.008392332,0.083516486,-0.015164726,-0.023182318,0.09612291,-0.0052948305,-0.012308518,0.026844572,0.03850282,-0.023123777,0.06586147,0.032167636,0.04214066,-0.019253297,0.06192637,-0.023887487,0.036592606,-0.060217556,-0.021578101,0.06662825,-0.06934672,-0.02538971,-0.028390663,0.05166333,0.043360677,-0.003021763,0.049448594,-0.049816165,-0.01078385,-0.013993265,0.047280237,-0.031902898,-0.0089481035,0.008718989,-0.003474712,0.014565111,-0.049812946,-0.032174837,0.050758313,0.0047735632,0.045009486,-0.032874428,-0.034101762,-0.065212674,0.009600478,0.004060585,0.0028019724,-0.014281291,0.03979466,0.008973927,0.06965243,0.010797564,0.040415343,-0.0050803283,0.02868608,0.0341957,0.033548072,0.035412833,-0.04892023,0.028726209,-0.025752189,0.037338953,-0.042871974,-0.06871948,0.019754479,-0.013417297,-0.012397341,0.03623279,0.04384059,0.003965557,0.015613017,0.016116092,-0.010419691,-0.020860814,-0.03598994,0.03353066,0.034970608,0.018945364,-0.056424793,0.021329362,-0.046372384,0.08533679,-0.0034492027,-0.026125254,0.018950535,-0.03945062,-0.026870603,0.020038113,-0.016366204,-0.012198112,0.015338392,0.08933181,-0.046012092,-0.010228615,-0.015272114,-0.033126548,-0.016963083,0.03416293,0.023091583,0.04924393,0.007055026,0.034027167,-0.025276646,-0.07784099,0.036501598,-0.039296787,-0.0027095869,-0.019905554,-0.013091486,0.019486338,0.01695558,-0.0058459127,-0.029118147,-0.005146588,-0.025797317,0.009129982,-0.033786274,-0.09761957,0.022159074,0.0083306255,0.021750923,0.040997583,0.007288586,0.0022495307,0.015400423,0.013697722,0.021095313,0.047747713,0.011395367,0.011110344,-0.042107243,-0.027890557,-0.027068349,0.036495756,0.031627648,0.004793609,0.04549765,-0.0030993202,0.016804555,0.030598864,0.03406556,0.044176117,-0.049849156,0.0012094954,-0.04954296,-0.0447879,0.042660236,0.02481208,0.013878812,-0.04226548,-0.062977076,-0.0062994207,0.019435631,-0.034394417,0.03337935,0.0007679872,-0.017349584,-0.058985952,0.036333073,0.03745766,0.011256932,-0.046236515,0.022508914,-0.021395387,0.00994993,-0.00043066434,0.058632325,-0.053005293,-0.015831007,-0.031709395,0.025303124,0.003945072,0.0096618915,0.016466651,-0.01717564,-0.058024988,0.0023099412,-0.041411933,-0.009661862,0.0010349283,-0.028724218,-0.020056685,0.001712425,-0.057616055,0.0408122,0.013040239,-0.005906781,0.06763029,0.036595643,-0.0058442983,-0.0032802615,-0.016062725,-0.04068486,0.004911468,0.014489339,0.025764152,0.03192695,-0.0013702939,0.032913778,0.032923233,0.0019825802,0.049068138,0.047134362,0.008465818,-0.019679554,0.008150153,0.046943855,0.02250822,0.035514656,0.03936698,-0.021168312,-0.0067103417,0.035619136,0.025642492,-0.059454728,-0.030756665,-0.0015336841,0.040646806,-0.009181315,-0.03970394,-0.044758216,0.053183917,0.015309763,-0.012679,0.08167778,0.00037407945,0.004025596,-0.022602465,0.026071101,0.0021263533,0.019606942,-0.016698375,0.030130966,0.029496908,0.069834076,-0.046882328,-0.012254917,0.044395182,0.017771207,-0.036748845,-0.0025963038,0.04035741,-0.028612757,0.019168166,-0.0017866475,0.007168687,-0.04309517,-0.0013312394,0.045754496,0.015906343,0.020466745,-0.010126722,0.009295611,0.03675371,-0.052706305,-0.0009579138,0.02664135,0.029605672,0.004790665,0.01583491,-0.01934547,0.05058597,0.048141453,-0.0047828765,-0.021011489,0.01596959,0.022588437,0.024286965,-0.040501542,-0.025669716,-0.02692758,0.030982872,-0.08276119,0.052932967,-0.06524248,0.000741559,0.015093728,0.0132024875,0.06457862,0.0059569976,0.02939722,0.052246053,0.034846846,-0.015721394,-0.06320279,0.027938938,0.0559664,-0.07253879,-0.0032147963,0.04402297,0.007722052,0.00575256,0.040044516,-0.051759776,0.11553481,0.018408157,-0.0015007138,-0.05721435,-0.034787636,-0.09688268,-0.000799989,0.058470085,-0.00923203,-0.008596435,-0.0051682633,-0.0525419,0.0019197369,0.007221735,0.050784547,0.006676849,-0.07795865,0.06585196,-0.017305119,-0.027919423,-0.045503322,-0.034991305,-0.025006091,0.07905653,-0.0027266087,0.061003055,-0.022053197,-0.0012013686,0.060246076,0.0006231387,0.008930447,0.051096313,-0.029214064,-0.012975409,-0.04368869,-0.035324544,0.0034787417,-0.0140864635,-0.07770233,-0.010262038,-0.0057113674,0.08221721,-0.015783401,0.06981699,0.02096994,0.055490937,-0.03974917,0.0701688,0.0220668,-0.009749126,0.013198469,-0.01132407,0.009756305,-0.014239918,0.03182388,0.013550938,0.06923002,0.03579169,0.0014015554,0.014676586,0.0069594528,-0.016247816,0.0075077084,-0.018124865,0.008582868,-0.0212439,-0.02969758,0.039670184,0.033867244,-0.035476077,0.050875336,-0.036367618,0.07294189,-0.006507987,-0.009370064,0.09689663,-0.00945054,0.016671347,0.0046858354,0.0047326833,0.027118966,0.039193973,0.008379304,0.037711624,-0.019261584,0.10218763,0.0027875002,-0.007504381,0.0043313927,-0.00690405,-0.0643032,0.032281496,-0.033288203,-0.03419254,-0.0035912492,-0.031508032,0.03784575,0.06302189,0.027754959,0.04390668,-0.013868808,0.010325056,0.0224532,0.05313503,0.020593075,-0.016042437,0.07124649,0.04198552,-0.009941555,-0.015837058,0.043043066,0.019995175,0.0399566,0.022077901,0.0170648,0.047861494,-0.010270135,-0.030299,0.02681177,0.043674204,-0.010858218,0.0024304283,0.05749932,-0.0530486,0.025864977,-0.044543203,0.08250143,0.0050077275,0.030027684,0.040962216,-0.020081092,0.0021864078,-0.022285616,0.010613463,-0.024010146,-0.0413507,0.068354584,0.0406906,0.0061487025,0.008395302,-0.0012294119,0.06039203,0.055811442,-0.0013196595,0.017560618,-0.0041730604,0.019761834,0.029660719,-0.03148114,-0.04853084,-0.092687085,-0.005336886,-0.027298333,-0.04370284,-0.025881846,0.025212651,-0.02950878,0.019646289,-0.08195451,0.04503217,-0.0011472121,0.03902787,-0.018550768,0.010354084,-0.0038617947,0.050998002,-0.037923954,0.0020914199,-0.021597566,0.019588063,-0.02301711,-0.022018641,-0.015064795,-0.0008980175,0.0073193754,-0.040264487,0.04037795,-0.010376806,0.056029473,0.0026668375,-0.01591772,-0.027844282,-0.011320026,-0.0062856623,0.020982563,-0.049777072,-0.011497328,-0.07715775,-0.008119959,-0.022110954,0.043410733,0.02157991,0.038457073,0.04275932,-0.06687051,0.032863364,0.085669965,-0.06267166,-0.008558485,0.022494053,0.0045280657,-0.01605285,0.026836129,0.028138982,0.047689945,-0.0006423037,0.029199066,0.011965994,-0.08024484,0.022944745,0.019490786,-0.024669893,0.014595212,-0.018364392,-0.029659703,-0.015882794,0.06736676,0.037018463,-0.011244912,0.080727905,-0.05200634,0.016404582,-0.043062784,0.023872893,-0.049172264,0.06985089,0.046215042,0.08793712,-0.0077535287,-0.022123074,-0.04009669,0.017497644,0.015845057,0.038370576,0.052556366,-0.0058235847,0.017184911,0.0104217995,0.051917195,0.00422241,0.011364064,-0.007142498,0.04371978,-0.021866897,0.018709771,-0.0056879614,-0.06375996,0.0030178393,0.029781204,0.05910675,-0.00036429468,-0.10201448,-0.004358531,-0.016982727,0.03026153,-0.018633323,-0.02815524,-0.060847815,-0.011410411,-0.06920069,0.005452894,-0.006420988,-0.020615177,0.05667416,0.019784171,-0.09302825,0.02586173,0.011202293,0.001499704,0.031253606,0.03387475,0.033953905,-0.04789602,-0.04369146,-0.0056113275,-0.065635785,-0.030651025,0.017113622,0.03632305,0.05319951,0.040929377,-0.056104742,-0.027831059,-0.019245937,0.08995375,0.0037444306,0.018942717,0.016451081,0.0014010246,0.013581906,0.011788192,0.008726249,-0.034324758,0.016733356,0.0314948,0.053405263,0.0767574,0.027268937,-0.06258364,0.0019460082,-0.014075662,0.06462404,0.02832681,-0.03561627,0.024468156,0.046785194,-0.03065346]	\N	2026-07-28 21:15:13.065185
14	11	0	Tên địa điểm: Công viên nước Đầm Sen\nMô tả: Đầm Sen là một trong những khu du lịch lớn đặc sắc nhất nước Việt Nam. Kiến trúc được kết hợp một cách hoàn mĩ nền văn hóa Đông-Tây và một chút vẻ đẹp thời La Mã. Ngoài những khu vui chơi, Đầm Sen còn có những nhà hàng, khách sạn và hàng chục các loại hình khác để phục vụ khách du lịch. Đầm Sen là nơi vui chơi giải trí rất hấp dẫn cho người trong và ngoại nước.\nKhu vực: Bình Thới, Quận 11, TP.HCM\nDanh mục: Khu vui chơi\nHợp với sở thích: Giải trí, Gia đình\nĐộ phù hợp nhóm tuổi: CHILDREN (5/5), TEENAGER (5/5), YOUNG_ADULT (4/5)\nKhoảng giá: 180,000 - 220,000 VND	[0.019665878,0.06012663,0.015489586,-0.03184192,0.027636403,0.054214716,0.0039421115,0.07307297,0.021425541,9.440528e-05,-0.065293625,-0.00971012,-0.005522415,0.0031201455,-0.018532082,0.029874265,0.0042553986,-0.024359228,0.027647046,0.0111908,-0.03209443,0.01421996,-0.013955121,-0.017092692,0.022547629,-0.011166181,0.06252026,0.034633163,-0.012764027,-0.0318491,0.053116944,0.010004699,0.0455535,-0.04191515,0.031647816,-0.019418975,-0.020405658,0.036326647,0.014835991,-0.005929825,-0.02203869,-0.029578887,0.06998425,-0.0049575428,-0.041332416,-0.038210783,0.012017591,-0.018907929,0.014340393,0.07168553,-0.013414745,0.06282941,0.041443694,-0.01038818,-0.07227762,0.028413212,-0.0032707662,0.01932539,0.023962153,-0.015631145,0.023438489,-0.075985,-0.0075949426,0.06294386,0.04057802,0.009072873,0.01587575,-0.005449033,0.019683307,0.027311714,0.052855834,-0.067345485,0.024756134,0.028498037,-0.021867763,0.023682399,-0.027160037,-0.003157845,-0.027403511,-0.006347463,0.03200535,0.034938022,-0.024882583,-0.054968365,0.03805515,0.1071754,-0.04533238,-0.033254407,-0.019186221,0.025282653,-0.049291797,-0.030734072,-0.019899938,-0.0016668034,-0.015048861,-0.024454057,0.031112855,-0.03234015,-0.020933647,-0.010170336,-0.018848265,-0.053067528,0.062329475,0.01013044,-0.030768458,0.010588308,0.043949876,0.0023718835,0.020688685,-0.017620321,0.028337542,-0.02589612,0.03763348,-0.01323797,-0.041404244,0.022698188,-0.051732827,-0.018875426,0.072514124,-0.015390482,-0.026207823,0.025476502,-0.0028246744,-0.055929575,-0.06651907,0.011109901,-0.062469177,-0.0195994,-0.017697793,0.047731962,-0.008007198,-0.025217496,-0.007935034,0.03302579,-0.040877447,-0.01338409,0.03418584,-0.010571669,-0.035333507,-0.012037792,-0.01460413,0.027602632,-0.024608567,-0.051150504,0.0039964407,0.053996485,0.04510049,0.032840434,-0.038863506,-0.059416838,0.0020054479,-0.01185783,9.356716e-05,-0.0016480021,-0.009356827,-0.0385151,-0.0013955655,-0.035969716,0.018034954,0.01292334,-0.055800747,-0.028302204,0.066334516,-0.015141841,0.036174767,-0.018061746,0.04435326,0.033385213,0.038876392,-0.0015003019,-0.021878729,0.08440335,-0.037132706,0.007327457,0.07894092,0.031536654,-0.0020853162,0.036320142,0.014836219,-0.020677814,-0.003979077,0.06108264,0.026888473,-0.0060933954,-0.00584207,-0.03936557,0.06768598,-0.060656827,-0.0070474884,0.011319305,0.004925259,0.008726853,0.066985026,-0.0007430196,-0.037597805,-0.043674383,0.014731272,0.018334862,-0.010145998,-0.06274167,-0.016818363,-0.019112602,-0.014443313,-0.050510034,0.0107278535,0.10898083,0.028872505,0.05442738,-0.011874873,-0.013179502,-0.011249107,0.0023897232,-0.036090333,-0.015408948,-0.019488972,0.03535588,-0.0234591,0.014247881,0.06691333,0.02697039,-0.0010120193,-0.0026999437,0.03561099,-0.0010027046,0.040526427,0.005513352,-0.006394434,-0.049494214,0.028158806,0.006387556,-0.06192965,-0.013041329,-0.003420429,0.0300216,0.05061234,0.0026660834,0.036084622,0.012165311,0.028084002,0.002328246,-0.0376003,-0.04240437,0.018119063,0.04729745,0.018082391,-0.05809701,-0.03771801,-0.07558712,-0.01098261,0.05595515,-0.020665469,0.043284215,-0.043736722,0.0120268855,-0.0037112585,0.007913578,-0.007975037,-0.018502073,0.048918366,-0.0038390518,0.044362772,0.00029935793,-0.029055486,-0.0027567118,0.0075719743,-7.951617e-05,0.04656102,0.024787813,0.049450316,0.028407767,-0.015929125,0.038341675,-0.056040537,-0.018088022,0.0007333752,-0.036945943,-0.022869725,0.054185852,0.019266473,-0.054136995,0.03519791,0.011455891,0.032064408,-0.0010428907,-0.059077196,0.054620948,-0.019389436,0.052878752,0.04375058,0.04143836,0.0024769865,0.036369704,-0.004314452,0.043520913,0.035566572,-0.016450884,0.021125397,0.0056984066,-0.017839184,-0.03312238,-0.006516178,-0.020973444,0.006782327,0.02698885,-0.058535106,0.008112406,0.012005002,-0.03895114,0.040422853,-0.0034961312,-0.013189878,-0.057666257,-0.01188292,0.07888637,0.035691205,-0.0018700681,-0.01575321,-0.05592267,0.072758086,0.04174805,-0.009805704,-0.01800295,0.03422398,0.0182299,-0.053682037,0.04509322,0.06770545,0.02080455,0.009811219,0.036639966,-0.016225396,0.018176254,0.017686639,0.022183368,-0.02755398,-0.008378459,-0.022997368,0.012011192,0.040701173,0.030705638,-0.014938817,-0.028764458,-0.009969663,-0.03326632,-0.015053431,0.053630784,0.003328056,0.01310182,0.028156785,0.007091762,0.04166865,0.02760271,0.02796247,0.024818784,0.07823088,-0.009275942,0.0043014544,0.0014957333,-0.03703285,-0.025886893,-0.02453635,-0.03642814,-0.039155457,-0.01824753,0.015268579,-0.0039176075,0.021951698,0.044809237,0.012551593,0.0830337,0.0023804633,0.0052502407,-0.005460308,0.05062157,-0.010168341,0.05662736,0.030204318,-0.038047172,-0.021681348,0.007253302,0.0037684978,-0.036168993,-0.016750505,0.033667028,0.056009516,0.03976202,-0.07152374,-0.039860826,0.060755864,-0.023067372,-0.03857488,0.04879344,0.011839558,0.009068142,-0.06189697,0.057809744,-0.0065056104,0.020804359,-0.01722565,-0.009703611,0.020928707,0.07481957,-0.0470749,-0.018425906,0.035176147,0.017639916,-0.041839898,0.0064941933,0.07239948,-0.0013160581,0.017389134,-0.026494669,0.008729295,-0.03663754,-0.009402863,0.025657624,0.03624455,0.039828397,-0.03422272,-0.029300591,0.00325203,-0.0183198,0.027902767,0.032079186,-0.009693736,0.0077325776,-0.0105403615,-0.044865347,0.021705376,0.055588204,-0.02685015,0.04029037,0.05958568,0.007731491,-0.00993605,0.017677596,-0.053883415,-0.0056414567,0.02974866,-0.033640403,0.003921992,-0.09866922,-0.008445462,0.04394755,-0.052815214,0.035875157,0.0205494,0.026519574,0.011825058,0.01517545,0.033276044,-0.05300431,-0.032105196,0.014548787,-0.033369016,0.009071963,0.06678245,-0.035353787,-0.00992865,0.019352535,-0.049689174,0.08015373,0.07705093,0.015781723,-0.052399132,-0.022953462,-0.09309273,-0.014196295,0.03560201,0.02201939,-0.01525968,-0.014677921,-0.0068910113,-0.030553078,0.0520622,0.046921927,0.020194124,-0.025151486,-0.008953121,-0.03286757,-0.02385007,-0.052663654,0.002020357,-0.0029922735,0.098003685,-0.01407046,0.05812276,-0.0077133845,0.042143404,0.055751614,-0.0476291,-0.017659223,0.07162302,-0.043086722,-0.025794407,-0.00812144,0.0069429507,0.082935214,-0.039357867,-0.016993186,0.028036995,-0.060346298,0.025402678,0.010975595,0.038847722,-0.012122615,0.055586226,-0.012703923,0.07884054,0.013276184,-0.011757647,0.050561998,-0.010785438,0.010692235,0.027058715,-0.037421823,0.0066770916,-0.01031402,0.031430464,0.025562363,-0.044400733,0.007714455,-0.0069765137,-0.0014671483,-0.033319812,0.009853124,0.023517935,0.004962514,-0.019876845,0.03756935,0.004286276,-0.009910736,-0.023889547,0.010225519,-0.00865104,-0.01901489,0.06510321,0.034316372,0.041478865,-0.025444306,-0.01616593,0.016915793,-0.029562809,-0.023983365,0.014823106,-0.0104288235,0.071139865,0.0029212886,0.0094694365,-0.04392514,0.023405379,-0.0010482554,-0.013413111,-0.049302075,0.015153878,0.034136422,-0.030544588,0.0035912464,0.052929893,-0.05757898,0.06930448,-0.045314144,-0.034753054,0.005155425,0.043384656,-0.017613724,-0.023918688,0.06301808,-0.0038115003,-0.052508045,-0.020107064,0.056299195,-0.043868132,0.025509596,0.073473155,0.022506846,0.056816835,0.0017814706,0.040660232,0.022086391,0.041512337,-0.0061320094,-0.016715657,0.058396675,-0.07043239,-0.031883385,-0.03274926,0.13134685,-0.050658397,-0.00846404,0.036383588,-0.023019308,0.008129121,0.042547163,0.0044674356,-0.02538387,-0.056786552,0.0118554905,0.014783308,0.019253798,-0.0054155923,0.0039433884,0.07112947,0.080482036,0.027601184,0.014350095,-0.0031474875,-0.02048142,0.0322899,-0.027140522,-0.04803805,-0.023214469,-0.007099467,-0.016254783,-0.0063635055,-0.03283117,0.016040886,-0.02031434,0.0030126893,-0.0659439,-0.008222103,-0.007918574,0.04188501,-0.0038569898,0.024748873,-0.018375963,0.05067835,-0.0030828356,-0.029957186,0.0022756052,0.019735698,-0.030790318,0.010004173,-0.045969702,0.028986651,0.024254099,-0.032440916,0.009321524,-0.038351644,0.0858144,-0.016553257,0.04511293,-0.061005075,0.040715948,-0.008948821,0.00031053065,0.013830372,0.03714032,-0.042289324,0.01940532,0.029514005,0.023330234,-0.009331391,0.056211136,0.036879964,-0.054543864,0.057418816,0.041020792,-0.09239561,-0.030185048,0.007916579,0.0024382577,0.021757487,0.00715269,0.008196104,0.047840282,-0.010031312,0.02191188,0.020582637,-0.059380293,0.06723563,-0.04829904,-0.008815547,0.005659453,0.010192242,-0.020947214,-0.016903678,0.04670214,0.04456496,0.0236998,0.044373624,-0.04225872,-0.020028193,-0.046193074,0.030106176,-0.037479114,0.06710032,0.026132753,0.08402699,-0.041924447,-0.049080692,-0.059009377,0.0050695585,-0.019389926,0.04177581,0.012083334,0.0042807697,0.063025944,-0.028640585,0.084294185,-0.0071703694,-0.027065754,0.060526203,0.011994243,-0.0501317,-0.016984437,0.04054438,-0.084028095,0.01074076,0.02840522,0.021119293,0.028450202,-0.052594177,0.0024607745,0.020520614,-0.024463078,0.02729406,-0.021794554,-0.033849794,-0.0018281678,-0.05703227,0.019079426,-0.007844722,-0.01118365,0.06760301,0.015279464,-0.06793692,-0.01226774,0.014736022,0.03244362,0.047180425,0.032648996,0.08946508,-0.06482916,0.0014430971,0.012370526,0.0003013984,-0.035632618,0.033248983,0.022711385,0.04349255,0.04682801,-0.05112262,-0.03481502,0.03605893,0.05618174,-0.035326518,-0.001071194,0.017448934,0.019857496,0.0015527654,0.021327164,-0.033382237,0.03474185,0.0067280997,-0.015693314,-0.001052783,0.06308071,-0.00690878,-0.019534035,0.018259643,0.022537673,0.0138862915,0.04780094,-0.0063629593,-0.012253782,-0.01730506,-0.013676554]	\N	2026-07-28 21:33:44.418838
16	13	0	Tên địa điểm: Đường sách TP.HCM\nKhu vực: Sài Gòn, Quận 1, TP.HCM\nDanh mục: Phố đi bộ\nHợp với sở thích: Chụp ảnh, Giải trí, Gia đình, Văn hóa\nĐộ phù hợp nhóm tuổi: CHILDREN (4/5), TEENAGER (5/5), YOUNG_ADULT (5/5), ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (4/5)	[0.042588532,0.016658079,-0.0047143134,-0.081947245,0.033762746,0.023421196,-0.01556751,0.06507378,-0.010618163,-0.022504935,-0.10021974,0.03381582,0.03425308,-0.0012962688,-0.013474419,0.02780266,-0.033540595,0.007906501,0.0039655175,0.008692912,-0.008979245,0.007508444,-0.024548352,-0.020354433,0.0039413883,0.033070255,-0.014993835,-0.018898588,0.0014624258,-0.054369505,0.07154314,0.036952127,0.018565651,-0.026682295,0.017245866,-0.03435427,-0.036465272,0.061405495,0.019362682,-0.030835753,0.041027218,-0.038798355,0.053512108,-0.030822348,-0.06743089,-0.03394902,-0.03677093,-0.052166943,-0.017575804,0.07357658,-0.0133897,-0.00096967927,0.039743397,0.028761186,-0.02190503,0.023025908,-0.0013318277,0.037802488,0.11002028,-0.01440437,0.0012018854,-0.062164266,-0.0066702096,0.04702143,0.038896583,0.031093864,0.009322012,-0.030096687,0.011327155,0.012595188,0.061133463,0.062155094,0.04476591,-0.021079438,0.022636175,0.029920973,0.01188366,-0.0050301948,-0.005290194,0.026793266,0.021016875,0.0023778516,-0.0046440703,-0.011385701,0.04108218,0.02656714,-0.06004485,0.022792522,0.05901483,-0.015495483,-0.03946814,0.0118453745,0.015681464,-0.014304458,-0.013878263,-0.03954919,0.032674205,-0.009301574,0.009264789,-0.07423535,0.012664809,0.0007087244,0.050003607,-0.02092888,-0.031113807,0.028777467,0.025399098,0.027804622,0.011743152,0.0022125472,0.0031740593,-0.04290941,0.06419929,-0.030840745,-0.036536496,-0.030476209,0.024555072,-0.03808828,-0.009492748,-0.021116013,0.011376262,0.05067194,0.0132470485,-0.0038444102,0.05104305,-0.018813876,-0.0319587,-0.010311476,-0.033146445,0.031190991,0.019201206,-0.04488449,0.010329395,0.03404762,-0.021817032,-0.013571785,-0.008986243,0.008168145,-0.040994827,-0.009136712,-0.011958971,-0.01963361,-0.03005267,0.02697436,0.012221905,0.006180471,0.042301305,0.07336464,-0.053103745,-0.048337728,0.037847687,0.009596048,-0.03239028,-0.02213813,0.015213497,0.008819725,-0.02463561,-0.012605891,0.005929145,0.008516122,-0.019354703,-0.0002737183,-0.0037525257,0.0077540046,0.04357725,-0.014059706,0.00029728765,0.019477826,0.07592714,-0.04743546,0.004900298,0.052162174,-0.061049737,-0.0005030414,0.11914576,0.034877665,0.048120394,0.063445,0.022761544,0.0048230854,-0.05368208,-0.010045314,0.001797388,-0.010307937,-0.042273253,-0.03584026,0.05725647,-0.086819954,-0.00785294,-0.024738284,0.050851773,-0.0054221335,0.00722066,0.033415742,0.038200025,-0.032548223,-0.036643006,-0.0003941575,0.009162228,0.041019112,-0.025284376,0.005958862,0.011930247,-0.05520199,-0.05444191,0.07876966,-0.03062561,0.019452967,-0.0084283445,-0.022339668,-0.023319593,0.073219165,0.024198273,-0.040083367,-0.072525546,0.016765632,0.025974333,0.030029844,0.021581072,-0.00088634354,-0.015809922,-0.025762537,0.026399532,0.00079250534,0.05429154,-0.04322832,-0.0002861875,-0.042989258,-0.006613615,-0.0044665067,-0.057348616,0.01677122,0.012548584,0.034245458,0.0027770374,-0.0018114328,-0.03697904,-0.033361517,-0.009746559,-0.004484655,-0.04467455,-0.024660874,0.02162416,0.028597951,0.033879705,0.010353659,-0.015934777,-0.032841623,0.11199978,0.04718737,-0.025543429,0.093983576,-0.011435562,-0.006596068,0.0057287104,0.029160619,-0.02299986,0.002978207,0.04799201,-0.02030989,0.015752638,-0.016993063,-0.012362889,-0.06580491,-0.017139727,0.042794023,0.029243534,0.027885351,0.017789248,-0.02900147,0.0010832926,0.0079555055,-0.02198791,-0.028979527,-0.058992144,-0.018653749,0.045784187,0.042499166,-0.03493527,-0.008183218,0.0761301,-0.011905738,-0.024273869,-0.02970416,-0.052199055,-0.007455272,0.04909265,0.074862435,0.049058244,0.05525984,0.031744245,-0.003032995,-0.08902994,-0.012077342,0.05371793,0.050819438,0.032243308,-0.0002624686,-0.036952853,-0.071737945,0.052026846,-0.0069582006,0.035512626,0.017087758,0.0048839645,-0.009480498,0.013772981,0.027443325,0.07127078,0.025249336,-0.01215184,-0.002813965,0.023013435,0.019222155,0.01797591,0.022100888,-0.032431897,0.008549801,-0.013216168,0.0066529484,-0.098479874,0.03828618,-0.00083642174,-0.0401431,-0.0406284,0.013756645,-0.0048005437,0.027343346,-0.058156736,0.016848663,0.02590297,0.01561798,0.023113146,0.044861652,-0.008444077,-0.002493032,0.014927913,0.024362493,0.007496616,0.0812961,0.005821269,-0.038764767,0.010883759,-0.026403764,0.015683316,0.07201312,0.0019291048,-0.0040692287,0.014510383,0.018488467,-0.056787726,0.019704835,0.0029584093,0.031450283,0.09478294,0.04069442,0.019440927,0.009214709,-0.047596145,-0.03282421,-0.0028615838,-0.011418628,-0.044113945,0.08381614,-0.031223865,-0.010633318,0.037379347,-0.020337723,0.023402466,-0.0035472906,0.029673167,-0.004001151,-0.011182466,0.0102846995,0.027167354,0.0036070314,0.036652185,0.007151401,0.012456851,0.05130902,0.016612006,-0.004934604,0.017618768,0.0040806523,0.05733707,-0.007521704,-0.022516318,0.014245479,0.06273534,0.028888421,-0.017258925,0.034195416,-0.0193959,0.021450914,-0.056204647,0.0329875,0.041386455,0.03086422,-0.0023867427,-0.0016981864,-0.01019315,0.058977004,-0.043169715,0.017459627,0.018833132,0.015367543,-0.034955416,-0.03426167,0.036198627,-0.04422174,-0.0220904,0.03684963,0.031766042,-0.03238464,0.047812376,0.028368331,0.012600664,0.025526742,0.0059256293,0.0035954572,0.027458774,-0.02012607,-0.0016848508,0.0071761776,-0.007877071,-0.014816433,-0.013507292,-0.033932745,0.0063144667,0.039498933,0.039179392,-0.0090498235,-0.051377915,0.038223233,0.03943866,0.059446216,-0.0079959575,0.005567824,-0.008174728,-0.06739011,0.053378616,-0.0185017,0.024413286,0.05937259,-0.034916043,0.0063356543,0.028753486,0.02169178,0.040799893,0.04145262,-0.039063614,-0.07112767,-0.03624084,0.025862183,-0.06734796,0.014908164,0.052121323,-0.021997705,-0.024668075,-0.03795517,0.03262598,0.07210584,-0.0010653152,-0.033616602,0.047366735,0.009788694,-0.05161329,-0.005072195,0.06155834,-0.025605738,0.0075557115,0.00074474,-0.036611833,0.000586217,0.018041372,-0.013418729,0.009491652,-0.031606093,0.03990643,-0.014925859,0.010476482,-0.046024904,-0.051292706,0.002133996,0.1139089,0.050545305,0.021147355,-0.0016095593,0.013745776,0.03977726,0.01593238,-0.01709353,0.011557748,-0.038587075,-0.0129499845,-0.023154465,-0.052113518,0.048707854,-0.03679025,-0.061163016,0.054271173,-0.016097507,0.04207377,0.03392962,0.020090802,-0.012874683,0.05119508,0.019337835,0.026681267,0.036590833,-0.010526647,0.06691107,-0.0744387,0.020523977,-0.034880117,0.025754469,-0.010664206,0.067364156,0.012231418,-0.018808413,-0.03527118,-0.024212765,0.025539432,0.0069794785,0.0604888,-0.025258256,-0.00077635114,-0.005109498,0.03383777,0.023170672,0.038632993,-0.014798374,-0.033386413,0.056078363,0.058650784,0.026137209,0.05258139,0.03257027,0.037081834,-0.03573234,-0.014420475,0.05678401,-0.056753248,0.046124857,0.0039059224,-0.00030384763,0.15376014,-0.030137267,0.030033091,0.06204906,-0.02803966,0.010549101,0.0022721353,0.0010855573,-0.0024915435,0.0066414746,-0.04216348,-0.0024414991,0.06347608,-0.04274799,0.06370361,-0.035010386,0.04418826,0.009919451,0.034080096,0.009950749,-0.062147632,0.0378646,0.010333228,-0.021853589,0.017396051,-0.0077951928,-0.006508113,0.032903753,-0.03462138,0.012072252,0.06377826,-0.017700579,-0.010097952,0.028663881,0.013358191,0.005762524,-0.0052389656,-0.04287756,-0.0638331,0.01966314,-0.14056876,0.104071274,-0.005521307,0.05264082,0.03805389,0.033858936,0.013996233,0.0064228736,-0.023207134,-0.0015691954,-0.05346796,0.035212062,0.034498025,0.020777784,0.01987183,-0.022655848,0.07115675,0.034874786,-0.010236568,0.027052077,-0.00947111,0.002235464,0.0025800036,-0.071357876,-0.009078639,-0.022035632,0.028080218,0.028626438,-0.04512505,-0.009396258,-0.005639053,0.0029294402,-7.771236e-05,-0.054060526,-0.008911731,0.003393747,0.020466622,-0.023504617,0.031293996,0.020012967,-0.0077727954,0.04604275,-0.025364904,-0.00059391395,0.08842605,0.028138995,-0.006870261,0.015995294,0.01302946,-0.017663702,-0.11219606,0.06467934,0.017424382,0.050472107,-0.028646844,-0.0034359554,-0.031869043,-0.046560053,-0.01812621,0.038020346,-0.09255446,0.030538945,-0.028763555,0.013154904,-0.039834067,0.012698789,0.055942778,0.015232326,-0.008651645,-0.041810155,0.05481612,0.05078931,0.02210473,0.0027011023,0.024773937,-0.033091955,-0.023159958,-0.0091793835,0.049800444,-0.027806643,0.007924308,-0.026148375,-0.027996961,-0.049076673,0.01665481,-0.028753407,0.0007594523,0.019491933,-0.036914874,0.050202265,0.016162924,0.057413235,-0.01248529,0.038933277,0.013049307,-0.052873332,-0.016156215,0.034840707,0.030940818,-0.06681079,0.02271456,-0.018143684,-0.0062475097,-0.011677243,-0.039313436,-0.059931684,0.024841731,0.028080283,0.02441824,0.0016662846,0.035502452,-0.041972768,-0.015424943,-0.0019522118,0.050559007,0.0038502847,0.004052838,0.018403444,-0.021158667,-0.00925906,0.051406275,-0.061243523,-0.011267383,0.04404533,0.04599918,0.03209847,0.034457404,-0.023229385,0.018072803,0.0088275755,-0.014474405,0.01632184,-0.039502785,0.08306139,-0.0116523765,0.0073879454,0.0031014318,-0.018737527,0.03147309,0.022251694,-0.003890861,-0.011476703,-0.024611868,0.016299225,-0.009277614,0.009597051,0.051608045,-0.011756218,-0.043771118,0.0091137905,0.02189161,-0.03502384,-0.014877146,0.012461855,0.04957351,-0.009058442,-0.04520256,-0.050890837,-0.02368909,0.057953995,-0.05503692,-0.00684712,0.04006291,-0.0010478112,0.0025487863,-0.0059584775,0.015983837,0.013774809,0.005894252,-0.010074844,0.007340351,0.031489085,-0.008762615,0.012400828,-0.03214406,-0.048898436,0.03718133,0.05462659,0.0029847494,0.010951102,-0.0010846453,-0.0048096497]	\N	2026-07-28 21:53:54.893713
19	16	0	Tên địa điểm: Bưu điện trung tâm Sài Gòn\nMô tả: Bưu điện Trung tâm Sài Gòn, còn gọi là Tòa nhà Bưu điện Thành phố Hồ Chí Minh là một trong những công trình kiến trúc tiêu biểu tại Thành phố Hồ Chí Minh, tọa lạc tại số 2 Công trường Công xã Paris, phường Sài Gòn. Đây là tòa nhà được người Pháp xây dựng trong khoảng năm 1886–1891 với phong cách chiết trung theo đồ án thiết kế của kiến trúc sư Marie-Alfred Foulhoux. Đây là công trình kiến trúc mang phong cách phương Tây kết hợp với nét trang trí phương Đông.\nKhu vực: Bến Nghé, Quận 1, TP.HCM\nDanh mục: Công trình kiến trúc di sản\nHợp với sở thích: Lịch sử, Chụp ảnh, Kiến trúc, Văn hóa\nĐộ phù hợp nhóm tuổi: YOUNG_ADULT (4/5), ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (4/5)	[0.0081728315,0.003366114,0.007903082,-0.01898395,0.05357077,0.046570748,0.03804405,0.02316826,-0.0066694217,-0.022778617,-0.021786459,0.0135185355,0.004911219,0.035503674,0.0040173614,0.038730856,-0.06126847,-0.044356443,-0.013175234,0.011850533,-0.04832667,0.030538043,-0.0010432916,-0.019302802,0.060802266,0.0036197677,-0.00042762278,-0.0570647,-0.021486351,-0.049806044,0.07742125,-0.008017528,0.017203411,-0.015501934,0.061334632,0.003368078,0.01332596,0.022040887,0.018750142,-0.017619733,-0.0048324014,-0.0652938,-0.009233127,0.0027103175,-0.022461697,0.029107537,0.06686,0.0067508863,0.00466769,0.034622084,0.00978021,0.0062931436,0.02508299,-0.046389848,0.0032182117,0.03917246,-0.016988762,0.07486595,0.0064464514,-0.049531378,-0.033619497,-0.0836045,-0.0043571074,0.009105819,0.015603298,-0.0015581955,-0.03850188,-0.024631782,0.022142217,0.04737675,0.08195251,-0.016863683,-0.015647598,-0.026891632,-0.007019619,0.050454292,-0.009439156,-0.0052108536,0.004495614,-0.038839277,-0.013128344,-0.02403498,-0.009898695,-0.016573349,-0.012117591,0.06819772,-0.043999854,0.020390816,0.0105075305,0.0067881295,-2.337682e-05,-0.04444237,0.03917314,0.005149538,0.0049701775,0.021284109,0.033667803,-0.012359221,-0.061788525,-0.024273366,-0.026749792,0.018235365,0.012694215,0.016154692,-0.00383094,0.076441795,0.01198464,-0.028896468,-0.038069643,0.013620926,-0.010676432,-0.019237675,0.063993864,-0.015300961,-0.03873375,0.04014598,0.012087653,0.04341939,0.023000449,-0.05386447,0.024839507,0.018595759,0.034744617,0.029483158,-0.022643184,0.019217804,-0.013692712,0.015837712,-0.055029023,0.0026886538,0.022963092,0.0082233315,-0.003028232,0.033138856,0.007628758,0.019722773,-0.0097119985,-0.023517538,-0.058815457,-0.006566834,-0.028954435,0.0007735872,0.011820137,0.024683328,-0.02424328,0.006354322,0.03544682,0.031996496,-0.041477345,-0.056399707,0.022961484,-0.011331275,-0.015910732,0.03152892,-0.023036612,-0.023963595,0.009811669,0.0017537005,0.0029846788,-0.020897854,0.025459716,-0.032750778,-0.018128391,-0.018818414,-0.00775735,0.0012995627,0.01378024,0.002445435,0.07461657,-0.018753268,-0.0037186318,0.03367774,-0.08047558,-0.01654236,-0.028262842,0.00017235393,0.053428855,0.038453817,0.031612903,0.03596725,-0.011911628,0.0290927,0.0005937731,0.028766336,-0.030088985,-0.019840745,-0.008309506,-0.0558953,-0.04505693,-0.01211855,0.04635532,-0.0001661382,-0.01627779,0.00952602,0.023119539,-0.010404387,-0.0048323846,0.023241071,-0.02736665,0.008247913,0.021834461,0.053409003,0.015721465,-0.045996558,-0.05754286,0.03636693,0.00051644794,0.088228285,-0.006748933,-0.002251844,0.02258741,-0.013897367,0.022415372,0.033978704,0.046079803,0.022966241,0.079767555,0.029795201,-0.0064487355,0.008884281,0.002344572,-0.014667192,0.0549341,-0.06032045,0.029077623,-0.02170686,-0.033632543,-0.0081692515,-0.033389937,0.033151723,-0.039760273,0.044690434,0.0014562837,-0.00567277,0.020266673,-0.0512813,-0.050759505,-0.005112646,0.056997936,0.014589171,-0.01935249,-0.03434765,-0.031529818,0.05645967,-0.0032662402,0.039793264,0.027214833,-0.048910957,0.0048935562,0.03679309,0.00998947,0.05728165,0.016376475,-0.080322646,0.017110132,-0.028521784,-0.045005783,-0.07429587,0.051339258,0.030740947,0.04407821,-0.018177474,-0.008747393,-0.007732303,-0.00075094943,0.0023340483,0.077253364,0.032621242,0.027236326,-0.00064824894,-0.08830103,-0.0069956137,-0.047969967,-0.04798193,-0.011039607,0.0254757,-0.002985332,0.0437948,0.03335205,0.052940037,0.031136686,-0.0425623,0.004891464,0.013640668,-0.03435295,0.0017458971,-0.018524952,0.0118865445,0.08236462,-0.006801425,0.010918148,0.009669445,-0.029671274,0.008588607,0.06316057,0.003974985,0.023992253,-0.0070066727,-0.018568868,0.009461387,0.014605396,0.007578206,0.04404265,0.051480576,-0.05370955,0.07447179,-0.007771804,0.041256692,0.02086054,0.013144962,0.03739838,-0.016768979,-0.00207971,0.0027416586,0.01119787,0.012497531,-0.0067935423,-0.0052201175,0.015549527,0.025609378,-0.049073856,0.027647624,0.013384652,-0.05726591,0.021123707,0.03277028,-0.07085076,-0.012705029,-0.023651037,-0.024501102,-0.001822586,0.07404277,0.0006946199,0.013682739,0.04476987,-0.0016339648,0.0025355755,0.0006608634,0.018666174,0.011011665,0.021492697,-0.025325276,0.029447125,-0.075234555,-0.038483247,0.050498098,0.059223536,0.0006848484,0.09448127,-0.010205895,-0.052093875,-0.009717094,0.036461063,-0.0036264274,0.05143356,0.05872984,0.038874254,0.048918612,-0.017638579,-0.006509547,0.060771674,-0.040519178,-0.034451634,0.05176976,-0.03442432,-0.04739104,0.02168339,-0.01795524,0.039204404,0.059872862,0.06613298,-0.046521787,-0.0031134025,0.0060724714,-0.004466821,0.055769578,0.017623398,-0.006587141,-0.025693644,0.0023101948,-0.07734689,0.013501601,-0.065288745,-0.02098311,0.005224808,-0.010591945,-0.03926986,-0.075895086,0.06466851,0.0009938282,0.0069221277,-0.007419631,0.029925017,0.030175589,-0.021667752,0.07874657,-0.06229955,0.0519146,-0.0052023157,-0.03603037,0.044448256,0.061618056,-0.065480374,7.034765e-05,0.042324394,0.055242278,-0.009934511,0.005797393,-0.012094746,0.020116126,-0.006195151,0.036996685,0.0025444306,0.003731752,-0.0006574365,0.014546382,-0.010454614,0.0300518,0.012333391,0.009745674,0.03767666,-0.06249824,0.0046212217,0.019593205,0.0030249665,0.0037636363,-0.00090499106,-0.0062560877,0.010304865,0.026232608,-0.010446382,0.032818165,-0.04681556,0.07573147,0.049578574,0.013220019,-0.010975005,-0.007363226,0.010722453,-0.005210134,0.029387834,0.050442014,0.026994387,0.023217183,-0.08320459,0.0026385707,0.0031480216,-0.028629059,0.040208723,-0.012980962,0.029630965,-0.04699845,-0.01576374,0.02972057,-0.04562533,0.0042419466,0.015515252,0.015929129,-0.0031832703,0.028182205,-0.021189408,0.08212359,0.026505668,-0.06055366,-0.018810492,0.0810459,-0.030702326,-0.04432573,0.027155316,-0.0073833195,0.013417735,-0.0035631647,-0.040422343,-0.045175016,-0.004844882,0.024696551,-0.10090339,-0.018621111,-0.030244162,-0.041656166,-0.033739004,-0.034889203,-0.020064527,0.019531846,0.11402222,0.0032643792,0.037885144,0.0012625954,0.029539425,0.040460557,-0.01527276,0.012957677,-0.007474964,-0.048911627,0.0057960404,0.0028673196,-0.05373539,0.034344956,-0.049502164,-0.031031046,-0.013138344,-0.060111046,0.006380666,0.0056218943,0.09851622,0.009071293,-0.016796498,0.021423647,0.07062831,-0.019481622,0.05634371,0.036051564,-0.019377725,0.032544937,0.04794286,-0.010368359,0.061372664,-0.013802295,0.028242856,0.0061303596,-0.018360317,-0.021021072,0.08010839,-0.008271745,-0.016639145,0.015661083,-0.038709663,-0.018612646,0.023294788,0.044052824,0.008789956,0.0017546009,0.02257691,-0.011055078,0.056736644,0.013416908,0.07985692,-0.04385439,0.02665383,0.016495327,-0.03150455,0.057637967,-0.02201203,0.036285646,-0.006847875,-0.002965287,0.17025065,-0.01384182,0.029725663,0.036474917,0.009724711,-0.048405632,0.0013097485,-0.037407015,-0.0061613456,0.051078886,-0.031819504,-0.0015344498,0.03475614,-0.03621061,0.040433,-0.014538805,0.009680657,0.035192452,0.017244088,0.024443982,-0.025453568,0.09486699,0.059457444,-0.004957205,0.015916536,-0.026587687,-0.0018921738,0.09742728,0.0045433426,-0.027080353,-0.019141978,0.027929403,0.060008056,0.01750677,-0.02112266,-0.0023161883,-0.016783247,0.07073802,-0.05331093,0.028954169,-0.017369524,0.0998036,-0.050677586,-0.018244017,0.03847535,0.030494407,-0.027837638,0.034255397,0.03639273,-0.020310229,-0.038114406,0.020203603,0.046279225,0.032070596,0.011277852,0.035416573,0.046971858,0.021134552,-0.055467963,0.032262534,0.02291411,-0.04355593,0.026688373,-0.025538024,-0.041975833,0.030528756,-0.0049133673,0.0410892,-0.027138539,0.0059566777,-0.004480052,0.040851306,-0.013521468,-0.010612793,0.061425682,-0.034927886,0.0031809912,-0.013535803,0.0504779,0.014236206,-0.010877835,0.0016332321,-0.02942922,-0.02348581,0.0289522,0.030419137,-0.09614624,-0.016888702,0.022830486,-0.027962474,-0.08388153,0.031206891,-0.08080125,-0.0012663637,-0.010667328,-0.0289198,-0.042924285,0.007294886,0.0007324481,0.030120756,0.012862135,0.021112703,0.0066962386,0.017815186,-0.024501862,0.029744511,0.028196646,0.035897046,0.05483221,-0.067576125,0.06435511,0.056853067,0.049636785,0.0057543423,-0.0013938097,0.010174698,-0.053120628,0.04422916,0.013576463,-0.014167066,0.043075144,0.03093134,0.002160831,-0.054654412,0.04038275,-0.02962435,0.0036405474,-0.018843865,-0.049677327,-0.017237864,-0.032540083,-0.026811186,-0.016764509,0.06127489,0.035865027,-0.041560907,0.011697905,-0.029359644,0.019231375,-0.04987266,0.04927441,0.026807051,0.031179192,0.015741598,-0.06399642,-0.043198165,-0.013102689,0.040510718,-0.00058534945,0.009155158,-0.024679424,0.0127968555,-0.044336062,0.0851501,0.0032177577,-0.013524416,0.049123112,0.020552771,-0.015192422,0.00671124,0.08790149,-0.03242417,-0.05571594,0.045389224,0.07974448,0.018171499,-0.011344941,0.022180935,-0.0003585614,0.04413672,-0.020779064,-0.029842466,-0.019102404,0.035181947,-0.0068430626,0.012612742,0.02948494,-0.0057141543,0.011988462,0.012763223,-0.116651356,0.011313896,-0.033581425,0.014248921,-0.012549805,0.008325913,0.042881537,0.017824,-0.0040097893,-0.024345925,-0.052080706,-0.02940098,-0.005347083,-0.009028659,0.025658576,0.0796221,-0.025953302,0.02768895,-0.010162084,0.059914276,-0.028995248,-0.04981623,-0.0017727418,-0.04108165,-0.025987716,0.03062719,-0.011851678,-0.013530764,-0.008240631,-0.013030795,-0.04060166,-0.033478517,0.025911896,0.03963383,-0.015045089,-0.010728634,0.011134962,0.060794532,0.0063732406,0.006789339,-0.03671803,0.0032743576]	\N	2026-07-28 22:34:41.889883
23	19	0	Tên địa điểm: Bến Nhà Rồng\nMô tả: Bến Nhà Rồng là di tích lịch sử quan trọng bậc nhất, gắn liền với sự kiện Bác Hồ ra đi tìm đường cứu nước năm 1911. Công trình mang đậm dấu ấn kiến trúc giao thoa Pháp - Việt, nổi bật với biểu tượng 'lưỡng long chầu nguyệt' tinh xảo trên mái ngói. Đến đây, du khách nên tham quan các phòng trưng bày chuyên đề về lịch sử, sau đó tản bộ ở khuôn viên lộng gió hướng thẳng ra bờ sông Sài Gòn. Địa điểm này là lựa chọn tuyệt vời cho người lớn tuổi, sinh viên và những người muốn tìm hiểu sâu về lịch sử dân tộc. Điểm đặc trưng nhất chính là tòa nhà thương cảng nguyên bản được bảo tồn hoàn hảo với tầm nhìn bao quát cảnh quan sông nước hữu tình.\nKhu vực: Xóm Chiếu, Quận 4, TP.HCM\nDanh mục: Bảo tàng, Di tích lịch sử\nHợp với sở thích: Lịch sử, Chụp ảnh, Kiến trúc, Văn hóa\nĐộ phù hợp nhóm tuổi: TEENAGER (4/5), YOUNG_ADULT (4/5), ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (5/5)\nKhoảng giá: 0 - 20,000 VND	[0.013587132,0.0003815023,-0.04745726,-0.015911812,0.040387806,0.034262553,-0.028114894,0.064923376,-0.02280964,-0.05049428,0.012211556,-0.0053554308,0.0453495,0.01696614,0.046735026,0.047989473,-0.041758876,-0.019042544,-0.038518023,-0.0012138855,-0.045972116,0.026755497,0.002143533,-0.03413011,-0.0012885566,-0.0017215499,0.008060443,0.014005304,-0.046624273,-0.08016236,0.06480964,0.008093071,-0.012938516,-0.02657223,0.072035305,-0.049819924,-0.009524143,0.060298122,0.024931625,-0.019559745,0.004158803,-0.022028152,0.05686466,-0.01870067,-0.043864306,-0.0011796654,0.068079785,-0.05833032,-0.017959893,0.010651178,-0.022915995,-0.020606343,0.029861683,-0.01928169,-0.032987617,0.001997885,-0.02554777,0.05520559,-0.001114286,-7.858228e-05,0.013521344,-0.03310058,0.0019444495,0.019071078,0.05334909,-0.027118376,-0.015053636,0.0165797,0.023288382,0.05098336,0.051634163,0.029767828,-0.010260534,-0.010408723,-0.01806236,0.030141396,-0.015400595,0.012519471,-0.005078875,-0.01379963,-0.0059638484,0.022616787,-0.016563175,0.029565975,0.029060388,0.047905367,-0.018112363,0.020045895,0.027518477,-0.008106905,-0.03295627,-0.026828319,0.0070877788,-0.0029020975,-0.006469207,-0.0074677835,0.048052322,-0.008799846,-0.044383455,-0.053593036,-0.01296334,0.025257127,0.046238642,0.010505619,-0.0030611283,0.012800122,0.024734195,0.038331687,0.014220394,0.039294288,-0.002550283,-0.009019959,0.09300076,-0.026933776,-0.017313005,0.013455483,-0.00076915993,0.005977039,0.013300814,-0.0013706108,-0.012354805,-0.029312612,0.0020929275,-0.036717504,-0.020322502,-0.016674953,-0.039863154,-0.017839666,-0.037927784,0.01345423,0.05668727,0.010532419,-0.03360472,-0.0016813074,0.020686127,0.012789174,-0.0058081076,-0.03112008,-0.06714585,0.016264107,-0.020194262,0.039258502,-0.024705712,0.027941456,-0.036028855,0.04155174,0.011505453,0.096893996,-0.05063192,-0.035737157,0.013213838,-0.067696355,0.0009421184,0.018333932,-0.051245715,0.008711373,-0.020677635,-0.014347919,-0.023035945,0.028635956,-0.0052542444,-0.004630251,-0.023255397,-0.02941465,0.008328586,0.04674852,-0.025601398,0.030893689,0.032048777,-0.06066196,-0.014020134,0.019779675,0.0005215674,-0.007017759,0.04259541,0.05641512,0.0067302044,0.044833288,0.029797532,-0.014449136,-0.016373727,0.018867552,-0.015399369,-0.014507125,0.016160764,-0.04023997,0.019437373,-0.04304681,-0.041706692,0.012223985,0.07204622,0.029031163,0.011366398,0.045986958,0.047652517,-0.014904115,-0.032120787,0.033396684,-0.06719821,0.021333518,0.004566259,0.017610144,0.057401776,0.005977694,-0.09336995,0.047542352,-0.017000912,0.0729752,0.0129281,-0.021047283,0.0034992802,-0.03558233,0.03351196,-0.015267181,-0.042347625,0.028537001,0.031448875,0.028653696,0.029473538,0.02548192,-0.004807368,0.03979929,0.0438066,-0.011990069,-0.0060441876,-0.024672842,-0.009276791,-0.04066064,-0.027404135,8.475368e-05,-0.039081264,-0.010230181,0.032658234,0.013715937,0.008186349,-0.05697435,-0.028644009,0.035626184,0.03472155,-0.019029789,-0.05004736,-0.042269114,-0.061646238,0.03264598,-0.0039291955,0.071656436,0.047219526,-0.038977236,0.11017899,0.066981375,0.03604322,0.05227749,0.021938667,-0.031204026,-0.009781815,0.033704385,-0.0044609196,-0.039377745,0.06290722,0.0092563145,0.01423904,-0.042794816,0.015773105,-0.016768616,0.010956096,-0.0040655993,0.040672164,0.014195142,0.038282912,-0.036583938,-0.03369159,0.025563866,-0.033215802,0.0064623817,-0.048428267,0.027857622,0.038698833,0.047162365,-0.026117276,0.03676044,0.0037313881,-0.0032389075,0.019375186,-0.017307062,-0.06698741,0.0028451134,0.0044385633,0.048250306,0.052225966,0.00020954887,-0.011303365,-0.03331712,-0.038607966,-0.0020880909,0.052100424,-0.0007216195,-0.008249241,-0.03139026,-0.0203893,0.03174549,0.049064547,-0.025057882,0.040055584,0.033919927,-0.008754095,-0.0014434189,-0.06767249,0.010511512,0.07152975,0.03028951,-0.015008538,-0.042886063,0.0048096874,0.040185053,0.043209463,0.028240006,-0.054424632,0.0061034267,-0.000892456,-0.022178233,-0.09017773,0.048268083,0.0064295614,-0.03972572,-0.024922265,0.04529126,0.0197126,-0.020283533,0.013134445,-0.019602284,-0.007106654,0.06121937,0.028421393,0.03205797,0.010162831,-0.022427464,-0.014614151,0.03117463,0.045566186,0.013262586,-0.029797986,-0.026855836,0.030709036,-0.043301776,0.023917397,0.071216755,0.06544181,-0.01968819,0.060783394,0.00121847,-0.06881859,0.02535209,0.022126865,-0.024471369,0.07293655,0.100320704,-0.005388851,0.033416495,-0.016287707,-0.03469755,0.09073381,-0.03725992,0.0062903324,0.080615066,0.012067288,-0.0025057525,0.01464061,-0.010408173,0.006877801,0.043848373,0.048740704,-0.029635997,-0.001845884,-0.0022513943,-0.0016334271,0.05896953,0.0031891747,0.01403944,-0.03477152,0.024566563,-0.00681421,-0.013160425,-0.061632052,-0.009150009,0.018644385,0.0093023805,-0.00017909906,-0.07526827,0.08691945,0.005515389,0.023641082,0.0073251734,-0.019038985,0.029473547,0.0024527384,0.04027866,-0.018909857,0.042055346,-0.035639357,-0.039353315,0.06536879,0.026128272,-0.076180756,-0.030045487,0.01889509,0.02075845,-0.038837638,-0.024308458,-0.007389211,-0.002918022,0.025938066,0.011792296,0.0035842864,-0.057792965,0.03758064,0.031870473,-0.002579736,0.024081739,0.002781031,0.011372033,0.04760669,-0.027320186,-0.0039685806,0.044903744,-0.008529711,0.037451778,-0.010921129,-0.0049505667,0.016068656,0.041947454,-0.03152085,0.023395918,-0.016879482,0.06697405,-0.008843497,0.048383188,0.023485132,-0.01494166,-0.0035559956,-0.028422715,0.015561444,-0.016725708,0.006962916,0.027474914,-0.036450036,0.048551984,0.022324722,0.044748817,0.043688886,-0.05552606,0.029785309,-0.020702237,-0.006699538,0.03179699,-0.044324692,-0.051872943,0.09593359,0.006387873,0.0066092433,0.013701762,-0.048732422,0.123962104,0.00096894027,-0.0023772288,-0.0031439597,0.025488945,-0.008993915,0.029759636,-0.02195265,0.015476445,-0.012383599,-0.018806607,-0.035661325,-0.0074096196,-0.0006249718,0.06852389,-0.028871004,-0.00917992,0.0011603197,-0.022846494,-0.027177764,-0.061628055,0.009415569,-0.02990871,0.087759115,-0.0023123177,-0.007621459,0.007906487,0.032611266,0.03519488,0.011025847,0.018477546,0.042738333,-0.05654621,0.0004047579,-0.01372508,-0.057492536,0.023305763,-0.046620715,-0.053935852,0.022098828,-0.03945449,0.057354897,0.027397918,0.094831325,-0.027149504,0.00831876,0.048109483,0.043368038,-0.011737034,0.01318612,0.028535163,-0.027870907,0.045430463,-0.010831471,-0.022791052,0.020000542,0.046981256,-0.028534673,0.01761944,-0.015663544,0.030988455,0.047875196,0.013234243,0.009617535,0.026693542,-0.033066478,0.013072795,0.023695592,-0.028930172,-0.03609554,-0.05015487,-0.005366293,0.043149944,0.03661413,-0.01744198,0.03711991,-0.023739118,0.017644184,-0.020389257,-0.057431303,0.03424588,-0.03259539,0.032537125,0.006749887,-0.037822682,0.06065156,-0.03295384,-0.0050655254,0.015172279,-0.012015238,0.009852894,0.007682269,-0.016255738,0.014946686,0.10131545,-0.028386645,-0.016985644,0.046912357,0.0073584733,0.09363098,-0.014004608,-0.018424729,0.0077336375,0.0045217914,0.008047788,-0.042478934,0.0845429,0.04517476,-0.024273805,0.010640971,-0.0011523551,-0.00071002886,0.038384244,-0.023007369,-0.010248293,0.018315464,-0.02700434,0.05271145,-0.012529926,0.025202584,-0.022999555,-0.041895203,0.06446656,-0.113722004,0.013848049,-0.07469536,0.106560916,0.02723383,0.0071555185,0.02826414,0.033550806,-0.032619305,0.0035035836,0.008272789,0.0077016633,-0.042570293,-0.038582344,0.041261557,-0.010252461,0.0025512876,0.0056254645,0.08749756,0.029446214,-0.012784693,0.035504032,-0.0070143854,-0.024779756,0.04247533,-0.019167038,-0.06800988,0.027126877,0.041919958,0.015465928,-0.02720936,-0.0013611909,0.018396849,0.032179423,0.019718315,0.03337283,0.043699235,-0.005468346,0.090081334,-0.026244536,0.009843002,-0.031461917,-0.011116972,-0.030367117,-0.039336875,-0.05971149,0.046069954,0.03838681,-0.03158717,-0.0067171627,-0.028539639,0.00030482525,-0.11808693,0.064373955,-0.047021482,0.028525641,-0.019540297,-0.013614549,-0.003416278,-0.009937872,-0.029741086,-0.019755645,-0.038469948,0.05375498,-0.008550007,0.009265722,-0.055975072,0.046242874,0.041496754,0.029047942,0.062230896,-0.045267478,0.10896701,0.0692725,-0.0032046228,-0.078068145,0.011594481,-0.016376697,-0.058672052,0.014425959,0.024356194,-0.01214769,0.018051619,0.02378082,-0.030538412,-0.037984867,0.05429245,-0.013034488,0.017582856,-0.025374016,-0.003558542,0.038067658,0.017420031,0.0053806417,0.0014154504,0.037151895,0.0304396,-0.029615048,0.014624087,0.003959654,0.025164772,-0.011397759,0.054032873,0.031208953,0.029399628,0.03810649,-0.04958636,-0.012025234,0.054627158,0.06842079,0.038521532,0.00040310016,-0.014768323,-0.033626128,0.015640954,0.05721003,0.01411782,-0.062052496,0.009173689,-0.029677868,-0.021457374,-0.013152399,0.042569455,-0.051745173,-0.01956063,0.08105112,0.022974247,0.009064091,-0.022105852,0.006427506,0.02793072,0.029133866,-0.03450742,-0.02862346,-0.0659563,0.07312749,-0.001605076,0.001368466,0.052647103,-0.02379548,0.013071716,0.019654267,-0.061812524,0.0075005977,0.031026648,-0.018492699,0.001147815,0.01777856,0.02738525,-0.023423227,-0.0034243586,-0.01774896,-0.004030749,-0.05133792,0.0132743325,-0.02067354,0.046567824,0.05870549,-0.054544833,0.012094987,-0.015603623,0.029581344,-0.010128131,-0.03413935,0.055819675,-0.043576818,-0.016339581,0.0096977465,-0.012817913,-0.0044373577,0.03873469,0.02299819,0.012860551,0.012823763,0.031983286,0.047268555,-0.010560652,-0.007399458,0.0123378085,0.016601047,-0.043164946,0.042953458,0.00097247976,-0.08532127]	\N	2026-07-29 18:24:52.297384
26	21	0	Tên địa điểm: Bảo tàng Thành phố Hồ Chí Minh\nMô tả: Bảo tàng Thành phố Hồ Chí Minh là một công trình kiến trúc mang đậm phong cách Baroque kết hợp Á Đông tuyệt mỹ, nổi bật với hệ cầu thang vòm uốn lượn ngập tràn ánh sáng tự nhiên. Du khách đến đây có thể thong thả chiêm ngưỡng các bộ sưu tập hiện vật về lịch sử, văn hóa, thương mại của Sài Gòn xưa và khám phá hệ thống hầm ngầm bí mật dưới lòng tòa nhà. Địa điểm này vô cùng lý tưởng cho giới trẻ đam mê nhiếp ảnh, du khách quốc tế và các sinh viên, những người làm trong ngành du lịch muốn trau dồi kiến thức về lịch sử đô thị. Điểm đặc trưng nhất là sự giao thoa giữa không gian trưng bày di sản và một phim trường mang đậm chất điện ảnh hoài cổ, thu hút vô số người đến chụp ảnh nghệ thuật mỗi ngày.\nKhu vực: Sài Gòn, Quận 1, TP.HCM\nDanh mục: Bảo tàng\nHợp với sở thích: Lịch sử, Chụp ảnh, Kiến trúc, Văn hóa\nĐộ phù hợp nhóm tuổi: TEENAGER (4/5), YOUNG_ADULT (5/5), ADULT (5/5), MIDDLE_AGE (4/5)\nKhoảng giá: 15,000 - 30,000 VND	[0.057545684,-0.020401862,-0.004275842,0.008539277,0.016753364,0.04350176,-0.0065578944,0.026035203,-0.045635413,-0.06392726,0.008077475,0.0019915388,0.027992703,0.0064438167,0.008958996,0.028718023,-0.031110581,0.018251207,0.013917081,-0.01700253,-0.010796959,0.0409454,0.020059895,0.0076642735,-0.0015673228,-0.017413855,0.029132476,0.018624991,-0.0021261615,-0.07336298,0.049290672,-0.016277445,0.0071324483,-0.03544493,0.108672135,-0.06460484,-0.034018245,0.063394465,0.03682903,0.005079941,0.015527716,0.0061118132,0.019145329,-0.02748159,-0.039656673,0.0127549665,0.0370344,-0.029234603,-0.0029152592,0.022813821,-0.053937882,0.0010593409,0.029687867,0.0031723755,-0.018557442,0.024097782,-0.042858586,0.035481956,0.027077992,0.017923376,0.010379943,-0.041531052,0.007951601,0.006951652,0.017694144,-0.04652898,-0.014400137,-0.020980697,0.014406403,0.055539124,0.04159256,0.023437908,0.014656597,-0.015462585,-0.014235528,0.020822352,-0.008194866,0.044904534,0.0034001654,0.00021287825,0.025595093,-0.009070303,-0.014558995,0.02633501,0.0326908,0.055689644,-0.017617451,0.009947341,-0.0046799676,0.036306076,-0.05908718,-0.052499633,0.033920567,0.027209722,-0.011776863,-0.03198148,0.014042478,-0.03113448,-0.029350871,-0.015582261,-0.023001667,-0.0015086686,0.052169424,-0.019447058,-0.024795514,0.0015249066,0.04167896,0.03255334,-0.017729541,0.055428028,0.017871866,-0.0037951453,0.08567319,0.0017914644,-0.058313668,-0.016707614,0.012429943,-0.013517138,0.027104024,0.0034820498,0.0021428748,0.017133188,0.00912484,-0.020026097,0.010522448,0.023136448,-0.04351272,-0.0192206,0.0015861039,0.01615604,-0.0067477645,-0.010490328,0.016258808,-0.0051713726,-0.015821205,-0.0026880687,-0.026446695,-0.047358263,-0.026812594,-0.02574692,-0.02435088,-0.018247005,0.011930295,-0.042243093,-0.039503295,0.031455636,0.026238501,0.050950147,-0.041616194,-0.019542295,0.06537086,-0.015710888,-0.007816031,-0.01950147,0.0056460593,-0.01023907,-0.044051208,-0.006025088,-0.025561206,-0.014169251,0.0010018981,-0.019080097,-0.0004818214,0.038454726,0.022533001,0.020560006,-0.018742003,0.049934782,0.045469873,-0.0698561,-0.02015167,0.052089777,-0.02308781,0.022673784,0.11894329,0.04063456,0.0036909138,0.07620341,0.045872383,0.0266231,-0.06765582,0.017395975,-0.02019097,-0.0130034555,0.0111,-0.045158006,0.02935791,-0.050012905,-0.0011016529,-0.006336894,0.04045325,-0.010574332,0.043434694,0.012216589,0.084282584,-0.041155346,-0.034567688,0.035141192,0.003180814,0.007550336,0.014448536,0.0028416095,0.059480306,-0.00048996,-0.03653444,0.051087182,-0.0012723741,0.05957366,0.022837477,-0.028549079,0.036850873,0.0039881347,0.019805618,-0.00011732589,-0.001199513,0.021096444,-0.003617845,0.021666795,0.071361154,0.038225077,-0.014187196,-0.020706626,0.035708074,-0.04575693,0.047700267,-0.024165507,-0.010464693,-0.009004167,-0.067626216,-0.008225743,-0.05057003,0.021693744,-0.006760344,0.0316228,0.006712666,-0.018040577,-0.0034473916,0.006503172,0.009320613,-0.039524503,-0.024451677,-0.026612272,-0.06788998,0.015763542,-0.0075660646,0.038592126,-0.024207544,-0.018913258,0.045656577,0.102259785,0.022073666,0.09582008,0.013674669,-0.01762479,0.009881171,0.038022585,-0.028251313,-0.066801,0.060784947,0.02944544,0.042391166,-0.03696377,0.024879245,0.0029408005,-0.02796623,-0.013105402,0.07988696,0.016749168,0.025540609,-0.02309496,-0.0061990526,0.037790954,-0.0216801,-0.034575123,-0.003309253,-0.009885691,0.059121907,-0.019199045,-0.0041591497,0.011052572,-0.0011998453,-0.032426212,0.0025504192,-0.055046707,-0.047896557,0.029458357,0.03182646,0.033168636,0.046322737,0.015332108,0.00046971874,-0.02559687,-0.007654737,-0.012225022,0.05055999,-0.04203026,-0.0034923078,-0.0020414346,-0.01871628,-0.003582256,0.019540302,-0.022117548,0.050083525,-0.03172509,0.0015050087,0.022684209,0.0022944175,-0.010880381,0.015422879,0.03206869,-0.009164071,-0.014370911,0.007850107,0.06618336,0.07908704,0.04580301,0.0036950447,-0.0021857505,0.038441166,0.0067519885,-0.076917805,0.021527294,-0.018532742,-0.056336127,-0.021290936,0.06697352,-0.01383595,-0.020022787,0.0005108632,-0.0073827114,-0.0018635973,0.058793522,0.026251443,0.051000983,0.019047892,0.0041232314,-0.02294557,0.026473273,0.0022519492,0.023888465,-0.052316286,-0.03187359,-0.0123688495,-0.03456183,-0.057404563,0.06903342,0.06725689,-0.0012302417,0.07244862,0.008995893,-0.011007308,0.016169712,0.030805277,0.03402061,0.064069204,0.060245935,-0.024977453,0.012931232,-0.03305075,-0.022396753,0.037733573,-0.064326316,0.005503892,0.053323533,0.010459421,-0.03528136,0.026601082,0.0056625903,0.004528478,-0.032252166,0.044046298,-0.05425324,-0.051208213,-0.012049137,0.019874085,0.061521497,0.0071695736,-0.0019672636,-0.0100172525,0.038141962,-0.050400555,-0.008141759,-0.042158667,-0.0010949722,0.04798167,0.022864146,-0.014694547,-0.06614715,0.0515185,0.01041713,-0.023839865,0.0049938993,-0.0144851385,0.0037109677,-0.012492651,0.033757374,0.017651096,0.038424682,-0.0039196447,-0.0184454,0.09103469,0.022198068,0.008711091,-0.02229726,0.014575211,-0.00596646,0.0031156384,-0.03897718,0.0006571848,-0.044768073,-0.019274594,0.033068467,0.018661935,-0.040178053,0.06371967,0.036066104,-0.01332786,-0.00078955654,-0.01608075,-0.02054162,0.072663955,-0.04261258,-0.01076807,0.026012305,-0.052785616,0.02641399,-0.054923806,0.015195907,0.017729104,0.07513481,-0.0027380243,0.040760964,-0.026178697,0.034905545,-0.0034946061,0.038188696,0.008858642,-0.018770944,-0.015311435,0.002894955,0.052369054,-0.019722266,0.03513293,0.030177178,-0.017180122,-0.014248546,-0.034142625,-0.0017806586,0.093611114,0.01674094,-0.0025525356,-0.055119134,0.00515359,0.04753798,-0.019839074,-0.051451623,0.09061856,-0.018881584,-0.002105709,-0.006155995,-0.08703175,0.07406677,0.0006314739,-0.0030920152,0.021417797,0.043112475,-0.027220279,0.010170651,-0.01977432,-0.031591907,-0.008440169,-0.0304565,-0.02010876,-0.0272379,0.00044954842,0.019637773,-0.04059359,-0.009759136,0.037765656,-0.04728518,-0.013765137,-0.057687826,-0.005893876,-0.022806872,0.09636788,0.0054922425,0.04489791,0.021975808,0.028161041,0.060257196,-0.0043229596,-0.031453352,0.03795599,-0.045204926,0.010164483,0.012554719,-0.045392387,0.03719907,-0.06073954,-0.04406691,0.08190998,-0.0152793005,0.065253034,0.030532543,0.04073631,-0.05707146,0.015957616,0.041459993,0.05201732,0.0020084037,0.008607298,0.043472122,-0.01587366,0.039710764,0.023203515,0.019992642,0.061869666,0.05255691,-0.0053519374,0.0025584428,-0.039094422,0.016161961,0.0068564825,-0.026576925,-0.009864689,-2.87413e-05,0.011869682,0.008663426,0.017913848,-0.0049671098,-0.032825295,-0.065864764,0.027878731,0.034353126,0.045872852,0.010926493,0.04154349,-0.021259813,0.04737384,-0.05800616,-0.0288127,0.0154011445,-0.04025844,0.00034907524,0.033906393,-0.01726462,0.11204464,-0.0353128,0.0026413624,0.012331483,0.007970762,-0.03042719,0.012010491,0.0006072645,0.03791285,0.042388946,-0.016913751,-0.025924074,0.047986288,-0.030593922,0.12001326,-0.031693276,0.0020966497,0.035187915,0.013301174,0.038407095,-0.027051594,0.06664759,-0.009823265,-0.017902346,0.015269927,-0.050686784,-0.046971686,0.053924866,-0.017705513,0.014136059,0.07781031,0.0066786287,0.051375896,-0.0184485,0.025672358,-0.01818586,-0.06182984,0.08892121,-0.04185883,0.0023434095,-0.12188384,0.057223856,-0.007697371,0.0011333023,0.044989098,0.04327127,-0.050859347,-0.031950586,-0.014800953,-0.018011242,-0.098150365,-0.004789124,0.0018780846,0.019861566,-0.0037492628,0.028421404,0.051852282,0.026310511,-0.0045553027,0.0650116,-0.018444011,-0.021335933,0.0435805,0.0016715599,-0.029456813,0.018896367,0.014263218,0.0054470827,0.009007596,0.012380884,0.0013621994,0.05463511,0.01271098,0.003144059,0.009546023,0.02728009,0.062882595,-0.0008788707,0.041118458,-0.018500745,0.018912246,0.006091368,-0.017401712,-0.038497616,0.075849086,0.013074475,-0.04485217,-0.016233763,-0.010688339,-0.010101943,-0.16258608,0.042353556,-0.06794424,0.011098378,-0.040433265,-0.015980748,-0.020895101,-3.1094023e-05,-0.027803624,-0.005693061,-0.024187796,0.06702194,0.02563369,0.008292565,0.009163283,0.04441365,-0.020439941,0.019814633,0.024759328,-0.027097432,0.12111923,0.05493289,0.015164449,-0.008817451,-0.018017478,-0.011571112,-0.08669086,0.026987057,0.006182434,0.011565191,0.012247676,0.012525485,-0.023984523,-0.04221957,0.04728824,-0.030001167,0.00047858135,0.02087126,0.010272472,0.05345151,0.016413705,0.005200476,0.0032860744,0.060953636,-0.017862592,-0.049264587,0.024380935,0.032277234,0.0011280829,0.014569449,0.048848968,0.035474144,0.039119627,-0.0082420055,-0.021054035,-0.015806375,0.030519167,0.034814395,0.042852495,0.0042029605,-0.015408925,-0.041982263,-0.0155977085,0.0016492993,0.043531336,-0.07822658,0.034204792,-0.007088214,-0.025047304,0.0009469581,0.05911356,-0.03477752,-0.024906518,0.055572767,0.06291957,-0.008591158,0.007034537,5.90168e-05,-0.010869635,0.02363991,0.005587449,-0.00849126,-0.05199881,0.088737026,-0.047969278,-0.013223552,0.04231976,-0.002165323,-0.025416652,0.017524928,-0.09159649,-0.011275147,-0.0047361287,-0.009040235,-0.032598283,-0.030540934,0.06232405,-0.009867924,0.035932537,0.0018058221,-0.0043076,-0.055607393,-0.039330952,-0.025962623,0.02850065,0.010837786,-0.039828707,-0.058560032,-0.022477541,0.05622596,0.02808212,-0.014555451,0.04146659,0.014220941,0.0032937292,0.034035776,-0.01504173,0.049901225,-0.01707529,-0.022088561,0.0005467863,0.02274261,0.015959801,0.043904893,-0.05834993,-0.005889787,0.0288638,-0.0021721856,-0.0352189,0.021646276,-0.02443588,-0.02465363]	\N	2026-07-30 15:37:41.583952
60	26	0	Tên địa điểm: Bamos - Tân Hưng\nMô tả: Bamos Coffee & Tea nổi bật với không gian mở thoáng đãng, ngập tràn ánh sáng và cây xanh. Điểm đặc trưng lớn nhất làm nên thương hiệu của quán chính là thời gian hoạt động xuyên suốt 24/7 kết hợp cùng các đêm nhạc Acoustic sôi động từ 19h00 - 21h00 tổ chức vào thứ 7 và chủ nhật. Khách hàng đến đây có thể thoải mái tìm một góc yên tĩnh để chạy 'deadline' ban ngày, hoặc tụ tập trò chuyện xuyên đêm cùng bạn bè. Địa điểm này là thiên đường dành cho sinh viên, giới trẻ đam mê cuộc sống nightlife và những ai thích check-in tại các quán cà phê có gu. Đây thực sự là một trạm dừng chân lý tưởng để trải nghiệm nhịp sống không ngủ tràn đầy năng lượng của giới trẻ Sài Gòn.\nKhu vực: Tân Hưng, TP.HCM\nDanh mục: Quán cà phê\nHợp với sở thích: Cà phê, Giải trí\nĐộ phù hợp nhóm tuổi: CHILDREN (3/5), TEENAGER (4/5), YOUNG_ADULT (5/5), ADULT (4/5), MIDDLE_AGE (4/5), SENIOR (3/5)\nKhoảng giá: 35,000 - 70,000 VND	[0.07662538,0.080280714,-0.0038509336,-0.060671125,0.025365574,0.033154584,0.036953278,0.07743569,0.0056366925,-0.03655102,-0.035160415,0.02881709,0.03248143,0.0053019235,-0.0060439683,0.0352521,-0.036846723,0.015806744,0.005806878,-0.025931627,-0.026692102,0.027798466,-0.022894235,-0.03152166,-0.021090254,0.04392876,-0.0041561928,-0.017019842,0.01493911,-0.05087748,0.040095676,0.017460417,-0.011506332,-0.0047872905,0.10307944,-0.008852485,0.0005964213,0.052087314,0.07881712,-0.04690402,-0.010401673,-0.05455018,0.020820696,-0.0007458489,0.016472176,-0.03764702,0.009957921,-0.091327265,-0.0076119383,0.036560044,-0.05697387,0.008429148,0.06933501,0.019280352,-0.042491253,0.016628936,-0.051521912,0.0063732583,0.0195165,-0.022335786,0.06684434,-0.044117983,0.0025991916,0.03337269,0.038693883,0.016626423,0.0036056633,0.004551855,0.057705093,-0.038023025,-0.010399465,0.049081396,0.028992707,-0.010496119,0.010614074,0.04368695,-0.018540505,-0.015700014,-0.015689297,-0.015687626,0.044152655,0.082495846,-0.032629598,-0.03513802,0.018452935,0.03597991,-0.058456622,-0.0019884605,-0.03103627,0.023077846,0.006205882,0.003535758,-0.019051865,-0.0058849542,-0.016983425,0.005543767,0.008490326,-0.026600877,0.004758361,-0.019764895,-0.014361148,0.023957582,0.049215566,-0.006588325,-0.014265154,0.03283205,0.013297186,0.0387513,0.04900414,-0.03492367,-0.017388657,-0.009495374,-0.020311678,0.0045857746,-0.065582536,0.005278955,-0.01047669,-0.038506806,-0.01685927,0.023305299,0.014459342,-0.034143534,0.027379958,-0.028277626,-0.04085041,0.043220546,-0.020084247,0.01087302,0.011594416,0.04674648,0.08460625,0.014978077,0.06039509,-0.027772542,0.004968465,-0.04264674,-0.00068770675,0.029892964,-0.057339348,0.06802066,-0.023724457,-0.02428549,-0.03288909,0.010495858,0.05605341,0.006001651,-0.012094595,0.061311625,0.005057289,0.03572378,0.034098532,0.007253151,0.004299651,-0.025696823,-0.0064226063,0.018855764,-0.022747068,-0.045527045,0.018075077,-0.03114539,-0.015630241,0.007867993,0.025635188,0.029149378,0.024260396,-0.036182757,0.00902027,0.029109677,0.0722203,0.031434007,-0.016093161,0.021595696,0.0076540583,-0.026946269,0.054911688,0.056269884,0.111628465,-0.0013030757,0.0143195195,-0.0018178453,-0.012574885,0.04557318,0.011519275,0.0017217068,-0.028053736,0.0407502,0.043125063,-0.05129571,-0.016556902,0.020644316,0.033207823,-0.07075814,0.055129282,-0.0022273345,-0.003017176,-0.023536973,-0.055711366,0.0062725656,0.018230796,0.048226587,0.0022443598,-0.0539438,-0.044765025,-0.10133557,-0.053346574,0.025583308,0.007969842,0.048011333,0.012887909,0.02501117,0.021250276,0.04555594,-0.05886293,-0.046670385,-0.021890191,0.009965965,-0.0067033516,0.022446377,0.005367823,0.017168604,-0.004681375,0.023375472,-0.04231409,0.017660914,-0.007501067,-0.07344604,0.06115096,-0.07242266,0.031904306,-0.02378921,-0.048869293,-0.005109608,0.019350994,0.015196767,0.017826516,0.014020261,-0.049803793,0.057364088,-0.029461578,-0.0076314313,-0.07271147,-0.014538413,0.033613797,0.02752386,0.04695179,-0.030159079,0.018410958,0.0045247246,0.03590071,0.017962914,0.012663431,0.0600942,-0.014001033,0.017657006,0.05108994,-0.024108473,0.046942964,-0.051525876,-0.0008996269,0.007953936,-0.0005234855,0.010148197,0.05877036,0.016573112,0.021710832,0.032580633,-0.009849735,0.029745499,0.059441485,-0.045543388,0.032879125,0.023366714,-0.032103278,0.019462753,-0.0276918,0.003423258,0.01847754,0.011413706,-0.019076537,-0.02826077,0.068417214,-0.05114989,-0.0017517172,-0.01833856,-0.00042140746,0.029119547,0.046526086,0.0312503,-0.012393208,0.020965569,-0.017140161,-0.0063089887,-0.13999017,0.0025595184,-0.001688679,0.021934478,0.0074149673,-0.05935804,0.0023360588,-0.007656885,0.03944489,-0.0095029045,0.021664385,0.0012526445,-0.0028836268,0.008038277,0.0071719037,0.03563464,0.014235541,0.0061128875,-0.054851543,-0.04466403,-0.04437812,-0.021902122,0.024708565,0.012875385,-0.054714356,-0.0073090657,-0.052413777,0.025589423,-0.043982834,0.06663044,0.0119609535,-0.003142782,-0.028657846,-0.041079268,0.0015412099,0.053577904,-0.03657011,0.0061623165,0.0017081185,0.042324953,0.031497404,0.009631954,0.051378522,0.0055674594,0.04503342,0.06132626,-0.019163707,-0.034251012,-0.018393515,-0.08524713,0.0024152163,0.014877992,-0.03195894,-0.04622613,0.037697673,-0.030905157,0.0013782136,0.0005560462,-0.086531535,0.02958473,0.0013048806,0.04638775,0.030705167,-0.026993891,-0.030085426,0.011581796,-1.1947112e-05,0.020696945,0.04336106,0.04169503,-0.0056320564,0.04700036,0.0058523105,-0.0049412134,0.08690384,-0.019208007,0.0089012785,0.094443694,-6.421223e-05,-0.052342907,0.007940599,0.025850387,0.020351084,-0.015743183,0.031718396,-0.063077606,-0.017788759,0.0752664,-0.004819641,-0.043320753,-0.043750193,0.02997922,0.009351344,0.011094566,-0.03735103,0.007029205,0.044852808,-0.016981723,0.0035680542,0.0062675113,0.0019526901,0.05440728,0.018793484,0.051826596,-0.023906564,0.025730401,-0.046214037,-0.0031323528,0.012274734,0.014597072,-0.009662738,0.036981087,-0.0023794682,-0.008299832,-0.06811679,0.008846812,-0.013110771,0.025789622,0.0032006658,-0.05335764,0.0023511245,0.019912481,-0.0016566159,-0.004990815,0.051492006,-0.03686215,0.01914086,0.023475539,0.04533221,-0.090407655,0.039489824,-0.04112021,-0.013738143,-0.00881758,0.029239476,0.00463066,0.0033591054,-0.0459835,-0.017913014,0.0138054155,0.030854544,0.014716112,0.00079410715,0.034600556,-0.012020529,-0.0058082924,0.015524149,-0.032469727,-0.027629066,-0.016748562,-0.019828817,-0.01732038,-0.036708973,0.053512346,0.019992433,0.031621877,0.048354276,0.06015939,-0.039440982,0.005282153,-0.07059592,0.02354939,-0.036860187,0.01520415,0.041356944,-0.05185114,0.008824767,0.017336775,-0.026404712,0.008684278,0.009485784,-0.049461804,-0.049355388,0.013558235,-0.11824998,0.018884378,0.025014622,-0.0210625,0.010623589,0.030881923,-0.015978169,0.020652022,-0.018906448,0.0032220115,0.06594129,-0.045458995,0.018131325,-0.028895363,0.0090122465,-0.06424147,-0.015298438,0.0068684956,0.02147923,0.0012214847,0.0018516841,0.0063962745,-0.019349014,0.020150324,-0.047544695,-0.011310198,0.010966784,-0.0036952936,-0.06729929,0.0142330015,-0.10540919,0.0036720221,0.03129198,-0.008822038,0.023087382,-0.026325831,0.035447378,0.050427746,0.06931905,-0.002476788,0.0045004804,-0.004986559,-0.0090614315,0.020753494,-0.0026640075,0.045617796,0.033373293,0.028026326,-0.018431712,0.05729831,-0.03248143,0.028539153,-0.0142715555,-0.025186155,-0.030075392,-0.038532905,0.030661056,-0.020865463,0.012005661,0.03100727,0.022707295,0.014523348,0.019688075,4.662371e-05,-0.012930947,-0.013386871,0.0214548,0.006891672,0.030911392,-0.035582557,-0.0029130639,0.008065182,-0.0015785361,-0.07137045,-0.02372719,0.031137219,-0.0007194849,0.026199369,0.027954737,-0.01144068,0.08837236,-0.038145185,-0.0039591906,0.014473342,-0.0014312852,0.014121088,-0.03487146,0.002958935,0.020716086,0.029777844,-0.042545553,-0.010619803,0.08554289,-0.019821297,0.022438446,-0.027108531,-0.001804238,0.0073243906,0.023034533,0.035931822,-0.036125638,0.035965886,0.027266726,-0.011467459,0.063744046,0.038685948,0.03060141,0.047303688,0.033154,-0.02127098,0.05787941,-0.046900373,0.04236957,-0.035046715,0.025944712,-0.020747568,0.00046513416,0.012332977,-0.072964214,0.07729382,-0.06707753,0.047560886,0.0011738753,0.01247889,0.038752455,0.040601842,0.05211493,-0.0037616533,-0.032468114,0.0022355225,-0.012788465,-0.0051272395,0.014045772,0.035032526,0.0015536831,0.0018115729,0.0876247,0.09310057,0.0067185713,0.0101200035,-0.036361728,0.0016263999,-0.01952798,-0.017921176,-0.047809392,-0.07457989,-0.01132233,0.014188071,-0.011807949,-0.021992773,-0.041381244,-0.045481894,-0.025038725,-0.035221793,0.018757707,-0.032709848,0.07566949,-0.00235154,-0.0033693213,0.10266041,-0.0041754115,-0.024916168,-0.0068085315,0.010924287,0.09335664,0.012046888,0.050131638,-0.0007757903,0.021475507,-0.014055889,-0.058510493,0.059358466,0.00053317583,-0.009282801,0.03259024,-0.012713672,-0.02469601,0.01199386,-0.0038844277,0.029344719,-0.04851096,-0.022339728,-0.060967937,-0.013648206,-0.025714928,0.030586941,0.025569612,0.025218872,-0.00901488,-0.037245326,0.043473233,0.07126662,0.00603956,0.02832614,0.04329535,-0.03411122,-0.014509226,-0.009787544,0.03433251,-0.05416962,-0.028753545,0.02081638,0.03442947,-0.067232125,0.03062295,-0.028754134,-0.00032117066,0.012058283,0.012929621,-0.0005678811,0.022859508,0.027848328,0.010675521,0.043542165,0.034848876,-0.0037279066,-0.02503138,-0.030996012,-0.018495807,0.012775352,0.03009239,-0.023217967,0.087591276,0.010176415,-0.00735214,-0.02665837,0.011255011,0.030638868,0.024255313,0.037264787,0.0027348993,0.0026260575,-0.026639545,0.035159294,0.025302049,0.0039137094,0.020983558,0.011773129,-0.0320613,-0.050720114,0.036299337,-0.039597854,-0.0062715854,0.018030453,0.01948014,-0.017915212,0.007726785,-0.04349803,0.02550307,0.0433994,0.05395202,0.033881437,-0.06862468,0.028966857,0.01844498,-0.061488908,0.049444683,-0.00572128,0.029840771,-0.007376942,-0.031595122,0.018368136,0.016506866,0.055830043,0.04383811,0.022852084,0.068161756,0.020848662,-0.018521046,-0.008765991,0.039978903,0.02864999,-0.00340652,0.018854737,0.062797844,0.07683367,-0.11353548,0.0007759596,-0.0007433666,0.03467604,-0.05061736,0.065023266,0.037877332,-0.032260414,0.025664985,0.013070524,-0.020848151,0.08630495,0.02967445,0.028363792,0.065694496,0.018957889,0.04039609,0.01681764,0.01689049,0.057239328,0.043193474,-0.01039354,-0.008640091,0.022376388,-0.014916853,-0.09728717]	{"name": "Bamos - Tân Hưng", "ward": "Tân Hưng"}	2026-09-03 20:32:27.019772
36	22	0	Tên địa điểm: Landmark 81\nMô tả: Landmark 81 là tòa nhà cao nhất Việt Nam và biểu tượng đầy kiêu hãnh của sự phát triển hiện đại tại TP.HCM, mang thiết kế lấy cảm hứng từ bó tre truyền thống vươn lên mạnh mẽ. Đến đây, du khách có thể thỏa sức mua sắm tại trung tâm thương mại sầm uất khối đế, trượt băng nghệ thuật, hoặc mua vé lên đài quan sát SkyView trên đỉnh tòa nhà để ngắm toàn cảnh thành phố ngoạn mục từ trên mây. Địa điểm này là không gian giải trí vô cùng lý tưởng cho giới trẻ, các gia đình và du khách yêu thích nhịp sống đô thị sang trọng, năng động. Điểm đặc trưng nhất chính là quy mô hoành tráng cùng hệ thống dịch vụ 'tất cả trong một', kết hợp công viên ven sông tuyệt đẹp ngay liền kề, biến nơi đây thành tâm điểm check-in rực rỡ nhất bất kể ngày đêm.\nKhu vực: Thạnh Mỹ Tây, Quận Bình Thạnh, TP.HCM\nDanh mục: Check-in, Trung tâm thương mại\nHợp với sở thích: Chụp ảnh, Nightlife, Kiến trúc\nĐộ phù hợp nhóm tuổi: CHILDREN (3/5), TEENAGER (4/5), YOUNG_ADULT (5/5), ADULT (5/5), MIDDLE_AGE (4/5), SENIOR (3/5)	[0.05189038,0.05312752,-0.042799596,-0.028040733,0.012033048,0.074783705,0.010204619,0.050735258,-0.0041096136,-0.031366546,-0.0042733955,-0.017402232,0.017592622,0.0045967046,0.033697184,-0.0142549975,-0.03297599,-0.011474756,-0.013768623,-0.017307648,0.04164298,0.00048970303,-0.015677676,-0.017172381,-0.014823578,-0.027572846,0.01490884,0.0066810744,-0.00076990284,-0.06545499,0.10305531,-0.013991007,0.053322285,-0.018208686,-0.0032954144,-0.0059581148,-0.030494297,0.05451589,0.0018406602,0.008434774,0.019363973,0.022666944,-0.013030684,0.017653706,-0.008717215,-0.04473311,0.035963915,-0.041815106,-0.022422113,0.059434593,-0.060038514,-0.013741704,0.03147549,0.023552615,-0.01325132,0.03175525,-0.054329995,0.03623047,0.0674312,-0.033057634,0.065529026,-0.035156142,0.016128698,0.033328492,0.038808938,0.001839292,0.012589271,-0.0070715877,0.064208485,-0.00016933469,0.0148781,0.01724704,0.04594818,0.008028423,0.00013887975,0.028897785,-0.048513696,0.037199754,0.029650979,-0.06885375,0.056153312,0.0456587,-0.023425937,0.0060187317,0.00449602,0.048410773,-0.044467427,-0.007395753,0.011518813,0.014501515,-0.0020930208,-0.0035126768,0.007270738,-0.022681573,-0.01056106,-0.023610331,0.0026313013,0.04428451,0.0072501744,-0.03000433,0.02147617,0.021465892,0.024911664,-0.03864759,-0.103408545,0.09234584,0.016748987,0.05531337,0.024868902,0.030189764,0.0046638497,0.00034252479,-0.020303393,-0.014376326,-0.04556719,0.042210765,0.007438618,-0.022147482,0.027538905,-0.0014286801,0.07112696,0.023014281,-0.0032525538,0.001994752,-0.01898415,0.0044281594,-0.025392339,0.011045701,-0.01455154,0.044742953,0.024828171,0.00739705,-0.010471191,-0.021112118,0.011338797,-0.050765365,0.0016523668,-0.028925573,-0.08627546,0.06000802,0.013173306,0.058021486,-0.0057103466,0.0018807019,0.051854834,-0.0023911314,0.031507872,0.026615648,-0.029619653,0.08683548,0.0031574785,-0.015006666,-0.011726871,0.011386957,-0.00679764,0.00017516171,-0.007870098,0.014802953,0.037652552,-0.029164786,-0.01948965,-0.0071934573,-0.0063075875,-0.02202498,-0.021101395,0.0007210471,-0.020134732,0.009553207,0.10874392,-0.002264115,-0.031490058,0.062784046,-0.0579121,0.041555602,0.059344377,-0.0037255846,0.027828429,0.05389021,0.04424086,0.008968391,-0.024746729,-0.012651197,-0.015748473,0.03903524,-0.06327241,0.005062871,0.022343693,-0.069598824,-0.016989715,-0.012707812,0.020071061,-0.07199539,0.055366416,0.0022244707,0.015025321,0.0010227135,-0.02861217,-0.0029608917,-0.040789,-0.01489043,-0.034633107,-0.011810876,0.025979748,-0.056639373,-0.018160863,0.055035625,0.022039957,0.0023532568,0.0020425236,-0.030729774,-0.025501957,0.049175955,-0.038503665,-0.016870342,-0.007690234,0.03094221,-0.017448505,0.010891891,-0.005278944,0.0017697123,-0.010423376,0.047216732,0.014709427,0.034559455,0.022729022,0.00048517564,0.049868364,0.007601248,-0.026008451,0.01916573,-0.04142052,0.040013965,-0.032803793,0.0043858476,0.053578425,0.020990921,-0.024011096,0.01434959,-0.02909856,-0.0030986823,-0.07622754,-0.066683404,-0.077754036,0.015980976,0.022966167,0.0072847214,0.02887671,-0.02290358,0.045246247,0.047852773,-0.0065183365,-0.0025598484,-0.013333005,-0.020348247,-0.00815031,0.017211935,-0.009529685,-0.03265661,-0.037118006,-0.025674364,0.038804524,-0.007823617,0.0004683597,-0.01389603,0.029655216,0.007219356,0.08603868,0.06300782,0.03618349,-0.008374445,-0.014148399,0.01672432,-0.03822011,-0.00497811,-0.09565865,-0.023404242,-0.0016157635,0.021513965,-0.029068414,-0.0072557833,0.050687842,-0.018126875,0.0061419583,-0.030532638,0.023982637,0.04814612,0.059121516,0.0011422847,0.025050292,0.030124446,0.051886115,0.0016288775,-0.07224789,0.0024651834,0.04441097,-0.010683173,-0.013038449,0.017747115,-0.003829383,-0.016149873,0.05706815,-0.007084326,-0.0060058776,0.0031732453,-0.02706457,0.0075023565,-0.018332092,0.018122062,0.037247267,0.047214016,-0.08089804,0.0059282165,-0.0112404125,0.020330379,-0.00044360795,0.0015726185,-0.026540466,-0.04720443,0.008845701,0.020283068,-0.010957852,0.03648341,0.0451723,-0.004404347,-0.038215794,0.05011382,-0.028749803,0.013429655,-0.013509651,0.0071591283,0.021553548,0.01793711,-0.044867463,0.046399277,0.015349777,0.019382909,0.020661311,0.020004475,-0.011847306,0.042830758,-0.0014661971,-0.061105955,0.01823224,-0.009374592,-0.016941076,0.044875287,-0.032908596,0.006227444,0.02588418,0.03229624,-0.031969372,0.011391863,-0.005489302,-0.0005952934,0.084173076,-0.017943352,0.009409143,0.03464012,0.012066022,0.01543845,-0.0025336149,-0.013543474,-0.059373576,0.06320084,0.036796734,-0.016343055,0.063916214,0.006295667,-0.07080045,0.09828188,0.060056902,-0.043557435,-0.020477952,0.0045223716,0.054744516,0.05206635,0.048899062,-0.026238525,-0.03952137,0.036029648,-0.0007069178,-0.0078357905,0.015101109,0.019324249,0.013430938,0.026447594,-0.050811794,-0.06227426,0.0010747209,0.011381575,-0.019014511,-0.01458739,-0.025496054,0.029132232,-0.016258594,0.044595797,0.008747,0.03809474,-0.026623392,-0.0035106621,-0.022114323,0.053502817,-0.06150263,0.017165734,-0.009109469,0.030356241,-0.0042327275,-0.014876426,0.024297211,-0.044212375,0.030654902,0.0064421105,0.042255647,-0.037052035,-0.019010352,0.001753937,-0.002389891,0.013461923,0.015854808,0.024955343,0.053352054,-0.026907125,-0.006935423,-0.0011019628,-0.024898553,0.010667669,-0.009139167,-0.007449237,0.01399646,0.025306012,-0.036337305,-0.016263342,-0.0596781,0.04036849,0.032743905,0.014373645,0.0020457238,-0.006223492,0.014515361,-0.019928498,0.018324899,0.008626539,-0.01383844,0.009830664,-0.02514631,0.02247543,-0.028312422,0.07280402,0.032712113,0.016123975,-0.023286412,-0.07074248,-0.048536748,0.013089214,-0.025604716,-0.10016646,0.035430077,-0.007864897,0.0046841777,0.022823105,-0.017531766,0.09224416,-0.026338061,-0.02637552,-0.03261539,-0.039985124,-0.08371379,-0.025099823,0.043182086,-0.023467539,0.031877037,0.02556393,-0.02145176,-0.008426606,0.03754002,0.01135754,-0.041153844,-0.06050977,0.0034758335,-0.076806955,-0.02401167,-0.055253398,-0.061304297,-0.015022061,0.09790236,-0.016167657,0.0049015847,0.040493395,0.009951633,-0.019303234,0.06833249,-0.0173968,0.036709737,-0.07908698,-0.029339409,-0.0064363135,-0.08945541,-0.0012361908,0.009831858,-0.027513094,0.055768378,0.0068116756,0.05183107,0.058899898,0.020697078,-0.0011012172,-0.025971306,0.021503152,0.06634713,-0.01750881,0.009123526,0.016219907,0.00021483276,-0.014567674,0.026249822,-0.02243736,0.0072448966,-0.03988656,0.054282393,0.037975486,-0.01977283,-0.062294167,0.00022218766,-0.017931128,-0.02376866,-0.033359054,0.026122851,0.009776785,-0.0038628932,0.019507637,0.0164317,-0.08027943,-0.0018499948,-0.008831858,0.057634998,-0.0039967136,0.04990815,-0.002627852,0.070566006,-0.05118667,-0.038238905,0.033373117,-0.0067011225,0.011652271,-0.06265478,0.007399361,0.1650452,-0.02465818,0.012581873,-0.0060058567,-0.012694774,-0.030805668,0.032958366,-0.073351,-0.0024156468,0.060460217,-0.0032207586,-0.012305406,0.058118727,0.0018857714,0.042009544,-0.006130779,0.0115131335,-0.010477796,-0.034680232,-0.004899189,-0.06470626,-0.0051423293,-0.00026827265,0.015292513,0.028306885,0.035756852,0.0047266595,0.024288805,-0.026589008,0.027100474,0.020946858,-0.0050958428,0.08045168,-0.013374722,-0.032433834,0.015590275,0.0028736729,0.035935342,-0.09196591,0.010560864,-0.047455583,0.1120592,0.014416407,0.050744522,0.03469596,-0.005004212,0.0080832215,0.05352931,-0.023356691,0.0037566146,0.00055459293,-0.014852065,0.010553732,0.04253658,0.02712059,-0.012405886,0.0976401,0.08449519,0.0251042,0.06406778,0.009084695,0.030735746,-0.0063732043,-0.053840246,-0.02076834,-0.039377227,0.019491846,0.01912405,-0.017932167,-0.025316702,0.011923313,-0.031201743,-0.0003989222,-0.0054850113,0.061385486,-0.020437082,-0.0056474237,-0.0088108545,0.04356215,0.056589805,0.027403628,-0.02327974,0.008421349,-0.006075153,0.04107858,-0.01687794,0.018335445,0.016750026,0.031470217,0.027943756,-0.07132027,0.03798936,-0.014826012,0.02168776,0.01580533,-0.031555276,-0.016844934,-0.025958858,0.00029592708,0.0012815645,-0.05665131,0.038570337,-0.026308611,-0.028727852,0.017485123,0.01341277,0.02260109,-0.018306673,-0.000954657,-0.048471108,0.05716721,0.06907512,-0.007052153,0.012880708,0.01875538,-0.053336263,-0.014743008,-0.020625737,0.016790185,0.017715117,-0.007140955,0.05023215,0.046508227,-0.08186226,0.058853716,-0.03906195,0.017696748,0.01985672,-0.042435728,0.015327586,0.037349164,-0.004384484,0.0075805625,0.036268733,0.027514445,-0.034310095,0.030517185,0.0296498,-0.0325137,-0.048600633,-0.0006067903,0.006313848,0.05389913,-0.0558846,-0.054161467,-0.024648184,-0.023307847,0.01717945,0.05695375,-0.0012816617,-0.0017934288,0.040774636,-0.00407218,0.073455006,0.012463897,0.007166432,0.054962404,0.037135065,-0.049455944,0.05944961,0.06769964,-0.076362364,-0.044905473,0.043594573,0.039178822,0.021627063,-0.000102421014,-0.04694529,0.04519251,0.015284679,0.018568229,0.0039754617,-0.0664918,0.022660455,-0.048241034,-0.025524216,0.065571696,0.0035781641,0.019243555,-0.037534807,-0.046568327,-0.0071289465,0.020571336,-0.009205423,-0.026616229,0.040895764,0.059000954,0.0041662306,-0.011427317,0.02997568,-0.005633475,-0.0027989377,-0.003872878,-0.021688227,0.06936745,0.010060462,-0.043867737,-0.019647572,0.05067977,0.037727244,-0.048810646,0.017546706,0.06256082,0.0076818527,0.007950638,0.03205604,-0.018175546,0.07412919,0.024689704,0.0064328634,0.011890737,0.019753799,0.024978355,0.06588461,-0.007012367,0.009881334,0.043960687,0.041556526,-0.006647217,0.026223408,-0.028763318,-0.08752907]	\N	2026-08-04 23:48:40.06882
38	23	0	Tên địa điểm: Bitexco\nMô tả: Tháp tài chính Bitexco mang tính biểu tượng cao với thiết kế lấy cảm hứng từ búp sen truyền thống và bãi đáp trực thăng nhô ra độc đáo giữa lưng chừng trời. Du khách thường đến đây để trải nghiệm đài quan sát Saigon Skydeck ở tầng 49, thu trọn vào tầm mắt toàn cảnh 360 độ của trung tâm thành phố và dòng sông Sài Gòn uốn lượn. Đây là điểm đến hấp dẫn đối với du khách quốc tế, giới trẻ đam mê nhiếp ảnh và là một tư liệu kiến trúc quan trọng cho những ai đang nghiên cứu, thực hành nghiệp vụ thuyết minh tuyến điểm du lịch. Điểm đặc trưng nhất chính là sự giao thoa giữa nét đẹp văn hóa Việt qua hình dáng búp sen và nhịp sống thương mại hiện đại bậc nhất của khu lõi trung tâm Quận 1.\nKhu vực: Sài Gòn, Quận 1, TP.HCM\nDanh mục: Check-in, Trung tâm thương mại\nHợp với sở thích: Chụp ảnh, Nightlife, Kiến trúc\nĐộ phù hợp nhóm tuổi: CHILDREN (3/5), TEENAGER (4/5), YOUNG_ADULT (5/5), ADULT (4/5), MIDDLE_AGE (4/5), SENIOR (3/5)	[0.022134678,0.032981116,-0.06337567,-0.05596597,-0.021019466,0.0347525,-0.01223425,0.09094169,0.0010550156,-0.032024335,-0.0064966567,-0.014021612,0.011103156,0.023447787,0.023035487,-0.02094415,-0.045590725,-0.004508584,-0.030746993,-0.012121614,-0.02868031,-0.009931358,0.0067808465,-0.020202784,0.027380079,-0.004420214,0.012007367,-0.010363189,-0.043665335,-0.04573445,0.10373732,0.005218651,0.015301011,-0.039685465,0.054166302,-0.049927764,-0.02280386,0.05765814,0.0030252344,-0.03045508,0.036994778,-0.034550153,-0.002882033,0.024978762,-0.06311507,-0.007995458,0.062096316,-0.037008204,-0.037273362,0.018099735,-0.070081234,0.0039273268,0.021335613,-0.06410147,-0.00325458,0.024090214,-0.055335984,0.030503038,0.032611117,-0.01989917,0.038965125,-0.05341396,-0.039131496,0.024823017,0.025966687,-0.02022847,-0.022070538,-0.026018783,0.06500256,0.023254508,0.04969369,-0.0058914395,0.023488943,-0.026127454,-0.023249269,0.023724876,-0.02636466,0.018554414,0.013426137,-0.036427602,0.06496595,-0.011230976,-0.0065187006,0.01902895,-0.0010305359,0.0750954,-0.027290458,0.010170221,-0.005930259,0.014204011,-0.01856178,-0.030573754,0.0078594005,0.011128361,-0.012027693,-0.005637349,0.005959398,0.022230461,-0.033543237,-0.0057028974,-0.0023984096,-0.022859182,0.04735238,-0.012584068,-0.064704314,0.045762897,0.019032333,0.067860626,-0.023534177,-0.0075129606,0.015725952,-0.0033656526,0.009692468,-0.00905849,-0.03629943,0.038653016,0.0024295698,0.008753042,0.061741147,-0.01722568,0.06873961,0.05244985,-0.010142022,0.015019951,-0.028674867,-0.008280786,-0.06583018,0.011527022,-0.031960245,0.0012527072,0.05990958,0.0068085124,-0.018307306,-0.023150025,0.0039597643,-0.011367281,-0.01957138,-0.04839449,-0.08269067,0.052182466,-0.008823503,0.059245095,0.03379996,0.03899236,-0.009638982,-0.0054776785,-0.0017621055,0.034778897,-0.056792963,0.03502964,0.039980687,-0.029588224,-0.007252922,-0.0028439844,-0.06567194,-0.007452483,-0.017300224,0.038367998,0.000637312,-0.029774923,-0.038436066,-0.03465309,0.0023575032,0.0018571554,-0.037284095,0.030983085,-0.017407233,0.02601501,0.120798804,0.010242008,-0.026161049,0.049737886,-0.06351121,0.0131368935,0.04304224,0.00020429883,0.021743646,0.066794954,0.034278985,-0.025402075,-0.03733478,0.02687965,0.015712222,0.019729286,-0.012213259,-0.008633126,-0.0006112227,-0.05515825,-0.04428766,-0.020890255,0.03259934,-0.045486808,0.029471524,0.022909626,0.007663476,-0.014285797,-0.039751153,0.018123794,-0.04953269,0.0035002478,-0.014518156,0.0059384657,0.018879853,0.009212512,-0.059257712,0.06282879,0.021540685,0.049757283,0.005318792,-0.012442899,-0.017994989,0.0075490023,-0.01734756,0.022903547,0.027525753,0.021394486,0.049522,-0.0015463752,0.016820107,0.031445723,-0.008046013,0.020664288,0.05598912,-0.030312272,0.0339191,-0.027773434,0.00066502724,0.0036866665,-0.065071106,0.012943687,-0.021700751,0.018307345,0.020084118,0.008005719,0.032808952,0.0024778903,-0.02717134,0.02411006,0.012540768,0.0054408917,-0.051545624,-0.043096166,-0.03944419,0.02505487,0.030061785,0.05421661,0.016846405,-0.03844613,0.04739376,0.062615566,0.032381468,0.045564167,0.015217533,-0.019555004,-0.013386241,0.010440149,-0.028979233,-0.018460955,0.045863394,0.032796383,0.051595226,-0.021217661,-0.013668948,0.00033265798,0.043892436,0.00035477095,0.053597856,0.0076940004,0.017241877,-0.02186505,-0.026000157,0.037793957,-0.020515252,0.015183347,-0.036756516,0.0405179,0.0010330476,0.018742917,0.01837845,0.039266095,0.044096123,-0.018765423,0.020025693,-0.045408547,-0.017043946,0.006354873,0.0064256033,0.021091647,0.1052646,-0.02233539,0.032843176,0.009845586,-0.04528106,0.008571761,0.044439074,0.01239638,-0.00546311,-0.008231416,-0.0015915332,-0.027604649,0.033045474,-0.010133138,0.0055328077,0.027160391,-0.09367056,0.028720105,-0.042453144,0.011941628,-0.0035202582,0.06661389,-0.0202437,-0.004213513,0.024859276,0.082986616,0.024920523,-0.0011733285,-0.05575776,-0.030905742,-0.0044333343,-0.00560392,-0.03142039,0.03889609,0.037175316,-0.054441594,0.019467076,0.053677447,-0.031070929,-0.036227066,-0.0342322,-0.01026341,0.019668587,0.0369496,-0.0334098,0.016077891,0.030878281,0.0072498783,-0.014248831,-0.0006209017,-0.009225328,0.028981652,0.0064760474,-0.041428346,0.07717849,-0.040919952,-0.018659506,0.051434655,0.014828626,0.0035880127,0.067119025,0.058891974,-0.002662285,0.016379792,-0.017258756,-0.010332575,0.06364914,0.04529808,0.01997777,0.047673807,-0.039596274,-0.030280774,0.0062074275,-0.03042579,-0.022836315,0.03369864,0.02355373,-0.01887728,0.03303483,0.028420603,-0.03239049,0.0624073,0.03288938,-0.04829333,-0.015525371,-0.021751216,0.054379124,0.032782927,0.046553683,-0.023780948,-0.02812439,0.051241383,-0.013438539,-0.0032101022,-0.058492135,0.006314566,0.02604767,0.017199408,-0.034974694,-0.09927103,0.04670318,0.0065322975,0.004575997,-0.028922867,-0.0161917,0.011796898,0.009257443,0.0690826,-0.0066100387,0.036040734,-0.029399913,-0.003942787,0.060575034,0.042694822,-0.06256886,-0.022364186,0.014826228,0.0011145681,0.0041337484,-0.00914784,-0.020246977,-0.031731304,-0.0059802975,0.039754733,0.02666146,-0.032949336,0.0029261769,0.007288615,0.02207179,-0.022638675,0.050188776,-0.007628023,0.06255821,-0.055303216,-0.013710918,0.01095535,-0.046169516,0.052772317,-0.003336778,0.0033308773,0.008262615,0.055729736,-0.04785656,-0.011864606,-0.022812221,0.0577196,0.022831608,0.053580254,0.04195099,0.008979564,0.016432796,-0.032113615,0.029282523,-0.006702904,0.011264606,0.008939041,-0.035441384,-0.0076530376,-0.013964966,0.063005805,0.011107817,-0.02063663,0.01669879,-0.067392536,-0.032148063,0.0072034975,-0.016189404,-0.09963804,0.017830728,0.026080001,0.019619243,0.010203447,-0.034195866,0.08621816,0.0031910904,-0.017255737,-7.83894e-05,0.027459983,-0.073397316,-0.028437553,0.011660636,-0.021041429,0.061024725,0.020559385,-0.05044059,-0.0032111434,0.015842268,0.05052965,-0.08303005,-0.024149576,0.017278062,-0.06706352,-0.016450867,-0.045085657,0.008249208,-0.012661679,0.090862215,-0.039037086,0.04264872,0.036455467,0.0005210561,-0.025957476,0.035413913,-0.0098578725,0.06556143,-0.052506052,-0.0037028354,-0.04001498,-0.0731217,0.018932534,-0.052881014,-0.011556712,0.029099213,-0.0030067628,0.034851495,0.01797086,0.06960548,0.03849557,-0.0060376055,0.04545185,0.08862443,0.0065780785,0.02262047,0.035996165,-0.008734182,0.01916045,-0.0032478645,-0.0038453033,0.0254063,-0.017823713,0.00033308467,0.013739871,0.011747186,-0.015609814,-0.011491678,-0.03522239,0.011636947,-0.0178726,-0.022865707,-0.008399997,0.021322237,0.027877674,0.03412762,-0.067337796,0.004999465,-0.03237585,0.055447146,0.039845724,0.050749976,-0.01236531,0.030652216,-0.013815736,-0.030432533,0.05241867,0.0011138709,0.014311137,-0.0099473065,0.0045133103,0.0995029,-0.029976036,7.6346434e-05,0.020924345,-0.023760114,-0.0968435,0.030714402,-0.026208816,-0.044163883,0.08434274,0.028825644,-0.033439357,0.075573616,0.012241996,0.05156405,-0.03452725,0.004957831,0.06713297,0.021719217,-0.005237556,-0.017269475,0.043635435,0.045864493,0.04319786,-0.00021812679,-0.031787675,-0.015413498,0.08676155,-0.047592502,0.0146662975,0.029040009,-0.026957609,0.06710349,0.005583452,-0.0070642554,-0.0057483385,-0.024605684,0.049219687,-0.0796831,0.0044680727,-0.04224675,0.07515114,0.036987007,-0.00036762518,0.05693798,0.04472465,-0.0036615003,0.0021315087,-0.010467851,-0.026079396,-0.016249707,-0.012556592,0.025689946,0.025955264,0.020437432,0.013543189,0.11196335,0.11731546,0.02739918,0.057255905,0.011398317,0.0021867726,0.03022235,-0.02378861,-0.06642461,0.029919744,0.031410977,0.03582036,-0.031068662,0.0108444365,0.004888851,-0.00524247,0.007108406,0.005894792,0.035698537,0.022475624,-0.008459929,-0.01566132,0.038301058,0.013379719,0.0043575023,0.005842684,-0.017618248,-0.04098196,0.041142102,-0.01781647,-0.036041647,-0.005578355,0.006112133,-0.009760494,-0.10148056,0.03478871,-0.046016697,0.002572759,-0.011168093,-0.0476335,-0.029070646,-0.030817086,-0.020831523,-0.021347892,0.0022073693,0.042885076,-0.015113123,0.00097559375,-0.0020608848,0.062659204,0.026821446,0.025183449,0.036490154,-0.028123166,0.07816073,0.038591348,-0.007765672,0.008987916,0.011709224,-0.030667294,-0.040664528,-0.031066323,0.013657778,-0.017577043,0.012729374,0.050470404,0.03996884,-0.043887816,0.073107414,-0.0013956998,0.010179524,0.024497114,-0.015123504,0.006783809,0.041435793,-0.01951694,0.033205587,0.051911894,0.039067842,-0.044281933,0.034828294,0.047429524,0.0062073935,-0.052638397,0.020613195,0.021965584,0.067427784,0.013426694,-0.07641176,0.00042932006,0.012398682,0.030156655,0.026688846,0.03476233,-0.010064739,-0.038275946,0.013641965,0.10758417,0.0057789586,0.018668607,0.05433673,0.013869139,-0.026352402,0.0051807277,0.05707688,-0.07262264,-0.0043032644,0.06978446,0.058936425,-0.0006026991,-0.014601935,-0.02732548,0.04586824,0.062312692,0.010567339,-0.009695667,-0.03404256,-0.0052954503,-0.07196135,0.0050056186,0.03168574,-0.021073151,0.026224451,-0.0277106,-0.022992114,-0.030326905,0.019879807,0.0044833147,-0.017957263,0.026640518,0.07092884,-0.03230535,0.012592377,0.0027504363,0.018076979,-0.033205714,-0.0017066392,-0.013083739,0.057197917,0.005396102,-0.041540287,0.015538475,-0.0105064595,0.02917496,-0.051924635,0.00085124554,0.031281557,-0.021998582,0.0008412168,0.025344955,-0.038019095,0.01493078,0.022148283,0.021473346,-0.009577517,0.007969719,0.035556175,0.01736595,-0.04434443,-0.010754886,0.07692069,0.03976857,-0.0061510922,0.034364145,-0.017869456,-0.09490242]	\N	2026-08-05 16:52:16.988882
40	15	0	Tên địa điểm: Nhà thờ Đức Bà Sài Gòn\nMô tả: Nhà thờ Đức Bà mang đậm phong cách kiến trúc Roman pha trộn Gothic tuyệt đẹp, nổi bật với mặt ngoài xây bằng gạch trần đỏ au mang từ Pháp sang và hai tháp chuông vươn cao uy nghi. Khách tham quan thường đến đây để chiêm ngưỡng vẻ đẹp cổ kính, tham dự các thánh lễ trang nghiêm hoặc chụp ảnh lưu niệm cùng đàn bồ câu thân thiện trước quảng trường. Địa điểm này là một điểm đến không thể bỏ qua đối với tín đồ Công giáo, du khách yêu nét đẹp hoài cổ và cũng là một trạm thực hành thực tế cực kỳ giá trị để trau dồi kiến thức chuyên môn cho những ai đang rèn luyện nghiệp vụ hướng dẫn viên du lịch. Điểm nhấn đặc trưng nhất là bức tượng Đức Mẹ Hòa Bình bằng đá cẩm thạch trắng và không gian nội thất thánh đường thiêng liêng, tĩnh lặng giữa lòng đô thị nhộn nhịp.\nKhu vực: Bến Nghé, Quận 1, TP.HCM\nDanh mục: Nhà thờ\nHợp với sở thích: Lịch sử, Chụp ảnh, Nightlife, Kiến trúc, Văn hóa\nĐộ phù hợp nhóm tuổi: CHILDREN (3/5), TEENAGER (3/5), YOUNG_ADULT (4/5), ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (4/5)	[0.0048957462,0.054494675,-0.036264505,-0.010954598,0.026641889,0.057004735,-0.0010974172,0.0023452118,-0.03893429,-0.032867398,-0.0028348742,0.047096618,0.038780447,0.012793519,0.022597212,0.024549114,-0.064292066,-0.038534198,0.018631168,-0.045903783,-0.019851392,0.019965168,-0.010743408,-0.026738344,0.022893846,0.0024015966,0.024149531,-0.06985358,-0.014846406,-0.04723999,0.06950871,0.0056543374,0.04256008,-0.039570473,7.494731e-05,-0.02481298,-0.02230067,0.04965491,-0.01628796,-0.07196999,0.030079752,-0.032284558,-0.039369415,-0.042497203,-0.09158987,-0.010003293,0.054717,0.012592958,0.0086858375,0.028657932,-0.06624574,-0.002812051,0.051803537,-0.037852492,-1.4410276e-05,0.065258995,-0.0374849,0.0022034626,0.013411787,0.003169203,-0.023516499,-0.060999632,-0.019151714,0.041479964,0.041062444,0.010273389,-0.029449545,-0.014194306,0.040064868,0.0207645,0.053364757,0.031105934,0.07308226,-0.023453133,-0.01821927,0.034743324,0.0076393676,-0.0148242125,-0.07562763,-0.021624211,0.0051429085,0.050496217,0.0067919805,-0.009483592,0.020731987,0.052500177,-0.08191022,0.02845493,0.025896132,0.0097841695,-0.03381168,0.042107984,0.045033723,0.03719853,0.0020681021,0.0041712765,0.05917063,0.016349921,0.04138844,0.0133270165,-0.009562056,0.017846296,0.064198315,-0.01993601,-0.042240262,0.040513426,-0.0068438924,0.020031566,0.0037159573,-0.01956284,-0.001264007,-0.024469165,0.021643218,-0.00080954056,-0.041905213,-0.012284359,0.07517936,0.018586041,0.02381026,-0.04393824,0.013437068,0.08892211,0.045492977,-0.028800197,-0.036467213,0.045576096,-0.0030683957,-0.018660381,0.011120364,0.031084536,0.015354597,0.015618772,0.06255652,0.029877821,0.0006199593,0.027758138,-0.054013796,-0.0100094965,-0.057914484,0.026880765,-0.074200444,0.042099264,-0.013248895,0.03214612,-0.0228164,0.0077444827,0.025959706,0.054695785,-0.05926961,-0.03350941,0.056447633,-0.02868867,-0.05471873,-0.0024851975,-0.007548125,0.014145811,0.023207113,0.05012137,0.0150104705,0.00760935,-0.017068703,-0.040243607,-0.06694316,-0.020088399,-0.06089334,0.0028683997,0.006853943,0.0061734514,0.05519673,0.016006991,0.0168271,0.06117641,0.012293119,0.00568007,0.08525489,0.0215607,0.07592531,0.08032484,0.05200516,0.02082209,-0.013854947,-0.008122923,-0.015661078,-0.004837836,0.04198197,0.019731317,0.06856518,-0.06670674,-0.010557679,0.021476546,0.051191576,-0.019262178,-0.011177243,-0.0076892115,0.03563579,0.00031983358,0.009265792,-0.05572234,-0.0083111115,0.018125325,0.0008223224,-0.023932768,0.0016207047,0.041662194,-0.0372049,0.021942249,-0.0014921246,0.0927959,-0.024933038,-0.0074874233,0.027231677,-0.0009919981,0.0345697,-0.024102246,0.041956022,0.009977876,-0.03220378,0.0036131942,-0.009875134,0.023056028,-0.023246836,-0.019237207,-0.0070923083,-0.016154604,0.010051569,0.00353846,0.0068893614,0.006773961,-0.040160324,0.03273172,-0.02148969,0.071832925,0.014606704,0.041250654,0.0022146471,-0.03981759,-0.04471541,-0.0061095525,0.0027301912,-0.026603261,-0.0187641,0.023421153,0.0036425628,-0.004647623,0.01724121,0.035602484,0.027166266,-0.07853815,-0.004365963,0.04847102,-0.001688279,0.04049256,0.008012304,-0.0015530072,-0.015849948,0.02535523,-0.005786622,-0.035544176,0.025980229,0.0041201664,0.08764397,-0.019094774,0.017391788,-0.023137005,0.017549941,0.01334724,0.008219436,0.012472962,0.04602636,0.005696059,-0.00090858614,-0.025857614,0.0023200822,-0.037060875,0.008540535,-0.027653804,0.013565154,0.027667696,0.014109305,0.0093224365,-0.0140733095,-0.06658892,-0.019307863,-0.020652067,0.014089604,0.00984313,0.046999313,0.018986544,0.026676198,-0.013388766,0.021881506,-0.007224236,0.0012838091,-0.044571217,0.021961633,0.012324565,0.0015537653,-0.05117057,-0.01072766,0.017473748,0.02987609,0.01667923,0.0343433,0.038641486,-0.0046294164,0.03979842,-0.03677311,0.012845609,0.044718836,-0.0010696645,-0.02349666,-0.017526181,0.020139704,-0.016844882,0.003288257,0.020543218,-0.034825757,0.0035575503,0.02146805,-0.008681266,-0.055435218,0.04405471,0.053277627,-0.07602171,0.058410093,0.04003173,-0.010551906,0.048370376,-0.0010786827,0.02255689,0.0055922708,0.039447412,0.0027314369,0.037618876,0.0355868,0.04353527,-0.019737577,0.043298542,0.034912687,-0.02612321,-0.031723093,-0.06982538,0.04147526,0.06141292,-0.014566455,-0.01934613,0.041147646,-0.015037718,0.08594368,0.030129457,-0.05292962,0.01919418,-0.005154475,0.009159334,0.013095678,0.04411765,0.018971583,0.05018043,-0.016269363,-0.008942649,0.029150357,-0.02088428,-0.055695392,0.0761934,-0.034429636,-0.02103029,0.016572108,-0.027433692,-0.012769112,0.06527714,0.039079074,-0.042219877,0.020861153,-0.024822013,0.027119754,0.03231346,0.04498669,0.034015443,0.007081099,0.07270761,-0.079057485,0.052819014,-0.020525144,-0.04816115,-0.011396212,-0.020684225,-0.023815092,-0.04691204,0.020820023,-0.017316846,-0.007016318,0.0048876014,0.031182846,0.027008189,-0.015168263,0.07641576,0.019147549,0.04964418,0.049584016,-0.01604283,0.020119341,0.022851158,-0.06297485,-0.0018953662,0.028496962,-0.027815714,0.035846308,-0.0007013443,0.029725634,-0.021380818,-0.0028443595,-0.028114475,-0.007404167,-0.101250306,-0.0017752759,0.0037140786,-0.006757261,-0.0003988478,0.04665522,0.013048859,0.05343592,-0.025176954,-0.021360112,-0.019758169,-0.0358553,0.022741586,0.00437263,0.027592663,-0.021011265,-0.003983014,-0.0052961614,0.018564794,-0.030920362,0.056623206,0.045913476,0.049299512,0.019756269,-0.018832754,0.015823547,-0.04570679,0.06186751,-0.032773025,0.027130235,0.018558003,-0.07096389,0.012317976,0.0036830697,-0.057098385,-0.00070906495,0.0724185,0.009635626,-0.008902922,-0.004596729,0.0024300057,-0.034604467,-0.022978086,0.014793379,0.0024617745,-0.0018524496,-0.009197203,0.012995936,0.11416494,-0.022392128,-0.035222724,-0.022149416,0.036237303,-0.08801319,-0.051940758,0.05953925,-0.020457769,-0.0042158416,-0.004200039,-0.004078915,-0.007198708,0.045453064,0.039835032,-0.052772447,-0.041575182,0.02426992,-0.015375372,0.03875093,-0.033554524,0.018721852,0.003468702,0.062764406,0.013172561,0.019169768,0.035961226,-0.0011586873,-0.017066069,0.005673558,0.0047410363,0.032038406,-0.06213572,0.014476317,-0.019204307,-0.058977846,0.06531447,-0.025835652,-0.06185854,0.10630515,0.027832886,-0.0078009902,0.016721446,0.053816885,-0.06787315,-0.034549087,0.007039454,0.061060652,-0.024707712,0.056789663,0.030078216,0.055648573,-0.0003695935,0.008377348,0.028711068,0.029965179,0.046215687,0.054483242,0.047204252,0.0098110875,0.0020667203,0.006259393,-0.022230664,-0.030825233,-0.0011905951,0.034523442,0.004056021,-0.002509688,0.009629758,0.009731906,-0.07108388,0.0066507314,0.011488167,0.09163524,0.0019698534,0.010609354,0.009670379,0.0068710973,-0.006147356,-0.026122704,0.09257445,-0.02154616,0.03459553,0.01313918,-0.013731954,0.11355413,-0.02312834,0.013213922,0.031806085,-0.03233072,0.060589284,0.039385006,-0.034852922,-0.0055067763,0.02428247,0.0048455703,0.047856938,0.032228053,-0.0419416,0.020702682,-0.018711116,0.0049464107,-0.0015243229,0.037554827,0.078868896,-0.017602114,0.043791786,0.08482341,-0.030799855,0.082440056,-0.042590573,-0.047067743,0.077353336,-0.025415214,-0.038711455,0.035508446,-0.011959883,0.03607555,0.020549454,-0.0044538816,-0.073477834,-0.053715907,0.03918484,-0.06062665,0.026873147,-0.03968029,0.042881418,-0.0052632373,0.025617052,0.051117383,0.06683684,-0.057813045,-0.027595941,-0.003001518,-0.04609471,-0.07682768,0.012015614,0.03930385,0.021262052,-0.005210086,0.0617906,0.030056274,-0.04314695,-0.02086997,0.044394247,0.016790835,0.023732794,0.020414544,-0.003734426,-0.020208636,-0.024761088,-0.030306678,-0.016047483,-0.056845415,0.025785869,0.0055934135,-0.024677372,-0.04000939,-0.009009965,0.04813709,-0.04811646,0.072842196,-0.028675018,-0.0028067725,-0.0043556644,0.0049718465,-0.0072136745,0.0006204104,0.0053489143,0.084043734,0.011141089,-0.08851478,-0.0062138094,0.005997947,-0.03054102,-0.03038539,0.0004072526,-0.056490783,-0.0013300978,-0.041758306,0.0017705705,-0.011010061,-0.027803078,0.022844495,0.009074499,-0.016915472,0.031705998,0.009276491,-0.01237216,-0.0059238262,0.05299106,0.018989118,0.010813926,0.054756775,-0.0032977816,0.04651415,-0.002292807,-0.013408205,0.006189425,0.01477576,-0.027867489,-0.04113378,0.0127261765,0.008296188,-0.005676296,0.000117586926,0.016214574,0.054854676,-0.051623102,0.03965421,-0.04755174,-0.0238157,0.04552189,0.00258492,-0.017459191,0.06568231,0.005303267,-0.0112461,0.051782314,0.0024164382,-0.033108175,-0.034915075,-0.019725034,0.0041119005,-0.02403847,0.0005761127,-0.00018520879,-0.011887415,0.09033916,-0.024920633,-0.07926011,0.048382517,0.07020584,0.029462354,-0.009141362,-0.031672616,0.00795985,-0.04082342,-0.0058984356,0.0133516,0.016703013,0.06024716,0.0011942288,0.025158595,-0.061340146,0.020476567,-0.050522745,0.009912433,0.018843818,0.020704689,-0.019863637,-0.0011036422,-0.017330537,-0.0298396,0.085894376,0.044761244,-0.00974792,-0.0073027737,-0.00010580922,-0.057270747,0.0021524923,-0.006833903,-0.035569005,0.012045166,-0.0036377965,-0.03313127,-0.002293429,0.024290549,-0.01988116,0.04175872,0.011144194,0.024948373,0.002066537,-0.02921128,-0.01351016,-0.021764651,-0.03309492,-0.03515969,-0.027935756,0.033200644,0.053768657,-0.09802958,0.028753344,0.032092307,0.027034009,-0.025400463,-0.026876109,0.013041605,-0.023380587,-0.00065379444,0.007449573,-0.067563824,-0.023701565,0.013840006,-0.042981237,0.04386963,-0.0152893895,0.033772748,0.053665936,-0.026514094,-0.021973148,0.060010243,0.017739963,0.0084882565,0.007981604,0.043796536,-0.02842907]	\N	2026-08-05 17:13:31.446269
41	18	0	Tên địa điểm: Chợ Bình Tây\nMô tả: Chợ Bình Tây nổi bật với kiến trúc Á Đông lợp ngói âm dương và tháp đồng hồ trung tâm, mang đậm dấu ấn giao thoa văn hóa Việt - Hoa truyền thống. Đến đây, du khách có thể khám phá nhịp sống giao thương sầm uất của hàng ngàn sạp bán buôn đa dạng, thưởng thức ẩm thực đặc trưng khu Chợ Lớn và tìm mua vô số các mặt hàng phong phú. Đây là điểm đến không thể bỏ qua cho những ai yêu thích văn hóa giao thương, và cũng là nguồn tư liệu thực tế sống động cực kỳ hữu ích cho những ai đang rèn luyện nghiệp vụ thuyết minh tuyến điểm du lịch. Điểm đặc trưng nhất là khoảng sân trong (giếng trời) mát mẻ với bệ thờ ông Quách Đàm - người có công xây dựng chợ, tạo nên nét tín ngưỡng thương mại độc đáo hiếm có.\nKhu vực: Bình Tây, Quận 6, TP.HCM\nDanh mục: Chợ\nHợp với sở thích: Mua sắm, Kiến trúc, Văn hóa\nĐộ phù hợp nhóm tuổi: CHILDREN (3/5), TEENAGER (3/5), YOUNG_ADULT (3/5), ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (4/5)	[0.034773566,0.05479343,-0.02160525,-0.02519283,0.08388668,0.044611037,-0.098706685,0.04331596,-0.07029733,0.034094945,-0.04895645,0.036264304,0.043990687,0.033626005,-0.011518151,0.027829487,-0.04759525,-0.027121035,-0.040427756,-0.0014412916,0.02065032,0.038473498,0.0022372948,-0.037325915,0.025450202,-0.01659888,0.008188565,0.029679902,-0.06279896,-0.08526566,0.06502326,0.019930378,0.055904847,0.0323496,0.01065473,0.004469517,-0.011802723,0.051008254,-0.0056731184,-0.012120253,0.016722526,-0.051373746,0.045819458,0.018458443,-0.031481665,-0.017424827,0.06734566,-0.08087717,-0.011476796,0.045746945,0.009672013,0.026479753,0.040339947,-0.025689375,-0.041668236,0.026867382,-0.035105027,0.008998162,0.044535603,-0.0014273467,-0.017207513,-0.06280944,0.0050222026,0.0129363965,0.05039463,-0.0056686453,0.010146773,-0.019350488,0.018733013,0.06504753,0.06487014,0.020195862,0.06511664,-0.0025829272,-0.014250169,-0.0047710105,-0.020538805,-0.016883262,-0.025899915,-0.004320656,-0.0053275404,0.02796782,-0.036880936,0.017290661,0.01286811,0.02286817,-0.05194668,-0.026572652,0.024080308,0.016736802,-0.017247487,-0.01858002,-0.00930518,0.004951372,-0.011515103,-0.007279271,0.0030628198,-0.016994486,0.014738821,-0.075575866,0.029290708,0.017109416,0.046406753,0.011676833,-0.00663478,0.08689635,0.014033875,0.061971787,0.009913695,-0.004565748,-0.03302249,-0.014542392,0.019678576,-0.006380274,-0.022512354,0.017884582,0.019582806,0.04976241,0.023384208,0.0012495816,0.013501427,0.027867319,0.026479848,-0.075403124,-0.04160079,0.0089087775,-0.081453495,-0.015127468,-0.016054325,0.04881289,0.024396598,-0.014529966,0.01799718,0.0008134953,0.021251058,0.014910888,-0.025443127,0.012396447,-0.015896713,0.023978781,-0.0059152683,0.07596176,-0.010865498,0.07508178,-0.027759096,0.05364481,0.041513544,0.060926408,-0.005612852,-0.049472053,0.074316315,-8.045779e-05,0.014282193,0.025237799,-0.046594214,-0.015806079,-0.01624344,0.005318952,0.00919378,0.029494012,-0.0270226,-0.0060039405,-0.024318041,0.035250477,0.0028880483,-0.008444704,0.013603711,0.02116884,0.0733355,-0.014404268,0.0017284104,-0.0019618468,-0.04175051,0.010772645,0.0777556,-0.0055972384,0.08869796,0.03542948,0.0406947,0.031359885,0.0037682264,0.0033587553,0.0059885327,-0.06284025,-0.017402854,0.009027794,-0.009371603,-0.033050045,-0.036126822,-0.010016339,0.028059041,-0.02121303,0.036853276,0.028279753,-0.0070288284,-0.008917962,-0.008722819,-0.0056353346,-0.080429904,0.0107579855,0.023001892,-0.04008301,0.021792397,-0.018802235,-0.002617046,0.046402227,0.011675622,0.04792842,0.0031120898,-0.041042138,-0.024479065,-0.016537827,0.035662685,-0.033564925,-0.009438524,0.022393188,0.05643699,0.009796001,-0.011041527,0.016381027,0.016376836,0.051488552,-0.011777107,0.025889968,0.05337772,-0.0055042855,-0.0007035081,-0.029768841,-0.019171933,0.016584575,-0.032990895,0.0001326897,0.01936834,0.025770556,0.03510188,-0.06572861,-0.013098033,0.003320093,0.048441164,-0.0015540778,-0.04489149,0.0018394782,0.028077684,0.012192555,0.0074180756,0.060032215,0.030204533,-0.044972572,0.08943167,0.03857199,-0.04536778,0.054448258,-0.0022277117,-0.013150752,-0.020476773,0.010950673,0.024540266,0.02172491,0.036518116,0.02034742,-0.008420098,0.008457314,0.04157442,0.020232152,0.00476927,-0.026141929,0.072171964,0.044454977,0.04502234,0.021249585,0.039860148,0.0064808964,-0.042939715,0.051353242,-0.06835471,-0.012442721,0.0599488,0.019846437,0.026387792,-0.01824653,0.0074195606,-0.012069177,-0.0068730246,-0.02155694,-0.021545961,0.02626671,0.004017058,0.059237015,0.04374361,0.03909906,-0.030476386,0.008144025,-0.059187174,0.00071072695,0.07396714,0.0192023,-0.05713689,-0.06295837,-0.022374684,0.044009298,0.051478397,-0.054687858,0.023942351,0.052156635,-0.048039988,0.010107373,-0.037507568,0.045970142,0.010950725,0.06938521,-0.011366094,-0.021501932,-0.0028013939,0.028354948,0.032350153,0.005935578,-0.06714698,-0.026134303,-0.009786841,0.037065446,-0.047445603,0.054591138,0.020276383,-0.011175604,-0.014152149,0.03288207,0.011260829,0.040805515,-0.038369093,-0.017323075,-0.014559768,0.042808864,0.024347493,0.08113197,0.01470976,0.0062549743,-0.020852152,-0.019086655,0.01308963,0.0043038246,-0.030891355,-0.07617927,0.045113,-0.07769433,-0.043039348,0.04279697,0.046458974,-0.016465815,0.06374924,0.013803898,-0.020686828,-0.014113557,-0.0005185534,-0.018154273,0.10054279,0.029318852,-0.00070800906,0.043963592,0.008490218,-0.027048646,0.027797582,-0.0027619754,0.013638882,0.043833137,-0.0142444335,-0.04374058,0.03291722,0.016369939,-0.014415202,0.07132357,0.03215243,0.015518244,-0.02497044,0.012010144,-0.024948977,-0.0041951947,0.018038094,-0.010071898,0.029079944,0.01823349,-0.0436226,0.019273937,0.037260022,-0.0016668306,-0.0085577965,0.00040751375,-0.08526346,-0.016467122,0.019317867,-0.0002079461,-0.0064346083,-0.039947227,0.010985832,0.023100743,0.023197081,0.048177175,0.023534141,0.011663607,-0.028030317,0.05328084,0.00091271603,0.035531923,-0.057311255,-0.0026484316,-0.0077124606,0.038107097,-0.021775965,-0.026725648,0.0034817627,-0.015038312,0.01709056,0.0050470587,0.035818607,-0.08203796,-0.021746011,0.010134825,-0.009249739,0.020531517,0.0045649065,0.048002396,0.03881106,-0.06945557,0.006893674,0.07431674,-0.04058218,0.020665424,0.008010574,-0.012267567,-0.02053575,-4.072551e-05,0.00028516524,0.002080957,-0.060557704,0.055712737,-0.0070580873,-0.007572689,-0.038041815,-0.037647456,0.028051538,-0.04682791,-0.03049184,-0.020861132,0.0042457986,0.0369565,-0.081689976,0.019348336,0.026398188,0.011078971,0.012198728,0.004752338,0.032077093,-0.043334533,-0.043828078,-0.013767271,-0.033064853,-0.056428384,0.046237342,0.023275757,0.010919199,-0.011975664,0.013239359,0.0942304,-0.02359734,0.0027675137,-0.038975876,-0.035188694,-0.06938204,0.005140535,-0.0020349938,0.018834528,0.02786579,-0.008983018,-0.020252418,0.023443647,0.023628721,0.041268226,-0.044197593,-0.0070863483,-0.04887786,-0.054701056,-0.0218674,-0.08622892,-0.004205947,-0.01843925,0.07194967,-0.00350263,0.026720947,0.0053298487,0.045446407,0.016050177,-0.055019166,-0.016505374,0.019967506,-0.042344663,-0.0028668577,-0.04197399,-0.063362114,0.031802747,-0.004066854,-0.020615228,0.046164863,-0.073310986,0.044577584,0.016310757,0.076573215,-0.026014429,0.03354409,0.0068778694,-0.007655503,-0.050131768,0.0039473604,-0.003479855,-0.07311638,0.011690916,0.024665613,-0.020380434,-0.011854608,0.027655795,0.076213256,-0.009220292,-0.011157195,0.04014082,0.022056524,-0.03865788,-0.019471282,0.04826201,-0.01466155,0.008727194,0.0052037877,0.016270865,-0.025145723,-0.03156857,0.028690442,0.008925484,0.08983464,0.022852704,0.079577744,-0.016519058,0.021988928,-0.028849797,-0.03420943,0.033746623,-0.027286777,0.04502098,0.06934405,-0.028999636,0.091483615,-0.008124584,0.0005402424,0.0344157,-0.032377042,-0.029215252,-0.02715467,-0.004054715,0.0016944181,0.061994117,-0.045806125,-0.008105305,0.03290489,-0.050648764,0.030560985,-0.0052025625,-0.04949505,-0.03048906,-0.0051451204,0.0014709615,-0.06553722,0.03730388,0.022735693,-0.00418158,-0.007618372,-0.014844568,0.014666057,0.048157442,0.038495734,-0.023458334,0.048549853,-0.026043896,0.0722924,-0.015346437,0.032414764,0.0023045612,0.0017189273,0.0018143951,-0.09007694,0.021186536,-0.08854016,0.061896686,-0.05368257,0.013149712,0.040738724,0.0018393626,-0.0009109193,0.037562646,0.014903198,-0.013500926,-0.030076949,0.03429604,0.065646,-0.0067708204,-0.005777349,0.054986794,0.077510364,0.032362737,-0.0051962524,0.051392484,0.030592734,-0.008971971,0.042234275,-0.082663015,-0.074595,0.009061362,-0.01000246,-0.03369689,-0.028156657,0.0072387485,-0.040005714,0.007623993,0.0104497485,0.016280338,0.026537027,0.03654319,0.02857319,0.008234917,0.03333937,-0.01636226,-0.000851455,0.01918104,-0.031621467,0.013909173,-0.006436532,0.0045155925,-0.036301088,-0.012712615,0.0076937038,-0.029373348,-0.10499121,0.067374766,-0.048183378,0.017442925,0.016289037,-0.045842193,-0.03912235,-0.05208615,-0.013758626,-0.01101534,-0.0037353148,0.0053180167,-0.06038039,0.0075956113,-0.011385309,0.013880464,0.013946537,-0.0060592475,0.031158248,-0.035696615,0.056298833,-0.00028867388,0.020601152,-0.044300515,0.015031461,0.00083920284,-0.019570995,0.0041498467,0.035578586,-0.031013753,0.021436546,0.04608601,-0.02377542,-0.05052716,0.076538585,-0.023472443,0.015014519,-0.014354577,-0.025935378,-0.02675607,-0.031229367,0.044313125,-0.028332522,0.011453318,0.0032451658,-0.03013194,0.0060141594,-0.0030149824,0.0054318924,-0.077660374,0.030543076,0.00731744,0.07918609,0.0007549819,-0.0071350657,-0.03269887,-0.0098128645,0.079778306,0.019052548,0.02059617,-0.016015975,0.027609691,-0.021874482,0.0353847,0.046123262,0.008579071,0.049048718,0.03380844,-0.035816893,-0.030256629,0.063508786,-0.082895614,-0.03604316,0.05762469,0.041506704,-0.0014972368,-0.0032144382,0.029416775,0.019667085,0.038134106,-0.023116533,-0.020365862,-0.041915674,0.04158285,0.0023632606,0.005583703,0.033422567,0.0041945763,0.038462978,0.03269687,-0.017911825,0.042037416,-0.017944453,-0.0016514672,0.0078049353,0.047727183,0.027346374,-0.027191807,-0.018626457,-0.014463692,-0.008660473,0.00058903603,0.011343299,-0.006713065,0.06445901,0.051982597,-0.056995068,-0.015992014,0.0015924561,0.044254195,-0.034465645,-0.01650764,0.02863761,-0.08034667,0.01513391,0.022071596,-0.055035032,0.0092720445,0.034374926,-0.016020851,0.032707784,0.045006655,0.11470011,0.027379753,0.033394013,0.003562845,0.005031283,0.03752109,-0.0062465155,0.00588347,-0.008550143,-0.031974804]	\N	2026-08-05 17:22:55.106777
50	24	0	Tên địa điểm: Phố đi bộ Bùi Viện\nMô tả: Phố đi bộ Bùi Viện là khu 'phố Tây' sầm uất bậc nhất Sài Gòn, nổi bật với không gian nightlife rực rỡ ánh đèn neon và âm nhạc sôi động vang lên từ các quán bar, pub san sát nhau. Đến đây, bạn có thể ngồi uống bia thủ công ven đường, thưởng thức các món ăn đường phố đa dạng và hòa mình vào không khí tiệc tùng náo nhiệt cùng du khách quốc tế. Nơi này là thiên đường giải trí về đêm cho giới trẻ, và cũng là một môi trường thực hành giao tiếp tiếng Anh hoàn hảo cho những ai đang theo học nghiệp vụ hướng dẫn viên du lịch. Điểm đặc trưng nhất chính là sự đa văn hóa, phóng khoáng và nhịp sống không ngủ, biến con phố này thành điểm giao lưu không khoảng cách giữa người bản địa và du khách năm châu.\nKhu vực: Phạm Ngũ Lão, TP.HCM\nDanh mục: Phố đi bộ, Bar, Pub\nHợp với sở thích: Nightlife, Giải trí\nĐộ phù hợp nhóm tuổi: CHILDREN (1/5), TEENAGER (1/5), YOUNG_ADULT (5/5), ADULT (4/5), MIDDLE_AGE (3/5), SENIOR (2/5)\nKhoảng giá: 0 - 500,000 VND	[0.0444345,0.09284994,0.008949045,-0.037774727,0.03878421,0.027956257,-0.019360363,0.033225145,-0.00080866134,-0.020036912,-0.00066628837,0.031301644,0.033743042,0.043492965,0.00092993706,0.052500058,-0.049034737,-0.016729534,-0.04626894,0.018719608,0.023934567,0.005522825,-0.037688576,-0.008536735,0.023977766,0.027653722,-0.016258657,-0.014004699,-0.0377014,-0.060950466,0.09568017,0.027746294,0.009805275,0.016937906,0.08285842,0.050108176,-0.0089749005,0.07206433,0.05486737,0.022544436,0.012551089,-0.0719535,0.05162481,-0.01143078,-0.00031784657,0.007917802,0.02710127,-0.07365059,0.0019137783,0.08324209,-0.019991148,-0.0063212756,0.018811557,0.018005962,-0.02013684,0.030625677,-0.022976762,-0.0048367884,0.018344915,-0.030174237,0.017637245,-0.05162534,-0.016105426,0.0540569,0.046809025,0.027144983,0.012794882,-0.037786506,0.028458752,0.054610867,-0.012399688,0.07750114,0.028365698,-0.028239261,0.00666351,0.011333376,-0.03541472,0.061837886,0.030859731,-0.014186199,0.039587982,0.04379786,0.003732527,-0.0044934102,-0.029375492,0.038516697,-0.049454935,-0.00024496616,-0.0043382505,-0.019739632,0.026167091,0.0037929206,-0.0010598641,-0.03405407,-0.01189557,-0.024728002,-0.0020166228,-0.010708012,0.029992022,-0.02924099,-0.027340049,-0.018163688,-0.018550163,0.0016761518,-0.009769957,0.087083526,0.006481979,0.054122586,0.056895703,-0.0365287,-0.004753441,-0.036141474,0.044358548,0.010323896,-0.03574385,0.034483474,-0.007825934,-0.0003468837,0.008190411,0.058683988,0.021647312,-0.044983704,0.016983876,-0.031141322,0.016623806,-0.01462856,-0.06570757,-0.04286927,-0.047825444,0.039829016,0.035663776,0.009093869,0.015438941,-0.015057033,-0.00038381023,-0.015172813,0.0032467907,0.0064317035,-0.038009714,0.08964001,0.023129748,-0.014425763,-0.05767906,0.009366914,-0.010679296,0.03247007,0.0342261,0.021594567,0.016683886,-0.027913768,0.079013966,0.020924913,0.0021099597,-0.030823883,-0.06151838,-0.0316679,0.03569029,-0.034752775,0.0026047998,-0.0046837865,-0.019742288,0.0021364973,-0.012131319,0.07728061,0.0137607,-0.050873455,0.027377827,0.034810446,0.100348584,0.003355961,-0.008005924,-0.018762808,-0.016320517,0.0029031145,0.029937712,0.021626843,0.095311604,0.022418154,0.029023135,0.00085101946,-0.009875157,0.019149737,0.03156509,-0.06254562,-0.006305438,-0.005124705,0.0020909398,-0.040513825,-0.032684263,-0.065256976,-0.0034826053,-0.026345687,-0.004919999,0.026349591,-0.0056108334,-0.016846532,-0.043012243,0.034028687,-0.01822561,0.018164514,-0.0021747956,-0.08589894,-0.021261593,-0.05747371,-0.07809145,0.01901409,0.0066137407,0.09947002,0.004731791,-0.012878834,-0.0119399475,0.008260147,0.0073056626,-0.01804604,-0.07149803,0.017692925,0.03176472,0.033517312,0.00947233,-0.0051770867,0.015747687,-0.01020992,-0.010223089,0.0029196907,0.017568499,-0.08611428,0.046688035,-0.022929804,0.03344053,-0.019684877,-0.028023822,0.004040035,0.010735839,0.018177718,0.040494755,-0.025973594,-0.007578888,0.025390424,0.03544597,-0.0017174713,-0.060055163,-0.019135116,0.018131629,0.07701894,0.04097855,0.018803205,0.012983466,0.010540091,0.10587361,0.026129285,0.024155358,0.059832897,-0.003579217,0.01505879,-0.043598156,0.012052805,0.022551598,-0.054082982,-0.01385546,0.01512244,0.026992058,-0.022059202,0.011451346,0.017073859,0.016602848,-0.036426388,0.035609946,0.0226474,0.051735993,-0.052081306,0.061385937,-0.01153368,-0.018559521,-0.0040305457,-0.07078471,0.018443847,0.00084612245,-0.008412195,-0.02889711,-0.060760062,0.05239978,-0.035381034,-0.0039683534,-0.03076491,-0.036785368,0.03380524,0.004922561,0.044541653,0.022287287,0.006479195,-0.026211577,0.020529108,-0.092981845,-0.020140918,-0.008259284,-0.0118648885,-0.0034211725,-0.009781255,0.013471127,-0.0034662883,0.027002634,-0.04420213,0.003937766,0.01133884,-0.023756715,-0.015566182,0.013988545,0.025902893,0.04510854,0.095375516,-0.007834755,-0.015120738,0.0089776395,0.010660362,0.03923753,0.022202034,0.023207152,0.01557833,-0.0045439,0.032358687,-0.085185744,0.031723406,0.027972009,-0.019341135,0.037047364,-0.0015029594,-0.028711488,0.01546891,-0.031123267,0.034318045,-0.008553392,0.027391855,0.0003535824,-0.005965989,0.040106967,0.0020641757,0.04314293,-0.0012022625,-0.009228061,-0.021480734,-0.01841173,-0.06760806,0.011582732,-0.05421761,0.006686716,0.018755535,0.017661199,-0.015590753,0.04305644,0.00851178,-0.00047763548,0.0133977905,0.003752369,-0.023781719,0.06491953,0.03318426,-0.004035047,0.034748852,0.0019767785,-0.015075403,0.045855682,0.020632977,-0.050489828,0.01925377,-0.0149566,-0.036009487,0.04047072,0.01531807,-0.011610313,0.08100996,0.05689103,-0.033279948,-0.029256765,0.023206221,0.03811401,-0.016883876,-0.008498931,-0.030656284,-0.0033363502,0.059833903,0.011079003,0.010673919,0.03984183,-0.017394448,0.026319694,-0.023562554,-0.04661345,-0.025560983,0.03397652,-0.014748713,-0.01299012,-0.02907609,-0.035320327,0.047279242,-0.0052440376,0.06270221,0.0022526542,0.036582004,-0.021055387,0.0005456408,0.00094349217,0.055672605,-0.011688845,0.05509189,0.03139842,0.052722204,-0.039847028,0.022479946,-0.0007886426,-0.012140308,-0.0074824886,-0.03648805,-0.008617686,0.0057879775,-0.0071235383,0.023196304,0.028002169,0.009871995,0.036113326,0.034831066,0.033466242,-0.07550427,-0.00802853,-0.017791107,-0.018627727,-0.027587784,-0.003682269,-0.009989812,0.012610286,0.012185089,0.019598436,-0.0022257185,-0.011817981,0.054703444,-0.032167256,0.07564034,-0.023021,0.007937305,0.01977902,-0.049541447,0.002597451,-0.023617093,0.050174523,0.028512636,-0.0047741854,0.02434958,0.04101945,-0.0061391816,0.0048938496,0.02172692,-0.022847617,-0.01341717,-0.04310571,0.028503671,-0.0075547853,-0.053272605,0.057539612,-0.037204515,0.027638432,-0.00729454,0.010005748,0.024334293,0.018579112,-0.02082389,-0.004020683,0.007816571,-0.113171905,-0.03201542,0.009664224,-0.0112658115,0.045904994,-0.016663048,0.0029679316,0.011824043,-0.017315082,0.0056791697,-0.0050516417,-0.035384767,-0.020019205,-0.053636238,0.02789668,-0.10605757,-0.053269565,-0.014684615,0.03488058,-0.047309786,0.00023691288,0.047277033,0.016515866,0.0059363255,-0.10080205,-0.022072807,0.005960336,0.0018005054,-0.024234194,-0.011057598,-0.030023042,0.0055740224,-0.0017293504,-0.048960228,-0.022948401,-0.086728536,0.05695917,0.061815817,0.03475333,-0.00044748152,0.017670464,0.037110183,0.031215748,0.0046024066,0.02073692,0.04604693,-0.02665484,0.018734854,-0.011688208,0.014922037,-0.024485148,-0.0034007765,-0.005867131,-0.02486111,-0.05838401,-0.002554876,0.012611763,-0.0715908,-0.02605334,0.022623423,0.0023475576,0.03601066,0.032176066,-0.012519573,0.014440388,-0.06394593,0.020236664,0.0319858,0.019026244,0.02073851,0.09820843,0.015689336,-0.024479982,-0.05827277,-0.0276934,0.02202249,-0.021385856,0.04731077,-0.0019930003,0.0073871817,0.07151868,-0.03413089,-0.0006296524,0.059061307,-0.0010157824,0.02669095,-0.031598534,0.025305592,0.010010527,0.058054905,-0.00735658,-0.027611934,0.04911309,-0.07588215,0.06703078,-0.04683884,-0.0422904,0.024894992,0.020755654,-0.016336676,-0.05946794,0.038752303,0.02417528,-0.0063499315,0.002118006,-0.0022937022,0.033338152,0.046126626,0.0038424567,-0.009749606,0.008267263,-0.04316969,0.051664706,-0.0076298597,0.07099833,-0.020211004,0.008071153,-0.030414376,-0.061195176,0.005308348,-0.04980241,0.10141017,-0.00545463,0.032713823,0.043667313,0.013110493,0.04711607,-0.00026479902,-0.058469202,-0.0020656304,-0.023766197,-0.011723236,-0.033371292,-0.02097254,0.033469036,-0.010196024,0.07139388,0.09826192,-0.0017684995,-0.017788485,-0.04524257,0.052852716,0.014538651,-0.03179927,-0.06252761,-0.026393054,0.043200105,0.011112777,-0.023728458,0.010170354,-0.02332404,-0.038730215,-0.013162908,-0.029612508,0.017129667,-0.004082692,0.008655353,-0.020813147,0.011152629,0.07565481,0.016938658,0.02356301,0.010107244,0.021870352,0.09555703,0.023668656,0.030740615,-0.0063492605,-0.006629374,-0.0076858043,-0.05963275,0.04526472,-0.021570709,0.043599647,-0.047278352,0.006146876,-0.06102486,-0.031083085,0.012499635,0.016171794,-0.023259057,-0.023046635,-0.010918193,0.03478193,-0.0043498967,0.0008734574,0.008535376,0.0012851544,-0.01774931,-0.023280028,0.07570735,0.06785121,0.030863453,0.03008186,0.0015234317,-0.00086763874,-0.023616644,-0.024205245,0.040639594,-0.027702048,0.008787905,0.06457034,0.024301797,-0.070576124,0.0670907,-0.040880952,-0.03877949,-0.003704477,-0.024073452,0.036454067,-0.013184537,0.03802864,-0.040575203,0.04319634,0.023462322,-0.007574117,0.03663155,0.030284647,-0.009228726,0.0044092406,0.017642546,-0.009549911,0.04075621,0.0075783064,-0.047562197,-0.080432445,0.0038200093,0.016453264,-0.0016874122,0.034620684,0.0056535467,-0.0073507405,-0.008543467,0.059514415,0.055055965,0.0051335134,0.041987345,0.012932628,-0.04752693,0.027298588,0.04589366,-0.06002237,0.03711381,0.045983706,0.061296895,-0.030236643,-0.017031124,-0.003054634,0.04169549,0.020517051,0.038535386,-0.031601943,-0.051990036,0.07861414,0.017833428,0.0016860405,-0.009678461,0.045134384,0.057702165,0.025608184,-0.00044713946,0.043489583,-0.047011342,0.043027557,0.011071742,0.058815908,0.07171826,0.0014303715,-0.018077012,-0.022080192,0.023528362,0.023952747,0.042673398,0.011547261,0.057610888,0.057891186,-0.032952804,-0.041986328,0.0061645512,0.030609379,-0.06869122,0.032247458,0.023594944,-0.05681527,0.004764357,-0.037120137,-0.058701508,0.062197044,0.037501827,-0.02202388,0.023194335,0.06604079,0.024528824,0.02573066,0.0036480038,0.06897043,0.048689682,0.03252688,-0.0029955574,0.018160898,-0.058818433,-0.06240828]	\N	2026-08-05 19:00:04.180926
51	20	0	Tên địa điểm: Khu di tích lịch sử Địa đạo Củ Chi\nMô tả: Địa đạo Củ Chi là hệ thống phòng thủ ngầm kỳ vĩ dưới lòng đất, minh chứng sống động cho ý chí kiên cường và nghệ thuật chiến tranh du kích độc đáo. Đến đây sẽ được trải nghiệm cảm giác chui hầm thực tế, thử tài tại trường bắn súng thể thao quốc phòng và thưởng thức món khoai mì luộc dân dã. Địa điểm này đặc biệt phù hợp cho du khách thích vận động, giới trẻ và những ai đam mê khám phá lịch sử thực chứng. Điểm đặc trưng nhất chính là mạng lưới hầm chằng chịt như mạng nhện dài hơn 200km, được thiết kế tinh vi với đầy đủ bếp Hoàng Cầm, trạm xá và không gian sinh hoạt ngầm.\nKhu vực: An Nhơn Tây, TP.HCM\nDanh mục: Di tích lịch sử\nHợp với sở thích: Lịch sử, Thiên nhiên, Giải trí, Văn hóa\nĐộ phù hợp nhóm tuổi: CHILDREN (3/5), TEENAGER (5/5), YOUNG_ADULT (5/5), ADULT (4/5), MIDDLE_AGE (4/5), SENIOR (3/5)\nKhoảng giá: 35,000 - 100,000 VND	[0.02360416,0.07013431,-0.044653457,0.02953835,0.05987513,0.037907675,0.018023169,0.01570354,-0.05338808,-0.03175633,-0.048036188,0.018679656,0.024506599,-0.026494334,0.036356285,-0.02333334,-0.006005615,-0.021478103,-0.02333798,0.009272953,0.056729853,0.027878813,0.03843652,0.002180783,-0.029403666,0.03261064,0.024188878,0.010605992,-0.03842163,-0.07888139,0.04447055,-0.04861965,0.015773447,0.0014411235,0.013168715,-0.026099425,-0.035588324,0.056352373,0.013187377,-0.00772567,0.03586701,-0.0073959343,0.0036589066,-0.057437282,0.0056111603,-0.010450431,0.034140058,-0.017336378,-0.012826552,0.022835806,-0.02478889,0.0069205407,0.0057612206,0.037492786,-0.025695557,-0.04413461,-0.038466576,0.021064593,0.011842698,0.012529493,-0.04259958,-0.009529361,0.066560455,0.024244515,0.020872341,-0.024548529,-0.036982372,0.013351317,-0.005212101,0.009186293,0.022108711,0.039758436,0.044612046,0.030022537,-0.014554196,-0.017840551,0.02458958,0.10460503,-0.011224872,-0.065843806,0.045754045,-0.0041282573,0.0035176014,-0.009343504,0.042579494,0.007221156,-0.042295635,-0.022962168,-0.00025485083,0.002424897,-0.020719746,-0.02214249,0.017928863,-0.00092851126,-0.003714319,-0.02248447,0.0040171924,-0.022853108,-0.017692242,0.0033919918,0.03122488,0.04342498,0.017256686,-0.022790978,-0.053006068,0.02822486,0.0116515625,0.03112263,0.016684161,0.03891854,0.027315268,0.00032015244,0.06658932,-0.01212698,7.572199e-05,-0.015343651,0.062446166,-0.014106849,0.004150468,0.018893348,-0.0105036935,0.010027925,-0.010874867,-0.05443973,-0.029006403,0.0018781975,-0.026712405,-0.026308639,-0.020593261,0.034360573,-0.016382322,0.031507485,0.040609177,0.005874102,-0.0025842749,-0.037066065,-0.04942525,-0.00050591247,-0.031241583,0.027976204,0.016461335,0.025044661,0.0071042217,-0.0013835939,-0.020230934,0.06774163,0.04656147,0.07714615,0.005937872,-0.044632714,0.033778004,-0.048430327,-0.023459394,0.00060415606,0.041247588,-0.008901416,-0.024354955,0.0055071646,-0.008490601,0.00021557689,0.0032471914,0.0024565079,-0.00091559626,-0.016530551,-0.008644641,0.028407913,0.0016417664,-0.04868804,0.054440048,-0.006767841,-0.04422181,0.06355222,-0.0005431926,-0.023732847,0.06632048,-0.0066457093,0.022179943,0.07915095,0.04794084,-0.0046146056,-0.0012922375,0.009283393,-0.014809802,-0.016671704,-0.011830794,-0.008708767,0.0032363688,-0.038447555,0.0052309018,-0.01594641,0.029530738,0.009126632,0.04310155,0.002981153,0.05152168,-0.034918886,-0.014848802,0.027301844,0.016675498,0.0053302404,0.04379853,-0.04352039,-0.002664045,-0.008686131,-0.015996909,0.03405412,0.046543736,0.056609444,-0.0037100562,-0.033129055,0.015286524,0.02167162,0.033712756,-0.020522164,-0.004543348,0.0014733719,0.024946412,0.057613023,0.028123878,-0.023330603,0.023454363,-0.005629082,-0.006073721,-0.008519562,0.047003787,-0.012966738,0.010728848,-0.022025334,-0.032102067,0.01984976,-0.07229083,0.030811403,-0.050034467,0.0073897606,0.019982178,-0.030384332,-0.015467989,0.022899283,0.0077197035,0.0029069511,-0.079675786,-0.03449059,-0.03702499,0.026198804,0.028214352,0.0017956571,-0.012807509,-0.04719822,0.13589077,0.024421487,-0.03361209,0.03611677,-0.026987584,-0.009869927,-0.022994004,0.031284608,-0.019262565,-0.06013512,0.03040213,-0.0416564,0.015596676,-0.056459177,0.046523195,-0.014960464,-0.0065964162,0.0057502193,0.017676182,0.062247038,0.034195382,0.008485949,0.039794248,0.08102073,-0.06742344,-0.011814907,-0.045233317,0.015091096,0.012191803,-0.0073655676,-0.001363413,-0.081607334,0.020376932,0.006539206,-0.0018106523,-0.045292716,0.030908938,0.022023035,0.06443541,0.09519139,0.013701819,0.0535582,-0.0014677942,0.025309855,0.008196892,-0.03303483,0.067070425,-0.0055901106,-0.0034633342,0.028817602,0.010695178,0.0043742075,0.002570976,0.0014440448,0.044601437,0.031880885,0.026523096,0.02363945,-0.0018896025,0.0022413244,0.02497011,0.020869747,-0.00065369305,-0.020852827,-0.024097867,0.002457406,0.05448587,0.045084294,-0.059158035,-0.022314569,0.016752377,0.016352208,-0.053119585,0.058713634,0.003903233,0.04204615,-0.03399504,0.034764487,0.0010705335,-0.049793266,0.03012539,0.054202233,-0.024765175,0.013451682,0.0011745627,0.06081268,-0.04404145,-0.01943319,-0.012788525,-0.019743804,0.019314375,0.02640559,-0.020528477,-0.058232658,0.037741594,-0.024268609,-0.010638672,0.05361606,0.052989617,-0.00020853485,0.056774955,-0.015228886,0.001141708,0.006762873,0.014681352,0.010046078,0.06493373,0.002844534,-0.014248214,-0.0009616633,0.00052414683,-0.007883985,0.008233768,-0.014081228,0.006436799,0.06482176,0.005233042,0.033084974,-0.051863533,0.0055731214,-0.018512076,0.0067700273,-0.018690431,-0.009865112,-0.016862595,-0.015362429,0.034309857,0.021169607,0.03983966,0.01727527,-0.019660976,0.013170779,-0.028534655,-0.018688044,0.029444134,0.04313453,0.06406361,0.009206054,0.032116607,-0.04530878,0.00815392,-0.015065235,-0.0082020005,-0.0035920339,-0.05070592,0.038142044,-0.031798802,0.008610155,0.024059352,0.013310994,-0.042416196,-0.008935266,0.056460753,0.014449422,-0.015535229,0.041969948,0.039242778,0.0030196137,0.0025722838,0.013102554,0.044003442,-0.029697258,0.018132146,0.047967475,0.023121968,-0.06527031,0.019544773,0.00016304446,-0.0063803233,0.00393112,-0.06117499,0.04557166,0.07793359,-0.006196027,0.010426853,0.027941782,0.010083331,0.012912674,-0.006728793,0.0042645154,0.012614006,0.07014869,-0.007687084,0.014831796,-0.037848204,0.034036756,-0.062828,0.044754863,-0.06492123,0.0016521967,0.019874291,-0.053703498,0.019709576,-0.065635264,0.043985367,0.029830879,0.023876902,0.018745374,-0.025666468,-0.008405332,0.041699946,-0.047142908,0.032424316,0.02486784,0.046842013,0.041722953,-0.06086614,-0.021846138,0.07809756,-0.0126211895,-0.007024409,0.024435515,-0.033691995,0.095820606,-0.021723244,-0.021160621,-0.06942233,-0.05036049,-0.05898141,-0.005678056,0.011161436,0.046510637,-0.020317107,0.004509766,-0.008099802,0.031172642,-0.0035105161,0.052280247,-0.09553287,-0.021023422,-0.0063896426,-0.006093617,-0.011511372,-0.0774331,-0.020989785,0.0052283593,0.034319032,-0.047988493,-0.0074854125,-0.0025997262,0.021623127,0.046340674,-0.045354396,-0.061868813,0.052918892,-0.05830726,-0.015105479,-0.055536345,-0.058948174,0.036859028,-0.042089734,-0.07258935,0.03323421,0.03171924,0.060734153,0.034105085,0.08247337,-0.09204284,-0.009527231,0.0213944,0.012173776,-0.025942858,0.015259398,0.019581698,-0.0009270858,0.010302727,-0.021142004,-0.0035839975,-0.0207821,0.020995546,-0.0062244586,0.011839615,-0.0354408,-0.011156951,0.02115775,-0.027336743,-0.0044565084,0.015857311,0.020154929,0.025559573,-0.019890103,-0.009718331,-0.0568597,-0.06638133,-0.013685866,0.019805867,0.056118667,0.023708923,0.06084709,0.019983536,0.033342205,-0.0462391,-0.017465625,-0.02426309,0.014485901,0.014659323,-0.024833543,0.005686256,0.15411341,0.0021551054,-0.035010293,0.05126248,0.023475002,-0.025257735,-0.0041086213,-0.03038222,0.027511787,0.058607906,-0.026130712,-0.015184278,-0.013258107,-0.04609472,0.08935698,-0.0329294,0.003993831,-0.020838603,-0.0011124078,0.0041895295,-0.08061922,0.06384227,0.0014693679,-0.037318084,-0.013346236,0.042450618,0.034565233,0.021442022,-0.010523218,0.045107964,0.045597404,0.05132809,0.05762416,-0.021122871,-0.033789665,-0.053189185,-0.028334137,0.061195847,-0.07436014,0.04060398,-0.08843442,0.0662983,0.0001626749,-0.017354626,0.027297234,0.04670714,-0.017021857,0.033625357,-0.018827785,-0.015814345,-0.041212592,0.030495457,0.04857148,-0.022539958,0.008076082,0.015019662,0.057300724,0.056644727,0.017303232,0.029068677,-0.029187975,0.06270018,0.02583556,-0.0057041217,-0.037425913,-0.027318323,0.007498761,-0.0043250006,-0.0313928,0.0098771155,-0.00391549,0.0052095377,0.0033143898,-0.012145671,0.023728935,0.034328975,0.08550694,-0.05115775,0.0065149376,-0.002237257,-0.0047914246,0.012771378,-0.00013472314,0.0038506752,0.06163108,-0.033803146,-0.006762636,0.018810933,0.003719892,-0.02606122,-0.10666342,0.05408967,-0.05199515,0.032444544,-0.05355765,0.044610377,0.02135558,-0.0306275,-0.042909715,0.017268147,0.025892122,0.043038093,-0.01702944,0.025496518,-0.027363308,0.038552973,0.012352756,-0.0019068972,-0.009958002,-0.032469414,0.06544884,0.020267883,-0.03544526,-0.04291011,-0.02790969,0.028346417,-0.05113138,0.025070596,0.022039814,0.033620518,0.021879524,0.04090246,0.013707951,-0.07466151,0.054491058,0.015444065,0.012176314,0.05122729,-0.01438145,0.07112357,0.03194436,-0.033260453,0.021667447,0.027297689,0.0038702039,-0.053597465,-0.0047885547,0.0067617605,-0.012868087,0.041712,0.020779984,0.0026976129,0.027131328,0.034463435,-0.008539815,-0.061717868,0.017800484,-0.024559848,0.05970058,0.021389604,0.028345829,-0.041952994,0.0019354181,0.043369543,0.014322507,-0.037819404,0.09191137,-0.033273827,-0.06266408,-0.032901227,0.017279245,-0.04257565,-0.008046445,0.052530184,0.05415542,0.04672552,-0.022272479,-0.013959306,-0.008427229,-0.018264951,0.035802815,-0.005956889,-0.11474817,0.0785212,-0.023526568,-0.02318807,-0.0120124,0.003932493,0.03513969,0.0064091124,-0.056465376,0.012200372,0.033963643,-0.03498696,0.042063106,0.033521716,-0.0032183016,-0.021791074,-0.021458033,0.034753893,-0.077176355,-0.0053161117,0.002396712,-0.050768603,0.080604106,0.0028664505,-0.06000767,-0.028853381,0.03378601,0.092109494,-0.026935317,-0.00012452004,0.0504988,0.002918485,0.011167441,0.0055102822,0.017451886,0.029368496,0.0045856065,0.013907405,-0.0022697113,0.052906256,0.06178722,0.027101273,-0.030049669,0.00081680017,0.036208812,0.0036709276,-0.026225215,0.07336218,0.033971798,-0.07073927]	\N	2026-08-12 15:42:43.70218
53	12	0	Tên địa điểm: Đầm Sen Khô\nMô tả: Đầm Sen là một trong những khu du lịch lớn đặc sắc nhất nước Việt Nam. Kiến trúc được kết hợp một cách hoàn mĩ nền văn hóa Đông-Tây và một chút vẻ đẹp thời La Mã. Ngoài những khu vui chơi, Đầm Sen còn có những nhà hàng, khách sạn và hàng chục các loại hình khác để phục vụ khách du lịch. Đầm Sen là nơi vui chơi giải trí rất hấp dẫn cho người trong và ngoại nước.\nKhu vực: Bình Thới, TP.HCM\nDanh mục: Khu vui chơi\nHợp với sở thích: Giải trí, Gia đình, Thiên nhiên\nĐộ phù hợp nhóm tuổi: TEENAGER (5/5), YOUNG_ADULT (5/5), ADULT (4/5), CHILDREN (4/5), MIDDLE_AGE (3/5), SENIOR (1/5)\nKhoảng giá: 100,000 - 300,000 VND	[0.032008987,0.05655206,0.027561588,-0.050851997,0.026579065,0.04908922,0.00928043,0.07147534,0.014889861,-0.0102435835,-0.079036966,-0.00495447,-0.0017590249,0.006027377,-0.025550835,0.03138069,-0.016347986,-0.021829275,0.026246887,0.006261938,-0.039078537,0.017643886,-0.018662205,-0.029081479,0.013842627,-0.013917212,0.058477916,0.031581108,-0.002127658,-0.038334545,0.054074578,0.012993515,0.044499874,-0.033267718,0.046366233,-0.01463785,-0.015399829,0.038462248,0.00089143077,-0.005751808,-0.029697174,-0.031162506,0.06262908,-0.012061117,-0.035789516,-0.028843325,0.0154547915,-0.019700855,0.003599683,0.059326366,-0.020670883,0.051468227,0.03864953,-0.004646911,-0.07561808,0.032301188,-0.01106006,0.037500795,0.030065563,-0.012655357,0.022944955,-0.08665276,-0.007329659,0.056431133,0.040335204,0.0178259,0.015000079,-0.0057425285,0.019218033,0.02424825,0.06156868,-0.0745409,0.041043468,0.022178683,-0.016554963,0.03472645,-0.030462261,-0.027466897,-0.0280486,0.0049204156,0.0356595,0.023209143,-0.022845402,-0.058346048,0.04307568,0.096333735,-0.058366418,-0.027521417,-0.014183376,0.023951162,-0.050465733,-0.019084347,-0.020140627,-0.0020365445,-0.023100117,-0.028858714,0.0193251,-0.035646714,-0.030807717,-0.018764708,-0.010901293,-0.04295455,0.055081073,0.00040392872,-0.03852458,0.014090866,0.045943193,0.005205455,0.017729834,-0.0108373985,0.025492176,-0.03588276,0.033415012,-0.014476891,-0.045224823,0.030162362,-0.036300067,-0.016374692,0.05324659,-0.021725506,-0.021029484,0.043161467,-0.01440204,-0.04980913,-0.04021722,0.016350837,-0.055506133,-0.021115016,-0.018974679,0.059487578,0.009687499,-0.032064367,-0.011629055,0.050662808,-0.045951355,-0.023144016,0.020255871,-0.0057975915,-0.048129786,-0.013621907,-0.015227887,0.030009715,-0.027477544,-0.050123453,0.019277534,0.037990876,0.050654065,0.04193561,-0.04701339,-0.04176328,0.0037415777,-0.006507059,-0.0048424206,-0.005418638,0.0016639672,-0.050148696,-0.012975697,-0.029967088,0.020233218,0.006088577,-0.05677087,-0.024295732,0.06637905,-0.004752725,0.037529837,-0.020544738,0.033087365,0.028495166,0.059548184,-0.00095955754,-0.021486571,0.088244855,-0.05224183,0.013561401,0.07968755,0.033032924,0.03245473,0.049038358,0.020318061,-0.010576615,-0.0026938815,0.052799135,0.025806809,-0.0018395376,-0.01347235,-0.038928267,0.070838965,-0.071634635,-0.010042864,0.005098038,0.008449047,-0.010383592,0.060172416,0.0035341536,-0.0395947,-0.04208654,0.01698574,0.010938327,-0.018034525,-0.06171795,-0.033284828,-0.017929666,-0.025813423,-0.04687483,0.019942265,0.10417483,0.025583053,0.05393901,-0.005324825,-0.0054852045,-0.010221207,0.027742852,-0.040863194,-0.014993134,-0.0068933666,0.042258125,-0.023227734,0.018944222,0.053745028,0.030451743,-7.889149e-05,-0.011420563,0.04180602,-0.007667151,0.048590653,-0.0035006707,0.00648191,-0.055142898,0.034813326,0.0015811973,-0.056736406,-0.015544047,-0.010359718,0.040275905,0.043055292,0.0062117865,0.024253743,0.011276031,0.022231787,-0.004532525,-0.04263909,-0.03980535,0.032873824,0.04813024,0.023829104,-0.05921986,-0.031614225,-0.08513781,0.0058215805,0.042550784,-0.037828233,0.04596479,-0.04343233,0.011968655,0.003428307,0.009864688,-0.009659956,-0.006386041,0.041701723,-0.0068459795,0.052046742,0.005153068,-0.023609238,-0.0066809477,0.008372959,0.011520488,0.04288178,0.029609505,0.05091598,0.0294921,-0.013973471,0.035078887,-0.044310987,-0.016840996,-0.0071127587,-0.02802398,-0.017477958,0.03838709,0.019067861,-0.05888303,0.036249854,-0.008050107,0.024372559,0.0143665355,-0.058799583,0.04523977,-0.02153392,0.058772217,0.045759346,0.043488752,0.013974304,0.045953345,-0.019845128,0.035178185,0.04052521,0.0032562402,0.022731341,-0.0019515621,-0.011549421,-0.030039264,0.0007585711,-0.013392548,0.007924502,0.030679852,-0.049961098,0.009059375,0.010722233,-0.03009717,0.03422133,-0.0026987311,-0.00447788,-0.059713032,-0.012309148,0.07724585,0.033533383,0.008499477,-0.031034116,-0.057427496,0.055929694,0.04331883,-0.032378502,0.0027923977,0.029489173,0.012242691,-0.063775584,0.04087868,0.066929534,0.043384396,-0.003202026,0.026065487,-0.007296154,0.022950536,0.021184346,0.026731929,-0.029632453,-0.014907924,-0.023669893,0.005740718,0.028081955,0.031759303,-0.011892623,-0.032142665,-0.012393781,-0.035780057,-0.03827243,0.05487154,0.0133305285,0.011484259,0.03683612,0.014511645,0.028196074,0.03072323,0.020956764,0.03442722,0.08876821,0.0021947497,0.015463678,0.00073447195,-0.033550188,-0.020357797,-0.015133008,-0.03899964,-0.03980841,-0.009924043,0.01532711,-0.0054383925,0.022636008,0.030364715,0.010458456,0.07717783,0.003778112,-4.112643e-05,0.0025480022,0.042422708,-0.0027782095,0.060706463,0.038667694,-0.03188511,-0.01610826,0.010062481,0.0005872337,-0.0393922,0.0065793474,0.032497983,0.03707932,0.044308126,-0.08403174,-0.023248024,0.0471163,-0.008459849,-0.040206756,0.052631017,0.012265439,0.009591944,-0.0697192,0.05696024,-0.005949114,0.018775852,-0.024893267,-0.009114514,0.008146685,0.07088656,-0.047964238,-0.015769618,0.034830797,0.013097423,-0.049598277,0.007329809,0.071613416,-0.0020948444,0.024627352,-0.018912349,0.017210046,-0.02769901,-0.012444142,0.028078578,0.03447307,0.042870548,-0.03880139,-0.02189265,0.0032593675,-0.024754716,0.025265262,0.03820728,-0.014510317,-0.002747692,-0.008082276,-0.052799996,0.006008531,0.059346173,-0.021135999,0.039187405,0.046424363,0.024850937,-0.008120963,0.01341253,-0.05203322,-0.0026776043,0.036031213,-0.031043887,0.0052389083,-0.09129274,-0.010897086,0.05667085,-0.059945125,0.040214773,0.019735025,0.014781825,0.014239423,0.012221639,0.028769994,-0.052255012,-0.033773597,0.016685797,-0.033171006,0.015546713,0.05853357,-0.029239975,-0.01995821,0.014976161,-0.04163762,0.10642049,0.06483759,-0.00048931286,-0.02800498,-0.023377195,-0.10114472,-0.018453661,0.03889043,0.019323258,-0.015415911,-0.004312247,-0.0045502516,-0.029490532,0.050000183,0.029426917,0.006762721,-0.023526682,-0.0045095766,-0.03289161,-0.012976154,-0.054504674,-0.007866609,-0.0020015186,0.10281949,-0.00915057,0.053809166,-0.013722931,0.036972098,0.04527627,-0.043924235,-0.019989839,0.06587899,-0.033960264,-0.03157489,-0.019905567,-0.0079568345,0.0747995,-0.045152545,-0.016618093,0.042861156,-0.04999835,0.029861549,0.014258303,0.047656607,-0.009712164,0.05071927,-0.017374618,0.06525352,0.0159413,-0.008129933,0.05776767,-0.0136901215,0.0072167735,0.02181758,-0.03392238,-0.00972193,0.0011121816,0.0331737,0.010565376,-0.037661683,0.00489634,-0.013886263,-0.01210805,-0.018392831,0.009454233,0.02341151,0.0012012458,-0.0066359914,0.04674713,0.010246881,-0.010401445,-0.018140392,0.011255379,0.0067718364,-0.018882805,0.07341016,0.040920608,0.050000507,-0.035205357,-0.022808176,0.028730242,-0.031848993,-0.02093948,0.017197987,-0.009978309,0.10493844,0.0007592143,0.008861507,-0.035757847,0.014209726,-0.0018782202,-0.0052297725,-0.052642483,0.011251047,0.012527587,-0.02218146,0.004792408,0.051351078,-0.04806258,0.068665065,-0.04305209,-0.014176245,0.02543705,0.0384859,-0.014763155,-0.032108076,0.06358659,-0.0025055108,-0.045193855,-0.015383661,0.052538395,-0.032296367,0.027325924,0.061784986,0.01271161,0.06273831,-0.0028821635,0.053820916,0.021095801,0.0484321,-0.0066101155,-0.01557871,0.04268303,-0.07466611,-0.021259567,-0.028144216,0.1278664,-0.051811766,0.0067932406,0.04167883,-0.014594897,0.0057778545,0.043271087,0.009215237,-0.021750694,-0.059750184,0.020648848,0.011020366,0.024965862,0.0006084844,0.006404155,0.072416864,0.08714438,0.025993928,0.013594909,-0.005691578,-0.022661867,0.026026009,-0.029381996,-0.050226066,-0.019999273,-0.0065738005,-0.01718986,-0.018756386,-0.037487045,0.012914617,-0.017868355,-0.0026938855,-0.06092451,0.00965072,-0.014060802,0.03147865,0.0010822788,0.019538272,-0.01062653,0.05205603,-0.0176279,-0.027741406,0.00495598,0.023678083,-0.030270888,-0.0035987555,-0.034952585,0.03368825,0.02201914,-0.03920248,0.011223567,-0.03922295,0.07615562,-0.0076666037,0.0359927,-0.07015174,0.04882899,-0.014852958,0.004287666,0.0060104486,0.025936663,-0.05205328,0.015330277,0.02696807,0.019681629,0.0020770961,0.048713952,0.034615897,-0.047981527,0.058643863,0.036308903,-0.06988989,-0.013692129,0.016875144,-0.004408468,0.018704278,0.013377705,0.013421992,0.047133204,-0.0060899532,0.020358814,0.01640452,-0.059979476,0.050756056,-0.04112249,-0.0012848955,0.00010570342,0.011615623,-0.029673278,0.0003934116,0.036753442,0.04063442,0.0384305,0.040839702,-0.047760762,-0.026073026,-0.033878755,0.035127744,-0.055165637,0.0667748,0.027040634,0.09393091,-0.044016,-0.05762052,-0.057503957,0.019026719,-0.018895287,0.036597665,0.013686334,0.00036309543,0.05752875,-0.03600395,0.09974036,0.004842382,-0.021809958,0.062246613,0.015699202,-0.047392994,-0.016616674,0.05480297,-0.08506545,0.0035736081,0.032556914,0.019189121,0.033085022,-0.03952109,-0.0043257303,0.032429226,-0.027424188,0.026456045,-0.019296033,-0.05302978,0.005386554,-0.043831855,0.0044489834,-0.0070796018,-0.024130268,0.06406282,0.0091251945,-0.058574405,-0.015453846,0.013815257,0.023877233,0.037073478,0.025906792,0.087358415,-0.059816748,-0.009081519,0.01417282,0.0010554162,-0.019392291,0.023011087,0.027624896,0.05462881,0.047919102,-0.057757918,-0.03713078,0.038449943,0.07580316,-0.042861953,0.0010871483,0.019851513,0.007342324,0.0017851467,0.018859226,-0.026202688,0.028131858,0.005401299,-0.012618523,-0.0007917748,0.05781436,-0.0028150838,-0.029785238,0.022234377,0.02002127,0.015748447,0.05654492,-0.00805087,-0.011763638,-0.023314744,-0.007795777]	\N	2026-08-12 17:44:43.632265
54	17	0	Tên địa điểm: Nhà hát Thành phố Hồ Chí Minh\nMô tả: Nhà hát Thành phố mang đậm phong cách kiến trúc Flamboyant thời Đệ tam Cộng hòa Pháp, nổi bật với mặt tiền được trang trí bằng các bức phù điêu và tượng điêu khắc nghệ thuật tinh xảo. Du khách đến đây có thể thưởng thức các chương trình biểu diễn nghệ thuật hàn lâm, vũ kịch đương đại hoặc đơn giản là tản bộ, chụp ảnh tại khu vực quảng trường rộng lớn phía trước. Địa điểm này là không gian thưởng thức văn hóa sang trọng dành cho giới mộ điệu, đồng thời là một công trình di sản thực tiễn cực kỳ giá trị để trau dồi kiến thức lịch sử, kiến trúc cho những người đang rèn luyện nghiệp vụ hướng dẫn viên du lịch. Điểm đặc trưng nhất là sự lộng lẫy của không gian nội thất với hệ thống vòm mái, đèn chùm pha lê và ghế bọc nhung đỏ, tạo nên một thánh đường nghệ thuật đẳng cấp giữa lòng trung tâm sầm uất.\nKhu vực: Sài Gòn, TP.HCM\nDanh mục: Công trình kiến trúc di sản\nHợp với sở thích: Lịch sử, Chụp ảnh, Giải trí, Nghệ thuật, Kiến trúc\nĐộ phù hợp nhóm tuổi: YOUNG_ADULT (4/5), ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (4/5)	[0.0527454,-0.008943757,-0.030389864,-0.05153929,0.013498563,0.04330916,-0.039597955,0.016418481,-0.017920995,-0.07088235,0.0019655551,0.03793159,0.03657901,0.04881901,-0.00547418,0.07064974,-0.054066,-0.004199989,0.030546438,-0.010276481,-0.03396025,0.007479624,-0.039033737,0.018730968,0.032190822,-0.015372582,0.04394165,0.03789854,0.0028984535,-0.03975698,0.07934434,-0.005051198,0.0595733,-0.039338082,0.12260972,-0.010907405,-0.025452109,0.06769883,-0.027674709,-0.013403571,-0.007762122,-0.032037836,-0.010823045,-0.0522604,-0.06108586,-0.014540085,0.034225382,-0.036012676,0.00041692037,0.031064367,-0.04494391,0.0058650994,0.056396056,-0.002036938,-0.043850422,0.047730863,-0.029233625,0.016601669,0.06866376,0.014621993,0.031326402,-0.047954995,-0.0059668613,0.053402487,0.030683946,-0.04153015,0.0011280364,-0.03423711,0.052352544,0.0606918,0.04194489,0.042604934,0.008714471,-0.051152874,0.0063281395,0.05251577,-0.05993695,-0.042542998,6.5361484e-05,0.007518882,0.01805377,0.040322248,-0.027283607,0.015138112,0.027793135,0.06369907,-0.05794529,0.015816083,0.010286824,0.011829864,-0.035252277,-0.010676734,0.044261217,0.0012411602,-0.018971588,-0.0035248487,0.028146693,-0.02065357,0.0061574257,-0.026611784,-0.025503283,0.02272215,0.043385122,-0.016141584,-0.014201444,0.02320417,0.0259189,0.017371997,0.0003816661,0.015132462,0.025642311,-0.020080298,0.0309698,0.024364578,-0.05990386,0.022468882,-0.0016571236,0.010906216,0.032051846,0.0064740777,-0.0050618956,4.2853567e-06,-0.01589359,-0.020579027,-0.028217157,0.012281133,-0.054854326,-0.033046298,-0.005635697,0.07565712,0.015887,2.9530238e-05,-0.0022569993,0.020243086,-0.0153502785,-0.00692725,-0.051622074,-0.025592467,-0.0918269,0.038205836,-0.037677698,0.060740203,-0.001042011,0.02119728,-0.042260677,-0.0051486627,0.010165754,0.0560547,-0.06940652,-0.005130591,0.025184287,-0.010028683,-0.045580037,-0.02577063,-0.04602029,-0.018371126,-0.023885291,-0.007227016,-0.010124018,-0.016700432,-0.019289717,-0.024061695,0.005447114,-0.0123261865,-0.0024642495,0.0032936211,-0.0017384626,0.041762765,0.07543566,-0.030469365,0.017854681,0.022120861,-0.016965866,0.023721501,0.05990975,0.032014854,0.028836036,0.05138219,0.05616913,-0.022692664,-0.07801681,0.021846484,-0.026237616,-0.019245544,0.03018591,-0.0048634307,0.01391793,-0.05502544,0.0075513134,0.03370582,0.038357403,-0.040129453,0.021616612,0.0047981977,0.03326508,-0.035480373,0.011470247,0.03561431,-0.022069296,0.02745862,0.032620296,-0.014544496,0.05618546,0.028157176,-0.040780116,0.045068495,-0.014675095,0.09970657,-0.005052164,-0.032721836,0.0504512,-0.015902553,0.0101677785,0.0028553675,-1.1035759e-06,0.03432205,-0.01282583,0.05534889,0.04165544,0.02509869,-0.020750895,0.021397052,0.017309451,-0.032398805,0.030093152,-0.0065282853,0.039252058,-0.0326426,0.0017405475,-0.018976565,-0.02811871,0.0327466,-0.024299838,0.018240675,0.0017176061,-0.050532307,-0.0072191716,0.012774822,0.044393506,-0.01530545,-0.042435657,-0.024196304,-0.039957877,0.027024152,0.028052513,0.045799177,0.023572512,-0.029154057,-0.0039973315,0.079493,0.004946898,0.06513209,-0.04748246,-0.019101366,-0.012834091,0.070455045,-0.028801885,-0.05695108,0.016947534,0.020159777,0.05115494,-0.013458279,0.015481478,0.023762159,0.008196577,-0.0077197477,0.07245197,0.01662875,0.052455716,-0.032388087,-0.011922893,-0.0045585446,-0.022465974,-0.037594106,-0.049696516,0.006485254,0.06426365,-0.01094779,0.01821687,-0.034297418,0.01542846,-0.023250725,0.009942837,0.020333264,-0.010992105,0.050735038,0.02198198,0.034384374,0.00889015,-0.007812505,-0.0045657707,-0.0076522077,-0.04803087,-0.022183506,0.04021171,-0.035257023,-0.014092803,-0.03963499,-0.016730536,-0.002984312,0.05665585,-0.024709843,0.01216935,-0.0106693525,0.00921565,0.01605816,0.0047419164,-0.0036523223,0.033468563,0.06060832,-0.0008679875,-0.033187184,0.005790768,0.013212794,0.059691094,0.033343535,-0.0117079215,0.023614697,0.036964845,-0.0074444744,-0.08140104,0.059776597,0.01706699,-0.016713163,-0.04384129,0.037507374,-0.0009731675,0.01553757,-0.022171514,0.013123762,0.009347423,0.035803232,0.021981776,0.043117575,0.040783,-0.017243374,-0.04025991,0.08986961,0.0012159516,0.004933524,-0.05084116,-0.05214736,-0.018415896,-0.0036279697,-0.035738036,0.04403305,0.06455465,-0.0073471847,0.06871276,0.0026391412,-0.03256768,0.015923131,0.017788403,-0.0016673136,0.076292045,0.062928714,-0.01948557,0.009098886,-0.006350488,-0.006929617,0.03282957,-0.031886462,-0.03252199,0.01309822,0.018537251,-0.029811466,0.08764633,-0.00329742,-0.017694194,0.047858186,0.05612177,-0.07029568,-0.026977286,-0.02050755,-0.007939469,0.04595244,-0.0038526393,-0.009047136,-0.012042219,0.0144413095,-0.048724066,-0.014159512,0.01588521,-0.023060136,0.016377319,0.031875793,-0.058272377,-0.043347046,0.014815076,-0.020340703,0.0013129775,-0.020532543,0.0028020479,0.015215343,-0.016931001,0.08113592,0.008146382,0.04537237,0.0066378196,-0.042177483,0.05776462,0.038091615,-0.011005897,0.0063790763,0.0040645357,0.019157978,0.0047461586,0.0034320522,-0.0037756304,-0.021247149,0.014770038,-0.038761023,0.015621382,-0.053667173,0.016137045,0.05705223,0.00877588,0.026568975,0.007953066,0.017671803,0.037106328,-0.010109835,-0.026488043,-0.006856149,-0.077908166,-0.0019359962,-0.014775351,-0.004082,0.0149928015,0.0047165053,-0.019397393,0.026474822,-0.030728517,0.016616294,0.026431989,0.047404964,0.012605327,-0.019578857,0.025822226,-0.028523678,0.030805107,-0.0098150065,0.036672458,0.028962895,-0.06598422,-0.031586,0.027414417,0.01605188,0.05057844,0.04262757,0.00897649,-0.06001677,-0.0398784,0.010414536,-0.039136734,-0.05751414,0.07701926,-0.0060404316,0.015241414,-0.00505695,-0.045361783,0.10414967,-0.005120359,-0.021259231,0.020157317,0.009863087,-0.0675901,-0.03054067,0.0041928203,-0.0020979783,0.022899004,-0.015149597,0.034439042,0.00077620306,0.00779435,-0.009272551,-0.035318583,0.009418841,0.04222814,-0.03029338,-0.018060751,-0.052676033,-0.025411755,-0.03596825,0.09096174,0.008844153,0.0024472722,0.059874754,0.024550736,0.028515162,-0.04868115,0.0039539416,0.004736969,-0.054243512,-0.0035696342,0.01863775,-0.04976312,0.03445335,-0.02476018,-0.06644222,0.09031811,-0.038720164,0.031647477,0.012111587,0.07877465,-0.019900067,0.03281145,0.028944295,0.08202755,-0.008939114,0.019560868,0.04021042,0.0047806986,0.039546233,0.023853,-0.006146441,0.026772538,0.030758385,0.011274277,0.002963798,-0.021893552,-0.01396194,0.029984657,-0.036551602,-0.0089307595,0.008410978,0.027083987,0.030088456,0.05465197,0.010959893,-0.043024696,-0.05630055,0.018379718,0.02817693,0.038038515,0.042599607,0.07303539,-0.027043793,0.0545645,-0.082812645,-0.010696346,0.039399516,-0.07625254,0.06593618,0.050350033,-0.001452907,0.08387258,-0.029545689,0.03541891,-0.013331208,-0.010987704,-0.008755904,0.013340428,0.0071800575,0.0259664,0.032144368,-0.025626665,-0.031614788,0.02853522,-0.031571306,0.101114996,-0.035372443,0.013022017,0.04927504,0.014799552,0.059239708,-0.04021151,0.085943356,0.0142955175,-0.049167555,0.03332127,-0.055044446,-0.048064448,0.05957461,0.047400642,-0.017176384,0.056139827,-0.02914171,0.04497038,-0.034803964,0.021184018,-0.0033039984,-0.013158757,0.046292916,-0.06872301,0.0137785,-0.033724736,0.08121731,-0.006197873,0.028772675,0.047288842,0.07474596,-0.06809271,-0.0030147235,-0.022542337,-0.0051340293,-0.09589652,0.019410027,0.006287928,0.06896309,-0.011856655,0.02008619,0.034787368,0.020630144,-0.014345967,0.035327613,0.017791007,-0.008563252,0.03621902,-0.00946976,-0.040517144,0.028877191,0.027770955,0.005338033,-0.015849546,0.01793326,0.011279068,-0.017883522,-0.028227227,0.03751676,0.029347792,-0.064255804,0.048047695,0.0021767516,0.021309607,-0.008316906,0.05160452,-0.024851924,-0.020295791,-0.022320405,0.080436595,-0.0056640552,-0.050183,0.0016334242,0.008980224,-0.012009509,-0.08258974,0.022388348,-0.024963932,0.0020446654,-0.022217995,-0.0196009,-0.061498035,-0.020619566,0.0068934024,-0.036277987,-0.02054852,0.051570605,0.0125666205,-0.081595995,0.021500476,0.043666616,-0.0044321874,0.02027643,0.041106626,-0.027082924,0.100681655,0.04639256,-0.018090162,0.0033062627,0.012499539,-0.023975458,-0.04762629,-0.01336049,-0.005038761,0.026202764,-0.002838874,0.011975604,0.007661041,-0.061917137,0.04505364,-0.04313887,-0.008174601,0.024837688,0.032636855,0.034616046,0.017028486,0.028644118,-0.026728228,0.10821136,-0.0061619286,-0.018540487,0.01146081,0.050639644,-0.020676034,0.016884323,0.05475614,0.0045215976,0.044465832,-0.018087968,-0.053412493,-0.051652808,0.054846004,0.05434226,0.025871407,-0.011966369,-0.018777823,-0.029167078,-0.05451675,-0.0029852549,0.056689307,-0.034068592,0.05798735,-0.0051377867,0.0025601892,-0.005390684,0.0466767,-0.07614005,0.010083588,0.046176568,0.04250786,-0.009506423,-0.0022375963,-0.030892795,0.010917008,0.020052597,0.015405223,0.0026112057,-0.05248657,0.04542416,-0.020483753,-0.034509,0.033078857,0.0069097616,-0.008483373,0.04800058,-0.03612268,0.0061676903,-0.0053136605,-0.018512959,0.0014143672,-0.017685056,0.043701425,-0.006188952,0.021327958,-0.013883588,0.008557695,-0.031148449,-0.016841639,-0.027347134,0.035798915,0.043970656,-0.070810854,-0.025238426,0.01996421,0.039458647,-0.027183887,-0.01545915,0.023745993,-0.03179712,-0.0267049,0.037979793,-0.06448119,0.03359157,0.027603356,-0.05218661,0.014100789,-0.007929252,0.006433795,0.0075893514,0.0034155375,-0.014338789,0.06594978,0.046407763,-0.0043979865,0.029743498,-0.019139634,-0.021603813]	{"name": "Nhà hát Thành phố Hồ Chí Minh", "ward": "Sài Gòn"}	2026-08-20 16:21:03.92351
56	14	0	Tên địa điểm: Bảo tàng lịch sử Việt Nam\nMô tả: Bảo tàng lịch sử Việt Nam được xây dựng và hoạt động từ những năm đầu thế kỷ 20, là nơi lưu giữ và bảo tồn những hình ảnh, cổ vật từ thuở sơ khai đến nay. Bảo tàng lịch sử Việt Nam thu hút phần lớn những du khách yêu lịch sử và kiến trúc pha trộn giữa 2 phong cách Á – Âu độc đáo. Ngoài là nơi lưu giữ nét văn hoa truyền thống của đất nước, bảo tàng lịch sử Việt Nam còn là một trong những điểm du lịch thành phố Hồ Chí Minh ấn tượng với những góc check in đẹp. Đây luôn là điểm đến thú vị trong những lịch trình của tour du lịch Hồ Chí Minh được yêu thích nhất.\nKhu vực: Sài Gòn, TP.HCM\nDanh mục: Bảo tàng\nHợp với sở thích: Lịch sử, Chụp ảnh, Văn hóa\nĐộ phù hợp nhóm tuổi: ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (5/5), TEENAGER (4/5), YOUNG_ADULT (5/5), CHILDREN (4/5)\nKhoảng giá: 15,000 - 30,000 VND	[0.07302554,-0.031835027,-0.007165681,-0.0017768464,0.020027893,0.0101608895,-0.031084212,0.04040232,-0.028105877,-0.041554127,-0.033213187,-0.04412634,0.016306585,0.021052925,0.011635817,0.02783625,-0.03505363,0.016962867,-0.005144927,-0.032392014,0.0057472317,0.059123263,0.031815313,0.02512599,-0.03893543,-0.041399587,0.036863476,0.021895384,0.01093224,-0.057981312,0.027453665,-0.007547329,-0.007650014,-0.042621147,0.061130576,-0.066351585,-0.027810156,0.057217952,0.026849486,-0.017989127,0.030909788,-4.2113217e-05,0.023429139,-0.044476207,-0.07260941,0.0054352176,0.028410967,-0.030778661,-0.017321613,-0.012774168,-0.013740249,-0.04176672,0.04072577,-0.041170843,0.015545033,0.0014594517,-0.041035242,0.06456224,-0.0073744464,0.021716353,-0.00247786,-0.050952166,0.00049650355,-0.020554397,0.020376025,-0.027869564,-0.0016480758,-0.0211001,0.0065235943,0.009002608,0.020646965,0.019174915,-0.035419814,0.015619474,-0.03587352,0.022697981,-0.017929384,0.043177504,0.010780946,-0.008539674,0.0557673,0.024124881,-0.015166511,-0.026272457,0.0075174132,0.06669317,-0.03931579,0.023800574,-0.013005593,0.021722348,-0.04349674,-0.026281806,0.0027481539,0.0234464,-0.015971724,-0.038229033,-0.008917339,-0.042195395,-0.05603132,-0.04345349,0.002708105,0.04060112,0.06468994,-0.014060073,-0.015892059,0.012674356,0.058528904,0.03210134,0.019745884,0.04049938,-0.0042705163,0.022336993,0.083323926,-0.016068641,-0.035874594,-0.0040049576,0.04508026,-0.041518226,0.038193416,-0.009302195,-0.010232992,-0.0044359495,-0.0055632587,-0.044994794,0.063328534,0.034930848,-0.04024506,0.016108342,-0.030409751,0.028272737,-0.014406877,-0.02518871,-0.0030726981,0.0011320311,-0.0058729914,-0.011242308,-0.012161394,-0.06237502,-0.06356022,-0.033016678,-0.05149752,0.02788223,0.007400137,-0.036121886,-0.022726726,0.026499236,0.03095912,0.07162673,-0.043019388,0.021891393,0.04286534,-0.07631466,-0.026043344,-0.025136989,0.017649319,0.065173194,-0.0524483,-0.009408886,-0.032019492,-0.009465454,0.018004628,-0.030676698,-0.007796579,0.035591308,0.03624999,0.021810079,-0.002155169,0.03455782,0.034283996,-0.078664504,-0.009031408,0.046959937,-0.015420963,0.02812743,0.12945752,0.052081946,-0.02840488,0.09241346,0.042135768,0.008812958,-0.05669063,0.04607453,-0.021821514,-0.02124646,-0.023263833,-0.036613856,0.07491284,-0.05752498,-0.012847066,-0.022952046,0.050590202,-0.018214637,0.016917953,0.03320474,0.047713097,-0.00932016,-0.016967058,0.04656151,-0.014963077,-0.0011432116,0.012664201,0.0284581,0.060773667,0.016067801,-0.0306908,0.03983996,-0.012200981,0.04585744,0.015827795,-0.006925246,0.02118387,-0.00272498,-0.012485365,0.028271718,-0.041388564,0.016591698,0.009015953,0.027238984,0.06399954,0.046964217,-0.0005302534,0.029079286,0.050487194,-0.0023932164,0.057816505,0.0006417652,0.00934097,-0.020848831,-0.06676357,-0.0008854442,-0.046771318,0.032847527,0.009228296,0.026668698,-0.020553403,-0.017087055,0.0014411346,0.010461284,-0.010004901,-0.030296076,0.012226536,-0.028375,-0.030107886,0.018741922,0.0061571263,0.008196432,-0.0030381407,-0.031491302,0.09281635,0.11272738,0.005466485,0.0748585,0.042833056,-0.03830742,-0.0068033068,0.027765062,-0.021453798,-0.028926559,0.072840236,0.023930335,0.03962899,-0.032795914,0.08298443,-0.012932003,-0.013883537,0.0050702835,0.047774468,0.019562915,0.055255618,-0.029815882,-0.033418655,0.043157037,-0.038172107,-0.014623105,-0.041197218,0.012499711,0.06990496,0.0066493712,-0.0034977607,-0.015171598,-0.0032589743,-0.0357396,-0.014344818,-0.057314526,-0.054261573,0.039448347,0.011006734,0.029524643,0.058666207,0.005635923,-0.0026410911,-0.039858166,0.005114271,0.04180934,0.057616685,-0.020447195,0.0099974945,-0.030453127,-0.014474535,-0.00026019616,0.00974982,-0.011429587,0.035175923,0.014971071,-0.009783139,0.022955742,0.0032534306,-0.026811136,-0.004630441,0.012225492,0.0022228349,-0.040095344,-0.014330714,0.085539535,0.085265465,0.05596032,-0.02752945,0.024693465,0.04459958,-0.026938258,-0.05156316,0.042089302,-0.0068032285,-0.056877792,-0.030465929,0.053805035,0.025198545,-0.0018774911,-0.024152737,-0.02718896,-0.0039904714,0.04052093,0.024198689,0.03362062,-0.0029082927,-0.017439386,0.007666648,0.013070816,-0.0009514635,0.007494487,-0.005761471,-0.02594309,-0.019581953,-0.026520096,-0.025917323,0.05181159,0.07394171,-0.017508892,0.06443147,0.03373952,-0.04921409,0.032380026,-0.008164894,0.029936662,0.07206562,0.059476584,-0.017940503,-0.01950161,-0.05359147,-0.03079791,0.06362297,-0.067059316,0.0069479407,0.06242126,0.002479722,-0.002222357,0.0056636743,-0.026730973,0.016015979,-0.0004935488,0.047003224,-0.054420143,-0.022308398,0.021699749,0.022893962,0.08601333,0.014920602,0.0047750715,0.009105478,0.047665544,-0.038804214,-0.010652677,-0.05741175,0.00043191554,0.03065941,0.022866853,-0.029246373,-0.048241742,0.04046825,0.011994386,-0.028593753,0.011566064,-0.037220377,-0.006555033,-0.0044229636,0.03807922,0.03450411,0.03478058,-0.0098243235,-0.009719083,0.07351382,0.0025729586,-0.024310416,-0.035177514,0.012244791,0.013860336,0.009534029,-0.04307632,0.011271322,-0.05609865,-0.01476563,0.03703099,0.034373824,-0.056075472,0.020995637,0.06207486,-0.002600366,0.0028908772,0.004592317,-0.027766515,0.042674568,-0.03296201,-0.010854385,0.05285159,0.001604365,0.015901158,-0.03840803,0.01897435,0.017754255,0.057615906,0.027154686,0.024956116,-0.056151863,0.09565456,0.022777135,0.04166203,0.005568402,-0.020733645,0.03118648,-0.015749171,0.02159541,-0.024483137,0.03221372,0.044716857,-0.02026204,0.017314017,-0.023182945,-0.018089,0.082243584,0.004843915,-0.00545852,-0.05162352,0.041193705,0.034839023,-0.0003087853,-0.0444115,0.034567676,0.019340495,-0.004599436,0.0077839247,-0.07971541,0.09290021,-0.00661254,-0.045865145,-0.0092563,0.04791663,-0.04716588,0.028881341,-0.015847161,-0.018087389,-0.016226416,-0.030302241,-0.036538597,-0.014515054,0.024664626,0.022910904,-0.042201813,-0.0075771636,0.031852875,-0.022270644,-0.035996463,-0.056785982,0.019525092,-0.019240435,0.10781503,-0.019168394,0.038064077,-0.008581521,0.041605763,0.05880246,0.020482458,-0.03460249,0.043565605,-0.05037428,0.025116978,0.0024989345,-0.045397338,0.019008154,-0.058871202,-0.02258743,0.029429927,0.0024392128,0.0835343,0.024053762,0.047763225,-0.056754712,0.019598307,0.019380813,0.06883269,0.026025323,-0.009670585,0.0341383,-0.016533691,0.02426023,0.00740958,0.008352821,0.061727066,0.072927795,0.020430855,0.017443083,-0.06775731,0.037474323,-0.033839226,0.01545469,0.03454061,0.012927763,-0.032166686,0.014810396,0.0074184006,-0.003698604,-0.029099423,-0.037675314,0.01047289,0.06668879,0.06715806,-0.0136321215,0.048625235,-0.00804452,0.05679987,-0.025974311,-0.031328928,0.018555503,-0.031268504,0.02587015,-0.0019949363,-0.019065758,0.08959253,-0.0039863493,0.012600006,0.042186607,-0.024592906,-0.02599787,0.043997396,-0.023898099,0.039176397,0.03220395,-0.03407423,-0.016187625,0.0447156,-0.034033246,0.07982363,-0.024756385,0.0041423184,0.07015993,-0.012246685,0.029038928,-0.019638,0.05620646,0.00094457885,-0.018916138,0.018756054,-0.029388204,-0.059247147,0.062464505,-0.017795049,-0.00964466,0.061293386,-0.010600776,0.02700766,-0.03100265,0.025396539,-0.00012071662,-0.03023156,0.07997227,-0.08200464,-0.017988158,-0.10890241,0.05463653,-0.014760491,0.0057433103,0.042468175,0.016153712,-0.04270151,-0.028166784,0.0016416241,-0.0034488738,-0.08251549,0.011691377,0.028087376,-0.014127421,0.0089899395,0.03135431,0.028463291,0.010025618,0.0034459585,0.033647727,-0.019760283,0.0056612,0.03123617,-0.022424223,-0.05537897,-0.011826954,0.015655974,-0.005405097,0.0036525475,-0.022108262,0.00796925,0.03889822,-0.016010921,0.009861078,0.013760681,0.042329516,0.04897013,0.007936933,0.016567409,-0.017198715,0.040708438,0.0101259295,-0.011108354,-0.045085013,0.04028878,0.042773247,-0.046314605,-0.02503904,-0.015485315,-0.02172361,-0.13199842,0.050119698,-0.03958743,0.037350256,-0.0030028953,-0.05778338,-0.018981753,-0.02136482,-0.037885077,-0.015904002,-0.0037576419,0.06833322,-0.02838488,0.02625395,-0.002983574,0.053262956,-0.031643152,0.032138295,0.023831284,-0.00014441833,0.09774582,0.06217699,0.030127473,-0.02190084,-0.010110436,-0.028672727,-0.07669825,0.01912219,0.016588906,0.034804214,-0.00862062,0.024580201,-0.017020773,-0.038220897,0.009304738,-0.0033021756,-0.007896031,-3.3813565e-05,0.017637733,0.01872027,0.009351218,0.025710246,0.039849885,0.044985157,0.01803109,-0.026232777,0.037765477,0.0034385615,0.027197858,-0.004139797,0.037230954,0.049496688,0.050248787,0.037080966,-0.037681643,-0.008677891,0.03861028,0.022663329,0.037861448,-0.015567743,-0.015794346,-0.019777931,-0.0015095482,0.0008951584,-0.005091982,-0.08227931,0.020760825,0.015649946,0.027978418,0.001080087,0.051440056,-0.003845703,-0.027202833,0.052154563,0.039620172,0.009625504,0.009242506,-0.0068342616,-0.0168637,0.03272239,0.010038613,-0.0048455982,-0.053815432,0.06389931,-0.04511564,0.00051606516,0.037347954,-0.019055115,-0.017672287,0.009490057,-0.06507131,-0.043460406,0.013324688,-0.026082112,0.006683509,-0.0058470485,0.07671734,-0.011561527,0.010124426,-0.0040811063,0.008667467,-0.025524925,-0.04357427,-0.024058416,0.025781255,0.013184063,-0.018971369,-0.043042682,-0.021410782,0.00845788,0.03886124,-0.06482558,0.03148625,-0.0041667954,0.014651187,0.020554755,-0.041889425,0.003491137,0.0082406085,-0.030344091,0.028370164,0.033308446,0.036206823,0.0154654775,-0.04081507,0.0031642488,-0.0012159784,-0.0019383443,-0.037732024,0.035276514,-0.0173646,-0.009643665]	{"name": "Bảo tàng lịch sử Việt Nam", "ward": "Sài Gòn"}	2026-08-20 16:23:37.589673
57	9	0	Tên địa điểm: Phở Hòa Pasteur\nMô tả: Phở Hòa Pasteur mang không gian quán ăn truyền thống quen thuộc, giữ vững hương vị phở đặc trưng của Sài Gòn trong suốt hơn nửa thế kỷ qua. Quán phục vụ đa dạng đối tượng, từ người dân địa phương sành ăn, giới văn phòng cho đến du khách quốc tế muốn trải nghiệm ẩm thực chuẩn vị Việt.\nKhu vực: Xuân Hòa, TP.HCM\nDanh mục: Quán ăn, Quán phở\nHợp với sở thích: Ẩm thực\nĐộ phù hợp nhóm tuổi: YOUNG_ADULT (4/5), ADULT (4/5), SENIOR (4/5), CHILDREN (4/5), MIDDLE_AGE (4/5), TEENAGER (4/5)\nKhoảng giá: 95,000 - 200,000 VND	[0.0323045,0.04699528,0.006790311,-0.007913408,0.026476743,-0.0007477678,-0.005258959,0.0673357,-0.03718952,-0.033267476,-0.046730492,0.0133925425,-0.004334914,0.023709767,0.019302955,0.0693023,-0.014536224,0.008410968,0.021221314,-0.05364935,-0.0026184036,0.035811584,-0.06452216,-0.03831,0.033738468,0.015075261,0.02368688,-0.015171105,-0.014413653,-0.05664938,0.050907694,0.0014149819,0.043956432,0.023667144,0.0049794447,-0.053756222,0.026880423,0.0037921302,0.04020835,-0.044787064,-0.020028496,-0.0049274433,0.035894524,0.03495924,-0.083348736,0.0021000393,0.007426714,-0.016288528,-0.0022156946,0.020064833,0.0119726695,-0.010720421,0.012150141,-0.0025575515,-0.020206168,0.040033292,-0.03701079,0.047406938,0.015143934,0.018994901,-0.034939818,-0.07474857,-0.017663507,0.0035438465,0.05033001,0.057769634,0.0181952,-0.003254267,0.005760283,0.040864944,0.043013092,-0.0063808006,0.010081426,-0.009408782,0.011071933,0.049715813,0.018371506,-0.02800558,-0.03421394,-0.0074436036,0.04176766,0.08634784,0.011777411,-0.010117574,7.649544e-06,0.070263796,-0.060167126,0.0027606124,-0.02727359,-0.0042106844,-0.010913621,0.023980917,-0.0069343527,0.014705216,0.0070461556,-0.015160435,0.003066668,-0.046981577,-0.043077707,0.00265173,-0.023798808,-0.04709918,0.06273197,0.02778859,-0.0066823126,0.044961892,0.027426774,0.06401554,-0.008078372,-0.021899238,-0.021173563,-0.08628282,0.06305032,-0.04224749,-0.009708323,-0.014591748,-0.012711496,0.0055891536,-0.0038910594,0.013392794,-0.017174846,-0.01868808,-0.029311312,-0.015576237,-0.05715487,0.010054283,-0.03747059,-0.0013022323,-0.03357788,-0.030760717,0.04528762,0.0354713,0.0673071,0.03369745,0.010741975,-0.020826252,-0.021023184,0.0020483853,-0.061123025,0.008913171,-0.030704966,-0.009880159,-0.04877395,0.05824894,-0.059161916,0.048848487,0.010605608,0.04770922,-0.030564187,-0.03462022,0.0367025,0.0044360883,0.052477866,-0.033334866,-0.052105244,0.029128518,-0.044657543,-0.0046091494,0.03074841,0.026540749,-0.024339328,0.0013979818,-0.05351776,0.014146461,-0.0069168946,-0.02967264,0.0009822819,-0.0027755925,0.063693404,-0.015554794,0.016365396,0.022928525,-0.04586044,-0.011709049,0.059973937,0.067177735,0.082917064,0.07677882,0.028410077,-0.0075570215,-0.027718397,-0.007564687,0.06680916,0.0069972966,-0.046865784,0.060489807,0.040690944,-0.057344075,-0.0041214623,0.065506734,0.023417627,-0.014863404,0.021965154,0.016981106,0.040141053,-0.0053671123,-0.0068162098,0.004411017,-0.053965393,0.0517061,-0.0010841991,-0.004738848,0.015677841,-0.07228997,-0.04714399,0.0749309,0.00043592218,0.086066775,-0.0037317972,0.04448428,0.011817535,-0.0324188,-0.053015616,-0.003197684,0.0077943117,0.025934678,0.024027167,0.0457236,0.012122491,-0.038160935,0.0008932777,0.031845152,-0.009426989,-0.013764661,-0.0127386935,-0.029437674,0.01963536,0.02278961,0.035205755,0.010033729,-0.009839049,0.045351326,0.009802678,0.013665936,0.027926847,0.018070025,-0.028389812,0.021991642,-0.008544082,-0.02846345,-0.03156962,-0.028100954,0.009976295,0.027727228,0.032710083,0.010605544,0.05373976,-0.016716514,0.051184203,0.062197465,-0.023121605,0.05011195,-0.011153193,-0.07586278,0.017245483,0.010520435,0.02908819,-0.03937994,0.027352925,0.048039503,0.0019714236,-0.02567042,-0.0040316945,0.005922906,0.01162441,0.016605947,-0.047814433,0.021367382,0.024325538,-0.018779041,-0.020120855,7.7982346e-05,-0.022470046,-0.038786072,-0.023177058,0.005496143,0.031885702,0.039392445,0.024709795,-0.018931536,0.058781173,-0.05142375,0.005489532,0.0018601852,-0.033690695,0.009409713,-0.0050809844,0.038896486,0.0059425095,0.018672822,-0.02296723,0.037169065,-0.05764581,0.0120818345,0.032828685,-0.02938289,-0.023523526,-0.09480376,-0.004336928,-0.028349562,0.049118947,0.05599548,0.049021177,0.018542105,-0.0019455035,0.009017825,0.0353781,0.07588788,0.01212304,0.018572202,0.0038047452,-0.008476988,-0.012602657,0.006982548,0.02237381,0.09559359,0.008100342,-0.024783853,-0.010033134,0.0012313792,-0.048431475,0.04474584,0.024883198,-0.035807364,-0.015120834,-0.01495261,-0.011979107,0.03578479,-0.025199452,-0.005655576,-0.01205313,0.02334414,0.033904154,0.03924469,0.0034554591,0.029895574,-0.02279065,0.009046818,0.05297686,0.003629833,-0.022190312,-0.019584179,0.034536567,-0.0129971905,0.043351904,0.0022707626,0.06174154,0.007722687,0.06153545,0.009501965,-0.084242485,0.031679824,0.013373007,-0.017733805,0.07311738,0.022297425,0.028030476,0.010329809,-0.065018505,-0.032633528,0.012505757,0.0363023,0.0032325443,0.0507185,-0.0429226,-0.028764205,0.07254329,-0.043444585,0.018711463,0.10091629,0.042611767,-0.003698866,0.0383578,0.019222666,0.012652318,-0.0040508728,0.011613711,0.031450886,-0.03338516,0.0031044155,-0.06189478,0.045887563,-0.035369154,0.0099206325,-0.06877117,-0.051792275,-0.016386991,0.008761904,0.07284568,0.02327716,-0.031733643,-0.036017235,0.014514655,0.09952701,0.015600972,-0.012187636,-0.03851972,0.024965532,-0.067909874,-0.012564203,0.028152242,0.067595676,-0.024954993,0.014349605,0.037058424,0.008685244,-0.027214384,-0.030698847,0.025860751,-0.006170248,0.009588301,0.008103745,0.0048718015,-0.031229742,-0.034798976,0.0063125705,0.03756005,-0.028170032,0.07367801,0.013963829,0.0343635,-0.07115112,0.02989545,-0.053637102,0.004362694,-0.018033521,-0.0027766288,-0.044004384,0.031743664,-0.024832182,-0.020758273,0.029919324,0.017940719,0.06864306,0.020053405,-0.030200576,-0.007556344,-0.014826332,0.032222807,-0.0342699,-0.015086174,-0.027276501,0.013145874,0.0026351255,-0.04212491,0.0065322723,-0.01749669,-0.050650857,0.026655037,0.0079808,0.004675515,0.007669083,-0.012968513,-0.009503722,0.005621112,-0.06649815,0.010456946,-0.025374357,-0.00016323832,-0.078916,-0.017786888,0.09610857,0.03568677,-0.041570347,-0.045791257,0.037774235,-0.08312312,0.00750085,0.017932698,-0.05782561,0.03430265,0.009308234,0.02100696,0.0013636273,-0.06393181,0.050495658,0.033484682,-0.021568049,-0.0043122666,0.0052331192,0.057828747,-0.0544537,-0.04364332,0.03664711,0.07955731,0.058937274,0.006958889,0.012611695,-0.005141008,0.0033977567,-0.020221993,0.0067284764,0.025708323,-0.032885607,-0.046582244,-0.044064578,-0.092953645,0.01794691,0.009478709,-0.072870664,-0.03530247,-0.071459055,0.0024048588,0.06604324,0.06307809,-0.0440276,-0.0031045666,-0.004670937,0.04650032,-0.00066256325,0.055583645,0.041363593,0.014727737,0.01381454,-0.04260541,0.018656772,-0.045187406,0.056281857,-0.036671452,-0.00034246666,-0.03004107,0.0024007594,0.011318198,-0.01819819,0.016163532,0.027015056,-0.03993807,0.0575569,0.002565934,-0.03345881,0.039595768,0.029843383,0.011938815,-0.025240634,0.043310698,0.007050909,0.07308885,0.015177617,-0.005121905,0.005665045,-0.027266024,0.025779083,-0.0077360263,0.030218305,0.055099696,-0.05324449,0.13622637,-0.03501508,-0.042391796,0.06324212,-0.042237673,0.026906062,0.0062471475,-0.020879967,-0.03192652,0.03951753,-0.036754366,-0.012007729,0.0909816,-0.02365562,0.0429298,-0.022251377,-0.006292049,0.051088326,-0.0072966157,-0.006156032,-0.07544445,0.06774798,0.029505309,0.0023286738,0.0001266307,0.009749768,-0.019729203,0.05543681,-0.0041199517,-0.021582112,0.05213428,-0.018764323,0.017294781,-0.0046357224,0.030981826,-0.035960298,0.01092735,0.032341138,-0.052643232,-0.0059042126,-0.059120517,0.09432634,0.013027622,0.035865717,0.054392684,0.024534762,-0.00632594,-0.019263757,-0.039516807,-0.025788127,-0.05274504,0.012195077,0.021685336,0.013876654,0.01760168,0.024881737,0.04257179,0.05307202,0.019347247,0.0023441052,-0.03603292,-0.012921636,0.047913853,-0.026351009,-0.029102404,0.01698247,-0.011770412,0.030390082,-0.012513829,-0.03547234,0.0020091073,-0.008991182,-0.032875694,-0.01798024,0.031368196,-0.0341759,0.029903125,-0.0008239717,0.005634536,0.016498653,0.007599702,-0.021598717,0.008299483,0.0032814522,0.05422502,0.028155344,-0.059955444,0.009492339,-0.0071553094,-0.034309927,-0.0760904,0.04808433,-0.04282171,0.03497284,-0.012315264,-0.022005683,0.045717303,-0.060256377,0.024988694,0.040469844,-0.025702745,-0.029578378,-0.05438081,0.0007013029,-0.03347135,0.002648535,-0.025718635,0.022398533,0.022582753,-0.016321314,0.030171001,0.04708882,0.069563456,0.020653581,0.0008402098,-0.006895639,-0.017611602,-0.02648593,0.039497305,-0.022428704,-0.009119346,0.060179427,0.032128513,-0.06262199,0.05543768,-0.013698201,-0.0407304,0.011116156,-0.021132063,0.026681358,-0.005484598,0.018847145,-0.018058285,0.028596738,0.01171763,-0.010588455,-0.04152416,-0.00025406724,0.016371628,-0.006208775,0.022859622,-0.005926182,0.05590459,0.05071092,-0.0458341,-0.032751262,0.04975496,0.044858407,0.05003047,-0.002089885,-0.022574993,0.029003894,0.0037737384,0.007171148,0.010897459,0.008272926,-0.031302076,-0.02085451,0.0038133815,0.0018270799,0.039747316,-0.06017381,-0.032877028,0.049732808,0.042237695,-0.04536559,0.043125298,-0.0149135515,-0.025208283,-0.007675826,-0.00638016,-0.00045585816,-0.068652384,0.041145094,0.011411689,0.020480823,0.0054101464,-0.022883583,0.026186684,0.022312246,-0.02485053,0.055989712,0.04111611,-0.0037082846,0.086913034,0.09214138,0.009114406,0.033612743,-0.018493427,-0.037010595,0.010859049,0.039793175,0.011609649,-0.03229085,0.04511473,0.06441666,-0.048366573,0.018232414,-0.042260822,0.029865747,-0.05594019,0.01678828,0.028687429,-0.035204772,0.0046288697,0.011065093,-0.0354949,0.020839013,0.042199083,-0.039859038,-0.0030378355,0.05872401,0.058980007,0.026744246,-0.008720289,0.039553054,0.018673057,0.015583035,-0.006630728,-0.0063777715,-0.025869325,-0.07110602]	{"name": "Phở Hòa Pasteur", "ward": "Xuân Hòa"}	2026-08-20 16:36:19.176799
58	6	0	Tên địa điểm: Phố đi bộ Nguyễn Huệ\nMô tả: Phố đi bộ là quảng trường hiện đại, thoáng đãng nối liền từ Ủy ban Nhân dân Thành phố ra đến bờ sông Sài Gòn. Vào mỗi buổi tối và cuối tuần, du khách có thể dạo bộ hóng mát, xem các màn trình diễn nghệ thuật đường phố sôi động. Nơi đây là tâm điểm vui chơi lý tưởng cho giới trẻ, các cặp đôi, gia đình và du khách quốc tế thích không khí nhộn nhịp về đêm. Điểm nhấn nổi bật là hệ thống đài phun nước kết hợp ánh sáng nghệ thuật.\nKhu vực: Sài Gòn, TP.HCM\nDanh mục: Phố đi bộ, Công viên\nHợp với sở thích: Giải trí, Nightlife, Gia đình, Chụp ảnh\nĐộ phù hợp nhóm tuổi: ADULT (5/5), YOUNG_ADULT (5/5), TEENAGER (5/5), MIDDLE_AGE (5/5), CHILDREN (5/5), SENIOR (5/5)	[0.031534877,0.042944856,-0.021590995,-0.02802708,0.0017115662,0.0416819,-0.007850008,0.07510586,0.052804127,-0.02609728,0.020455511,0.0034635693,0.05078694,0.002852834,0.0022749165,0.035121188,-0.047836587,-0.0005049736,-0.037795283,-0.0077070254,0.011065901,0.0021146599,-0.046829198,0.0019873902,-0.009497712,0.060756706,0.02012916,-0.0010498217,-0.03141777,-0.0888432,0.0966527,0.019376863,0.029450329,-0.026979687,0.08258446,0.019704686,-0.039436158,0.059767745,0.026624786,0.016089229,-0.0032009592,-0.040349264,0.04651128,0.011048162,-0.016437002,-0.024895836,0.015085654,-0.04436517,-0.003564002,0.070890844,-0.00480375,0.011843972,0.076450005,-0.04107195,-0.046053957,0.034819826,-0.026431527,-0.026317453,0.06567977,-0.014938115,0.05948703,-0.018972814,-0.0021557114,0.051103786,0.031795874,0.04060263,0.017389014,-0.016263831,0.048482656,0.015268333,-0.009276204,0.0047229147,0.022485891,0.0024604336,-0.03408963,0.03367505,-0.025360238,0.051042855,0.0037761622,-0.0038777897,0.017225828,-0.021529775,-0.0009860545,-0.0019466489,-0.0067785853,0.045958575,-0.03463067,0.03385241,0.016797291,2.3765815e-05,-0.016240718,-0.024202645,-0.008350837,0.017742455,-0.019624865,-0.0020358087,0.0058768885,-0.015145248,0.01801757,-0.025434583,-0.025694551,0.008579273,-0.017496938,-0.012981914,-0.042015076,0.018712796,0.0054292753,0.038243804,0.0030449976,0.0074017495,-0.0026694604,0.009301945,-0.02554365,0.018377673,-0.034419194,0.009765858,-0.019727537,-0.0063477242,0.021972822,0.015708527,0.058119692,-0.01611131,0.031669717,-0.023371091,-0.0004954957,0.028216528,-0.055822954,0.011896476,-0.035456754,0.015281858,0.013060264,0.017757345,0.0017878996,-0.04039356,-0.029004464,-0.014849351,-0.001221751,0.012427184,-0.07855441,0.06264319,0.011808967,-0.027804151,-0.012538004,-0.027250998,-0.0041983887,-0.0028727278,0.023210565,0.06796998,-0.017117904,-0.011536114,0.03417502,0.017534692,-0.03625672,-0.0031593086,-0.053192705,-0.022679524,0.007131209,-0.059732616,0.030854246,-0.0494477,-0.028193228,0.023613641,0.024334908,0.015789868,0.021676138,-0.03016824,-0.0006780168,0.04762931,0.1521872,0.0077930773,-0.007154754,0.03529159,-0.043463096,0.02336742,0.044736,0.018405912,0.017475558,0.036895894,0.027831653,-0.01131925,-0.018893998,0.029340783,0.015854267,-0.010306445,0.0134283425,-0.013038207,-0.012132696,-0.0511801,-0.012699082,-0.024256626,0.017759994,-0.045290496,0.0021685888,0.031521864,0.0019208388,-0.025097493,-0.08482232,0.032976717,-0.0036880411,-0.000876514,-0.037127875,-0.015411,0.069674216,-0.006531574,-0.08302201,0.07776293,0.007316178,0.07120252,0.01778116,0.004040381,-0.01863788,-0.0067783566,0.040565144,-0.032669377,-0.040399205,0.008267087,0.0063011376,0.030492397,0.014119205,-0.0028238166,-0.0038958555,0.0008883261,-0.0707554,-0.010559045,0.0222595,-0.1013151,0.013068298,-0.022112206,-0.0035022798,-0.032524634,-0.06811655,0.016278146,0.056797337,0.033226706,0.021361485,-0.023966419,-0.02751958,0.015705042,0.024468418,-0.014330725,-0.04107973,-0.03849295,0.00056296703,0.051136743,0.027818328,0.006139706,0.009045538,-0.012380699,0.12757894,0.041844323,0.007021794,0.04915101,-0.02581848,0.004733931,0.0013708576,-0.0033390203,0.0011972644,-0.033188555,-0.022153473,0.0022583192,0.01904094,-0.0476708,-0.01957727,0.020285146,0.028595552,-0.045136355,0.050625972,0.0022598465,0.022110019,-0.0435058,0.022726001,0.035020392,-0.050091643,0.024491308,-0.021602636,0.004092272,0.023211565,0.036646686,-0.06346018,-0.043406114,0.10276119,0.0016338283,0.019277379,-0.042202976,-0.06140315,0.025634088,0.02477611,0.04801153,0.013345311,-0.017160932,-0.03874582,0.0046151676,-0.12165004,-0.024745077,-0.006258338,0.011808125,0.030007578,-0.00465334,-0.021346128,-0.039096948,0.04742183,-0.035652414,0.017587546,0.0024022688,-0.01402289,0.015449736,-0.013752447,0.04185245,0.031218292,0.049441535,-0.047007244,-0.028662289,0.01899936,0.027210347,0.02873136,-0.00010058358,-0.033156067,-0.010236807,-0.032044265,0.0086753415,-0.08710774,0.004136476,0.022432989,-0.0059565725,-0.007557189,0.029285908,0.011341654,-0.014036608,-0.008553528,0.030646546,0.025195954,0.046458706,0.030493647,0.030120788,0.017441873,0.0006405622,0.018299554,-0.01705015,0.047183864,0.04076381,-0.07648441,-0.05931581,0.023861432,-0.015682742,0.044629693,0.03314674,-0.0015297926,-0.022787906,-0.0069320146,0.018336246,-0.011342494,0.034841377,0.010598196,0.04008001,0.07812312,0.06370248,-0.035077143,0.01626911,-0.0074440944,-0.02661412,-0.016275166,0.0035287617,-0.0628238,0.027196333,-0.010441149,0.0029175838,0.09872842,-0.01539656,0.0030792723,0.09576633,0.066197574,-0.024686757,-0.032683756,0.033769038,0.026350936,0.023952236,0.027824061,-0.039872084,-0.022323135,0.08163893,0.009806726,0.015896183,0.016209539,0.019382976,0.073436804,-0.013802104,0.01578511,-0.04169971,0.02758308,-0.00018263575,-0.013301218,-0.006966803,-0.040155757,0.04819035,-0.031704646,0.075327404,0.012349541,0.047826294,-0.03489538,-0.023707397,0.009747164,0.05268992,-0.049358986,0.033145573,0.025503727,0.017201714,-0.03837577,-0.012038985,0.0070735454,-0.007641181,0.0066358424,0.018652499,-0.014282714,-0.010209376,0.035420224,0.028182924,0.025304496,-0.0037914417,0.037080985,-0.009038139,0.012905834,-0.022186102,-0.05255563,0.018864315,-0.061096765,0.023522604,0.02437073,0.024206217,0.038727097,0.04797203,-0.019795751,-0.018921567,-0.039697412,-0.023195392,-0.0112620415,0.070648864,0.026133131,0.014604677,0.006912519,-0.058182683,0.02569655,-0.032923486,0.024408014,-0.02412725,-0.02104301,0.056854587,0.0020564382,0.023309315,0.012988072,0.036731113,-0.050888076,-0.050258912,-0.039778274,0.030407583,-0.03363893,-0.04217676,0.060677413,-0.035502248,0.033371884,0.036537085,-0.031967375,0.032684077,0.04537954,-0.0067289867,-0.012782251,0.035585657,-0.08659488,0.0060367286,0.00027761082,-0.016395375,0.038421206,0.028262671,-0.013299113,-0.0065716556,0.025568107,0.05163959,0.018124696,-0.050374065,0.010502769,-0.06153144,-0.012607174,-0.08015513,0.002667159,-0.02569533,0.038063277,0.016502474,0.015733995,0.041014597,-0.044227943,0.0154529475,-0.0065593086,-0.028402217,-0.0011186643,-0.01312237,-0.010811639,-0.01655193,-0.040925004,0.0014104326,-0.0077383467,-0.047323372,0.0029194793,-0.010025099,0.012394122,0.08207982,0.037428703,-0.0010043919,-0.0018022017,0.011321244,0.02822053,0.031382494,-0.023600977,0.043849364,-0.021870075,0.011403032,-0.04930075,-0.008790342,0.038150255,0.013661648,0.010615643,-0.0085469885,-0.04106563,-0.043370474,0.014661715,-0.043158896,0.026261572,0.011661769,0.04828412,0.037185572,0.03511005,0.033979774,0.029332995,-0.0385969,0.009130936,0.047669668,0.04023152,0.0031121431,0.12034877,0.024397513,-0.017505312,-0.03325926,-0.04867614,0.02367017,-0.04255964,0.01380527,-0.023678249,0.015304614,0.1467773,-0.021049934,0.034334324,0.0067262435,0.0013972642,0.03473487,-0.042577688,-0.0025424515,0.016496133,0.012489725,-0.03438529,-0.010710655,0.07035919,-0.03581062,0.07079733,-0.04010304,0.005416357,0.0036854446,0.0144815985,0.005804426,-0.025893755,-0.0067002936,-0.0011807522,-0.02895691,0.016733428,0.02374255,0.021494515,0.05587279,-0.01026379,-0.00024353416,0.007200629,-0.038510688,-0.0016408503,-0.015672488,-0.0010268074,-0.0091226315,-0.0147362165,0.041700017,-0.08326103,0.0018310114,-0.069859564,0.055515558,0.02626147,0.03719681,0.03210967,0.04756165,0.0112187825,-0.015327891,-0.05713763,0.024214227,-0.05263661,0.008282448,-0.00862731,0.046735447,0.044365562,-0.018161617,0.119435,0.07128637,-0.006209094,0.01048335,-0.03804578,0.08759422,-0.023170885,-0.040774837,-0.038802106,-0.03520518,0.034030113,0.0032155956,-0.060590923,0.019641135,-0.022949388,-0.05198688,-0.016877718,-0.043394133,0.030355543,-0.0060219844,0.056968294,0.015628401,0.0049533485,0.038239844,0.04547804,0.026928691,0.0027591833,-0.0060640955,0.08450244,-0.019121392,0.018792812,0.0013321891,0.011487336,-0.025657598,-0.08429014,0.013935125,0.028456906,-0.03663336,0.0010907729,0.024326473,-0.007223486,-0.02024472,0.023171548,0.01117498,-0.06568588,-0.038069703,-0.031384658,-0.0075903996,0.020005016,0.033865403,7.829349e-05,0.024539093,-0.004063393,-0.06844555,0.081951894,0.09063173,-0.029987494,0.03759529,0.0061079147,-0.0126571525,-0.01596086,-0.037424132,0.009361881,-0.052582882,-0.020379797,0.010454643,0.029139558,-0.10325532,0.051255714,-0.021348402,-0.040015776,0.012425674,-0.0021333797,0.06364458,-0.023549885,0.061418854,0.018867742,0.02135766,-0.002899438,-0.049373865,-0.008614478,-0.006162213,0.004059043,0.019594114,0.030287087,-0.0052807257,0.006380138,-0.011167918,-0.045891616,-0.040092163,0.010509877,0.046216488,0.007747605,0.008853957,0.023732934,-0.013938224,-0.015440489,0.036609076,0.039807104,0.012229592,0.022406697,0.040792093,-0.10375134,0.0031012176,0.034157097,-0.035554696,-0.008338938,0.05864199,0.047274724,0.014402039,-0.036317468,0.016514596,0.022112153,0.017340716,0.01176087,-0.024708433,-0.05100161,0.0320448,-0.023444343,-0.031949922,0.013052623,0.029780706,0.043485545,-0.0071644704,-0.007220821,-0.004411493,-0.008072739,0.011888569,-0.0047811316,0.03760381,0.056961186,0.023911444,0.011819074,-0.0049336753,0.027661595,-0.010926959,0.02143833,0.03425261,0.06422485,0.061798595,-0.066888556,-0.056773886,-0.009834398,0.022316104,-0.03848976,0.023518804,0.046103384,0.013215182,0.045988504,-0.004409806,-0.04690837,0.04261793,0.031725153,0.0068786256,0.023865774,0.026972922,-0.017458348,0.016324922,-0.007834399,0.018707247,0.053202964,-0.042043928,0.023281379,0.042439792,-0.021110116,-0.071868904]	{"name": "Phố đi bộ Nguyễn Huệ", "ward": "Sài Gòn"}	2026-08-20 16:41:02.985499
59	25	0	Tên địa điểm: Công viên bờ sông Sài Gòn\nMô tả: Công viên bờ sông Sài Gòn là không gian công cộng xanh mát, hiện đại với tầm nhìn toàn cảnh bờ Tây sông Sài Gòn và những tòa nhà biểu tượng của Quận 1. Đến đây, du khách có thể thong thả dạo bộ, thả diều, ngắm nhìn những chuyến tàu thủy nhộn nhịp qua lại hoặc check-in tại cánh đồng hoa hướng dương rực rỡ. Địa điểm này vô cùng phù hợp cho các gia đình dã ngoại cuối tuần, giới trẻ thích nhiếp ảnh và cũng là một trạm dừng chân hoàn hảo lồng ghép vào các tuyến tour thực tế để giới thiệu về quy hoạch đô thị mới của thành phố. Điểm đặc trưng nhất chính là bầu không khí lộng gió, thoáng đãng cùng khung cảnh hoàng hôn nhuộm vàng mặt nước sông Sài Gòn tuyệt đẹp bậc nhất hiện nay.\nKhu vực: An Khánh, TP.HCM\nDanh mục: Check-in, Công viên\nHợp với sở thích: Thiên nhiên, Chụp ảnh, Nightlife, Gia đình\nĐộ phù hợp nhóm tuổi: CHILDREN (5/5), TEENAGER (5/5), YOUNG_ADULT (5/5), ADULT (4/5), MIDDLE_AGE (4/5), SENIOR (4/5)	[0.03943412,0.052941505,0.01368548,-0.07796122,-0.01828387,0.043963134,0.010438736,0.0648514,0.030946815,-0.00061508204,-0.0392529,-0.011692539,0.038463153,0.008817587,0.01821469,-0.004081777,-0.054054413,-0.010490561,-0.0026008908,-0.02429513,0.0007162336,-0.03164445,0.024919394,-0.032004416,0.040903024,0.007505724,-0.0001386589,0.007028966,-0.0482296,-0.07537238,0.088788435,-0.0013214193,-0.015553406,-0.07136497,0.071508445,-0.0473355,-0.046326444,0.061356675,0.047992475,-0.06268833,0.037729736,-0.005004887,0.06925816,-0.023728117,-0.009121959,-0.05241884,0.038005892,-0.023763984,0.030274391,0.043739792,-0.03809138,0.02810513,0.053244244,-0.049607415,-0.014412572,0.005072719,-0.0060566776,-0.0006555755,0.038055934,-0.014880585,0.0062486813,-0.060531538,-0.02544543,0.068222694,0.035164505,0.052877907,-0.01397567,-0.0133274365,0.07022318,-0.01643332,0.08078711,0.08767832,0.09114833,0.0133686345,-0.03298392,0.03924232,-0.0098274285,0.03207184,-0.004036115,-0.032059334,0.032831524,0.029624343,-0.0098680975,0.00029836487,0.0045187864,0.07906484,-0.05020983,0.021806708,-0.030354116,0.01507585,-0.02045306,-0.0054193167,-0.0067493655,0.02582121,-0.038573075,-0.030998832,0.02883342,-0.025247104,0.027015733,-0.04467251,0.003449749,-0.0070689297,0.06559135,-0.0073274663,-0.046760708,0.074454926,0.034998473,0.07131344,-0.0027457313,0.024619283,0.025182655,-0.006227189,0.0054763323,-0.0070678014,-0.03866781,0.024639098,-0.013639014,-0.03700744,0.04397209,-0.030584218,0.021692982,0.00892851,0.02255847,0.0019420001,-0.053236917,0.029601354,-0.06378694,0.011461515,-0.010495243,0.06285942,0.005908654,-0.00019378944,-0.012386336,-0.02213074,-0.00930565,-0.027041528,0.012012958,-0.0063673514,-0.03460478,0.013154192,-0.006899749,0.001735603,-0.049166694,0.036827244,0.022266766,0.042602174,0.0155989835,0.07024376,-0.039734907,-0.03803712,0.017856209,-0.025542717,0.0004895755,-0.024880027,-0.0387268,-0.008299339,0.02219296,-0.014065595,0.018509682,-0.024837006,-0.04905637,-0.010572455,0.012943656,-0.0057729194,0.007249207,-0.004682526,-0.017074134,0.036290895,0.10716599,-0.03838391,-0.043925527,0.06705306,0.013066656,0.03539171,0.09926092,-0.008546433,0.0063435785,0.062787585,0.012656296,-0.027726978,-0.019588906,0.008530017,0.0069531384,0.0032619555,-0.040538732,0.0027922154,0.0086516775,-0.078102276,-0.004864495,-0.01756217,0.0400128,-0.034138624,0.027685348,0.022700543,-0.024239274,-0.04249269,-0.05834919,0.0011883305,-0.032967173,0.011793849,-0.02153682,-0.018834569,-0.003287956,-0.02905511,-0.06923452,0.02653413,0.006009228,0.08365045,0.035560064,-0.026356483,0.00025202386,-0.0017167904,0.018773478,-0.027081104,-0.037769295,0.029944746,-0.021689001,0.049545392,0.02400384,0.042891163,0.0017089549,0.006482274,0.01321926,1.7195729e-05,0.021954559,-0.05811099,-0.00018004196,-0.022497727,0.030188523,0.00054972025,-0.05600936,-0.007864275,0.049631055,0.039289564,0.040868413,0.01610878,-0.016439922,0.00923609,0.002889148,-0.017806185,-0.02761264,-0.045309544,0.013098543,0.012814771,-0.0022408967,-0.0076329676,0.013874721,-0.008516226,0.08813888,0.059765246,0.0059928154,0.038945265,-0.030569054,-0.006656295,0.0055703074,0.011901464,0.013812368,-0.020806586,0.030040588,0.015918685,0.053983215,-0.022514159,6.673616e-05,-0.028180623,0.022772675,-0.0037152919,0.0578464,0.012474313,0.011792072,-0.0560018,-0.00022436195,0.05012191,-0.009349516,0.014948715,-0.040361986,-0.01703263,0.012141949,0.06905791,-0.06346177,-0.016103808,0.041553702,0.010191858,0.022584602,-0.022882864,-0.06196599,0.057257116,0.011380509,0.044550776,0.045926116,0.03896555,-0.023513384,0.0110696135,-0.073945604,0.033683278,0.0351028,0.036668546,0.011979237,-0.01958525,-0.0068130125,-0.044063807,0.039325673,0.0098851165,0.04699929,0.02462993,-0.05003891,-0.012980099,0.00209127,0.027146718,0.032305274,0.0075150393,-0.03647734,-0.04113807,0.013907749,0.0592489,0.030978182,0.00390002,-0.046865765,-0.021318326,-0.030638464,0.015441232,-0.042182848,0.018416487,0.058875017,-0.037141625,-0.012625389,0.025542408,0.016107365,0.0041384255,-0.014798416,-0.01449928,-0.00018012553,0.061429612,-0.0065485584,0.009579979,0.005064265,-0.026816826,0.013901162,0.011845669,0.0044609895,0.05232261,-0.008524195,-0.05148273,-0.011789813,-0.0194676,-0.016272837,0.00013534825,-0.0045319446,-0.014123369,0.019653948,0.039067537,-0.0709116,0.037513375,0.011055973,0.059003986,0.04237046,-0.015743425,-0.025492013,0.028291836,0.0057631717,-0.02736614,0.022313341,-0.026649553,-0.04118444,0.05534556,-0.009626105,0.029065032,0.057510562,-0.052267514,0.015224587,0.05302884,0.040299486,-0.03681501,-0.04235871,0.030998854,0.05097451,0.03455882,0.03676029,-0.0343753,-0.008127477,0.04056801,-0.019242031,-0.047293812,-0.03922766,0.03521923,0.059730094,-0.0019573853,0.0059685973,-0.061664574,0.054421015,0.020256184,0.00816759,0.03342227,-0.015847152,0.02397779,-0.021047287,0.022335194,0.03744414,0.04865489,-0.026859809,-0.018510034,0.07569196,0.07160467,-0.048396982,0.021585796,0.030690886,-0.013989107,-0.015012464,0.005707088,0.013569174,-0.03183163,-0.0024662039,0.019226672,-0.0041708276,0.00978018,0.01888499,0.024384249,0.042670734,0.0040680654,-0.008725357,0.0011456024,0.02881655,-0.017523779,-0.015339006,-0.0395805,-0.020473894,0.05227767,-0.0035721497,0.011802125,0.016609753,0.04579896,-0.06768234,-0.033792544,-0.0061410423,0.048158478,0.03376948,0.037281096,-0.028993445,0.023583885,0.025836365,-0.08922126,0.019987065,-0.032297358,-0.0015460751,-0.004836336,-0.012488251,0.029730907,-0.020148119,0.039269306,0.03400316,0.03176403,-0.033497088,-0.08909671,-0.033704665,0.036888704,-0.05309561,-0.035356,0.03952066,-0.044419605,-0.0012458784,0.04914864,-0.0332163,0.07074957,0.024862092,0.01428866,-0.04035824,0.0006022435,-0.08730838,0.030760968,0.006910763,0.013160913,0.0071211196,0.018536733,-0.06970277,-0.03885113,0.051469035,0.04668806,0.008058718,-0.0408533,0.04251374,-0.05441345,-0.030061863,-0.056867234,-0.04176668,-0.011771246,0.05366167,-0.01813191,0.048234027,-0.003085236,0.014867729,0.038930733,0.021048395,-0.034879703,0.05340534,-0.08953327,-0.014835239,-0.0005986769,-0.07079143,0.028993595,-0.02854292,-0.036461826,0.034192774,-0.026143849,0.013553842,0.021998672,0.028784642,-0.011406037,-0.003637129,0.011108117,-0.0003008957,0.018428842,-0.032886826,0.063605525,-0.015904095,0.024307963,-0.015177954,0.001991266,0.02457261,0.06376707,0.011741289,-0.0054996363,-0.015967824,-0.027936006,0.016122993,-0.021204438,-0.039937858,0.008306762,0.016039567,0.0036790958,-0.0027165897,0.047714006,0.018488279,-0.013083778,-0.02883561,0.054762527,0.021224344,-0.02486746,0.03225665,0.010475871,0.01962999,-0.04055963,-0.0278012,0.02754952,-0.010696347,0.014552554,-0.003891071,0.00827211,0.1158728,-0.041573048,0.011362344,0.012141274,0.019273072,0.0027934823,-0.0094360085,-0.037000183,-0.024717346,0.04801817,-0.035456616,0.016821897,0.05300855,-0.025388692,0.08020842,-0.04006317,-0.015856626,-0.0007597519,0.04496739,0.014654834,-0.017864777,0.0024177616,-0.0359019,0.0011892868,0.012445285,0.032888804,0.026200982,0.04079967,0.028301539,0.01405179,0.050979927,-0.049634993,0.022899805,0.014392327,0.014877084,-0.00038246263,-0.038182154,0.04313279,-0.06252834,0.010278203,-0.06599563,0.08417083,0.03731983,0.023109874,0.035700597,-0.002156064,0.018397745,0.02305727,-0.040466957,-0.037205297,-0.003524416,-0.004454388,0.006867995,-0.0030817974,0.03959951,0.002372303,0.11887501,0.043446455,0.015587885,0.025576677,-0.043059085,0.030455537,0.028987171,-0.015626118,-0.07227014,-0.015400887,0.024434783,0.037636716,-0.05652371,0.0014523234,-0.029991588,-0.077366546,-0.011541728,-0.060175713,0.03513633,0.021029655,0.013882001,0.009093121,0.029778805,0.022042107,0.03594556,-0.020876685,-0.006708554,0.0024142242,0.05761736,-0.007940978,0.01929318,0.004640836,0.009706523,0.05129076,-0.062016126,0.040060196,0.009028986,-0.034488328,-0.015955877,0.0014016895,-0.028682807,-0.008853491,-0.04536897,0.029815339,-0.064849585,0.033242203,-0.01966589,0.019886801,-0.020439742,0.035049714,0.047422267,0.027950587,0.00067908596,-0.06294897,0.030644534,0.103649266,-0.052283514,0.007422165,0.047014993,-0.045680422,0.015199534,0.0067268126,0.027283851,-0.008813735,-0.015831439,-0.0033132576,0.03227657,-0.061432716,0.029013578,-0.020520277,-0.009336804,0.04171443,-0.013986818,0.017960789,0.03869143,0.043371163,0.025100593,0.045585886,0.05793305,-0.03987907,0.011719388,0.028767122,0.022186324,-0.05684637,0.0121510895,0.0074900202,0.06899373,-0.015909249,-0.0120475935,-0.05415779,0.021059409,0.0761454,0.008753179,0.0070550907,0.0027676704,-0.03594167,0.0033102646,0.032900784,0.0075555546,0.025173098,0.05487434,0.036372058,-0.058587994,-0.018145178,0.043950144,-0.07226856,0.016710952,0.061375346,0.037302386,-0.010227848,-0.058031894,-0.02730087,0.034371793,0.038006123,0.030708844,-0.024753343,-0.032445863,-0.003762295,-0.04941813,-0.031020451,0.04949537,0.012062973,0.045289334,-0.007176673,-0.03331526,0.014713392,-0.019199343,0.040436022,-0.0015909346,0.024692314,0.045705743,-0.031497862,-0.021007266,0.019285854,-0.0084451465,-0.028885918,0.007035369,0.013201177,0.07213892,0.008658213,-0.0979254,-0.009806421,-0.00493776,0.049765363,-0.0075096423,0.040741548,0.036167704,-0.00474033,0.013763487,0.054524302,0.005554647,0.012164082,0.02245988,0.022351587,0.05660314,0.07513409,0.0008671639,0.013474952,-0.009882146,-0.0123342145,0.068592176,0.04003662,-0.014035896,0.032617707,0.022456111,-0.10021797]	{"name": "Công viên bờ sông Sài Gòn", "ward": "An Khánh"}	2026-09-03 16:53:17.422839
61	27	0	Tên địa điểm: Khu du lịch Văn Thánh\nMô tả: Khu du lịch Văn Thánh mang đậm khung cảnh miệt vườn thanh bình với những bãi cỏ rộng lớn, ao sen và rặng dừa rợp bóng. Trong khuôn viên, du khách có thể tổ chức dã ngoại, câu cá, hoặc thưởng thức tiệc buffet cuối tuần nổi tiếng với các món ngon mang đậm phong cách ẩm thực khẩn hoang. Nơi này đặc biệt phù hợp cho các buổi tụ họp đại gia đình, team-building, và cũng là không gian thực tế sống động để tìm hiểu về nếp sinh hoạt văn hóa vùng đồng bằng sông Cửu Long qua hình ảnh chiếc áo bà ba hay chiếc xuồng ba lá ngay tại đô thị. Điểm đặc trưng nhất chính là sự đối lập đầy thú vị: một làng quê mộc mạc, tĩnh lặng nằm lọt thỏm giữa những tòa nhà chọc trời và nhịp sống hối hả của trung tâm thành phố.\nKhu vực: Thạnh Mỹ Tây, TP.HCM\nDanh mục: Công viên, Nhà hàng\nHợp với sở thích: Thiên nhiên, Gia đình, Ẩm thực, Văn hóa\nĐộ phù hợp nhóm tuổi: CHILDREN (5/5), TEENAGER (3/5), YOUNG_ADULT (4/5), ADULT (5/5), MIDDLE_AGE (5/5), SENIOR (5/5)\nKhoảng giá: 100,000 - 500,000 VND	[0.052977983,0.08230679,0.0028419222,-0.07267389,0.021618351,0.03086454,-0.019023595,0.05081874,0.02705958,-0.01247934,-0.056914087,0.005857661,-0.02295187,-0.019237071,-0.004228743,-0.008060583,-0.004581045,-0.0095354505,0.010817357,0.012343555,0.009745788,0.018907005,-0.034806494,-0.035746213,-0.010113507,-0.029821362,0.05439533,0.026757682,0.0055320123,-0.073129356,0.04989758,-0.014190657,-0.008508495,-0.017729873,0.061639283,-0.03549923,-0.002472725,0.04738184,0.033072755,-0.034128353,0.010210107,0.0017050816,0.04318155,-0.013359734,-0.02122996,-0.007824833,0.010809806,-0.02945158,0.016128182,0.001504019,-0.029177895,0.032432053,-0.012487194,-0.0077034878,-0.007830005,0.020348543,-0.011274422,0.0407373,0.025479151,0.0069455327,-0.058463834,-0.07181187,-0.016915288,0.008229611,0.07039504,0.046619684,-0.0029487272,0.034353916,0.034640715,0.024580738,0.054977216,0.038124144,0.10654356,0.019919686,-0.0019987402,0.026224043,-0.0060770935,0.04526185,0.012549061,-0.04863731,0.06688643,0.03302459,-0.027263483,-0.027210964,0.019054146,0.07431268,-0.030213486,-0.012189238,0.014980821,0.0084987115,-0.04512109,-0.004691161,-0.035123855,-0.008559147,-0.019956836,-0.011243131,0.0014849885,-0.031057984,0.015856156,-0.023013283,0.0012225399,-0.028385567,0.02949128,0.001257331,-0.018625537,0.045036077,0.058280803,0.051008586,-0.0029102804,0.011188826,0.014938873,0.0064324,0.05550628,-0.034710027,-0.033906523,-0.0032295573,-0.020652717,-0.0104786595,0.030361027,-0.032441456,0.014576106,-0.009278244,-0.017018657,-0.043610055,-0.07123636,0.04081316,-0.071212985,-0.04417008,-0.004920579,0.009793626,-0.0069041243,-0.036941227,0.004256288,0.046151098,-0.03543199,-0.028517753,-0.017896533,-0.05643995,-0.056632422,0.019285966,-0.048224136,-0.022111682,-0.06738455,-0.037647314,-0.0138185145,0.08797971,0.010369457,0.03748967,-0.015916597,-0.08967495,0.024077943,-0.004620529,0.016413398,0.01121953,-0.054730877,0.024110107,0.013652798,-0.02390905,0.019623607,-0.00058952085,-0.061695144,-0.030058306,0.038172424,-0.021563888,0.0018034972,0.010900717,-0.011360234,0.030199343,0.060817458,-0.02756136,-0.040544942,0.025350276,-0.03094525,-0.024619004,0.11819964,0.029540477,0.05692296,0.034685485,0.006409136,-0.019207265,0.036246844,-0.0028553095,0.050818503,0.03416479,0.012136855,-0.022124067,0.062287375,-0.067081995,-0.00077229546,-0.007222933,0.04600179,0.0019248443,0.019321172,0.044247877,0.022965819,-0.023050724,0.00873847,0.00633404,-0.032410603,-0.0011785739,-0.03874329,-0.06362746,-0.028319737,-0.013444691,-0.0033495722,0.057155203,-0.009570895,0.061875433,-0.009856566,0.019027686,-0.017452156,-0.026358774,0.0072326744,-0.00825314,-0.058828074,0.054605957,0.015303914,0.03862689,0.07907467,0.026337242,0.0068479874,0.02986854,0.04605403,0.04112507,-0.0013675134,-0.02744772,0.016692046,0.0047676633,0.0034184575,0.004122045,0.027245399,-0.04468448,0.024596546,0.05089548,0.076441675,-0.017728018,-0.0052076895,-0.007879063,0.038741596,-0.037817687,-0.0005351765,-0.03320234,-0.02965132,0.02134164,-0.008889564,0.0505752,0.056276254,-0.036248036,0.08622321,0.060465418,-0.04818222,0.049212005,-0.030696351,-0.021501547,0.016373232,0.0021239987,0.03877598,-0.011043292,0.037058968,-0.0049203145,0.014111651,-0.018777065,0.0030067444,0.02715124,0.034018207,-0.031398978,0.07972479,0.039242454,0.044099387,-0.00086527807,0.025422676,0.06831566,-0.008948241,-0.016330363,-0.050799735,0.021822104,-0.0062248856,0.036074705,-0.050578695,-0.028898703,0.07800184,-0.020477591,-0.010955757,-0.018941034,-0.03399784,0.059576847,-0.033861548,0.051927656,0.029767081,0.044350218,-0.022118963,0.06473276,-0.030042846,0.046011996,0.094252564,0.010488429,-0.013550857,-0.034049343,0.0034150865,-0.026253501,0.023119427,0.011301025,0.0366202,-0.010527871,0.008138636,-0.012534865,-0.012674874,0.012968328,0.013816003,-0.000117637086,-0.041738465,-0.050175477,0.008114325,0.07675455,0.052802477,0.010828721,-0.03794882,-0.043590542,-0.014807076,0.045514487,-0.016227117,0.051290456,0.01978806,-0.03164401,0.027508667,0.05255222,0.015632858,0.03980734,0.0029129393,-0.020560697,-0.047314823,0.06783728,0.039183114,0.044011883,0.0048365938,0.0058249664,-0.03488307,-0.04499383,0.05095618,0.011527018,-0.04824287,-0.05063624,0.026345117,-0.0197786,-0.016420066,0.028338235,-0.008146786,-0.0045484845,0.011565359,0.045907795,0.006393921,0.013660702,-0.010055687,0.009124613,0.036621384,0.025032157,0.010645486,0.019872034,-0.038416464,-0.03828899,0.019094042,-0.044913907,-0.018143177,0.01352713,0.007851786,0.014219427,-0.015580158,-0.008931114,-0.0006694093,0.062182624,0.058362346,0.023222055,0.0028715553,0.06077354,0.013541006,0.030389072,0.0225926,-0.03651912,-0.02016565,-0.022555828,-0.02719401,-0.029088832,-0.0140814725,0.026000096,0.031299133,0.012739583,-0.035894107,-0.047375288,0.04534127,-0.0035726891,-0.05085854,0.01350468,0.007372639,0.024373757,-0.0045494316,0.010050032,-0.0021675797,-0.01732197,-0.01604907,-0.020803995,0.03668122,0.030569721,-0.013205728,-0.007727719,0.05519057,-0.0068059266,-0.043805458,-0.03002613,0.0059634796,-0.050513726,0.010994827,-0.0601779,-0.027589642,-0.05070113,0.006416262,-0.005606025,-0.008155417,-0.0004886012,0.01921621,-0.004558536,0.032075,-0.011043511,0.044153135,0.0072368016,-0.028219158,0.013265965,-0.010384791,-0.018115176,-0.010435969,0.045744743,-0.020271303,-0.010176495,0.0063743433,0.09958694,5.560052e-05,-0.025998458,-0.005919624,0.022802534,0.0025695604,-0.026945485,-0.005128201,-0.060045373,0.007191165,0.036745064,-0.023985973,0.014417529,-0.059054267,0.03536962,-0.0013975054,-0.018929774,0.05032558,-0.029728156,-0.017681988,0.022652447,-0.058302447,-0.06060031,0.0031715638,-0.008788991,-0.004094886,-0.023366189,-0.027681543,0.105322435,0.035874322,0.031825308,-0.028464414,-0.017987793,-0.053919975,0.011057713,-0.010289973,0.03193723,-0.014826037,-0.030589622,-0.047008652,-0.0025569536,0.026892072,0.07783775,0.002569005,-0.03520179,0.0138832135,-0.023847139,-0.0043499814,-0.039923716,0.025644297,0.012205723,0.058743957,-0.025884578,0.02534674,-0.0017465373,0.058278006,0.04288084,-0.011677264,-0.02452451,0.05441434,-0.022548981,-0.029999772,-0.030760411,-0.029179752,0.08448224,-0.046914607,-0.011842871,0.039490324,-0.031497456,0.04054525,0.00624846,0.05921922,-0.0023874668,0.012841695,0.0039164023,0.025384856,0.004556246,-0.04690748,0.048812483,-0.035042405,0.019704465,-0.043730345,-0.026144505,-0.01898989,0.010683296,0.04610565,0.00818334,-0.029642884,0.040733542,0.010921813,0.028941795,0.013268426,-0.00040826367,0.0024636996,0.033531517,0.014244956,0.018345907,-0.019182496,0.02316827,-0.0217592,-0.0069017736,0.04473954,-0.0148572875,0.10125666,0.030096997,0.023384498,-0.0023272948,-0.03829973,0.0049071894,0.002751592,0.023745487,0.042789828,-0.051065583,0.10856632,-0.03149971,-0.033584114,-0.0063973786,0.020042423,0.009883387,0.011979348,-0.03708968,-0.011001646,0.026257895,-0.017249027,0.005894252,0.052907515,-0.025754636,0.04329973,-0.029959833,-0.061033625,-0.04800485,0.035979606,-0.00033373138,-0.041687388,-0.0044394773,-0.0015397108,-0.03705778,-0.01841788,0.031127142,0.007261559,0.018537804,0.036634848,0.03368238,0.043098997,-0.0073588514,0.042613197,0.021869238,0.04846176,0.0039075725,-0.0052785687,0.07458906,-0.043329615,-0.014278121,-0.057462588,0.108187765,-0.028348038,-0.017674878,0.047757283,0.0027564762,-0.035243493,0.033686172,-0.033839855,-0.00573327,-0.052675027,0.0075130546,0.06713445,-0.015420751,0.025650827,0.032586094,0.07887105,0.088442005,0.028719693,-0.0073248204,-0.028144548,-0.0214,0.058577813,0.009735099,-0.11708989,-0.011150167,-0.029563017,0.06360803,-0.019105097,-0.015735546,-0.025883386,-0.050825037,-0.046074975,-0.058053154,0.033500664,0.045326225,0.028771624,0.01957797,0.012532028,0.025925826,-0.021114666,-0.01490339,0.00832403,-0.014570678,0.015992394,-0.0025338845,0.010436794,0.0005552784,0.011594511,0.034483053,-0.041508537,0.05392608,-0.03629294,0.011594223,-0.037286792,0.03819431,0.05054059,0.058548376,-0.06736185,0.008350627,-0.041752286,-0.0026158378,-0.013313,0.047926363,0.0066154497,-0.016857935,0.009925021,0.023071464,0.04618832,-0.040285636,0.027208332,0.018506702,-0.05052198,-0.031087657,0.028939769,0.011796892,-0.023619125,-0.04656457,0.05116595,0.033069544,-0.025757639,0.037448388,0.044693444,-0.05813985,0.06741553,0.019245641,-0.0035628986,0.01879849,0.01233107,0.0315665,0.0437817,-0.02099406,0.028339742,0.06720954,0.031090647,-0.03589027,0.0065890634,-0.018694004,0.0065236446,-0.070790045,0.03568689,0.024226664,0.05275733,0.0064357077,-0.018813808,-0.05500077,0.064363845,-0.0060906545,0.028905628,0.029691456,-0.016987346,0.045257922,0.019785905,0.05873443,0.02237629,-0.015260081,0.044262994,0.0020865924,-0.029045777,-0.039180465,0.016351273,-0.08196991,-0.009808712,0.04302445,-0.017420048,-0.022559278,-0.039703894,-0.016050756,0.011638657,0.0327024,0.030116517,-0.06572963,-0.053571273,0.03736993,0.0041204076,-0.00015217945,0.021226367,0.03392909,0.072694905,0.019174231,-0.02632813,0.03613692,0.004809979,-0.0025537037,0.015074007,0.065762125,0.044914987,-0.064573765,-0.0077782865,-0.0078119165,-0.0014289732,-0.003947817,0.0012643001,0.00035186665,0.056280423,0.041641112,-0.06320863,0.01690866,-0.013203129,0.06324058,0.005426819,0.01216761,0.04039596,-0.056900192,-0.016985929,0.0012502811,-0.018315626,-0.0147487875,0.019033335,0.05309647,0.061765254,0.1123135,0.05864074,-0.0015377064,-0.012837846,-0.012446306,-0.0071980557,0.044205584,-0.012947821,-0.006815812,0.023008833,-0.111096896]	{"name": "Khu du lịch Văn Thánh", "ward": "Thạnh Mỹ Tây"}	2026-09-04 23:22:35.722297
62	28	0	Tên địa điểm: Nhâm Coffee\nMô tả: Nhâm Coffee mang đến một không gian mộc mạc, hoài cổ với thiết kế chủ đạo từ gỗ thô, những tán cây xanh rợp bóng như một 'Đà Lạt thu nhỏ' giữa lòng Sài Gòn. Bạn trẻ và du khách thường đến đây để uống một cốc cà phê, tìm một góc yên tĩnh để chạy 'deadline', đọc sách hoặc thả hồn vào những đêm nhạc Acoustic mộc mạc. Địa điểm này là chốn 'ẩn náu' lý tưởng cho sinh viên, giới văn phòng và những người yêu thích sự tĩnh lặng, hoài niệm. Điểm đặc trưng lớn nhất là vị trí nằm sâu trong con hẻm nhỏ yên bình, tách biệt hoàn toàn với dòng xe cộ hối hả trên đường Điện Biên Phủ, tạo nên một khoảng không thư giãn hiếm hoi.\nKhu vực: Gia Định, TP.HCM\nDanh mục: Check-in, Quán cà phê\nHợp với sở thích: Chụp ảnh, Cà phê\nĐộ phù hợp nhóm tuổi: CHILDREN (2/5), TEENAGER (3/5), YOUNG_ADULT (5/5), ADULT (4/5), MIDDLE_AGE (2/5), SENIOR (2/5)\nKhoảng giá: 50,000 - 70,000 VND	[0.02268685,0.062217914,-0.013716556,-0.05495805,0.012782555,-0.0047660293,0.014380769,0.044566914,-0.039912067,-0.070601866,-0.075057894,0.008419896,0.030233754,0.017723499,0.012107693,0.058351774,-0.04033242,0.0024412258,0.014833174,-0.02527435,-0.035455003,0.039597914,0.007496358,-0.04154576,0.058229927,0.04881377,-0.02400859,-0.022076149,0.0060175047,-0.01068258,0.020838013,0.0009723625,-0.014918456,-0.027597494,0.08416984,-0.022681449,0.0125190895,0.0064597526,0.111526266,-0.072185956,0.005090327,-0.037278075,0.03246353,-0.020021638,-0.035249688,-0.022667896,0.01876428,-0.07704212,-0.0074438835,0.0012345227,-0.08030236,-0.004781525,0.01693376,0.015077127,0.010319889,-0.009846123,-0.05058203,0.0207819,0.0442267,0.008670375,0.054594304,-0.07281302,-0.00043020715,0.025602175,0.060075365,0.009246047,-0.02646717,0.004274072,0.028459696,-0.010810977,0.046638653,0.059926275,0.050402462,-0.01733518,0.0529158,0.05474338,0.013886901,-0.016320774,-0.009307912,-0.010837954,0.045387235,0.0684737,-0.052229892,-0.0599335,-0.00050033536,0.047131218,-0.050345477,-0.003794731,0.007022162,0.021991124,-0.015809113,0.0016576089,-0.02075853,-0.022201307,-0.02339592,0.034726027,0.02900698,-0.02254387,0.04152609,0.0021884681,-0.0010615254,-0.0074411836,0.047298573,0.027315466,-0.005173058,-0.0029650512,0.028019093,0.032748457,0.027980795,-0.004637604,-0.00334891,-0.0071500917,0.04629039,0.013033167,-0.05693323,0.013943439,0.0012563148,-0.031582586,-0.014924811,-0.00037007534,0.034236737,0.019998435,0.03817174,0.006219106,-0.033215445,0.03910623,-0.01913064,-0.05846444,0.05588154,0.02907002,0.052788492,0.007849627,0.058252428,0.0092994785,0.026738964,-0.008300681,-0.003098769,0.039337426,-0.055048205,0.054979876,0.0043958076,-0.01790302,-0.031467464,0.08175885,0.057662234,0.019118056,-0.013183975,0.04803554,0.010561583,0.009265803,0.029667001,0.0062127137,0.026463361,-0.030680394,0.018533245,0.007566034,0.020331208,-0.009829804,0.018223105,0.0042719557,-0.023285488,-0.016215788,0.017318746,0.045181606,-0.0026808837,0.00056551426,-0.018373683,0.03058329,0.07457676,-0.008155696,-0.013411097,-0.009019797,0.007391481,-0.057830367,0.08394947,0.040292244,0.08227944,0.039397903,0.046341367,0.024961352,-0.033653367,0.027258616,0.018589707,-0.007988479,-0.04667406,0.013469702,0.044117432,-0.04397735,-0.01689398,0.020521386,0.05262805,-0.028197352,0.03213711,0.0065898374,0.034343764,-0.045124304,-0.026522668,0.015593998,0.03464032,0.07823316,0.023583284,-0.03621928,-0.06478501,-0.052042723,-0.06311898,-0.00013793727,0.02151108,0.049574163,-0.013830252,0.03994522,0.02280873,0.039108023,-0.024841541,-0.03923635,-0.021281919,0.014257087,0.0010426316,0.043355264,-0.0012438794,0.045606155,0.012388347,0.011241632,0.040765118,-0.008000086,-0.0023020052,-0.055190593,0.041530192,-0.05973573,-0.027921515,-0.0018345228,-0.028856443,-0.0055472166,0.04326314,0.038870778,0.021523375,-0.0017485963,-0.055794228,0.08964269,-0.0053639733,-0.013722821,-0.02543968,-0.00621684,0.009659421,0.034274843,0.02833453,0.010997291,0.035919063,-0.015264015,0.081035875,-0.034792367,0.011892177,0.086110994,-0.0028293552,0.033261165,0.0039065178,-0.021381002,0.0371323,-0.018321067,0.03264296,0.02821661,0.00755968,-0.011365636,0.045224547,-0.0068250713,0.020368384,0.008805021,-0.013678998,-0.010699892,0.04017499,-0.042601496,0.02725017,0.0070720017,0.008917493,-0.012220002,-0.017647425,0.006091851,0.038800325,-0.018759359,-0.016292816,-0.01920686,0.055629313,-0.06688077,-0.013805495,-0.03666863,0.02551254,0.048730027,0.0104307905,0.002155432,0.025345732,0.02279236,-0.026894294,0.00530105,-0.12574539,-0.015801968,0.023095224,0.01786992,0.0027593065,-0.05393199,0.02070042,-0.015793344,0.020976247,0.027500438,0.05638726,-0.023878178,-0.024080789,-0.010433215,-0.010868906,0.031496797,0.050666142,-0.0335304,-0.019216903,-0.036546465,-0.058501966,0.008212219,0.061293088,0.016222391,-0.04254425,-0.010301168,-0.028130632,0.032817714,-0.063142404,0.07921899,0.04499131,-0.032635976,-0.005989993,-0.015491803,-0.026389465,0.039216112,-0.027698921,-0.013502179,-0.031516574,0.08066658,0.034598123,0.005256987,0.04472534,0.018490601,0.017739918,0.08228508,0.0057609743,0.016296642,0.015049474,-0.077667885,0.028911158,-0.043781344,-0.016317466,-0.03202295,0.026043605,-0.01200908,0.0028508257,0.00058408757,-0.062391784,0.027152507,0.0017553095,0.0041583143,0.02784915,0.047542717,-0.022568854,0.031134607,-0.043477263,-0.009749359,0.076515086,0.03239189,0.03582112,0.06856317,-0.003462191,-0.010497831,0.03166968,0.027653681,0.015512338,0.04468346,0.01113931,-0.034968052,-0.013714602,0.02214016,0.0020643123,-0.021929095,0.005604184,-0.030631352,0.020613449,0.044892598,-0.013536453,-0.052949123,-0.040010728,0.010105816,0.016396318,-0.00908217,-0.046186548,-0.0043155407,0.076641165,-0.0028672158,0.032681245,-0.008521313,-0.00050523976,0.03125422,0.028121734,0.024389714,-0.06563529,0.0030437557,0.010493597,-0.009793344,0.044983856,0.028185748,0.0034835003,0.00658179,0.0065166093,-0.0071507427,-0.054091863,-0.05497134,-0.010786802,-0.033605203,-0.018792344,-0.017824097,-0.008536522,-0.045141272,0.0061277617,0.015036125,0.015495376,-0.015648672,0.03886373,0.04010227,0.08578626,-0.06468621,0.016889872,-0.027615879,-0.004699386,-0.03771043,0.036918487,0.010803186,0.0073178313,-0.043836314,-0.034966752,0.013592653,0.00430405,0.06356207,-0.0071726223,-0.011070715,0.018326363,-0.032739893,0.014991898,-0.027684635,0.026092302,-0.027167182,0.01365663,0.0061303466,-0.039043948,-0.010109037,-0.006258175,0.038781624,0.03807108,0.058323007,-0.016461,0.007929825,-0.03534566,0.04520339,-0.06380202,-0.0048509,0.07631776,0.020402739,0.037018478,0.0046283305,-0.0356534,0.020278323,0.00727341,-0.041266557,-0.04953461,0.04455815,-0.08346804,-0.013011774,0.0047924123,-0.023873162,-0.009319224,0.014200788,-0.015732631,0.022223184,-0.02228803,-0.0066652605,0.047710244,-0.033881575,0.04680409,-0.007834005,0.0358922,-0.08179701,0.030087698,-0.00011487623,0.014763929,-0.0054692915,0.039990146,0.023040233,0.0056352937,0.01292732,-0.05672815,0.016046863,0.054030564,-0.032584835,-0.035993837,-0.022806844,-0.060506146,0.061935324,-0.04604814,-0.01819437,0.055007752,-0.0056958976,0.029313914,-0.004804207,0.05977709,-0.0031867255,0.026034517,0.0042789225,0.010864079,0.024091566,0.033258922,0.032535814,0.019856725,0.027378881,0.016562317,0.06374985,-0.03159688,0.05886653,-0.054735467,-0.028142093,-0.0025309045,0.023269614,0.019176006,-0.044593196,0.0065487386,0.027573371,-0.014055387,-0.021860087,0.015694069,0.01858397,-0.003140208,-0.036978193,0.008986118,0.0030095717,0.01684503,-0.025451483,0.031709105,0.025199838,-0.03242755,-0.058679547,-0.0033929744,0.029234018,-0.005200721,0.054243006,0.032701813,-0.028306436,0.025012814,-0.06067332,-0.01912665,0.026541637,0.00987903,-0.026552094,-0.00055020646,0.007989995,0.00553743,0.029971723,-0.026081638,-0.01847371,0.07827007,-0.009704807,0.038433343,0.0014030957,-0.025370609,0.00075043284,0.029549759,0.030108145,-0.037067495,0.08563694,0.05302148,0.007885956,0.028946884,-0.012566799,0.049814768,0.06031932,0.020599954,-0.008343117,0.05769006,-0.023059884,0.063551635,-0.009165754,0.032671545,-0.05644105,-0.0068086674,0.004951457,-0.071958065,0.033362746,-0.09858495,0.117610976,-0.016742734,-0.025403159,0.05748646,0.02183211,0.01313675,-0.03354841,-0.010774547,-0.046324264,-0.021606259,-0.022224408,0.0017021527,-0.014004117,-0.008171886,0.06965437,0.06658405,0.09062412,0.018702086,0.02621083,-0.04688639,-0.004924901,0.013176353,0.013369021,-0.039873686,-0.046342194,-0.00070652034,0.024203284,-0.04617115,-0.029019611,-0.010815295,-0.0038131806,0.015726594,-0.041876,0.010021302,-0.0012813774,0.048634898,-0.009777445,-0.009270731,0.05260481,-0.009338485,-0.038104963,0.015074088,-0.012567098,0.12085671,0.017276578,0.008145554,0.018582305,-0.012205826,-0.015563234,-0.07481056,0.055764098,-0.053564727,0.01672867,-0.036547996,-0.021535665,-0.08743046,-0.015705142,-0.038662758,0.022228118,-0.034537252,0.008199341,-0.02195007,0.0110779265,-0.049786497,0.02414204,0.039228983,0.033118423,0.021299137,-0.031793248,0.007597271,0.047957417,0.0043728924,0.00073258876,0.028005108,-0.0065639005,-0.066759676,0.014476016,0.038757093,-0.054354474,-0.019583913,-0.0147782015,0.034715544,-0.08014102,0.03134747,0.0006273702,0.016086359,0.03205634,0.0048739845,-0.004156571,0.038130544,0.011157635,0.009409998,0.04742836,0.036515117,-0.03017499,-0.0075334287,0.013260974,-0.017486108,-0.036091384,0.015175626,-0.008598013,0.070156984,0.05382053,-0.009786293,-0.03630421,0.0130787445,0.0135086,0.011960899,0.045637354,-0.01607489,-0.00031757774,-0.0051427083,0.026249709,-0.0055512534,-0.0048846183,0.038453512,-0.0063053397,-0.0012107928,-0.076566845,0.043454286,-0.03265227,0.0021260076,-0.0060153003,0.0651132,-0.0034336317,0.008229237,-0.042081628,0.013169137,0.054806497,0.067953,-5.9944763e-05,-0.043639712,0.03970516,-0.0029897902,-0.008922773,0.019985534,-0.036881957,-0.0126771545,0.030776365,-0.07219596,0.032452833,0.0053796167,0.023777392,0.03197093,0.02317793,0.043771066,-0.045895763,-0.04759594,-0.0130725065,0.009537541,-0.015428566,-0.036365032,0.015432849,0.056496795,0.08560552,-0.104175694,0.029984869,-0.01328444,0.06259909,-0.0042767506,0.014405303,0.0118228635,-0.03544233,0.007045477,-0.0056151208,0.026465563,0.021221742,0.022061199,0.026452288,0.0362941,0.053609487,-0.008718348,0.019047353,-0.017574051,0.006471439,0.091336966,0.0035982637,-0.04835005,0.013177973,0.02019929,-0.10153437]	{"name": "Nhâm Coffee", "ward": "Gia Định"}	2026-09-04 23:30:11.145358
\.


--
-- Data for Name: placeimage; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.placeimage (id, place_id, img_url, caption, is_primary, created_at) FROM stdin;
1	23	https://res.cloudinary.com/dyjdromdd/image/upload/v1785861742/places/23/t4pcn1hwjnn36tvvjyio.jpg	\N	t	2026-08-04 23:42:20.835033
2	23	https://res.cloudinary.com/dyjdromdd/image/upload/v1785861808/places/23/soefw42zr7rqnwjscfcq.webp	\N	f	2026-08-04 23:43:28.110064
3	22	https://res.cloudinary.com/dyjdromdd/image/upload/v1785862104/places/22/maslmsjvunyxhy4vzu75.jpg	\N	t	2026-08-04 23:48:24.329974
4	15	https://res.cloudinary.com/dyjdromdd/image/upload/v1785924274/places/15/b2o0ctfjj8zdds0kdgdz.jpg	\N	t	2026-08-05 17:04:31.924717
5	18	https://res.cloudinary.com/dyjdromdd/image/upload/v1785925341/places/18/ipzl1f2ssethwiwliedu.webp	\N	t	2026-08-05 17:22:19.869991
6	18	https://res.cloudinary.com/dyjdromdd/image/upload/v1785925344/places/18/fgvheomjm7nhevfdfjwx.jpg	\N	f	2026-08-05 17:22:23.475971
8	24	https://res.cloudinary.com/dyjdromdd/image/upload/v1785926577/places/24/o1vbr4xqdkjt1rvsxswu.jpg	\N	f	2026-08-05 17:42:56.464259
9	24	https://res.cloudinary.com/dyjdromdd/image/upload/v1785926579/places/24/pn4evtwenk5hjodekqpk.jpg	\N	t	2026-08-05 17:42:56.464105
10	20	https://res.cloudinary.com/dyjdromdd/image/upload/v1786524137/places/20/fvdptbfhqtdvihvmf9e8.jpg	\N	t	2026-08-12 15:41:40.036454
12	21	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217202/places/21/du0dadjyc4e31vnj4eun.jpg	\N	t	2026-08-20 16:13:20.963753
13	21	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217210/places/21/vvps9rwjinfiwvev3vk0.jpg	\N	f	2026-08-20 16:13:29.814947
14	21	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217264/places/21/g0mehwnd9q3bzjvcdeb0.jpg	\N	f	2026-08-20 16:14:24.345562
15	19	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217398/places/19/cwusgexfbma2beefqnbt.jpg	\N	t	2026-08-20 16:16:38.269989
16	19	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217400/places/19/xkxh93pblhx1zwmx1t1e.webp	\N	f	2026-08-20 16:16:40.570508
17	17	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217483/places/17/gcwuponx1vvcktazsd9d.jpg	\N	t	2026-08-20 16:18:03.429611
18	17	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217486/places/17/gps0z4n9fmutbi27atu7.jpg	\N	f	2026-08-20 16:18:06.055287
19	16	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217749/places/16/d0ttutg27ydxxakithrh.jpg	\N	t	2026-08-20 16:22:29.520615
20	14	https://res.cloudinary.com/dyjdromdd/image/upload/v1787217860/places/14/rgdgbxe2gi3eaxqacglr.jpg	\N	t	2026-08-20 16:24:19.992622
21	13	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218173/places/13/hsfysnnocduxea856wxb.jpg	\N	t	2026-08-20 16:29:33.156871
22	13	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218176/places/13/xr2mhmahglj2dh2yarpz.jpg	\N	f	2026-08-20 16:29:36.06574
23	12	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218285/places/12/i9zfjrhjr2pslpbuyhv1.jpg	\N	t	2026-08-20 16:31:25.543724
24	12	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218287/places/12/zskjc8zuwj9z0zeyh6dz.png	\N	f	2026-08-20 16:31:27.643711
25	10	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218352/places/10/tw1lxhk64x0ye6jjfvqa.jpg	\N	t	2026-08-20 16:32:32.541463
26	11	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218404/places/11/gg5tgwqie1jhwjynsmbv.jpg	\N	t	2026-08-20 16:33:24.575057
27	1	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218490/places/1/xj3xzzd5elql5samhohx.webp	\N	t	2026-08-20 16:34:49.91166
28	9	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218548/places/9/lc4ycxudqcxt8svexgmd.webp	\N	t	2026-08-20 16:35:48.56837
29	8	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218655/places/8/uqh1qodza4pen8echdgr.jpg	\N	t	2026-08-20 16:37:35.474514
30	7	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218758/places/7/nk6mlxsnt0fums8jbeop.jpg	\N	t	2026-08-20 16:39:18.473698
31	6	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218851/places/6/qhehnmrvprhsfggiiq97.jpg	\N	t	2026-08-20 16:40:50.835068
32	5	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218934/places/5/jxzoxcv8ailtrzogwwqh.webp	\N	t	2026-08-20 16:42:14.557705
33	4	https://res.cloudinary.com/dyjdromdd/image/upload/v1787218983/places/4/n7ivlo4zj2ahjf2rga2t.webp	\N	t	2026-08-20 16:43:03.717467
34	3	https://res.cloudinary.com/dyjdromdd/image/upload/v1787219062/places/3/kuln58yxrn8hx33iuveq.jpg	\N	t	2026-08-20 16:44:22.061585
35	2	https://res.cloudinary.com/dyjdromdd/image/upload/v1787219113/places/2/kvk003xglo9g5s4aaek3.webp	\N	t	2026-08-20 16:45:13.567747
36	25	https://res.cloudinary.com/dyjdromdd/image/upload/v1788429275/places/25/qy1bpv4fb1gjnkrbwera.jpg	\N	t	2026-09-03 16:54:33.853273
37	26	https://res.cloudinary.com/dyjdromdd/image/upload/v1788442443/places/26/kwvvnbhqn1eddbxyq1kt.png	\N	t	2026-09-03 20:34:01.656871
38	27	https://res.cloudinary.com/dyjdromdd/image/upload/v1788539006/places/27/uckpnwor5qbrq5jpyikj.jpg	\N	t	2026-09-04 23:23:25.276413
39	28	https://res.cloudinary.com/dyjdromdd/image/upload/v1788547453/places/28/zlwrz1eg6c6ph4i4okty.jpg	\N	t	2026-09-05 01:44:11.476315
\.


--
-- Data for Name: placetag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.placetag (place_id, tag_id, relevance) FROM stdin;
1	2	1.00
1	3	0.60
1	13	0.90
2	2	1.00
2	14	0.90
2	4	0.60
3	2	1.00
3	14	0.90
3	4	0.70
3	13	0.90
4	14	1.00
4	9	0.90
4	13	0.90
5	6	1.00
5	1	0.90
5	14	0.90
5	4	0.80
6	7	0.90
6	11	0.90
6	12	0.90
6	4	0.90
7	3	1.00
7	7	0.80
7	12	1.00
7	4	0.80
8	1	1.00
8	11	0.80
9	1	1.00
10	3	1.00
10	12	0.90
11	7	1.00
11	12	0.90
12	7	1.00
12	12	0.90
12	3	0.70
13	4	0.80
13	7	0.90
13	12	0.90
13	14	0.90
14	2	1.00
14	4	0.80
14	14	1.00
24	11	1.00
16	2	1.00
16	4	0.90
16	13	1.00
16	14	1.00
17	2	1.00
17	4	0.90
17	7	0.90
17	8	0.80
17	13	1.00
24	7	1.00
20	2	1.00
20	3	0.60
19	2	1.00
19	4	0.60
19	13	0.90
19	14	0.70
21	2	1.00
21	4	0.80
21	13	1.00
21	14	0.80
20	7	0.60
20	14	0.70
25	3	1.00
25	4	0.80
25	11	0.80
25	12	0.90
26	5	1.00
26	7	0.80
27	3	1.00
27	12	0.80
27	1	0.80
27	14	0.60
28	4	0.80
28	5	1.00
22	4	1.00
22	11	0.60
22	13	0.80
23	4	1.00
23	11	0.60
23	13	0.70
15	2	1.00
15	4	0.80
15	11	0.60
15	13	0.90
15	14	1.00
18	6	1.00
18	13	0.90
18	14	0.90
\.


--
-- Data for Name: review; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.review (id, place_id, user_id, rating, title, content, visit_date, status, created_at, updated_at, images) FROM stdin;
1	1	4	5	Chỗ rất đẹp	Dinh rất bự, có rất nhiều chỗ để check-in chụp ảnh. 1 nơi ẩn chứa nhiều lịch sử Việt Nam	\N	APPROVED	2026-07-24 23:46:49.70361	2026-07-24 23:46:49.70361	\N
2	23	4	5	\N	Bitexco rất đẹp	2026-08-14	APPROVED	2026-08-15 22:47:27.077096	2026-08-15 22:47:27.077096	[]
\.


--
-- Data for Name: searchlog; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.searchlog (id, user_id, query_text, filters, result_count, created_at) FROM stdin;
22	\N	Bi	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:23:54.45817
23	\N	B	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:23:55.723502
24	\N	Land	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:23:58.469333
25	\N	Pha	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:24:05.788479
26	\N	Ph	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:24:06.221175
27	\N	Ph	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:24:08.03667
28	\N	p	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:24:08.990885
29	\N	Pho	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:24:09.957342
30	\N	Ph	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:24:11.544124
31	\N	bi	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:28:59.038852
32	\N	b	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:29:00.071046
33	\N	N	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:29:06.452816
34	\N	Nha	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:29:07.632904
35	\N	Nha	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:29:08.638995
36	\N	Si	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:34:21.947984
37	\N	S	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:34:22.477908
38	\N	Sai	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:34:23.996383
39	\N	Sai	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:34:25.462555
40	\N	s	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	23	2026-08-11 22:36:50.480673
41	\N	bi	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	9	2026-08-11 22:36:51.560982
42	\N	bite	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	1	2026-08-11 22:36:53.080363
43	\N	bit	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	1	2026-08-11 22:36:54.777777
44	\N	bi	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	9	2026-08-11 22:36:55.647205
45	\N	s	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	23	2026-08-11 22:36:56.811986
46	\N	sai	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	1	2026-08-11 22:36:57.827594
47	\N	sai gon	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:37:00.778387
48	\N	c	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	24	2026-08-11 22:37:07.446688
49	\N	Cu	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-08-11 22:37:08.523943
50	\N	Dinh	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-08-11 22:37:16.344995
51	\N	Sa2	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:38:42.859324
52	\N	Safi	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:38:43.707228
53	\N	Sa	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	5	2026-08-11 22:38:44.274104
54	\N	Pho	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	8	2026-08-11 22:38:48.305342
55	\N	Pha	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-08-11 22:38:54.619905
56	\N	Phao	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:38:55.209185
57	\N	Pha	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-08-11 22:38:55.709284
58	\N	Pha	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-08-11 22:38:56.658092
59	\N	Ph	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	22	2026-08-11 22:38:57.80363
60	\N	Pho	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	8	2026-08-11 22:38:58.743672
61	\N	Pho di	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:38:59.972334
62	\N	Pho di bo	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	0	2026-08-11 22:39:00.82081
63	\N	bite	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	1	2026-08-12 12:50:49.258229
64	\N	a	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	23	2026-08-12 12:50:52.311052
65	\N	land	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	1	2026-08-12 12:50:53.740423
66	\N	Chợ	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-08-20 16:02:19.318139
67	\N	Đầm	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-09-06 17:28:02.236936
68	\N	d	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	26	2026-09-08 17:32:52.851276
69	\N	dinh	{"ward": null, "tag_ids": null, "price_max": null, "price_min": null, "category_ids": null}	2	2026-10-01 11:32:50.355797
\.


--
-- Data for Name: tokenblacklist; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tokenblacklist (id, jti, user_id, expires_at, created_at) FROM stdin;
19	0aed3e08e2d446e684f2c90ea81d345b	4	2026-10-01 05:23:40	2026-10-01 11:35:23.169131
20	0acc53ee87224b2c87bb8dc4c217acbe	2	2026-10-01 05:36:04	2026-10-01 11:38:26.840145
\.


--
-- Data for Name: triprequest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.triprequest (id, user_id, raw_query, duration_day, parsed_prefs, created_at) FROM stdin;
1	4	Đi Sài gòn 2 ngày, thích chỗ check-in chụp hình, ẩm thực	2	\N	2026-08-16 19:57:05.965068
2	4	Thích check-in, ăn uống và tham quan bảo tàng lịch sử	1	\N	2026-08-20 15:51:47.548691
3	4	Đi đâu cũng được	1	\N	2026-08-20 16:01:31.379014
4	4	Tham quan bảo tàng	1	\N	2026-08-25 18:59:36.36601
5	4	Đi các chỗ cùng với gia đình	1	\N	2026-08-25 20:27:12.575846
6	4	tham quan lịch sử và ăn uống, ngồi công viên	1	\N	2026-09-06 17:38:19.450125
7	4	Tui thích tham quan bảo tàng, ăn uống và chụp ảnh check in	2	\N	2026-09-10 10:53:05.268708
8	4	Tôi thích đi tham quan bảo tàng, ăn uống và chụp ảnh check in	1	\N	2026-09-10 10:56:19.609196
9	4	Đi tham quan sài gòn	2	\N	2026-10-01 11:27:39.402783
\.


--
-- Data for Name: userinterest; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.userinterest (user_id, tag_id, priority) FROM stdin;
4	4	1
4	1	1
5	11	1
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, name, username, hash_password, avatar, email, phone, date_of_birth, gender, user_role, is_active, created_at, updated_at) FROM stdin;
2	Van Long	admin01	$2b$12$uqr6AXb5sPG/NVt82C9B4uRmB0L/gPosL5ywoxtG/OFhsSECp3w0O	\N	2351050097long@ou.edu.vn	0939017611	2000-01-01	MALE	ADMIN	t	2026-07-21 18:55:32.678657	2026-07-21 18:55:32.678657
5	Tất Văn Long	long02	$2b$12$kAoHPPatSrbiTSArmK.95uaHUyXzpi48fgq9rAfAsDDfZlY9.pLl2	https://res.cloudinary.com/dyjdromdd/image/upload/v1786521431/avatars/user_5.jpg	long25062005@gmail.com	0939017611	2005-06-25	MALE	USER	t	2026-08-12 14:48:56.568356	2026-08-12 14:48:56.568356
4	Tất Văn Long	long01	$2b$12$pgfRZdVDlXuh5RxVoMoB1OnFgI6YPXlXzzrLtqUw5JVZ.FBU325lW	https://res.cloudinary.com/dyjdromdd/image/upload/v1788863597/avatars/user_4.jpg	tatlong2506@gmail.com	0939017611	2005-06-25	MALE	USER	t	2026-07-23 16:42:09.56795	2026-07-23 16:42:09.56795
\.


--
-- Data for Name: usertravelprofile; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usertravelprofile (user_id, travel_style, budget_level, updated_at, with_children, with_elderly) FROM stdin;
4	SOLO	MEDIUM	2026-08-20 15:51:06.311635	f	f
\.


--
-- Data for Name: visitedplace; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.visitedplace (id, user_id, place_id, visited_at, source, created_at) FROM stdin;
1	5	22	\N	MANUAL	2026-08-16 15:12:47.306141
2	4	9	\N	MANUAL	2026-08-22 23:22:55.188933
3	4	2	\N	MANUAL	2026-09-08 14:42:05.578163
\.


--
-- Name: category_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.category_id_seq', 23, true);


--
-- Name: chatmessage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatmessage_id_seq', 28, true);


--
-- Name: chatsession_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.chatsession_id_seq', 9, true);


--
-- Name: interesttag_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.interesttag_id_seq', 17, true);


--
-- Name: itinerary_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.itinerary_id_seq', 8, true);


--
-- Name: itineraryitem_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.itineraryitem_id_seq', 54, true);


--
-- Name: place_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.place_id_seq', 30, true);


--
-- Name: placeagegroup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.placeagegroup_id_seq', 259, true);


--
-- Name: placeembedding_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.placeembedding_id_seq', 65, true);


--
-- Name: placeimage_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.placeimage_id_seq', 39, true);


--
-- Name: review_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.review_id_seq', 3, true);


--
-- Name: searchlog_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.searchlog_id_seq', 69, true);


--
-- Name: tokenblacklist_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tokenblacklist_id_seq', 20, true);


--
-- Name: triprequest_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.triprequest_id_seq', 9, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 5, true);


--
-- Name: visitedplace_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.visitedplace_id_seq', 3, true);


--
-- Name: alembic_version alembic_version_pkc; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alembic_version
    ADD CONSTRAINT alembic_version_pkc PRIMARY KEY (version_num);


--
-- Name: category category_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_pkey PRIMARY KEY (id);


--
-- Name: chatmessage chatmessage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessage
    ADD CONSTRAINT chatmessage_pkey PRIMARY KEY (id);


--
-- Name: chatsession chatsession_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatsession
    ADD CONSTRAINT chatsession_pkey PRIMARY KEY (id);


--
-- Name: favorite favorite_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT favorite_pkey PRIMARY KEY (user_id, place_id);


--
-- Name: interesttag interesttag_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesttag
    ADD CONSTRAINT interesttag_name_key UNIQUE (name);


--
-- Name: interesttag interesttag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.interesttag
    ADD CONSTRAINT interesttag_pkey PRIMARY KEY (id);


--
-- Name: itinerary itinerary_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itinerary
    ADD CONSTRAINT itinerary_pkey PRIMARY KEY (id);


--
-- Name: itinerary itinerary_share_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itinerary
    ADD CONSTRAINT itinerary_share_code_key UNIQUE (share_code);


--
-- Name: itineraryitem itineraryitem_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itineraryitem
    ADD CONSTRAINT itineraryitem_pkey PRIMARY KEY (id);


--
-- Name: place place_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_pkey PRIMARY KEY (id);


--
-- Name: placeagegroup placeagegroup_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeagegroup
    ADD CONSTRAINT placeagegroup_pkey PRIMARY KEY (id);


--
-- Name: placecategory placecategory_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placecategory
    ADD CONSTRAINT placecategory_pkey PRIMARY KEY (place_id, category_id);


--
-- Name: placeembedding placeembedding_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeembedding
    ADD CONSTRAINT placeembedding_pkey PRIMARY KEY (id);


--
-- Name: placeembedding placeembedding_place_id_chunk_index_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeembedding
    ADD CONSTRAINT placeembedding_place_id_chunk_index_key UNIQUE (place_id, chunk_index);


--
-- Name: placeimage placeimage_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeimage
    ADD CONSTRAINT placeimage_pkey PRIMARY KEY (id);


--
-- Name: placetag placetag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placetag
    ADD CONSTRAINT placetag_pkey PRIMARY KEY (place_id, tag_id);


--
-- Name: review review_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_pkey PRIMARY KEY (id);


--
-- Name: review review_place_id_user_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_place_id_user_id_key UNIQUE (place_id, user_id);


--
-- Name: searchlog searchlog_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.searchlog
    ADD CONSTRAINT searchlog_pkey PRIMARY KEY (id);


--
-- Name: tokenblacklist tokenblacklist_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenblacklist
    ADD CONSTRAINT tokenblacklist_pkey PRIMARY KEY (id);


--
-- Name: triprequest triprequest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.triprequest
    ADD CONSTRAINT triprequest_pkey PRIMARY KEY (id);


--
-- Name: userinterest userinterest_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userinterest
    ADD CONSTRAINT userinterest_pkey PRIMARY KEY (user_id, tag_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: usertravelprofile usertravelprofile_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usertravelprofile
    ADD CONSTRAINT usertravelprofile_pkey PRIMARY KEY (user_id);


--
-- Name: visitedplace visitedplace_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitedplace
    ADD CONSTRAINT visitedplace_pkey PRIMARY KEY (id);


--
-- Name: visitedplace visitedplace_user_id_place_id_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitedplace
    ADD CONSTRAINT visitedplace_user_id_place_id_key UNIQUE (user_id, place_id);


--
-- Name: idx_placeembedding_vector; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_placeembedding_vector ON public.placeembedding USING hnsw (embedding public.vector_cosine_ops);


--
-- Name: ix_category_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_category_name ON public.category USING btree (name);


--
-- Name: ix_category_parent_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_category_parent_id ON public.category USING btree (parent_id);


--
-- Name: ix_chatmessage_session_created; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_chatmessage_session_created ON public.chatmessage USING btree (session_id, created_at);


--
-- Name: ix_chatsession_user_updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_chatsession_user_updated ON public.chatsession USING btree (user_id, updated_at DESC);


--
-- Name: ix_favorite_place_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_favorite_place_id ON public.favorite USING btree (place_id);


--
-- Name: ix_itinerary_trip_request_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itinerary_trip_request_id ON public.itinerary USING btree (trip_request_id);


--
-- Name: ix_itinerary_user_updated; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itinerary_user_updated ON public.itinerary USING btree (user_id, updated_at DESC);


--
-- Name: ix_itineraryitem_itinerary_day_sort; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itineraryitem_itinerary_day_sort ON public.itineraryitem USING btree (itinerary_id, day_number, sort_order);


--
-- Name: ix_itineraryitem_place_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_itineraryitem_place_id ON public.itineraryitem USING btree (place_id);


--
-- Name: ix_place_address_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_address_trgm ON public.place USING gin (address public.gin_trgm_ops);


--
-- Name: ix_place_created_by; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_created_by ON public.place USING btree (created_by);


--
-- Name: ix_place_description_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_description_trgm ON public.place USING gin (description public.gin_trgm_ops);


--
-- Name: ix_place_featured_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_featured_status ON public.place USING btree (status) WHERE is_featured;


--
-- Name: ix_place_name; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_name ON public.place USING btree (name);


--
-- Name: ix_place_name_trgm; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_name_trgm ON public.place USING gin (name public.gin_trgm_ops);


--
-- Name: ix_place_status_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_status_created_at ON public.place USING btree (status, created_at DESC);


--
-- Name: ix_place_status_price_max; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_status_price_max ON public.place USING btree (status, price_max DESC);


--
-- Name: ix_place_status_price_min; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_status_price_min ON public.place USING btree (status, price_min);


--
-- Name: ix_place_status_rating; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_status_rating ON public.place USING btree (status, average_rating DESC, total_reviews DESC);


--
-- Name: ix_place_status_total_views; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_status_total_views ON public.place USING btree (status, total_views DESC);


--
-- Name: ix_place_status_ward; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_place_status_ward ON public.place USING btree (status, ward);


--
-- Name: ix_placeagegroup_place_age_suit; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_placeagegroup_place_age_suit ON public.placeagegroup USING btree (place_id, age_group, suitability);


--
-- Name: ix_placecategory_place_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_placecategory_place_id ON public.placecategory USING btree (place_id);


--
-- Name: ix_placeimage_place_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_placeimage_place_id ON public.placeimage USING btree (place_id);


--
-- Name: ix_placetag_place_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_placetag_place_id ON public.placetag USING btree (place_id);


--
-- Name: ix_review_place_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_review_place_status ON public.review USING btree (place_id, status);


--
-- Name: ix_review_status_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_review_status_created_at ON public.review USING btree (status, created_at DESC);


--
-- Name: ix_review_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_review_user_id ON public.review USING btree (user_id);


--
-- Name: ix_searchlog_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_searchlog_created_at ON public.searchlog USING btree (created_at DESC);


--
-- Name: ix_searchlog_keyword; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_searchlog_keyword ON public.searchlog USING btree (lower(TRIM(BOTH FROM query_text)));


--
-- Name: ix_searchlog_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_searchlog_user_id ON public.searchlog USING btree (user_id);


--
-- Name: ix_searchlog_zero_result; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_searchlog_zero_result ON public.searchlog USING btree (created_at DESC) WHERE (result_count = 0);


--
-- Name: ix_tokenblacklist_expires_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tokenblacklist_expires_at ON public.tokenblacklist USING btree (expires_at);


--
-- Name: ix_tokenblacklist_jti; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX ix_tokenblacklist_jti ON public.tokenblacklist USING btree (jti);


--
-- Name: ix_tokenblacklist_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_tokenblacklist_user_id ON public.tokenblacklist USING btree (user_id);


--
-- Name: ix_triprequest_user_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_triprequest_user_id ON public.triprequest USING btree (user_id);


--
-- Name: ix_userinterest_tag_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_userinterest_tag_id ON public.userinterest USING btree (tag_id);


--
-- Name: ix_visitedplace_place_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX ix_visitedplace_place_id ON public.visitedplace USING btree (place_id);


--
-- Name: category category_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.category
    ADD CONSTRAINT category_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.category(id) ON DELETE SET NULL;


--
-- Name: chatmessage chatmessage_session_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatmessage
    ADD CONSTRAINT chatmessage_session_id_fkey FOREIGN KEY (session_id) REFERENCES public.chatsession(id) ON DELETE CASCADE;


--
-- Name: chatsession chatsession_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.chatsession
    ADD CONSTRAINT chatsession_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: favorite favorite_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT favorite_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: favorite favorite_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.favorite
    ADD CONSTRAINT favorite_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: itinerary itinerary_trip_request_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itinerary
    ADD CONSTRAINT itinerary_trip_request_id_fkey FOREIGN KEY (trip_request_id) REFERENCES public.triprequest(id) ON DELETE CASCADE;


--
-- Name: itinerary itinerary_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itinerary
    ADD CONSTRAINT itinerary_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: itineraryitem itineraryitem_itinerary_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itineraryitem
    ADD CONSTRAINT itineraryitem_itinerary_id_fkey FOREIGN KEY (itinerary_id) REFERENCES public.itinerary(id) ON DELETE CASCADE;


--
-- Name: itineraryitem itineraryitem_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.itineraryitem
    ADD CONSTRAINT itineraryitem_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE SET NULL;


--
-- Name: place place_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.place
    ADD CONSTRAINT place_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: placeagegroup placeagegroup_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeagegroup
    ADD CONSTRAINT placeagegroup_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: placecategory placecategory_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placecategory
    ADD CONSTRAINT placecategory_category_id_fkey FOREIGN KEY (category_id) REFERENCES public.category(id) ON DELETE CASCADE;


--
-- Name: placecategory placecategory_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placecategory
    ADD CONSTRAINT placecategory_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: placeembedding placeembedding_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeembedding
    ADD CONSTRAINT placeembedding_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: placeimage placeimage_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placeimage
    ADD CONSTRAINT placeimage_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: placetag placetag_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placetag
    ADD CONSTRAINT placetag_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: placetag placetag_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.placetag
    ADD CONSTRAINT placetag_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.interesttag(id) ON DELETE CASCADE;


--
-- Name: review review_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: review review_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.review
    ADD CONSTRAINT review_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: searchlog searchlog_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.searchlog
    ADD CONSTRAINT searchlog_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: tokenblacklist tokenblacklist_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tokenblacklist
    ADD CONSTRAINT tokenblacklist_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: triprequest triprequest_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.triprequest
    ADD CONSTRAINT triprequest_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: userinterest userinterest_tag_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userinterest
    ADD CONSTRAINT userinterest_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES public.interesttag(id) ON DELETE CASCADE;


--
-- Name: userinterest userinterest_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.userinterest
    ADD CONSTRAINT userinterest_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: usertravelprofile usertravelprofile_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usertravelprofile
    ADD CONSTRAINT usertravelprofile_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: visitedplace visitedplace_place_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitedplace
    ADD CONSTRAINT visitedplace_place_id_fkey FOREIGN KEY (place_id) REFERENCES public.place(id) ON DELETE CASCADE;


--
-- Name: visitedplace visitedplace_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.visitedplace
    ADD CONSTRAINT visitedplace_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

\unrestrict ZspO62B16FzZLE03nEhlYrDE62fhMWjnXHdErnGUMfKeJT4eIGh2iQYGRtsTuf2

