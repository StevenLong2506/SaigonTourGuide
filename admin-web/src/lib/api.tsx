import axios from "axios";
import { clearToken, getToken } from "./auth";
import { ApiErrorResponse } from "@/types/common";

const api = axios.create(
    { baseURL: process.env.NEXT_PUBLIC_API_URL }
);


api.interceptors.request.use((config) => {
    const token = getToken();
    if (token) {
        config.headers.Authorization = `Bearer ${token}`;
    }
    return config
})

api.interceptors.response.use(
    (res) => res,
    (err) => {
        if (axios.isAxiosError(err) && err.response?.status === 401) {
            clearToken();
            if (typeof window !== 'undefined' && window.location.pathname !== '/login') {
                window.location.href = '/login';
            }
        }
        return Promise.reject(err);
    }
);

export function getErrorMessage(err: unknown): string {
    if (axios.isAxiosError<ApiErrorResponse>(err)) {
        const detail = err.response?.data?.detail;
        if (typeof detail === 'string') return detail;
        if (Array.isArray(detail))
            return detail.map((d) => d.msg).join(', ');
    }
    return "Đã có lỗi xảy ra";
}

export default api;