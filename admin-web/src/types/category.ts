export interface CategoryParentInfo { id: number; name: string; }
export interface CategoryResponse { 
    id: number; 
    name: string; 
    description: string | null; 
    parent: CategoryParentInfo | null; 
    created_at: string; 
    place_count: number;
}
export interface CategoryCreate {
    name: string;
    description?: string | null;
    parent_id?: number | null;
}
export interface CategoryUpdate {
    name?: string;
    description?: string | null;
    parent_id?: number | null;
}