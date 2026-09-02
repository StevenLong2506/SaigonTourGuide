import json
from datetime import time

from google import genai
from google.genai import types
from pyvi.ViTokenizer import ViTokenizer
from sentence_transformers import SentenceTransformer
from sqlalchemy.orm import Session

from app import settings
from app.models import Place
from app.models.enums import AgeGroup
from app.repository.place_embedding_repository import PlaceEmbeddingRepository
from app.schemas.itinerary import ItineraryItemCreate, ItineraryCreate

_SYSTEM_PROMPT = (
    'Bạn là trợ lý du lịch TP.HCM thân thiện. '
    'CHỈ được dùng thông tin trong DANH SÁCH ĐỊA ĐIỂM để trả lời; '
    'TUYỆT ĐỐI không bịa ra địa điểm hay thông tin không có trong danh sách. '
    'Nếu danh sách trống hoặc không phù hợp, hãy nói thẳng là chưa tìm được nơi phù hợp. '
    'Trả lời ngắn gọn, tự nhiên bằng tiếng Việt, ưu tiên gợi ý vài nơi hợp nhất và nêu lý do. '
    'Với giá vé và giờ mở cửa, nhắc người dùng nên xác nhận lại vì thông tin có thể thay đổi.'
)

_ITINERARY_SYSTEM_PROMPT = (
    'Bạn là chuyên gia lập lịch trình du lịch TP.HCM. '
    'Dựa trên DANH SÁCH ĐỊA ĐIỂM cho sẵn, sắp xếp thành lịch trình theo ngày hợp lý: '
    'các điểm gần nhau xếp cùng ngày, xen kẽ tham quan - ăn uống - nghỉ ngơi, '
    'thứ tự trong ngày theo thời gian. '
    'CHỈ dùng place_id có trong danh sách, TUYỆT ĐỐI không bịa địa điểm mới. '
    'Trả về DUY NHẤT một JSON hợp lệ (không markdown, không giải thích) theo cấu trúc:\n'
    '{"title": "...", "description": "...", "days": ['
    '{"day_number": 1, "items": [{"place_id": 1, "start_time": "08:00", '
    '"note": "gợi ý ngắn", "transport_mode": "Xe máy"}]}]}'

)

embed_model = SentenceTransformer(
    settings.EMBEDDING_MODEL,
    device='cpu'
)

genai_client = genai.Client(api_key=settings.GEMINI_API_KEY)


def segment(text: str):
    text = (text or '').replace('\n', ' ').strip()
    return ViTokenizer.tokenize(text)


def embedding_text(text: str):
    seg = segment(text)
    if not seg:
        raise ValueError('Không thể embedding chuỗi rỗng')

    vector = embed_model.encode(seg, normalize_embeddings=True)
    return vector.tolist()


def embedding_texts(texts: list[str]):
    segs = [segment(t) for t in texts]
    segs = [s for s in segs if s]
    if not segs:
        return []
    vectors = embed_model.encode(
        segs,
        normalize_embeddings=True,
        batch_size=32
    )
    return [vector.tolist() for vector in vectors]


def chat_completion(sys_prompt: str, user_prompt: str):
    res = genai_client.models.generate_content(
        model=settings.CHAT_MODEL,
        contents=user_prompt,
        config=types.GenerateContentConfig(
            system_instruction=sys_prompt, temperature=0.3
        )
    )

    return (res.text or '').strip()


def build_place_document(place: Place):
    parts = [f'Tên địa điểm: {place.name}']
    if place.description:
        parts.append(f'Mô tả: {place.description}')

    parts.append(f'Khu vực: {place.ward}, TP.HCM')

    cate_names = [pc.category.name for pc in place.categories if pc.category]

    if cate_names:
        parts.append(f'Danh mục: {", ".join(cate_names)}')

    tag_names = [pt.tag.name for pt in place.tags if pt.tag]

    if tag_names:
        parts.append(f'Hợp với sở thích: {', '.join(tag_names)}')

    if place.age_groups:
        ages = [f'{ag.age_group.value} ({ag.suitability}/5)' for ag in place.age_groups]
        parts.append(f'Độ phù hợp nhóm tuổi: {', '.join(ages)}')

    try:
        pmax = int(place.price_max)
        if pmax > 0:
            parts.append(f'Khoảng giá: {int(place.price_min):,} - {pmax:,} VND')
    except (TypeError, ValueError):
        pass

    return '\n'.join(parts)


def index_place(db: Session, place: Place):
    doc = build_place_document(place=place)
    vector = embedding_text(text=doc)
    repo = PlaceEmbeddingRepository(db)
    repo.replace_place_chunk(
        place_id=place.id,
        chunk_text=doc, embedding=vector,
        metadata={'name': place.name, 'ward': place.ward}
    )

    repo.commit()
    return 1


def reindex_all_places(db: Session, batch_size: int = 50):
    repo = PlaceEmbeddingRepository(db)
    places = repo.get_all_places()
    count = 0
    for i in range(0, len(places), batch_size):
        batch = places[i:i + batch_size]
        docs = [build_place_document(p) for p in batch]
        vectors = embedding_texts(docs)
        for p, doc, vec in zip(batch, docs, vectors):
            repo.replace_place_chunk(
                place_id=p.id, chunk_text=doc, embedding=vec,
                metadata={'name': p.name, 'ward': p.ward}
            )
            count += 1

        repo.commit()

    return count


