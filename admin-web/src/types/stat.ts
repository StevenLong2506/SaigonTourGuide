export interface OverviewResponse {
    total_places: number; active_places: number; pending_places: number;
    featured_places: number; total_reviews: number; pending_reviews: number;
    total_users: number; total_views: number; average_rating: number;
}
export interface TopPlaceResponse {
    id: number; name: string; ward: string; total_views: number;
    total_reviews: number; average_rating: number; favorite_count: number;
}
export interface KeywordStatResponse { keyword: string; count: number; }
export type TopPlaceOrderBy = 'VIEWS' | 'RATING' | 'REVIEWS' | 'FAVORITES';