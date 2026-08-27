export type ReviewStatus = 'APPROVED' | 'PENDING' | 'REJECTED';
export interface ReviewResponse {
    id: number; place_id: number; user_id: number;
    rating: number; title: string | null; content: string | null;
    visit_date: string | null; status: ReviewStatus;
    created_at: string; updated_at: string;
}
export interface ReviewStatusUpdate {
    status: ReviewStatus;
}

export const REVIEW_STATUS_LABELS: Record<ReviewStatus, string> = {
    APPROVED: 'Đã duyệt', PENDING: 'Chờ duyệt', REJECTED: 'Từ chối'
};