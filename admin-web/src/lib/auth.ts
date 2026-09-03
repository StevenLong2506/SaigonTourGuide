import { Cookies } from 'react-cookie';

const TOKEN = 'stg_admin_token';
const cookies = new Cookies();

export function getToken(): string | null {
    return cookies.get(TOKEN) ?? null;
}
export function setToken(token: string) {
    cookies.set(TOKEN, token, { path: '/', maxAge: 60 * 60, sameSite: 'lax' });
}
export function clearToken() {
    cookies.remove(TOKEN, { path: '/' });
}
