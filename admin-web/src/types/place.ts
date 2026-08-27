import { CategoryResponse } from "./category";
import { InterestTagResponse } from "./tag";

export type PlaceStatus = 'ACTIVE' | 'CLOSED' | 'PENDING';
export type AgeGroup = 'CHILDREN' | 'TEENAGER' | 'YOUNG_ADULT' | 'ADULT' | 'MIDDLE_AGE' | 'SENIOR';
export interface PlaceImageCreate {
    img_url: string;
    caption?: string | null;
    is_primary?: boolean;
}
export interface PlaceImageResponse extends PlaceImageCreate {
    id: number;
}
export interface PlaceTagCreate {
    tag_id: number;
    relevance?: string;
}
export interface PlaceTagResponse {
    relevance: string;
    tag: InterestTagResponse;
}
export interface PlaceAgeGroupCreate {
    age_group: AgeGroup;
    suitability?: number;
}
export interface PlaceAgeGroupResponse {
    age_group: AgeGroup;
    suitability: number;
}
export interface PlaceBase {
    name: string; description: string; address: string; ward: string;
    link_google_map: string; phone: string | null; website?: string | null;
    price_min: string; price_max: string;
    opening_time: string; closing_time: string; open_days: string;
}
export interface PlaceCreate extends PlaceBase {
    is_featured?: boolean; status?: PlaceStatus;
    category_ids: number[]; tags?: PlaceTagCreate[]; age_groups?: PlaceAgeGroupCreate[];
    images?: PlaceImageCreate[];
}

export interface PlaceUpdate {
    name?: string; description?: string; address?: string; ward?: string;
    link_google_map?: string; phone?: string | null; website?: string | null;
    price_min?: string; price_max?: string;
    opening_time?: string; closing_time?: string; open_days?: string;
    category_ids?: number[]; tags?: PlaceTagCreate[]; age_groups?: PlaceAgeGroupCreate[];
}

export interface PlaceResponse extends PlaceBase {
    id: number; average_rating: string; total_reviews: number; total_views: number;
    is_featured: boolean; status: PlaceStatus; created_by: number | null;
    created_at: string; updated_at: string;
    categories: CategoryResponse[]; tags: PlaceTagResponse[];
    age_groups: PlaceAgeGroupResponse[]; images: PlaceImageResponse[];
}

export interface PlaceSummaryResponse {
    id: number; name: string; ward: string; average_rating: string;
    total_reviews: number; total_views: number; is_featured: boolean;
    status: PlaceStatus; primary_image: string | null;
}

export interface PlaceStatusUpdate { status: PlaceStatus }
export interface PlaceFeaturedUpdate { is_featured: boolean; }
export interface WardCountResponse { ward: string; total: number; }
export const AGE_GROUP_LABELS: Record<AgeGroup, string> = {
    CHILDREN:'Trẻ em', TEENAGER:'Thiếu niên', YOUNG_ADULT:'Thanh niên',
    ADULT:'Người lớn', MIDDLE_AGE:'Trung niên', SENIOR:'Cao tuổi'
}
export const PLACE_STATUS_LABELS: Record<PlaceStatus, string> ={
    ACTIVE:'Hoạt động', PENDING:'Chờ duyệt', CLOSED:'Đã đóng'
};

