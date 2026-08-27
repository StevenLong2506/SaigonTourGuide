'use client';

import api from "@/lib/api";
import { clearToken, getToken, setToken } from "@/lib/auth";
import { LoginResponse } from "@/types/auth";
import { UserResponse } from "@/types/user";
import { createContext, ReactNode, useContext, useEffect, useState } from "react";

interface AuthContextValue {
    user: UserResponse | null;
    loading: boolean;
    login: (identifier: string, password: string) => Promise<void>;
    logout: () => Promise<void>;
}

const AuthContext = createContext<AuthContextValue | null>(null);

export function AuthProvider({ children }: { children: ReactNode }) {
    const [user, setUser] = useState<UserResponse | null>(null);
    const [loading, setLoading] = useState(true);

    async function restore() {
        if (getToken()) {
            try {
                const { data } = await api.get<UserResponse>('/auth/me');
                setUser(data);
            }
            catch {
                clearToken();
            }
        }
        setLoading(false);
    }


    useEffect(() => {
        restore();
    }, []);

    const login = async (identifier: string, password: string) => {
        const { data: loginData } = await api.post<LoginResponse>('/auth/login', { identifier, password });
        setToken(loginData.access_token);
        const { data: me } = await api.get<UserResponse>('/auth/me');
        if (me.user_role !== 'ADMIN') {
            clearToken();
            throw new Error('Tài khoản không có quyền admin');
        }
        setUser(me);
    }

    const logout = async () => {
        try{
            await api.post('/auth/logout');
        }
        catch{

        }
        clearToken();
        setUser(null)
    }

    return (
        <AuthContext.Provider value={{user, loading, login, logout}}>
            {children}
        </AuthContext.Provider>
    );
}

export function useAuth(): AuthContextValue{
    const ctx=useContext(AuthContext);
    if(!ctx)
        throw new Error('useAuth phải sử dụng với AuthProvider');
    return ctx;
}