def _search_similar_places(db: Session,
                          query: str,
                          top_k: int | None = None,
                          ward: str | None = None,
                          max_price: int | None = None,
                          min_rating: float | None = None,
                          tag_ids: list[int] | None = None,
                          age_group: AgeGroup | None = None):
    top_k = top_k or settings.RAG_TOP_K
    query_vector = embedding_text(query)

    rows = PlaceEmbeddingRepository(db).search_similar_places(
        query_vector, top_k=top_k, ward=ward, max_price=max_price,
        min_rating=min_rating, tag_ids=tag_ids, age_group=age_group
    )

    return [
        {'place': place, 'distance': float(dist), 'similarity': 1 - float(dist)}
        for place, dist in rows
    ]


def build_context(places: list):
    blocks = []
    for i, p in enumerate(places, 1):
        lines = [f'[{i}] {p.name} - {p.ward}']
        if p.description:
            desc = p.description[:400]
            lines.append(f'Mô tả: {desc}')
        cates = [pc.category.name for pc in p.categories if pc.category]

        if cates:
            lines.append(f'Danh mục: {", ".join(cates)}')
        try:
            pmax = int(p.price_max)
            if pmax > 0:
                lines.append(f'Giá tham khảo: {int(p.price_min):,} - {pmax:,} VND')
        except (TypeError, ValueError):
            pass

        if p.average_rating:
            lines.append(f'Đánh giá: {p.average_rating}/5 ({p.total_reviews} lượt)')

        lines.append(f'Giờ mở cửa: {p.opening_time} - {p.closing_time} ({p.open_days})')
        blocks.append('\n'.join(lines))

    return '\n\n'.join(blocks)


def answer_question(db: Session, query: str,
                    top_k: int | None = None,
                    user_profile: str | None = None,
                    ward: str | None = None,
                    max_price: int | None = None,
                    min_rating: float | None = None,
                    tag_ids: list[int] | None = None,
                    age_group: 'AgeGroup |None' = None) -> dict:
    results = _search_similar_places(
        db=db, query=query, top_k=top_k, ward=ward, max_price=max_price,
        min_rating=min_rating, tag_ids=tag_ids, age_group=age_group
    )

    places = [r['place'] for r in results]

    if not places:
        return {
            'answer': 'Xin lỗi, mình chưa tìm thấy địa điểm nào phù hợp với yêu cầu của bạn.',
            'places': []
        }

    context = build_context(places=places)
    user_prompt = ''
    if user_profile:
        user_prompt += f'Hồ sơ người dùng: {user_profile}\n\n'

    user_prompt += f'Câu hỏi: {query}\n\nDANH SÁCH ĐỊA ĐIỂM:\n{context}'
    answer = chat_completion(_SYSTEM_PROMPT, user_prompt)
    return {'answer': answer, 'places': places}


def parse_json(raw: str):
    text = (raw or '').strip()
    if text.startswith('```'):
        text = text.strip('`')
        if text.lstrip().lower().startswith('json'):
            text = text.lstrip()[4:]

    try:
        return json.loads(text)
    except json.JSONDecodeError:
        start, end = text.find('{'), text.rfind('}')
        if start != -1 and end != -1:
            try:
                return json.loads(text[start:end + 1])
            except json.JSONDecodeError:
                raise ValueError('AI trả về json không hợp lệ')
        raise ValueError('AI trả về json không hợp lệ')


def parse_time(value):
    if not value:
        return None
    try:
        parts = str(value).split(':')
        return time(hour=int(parts[0]), minute=int(parts[1]) if len(parts) > 1 else 0)
    except (ValueError, IndexError):
        return None


def generate_itinerary_plan(db: Session, query: str, duration_day: int, num_people: int | None = None,
                            ward: str | None = None, max_price: int | None = None):
    duration_day = max(1, min(duration_day or 1, 7))

    top_k = duration_day * 4 + 2

    results=_search_similar_places(
        db=db, query=query, top_k=top_k, ward=ward, max_price=max_price
    )

    places = [r['place'] for r in results]

    if not places:
        raise ValueError('Không tìm thấy địa điểm phù hợp để lập lịch trình')

    valid_ids={p.id for p in places}

    context = '\n'.join(
        f'place_id={p.id} | {p.name} ({p.ward}) - {(p.description or '')}' for p in places
    )

    user_prompt=(
        f'Yêu cầu: {query}\nSố ngày: {duration_day}\n\n'
        f'DANH SÁCH ĐỊA ĐIỂM (chỉ dùng place_id này): \n{context}'
    )

    plan = parse_json(chat_completion(sys_prompt=_ITINERARY_SYSTEM_PROMPT, user_prompt=user_prompt))
    if not isinstance(plan, dict):
        raise ValueError('AI trả về định dạng không hợp lệ')


    items: list[ItineraryItemCreate]=[]

    for day in plan.get('days',[]):
        day_number=day.get('day_number',1)
        for order, it in enumerate(day.get('items',[]), start=1):
            pid = it.get('place_id')
            if pid not in valid_ids:
                continue

            items.append(ItineraryItemCreate(
                place_id=pid, day_number=day_number, start_time=parse_time(it.get('start_time')),
                note=it.get('note'), transport_mode=it.get('transport_mode'), sort_order=order
            ))

    if not items:
        raise ValueError('Không tạo được lịch trình từ kết quả AI')

    return ItineraryCreate(
        title=plan.get('title') or query[:100],
        description=plan.get('description'),
        num_people=num_people,
        items=items
    )