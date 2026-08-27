import { InterestTagResponse } from "./tag";

export type UserRole = 'ADMIN' | 'USER';
export type Gender = 'MALE' | 'FEMALE' | 'OTHER';

export interface UserTravelProfileResponse {
    travel_style: "SOLO" | 'COUPLE' | 'FAMILY' | 'GROUP' | null;
    budget_level: 'LOW' | 'MEDIUM' | 'HIGH' | null;
    with_children: boolean | null;
    with_elderly: boolean | null;
    updated_at: string;
}

export interface UserInterestResponse { priority: number; tag: InterestTagResponse; }
export interface UserResponse {
    id: number;
    username: string;
    avatar: string | null;
    user_role: UserRole;
    name: string;
    email: string;
    phone: string;
    date_of_birth: string;
    gender: Gender;
    created_at: string;
    travel_profile: UserTravelProfileResponse | null;
    interests: UserInterestResponse[];
    is_active: boolean
}
export interface UserStatusUpdate{
    is_active: boolean;
}