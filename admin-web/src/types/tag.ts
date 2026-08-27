
export type TagResponse = InterestTagResponse;
export interface TagCreate{name:string;}
export interface TagUpdate{name?:string;}
export interface InterestTagResponse { 
    id: number; 
    name: string; 
    created_at: string; 
    place_count: number;
    user_count:number;
}
