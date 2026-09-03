import dayjs from 'dayjs'

export function formatVND(v: string | number) {
    const n = typeof v === 'string' ? Number(v) : v;
    return new Intl.NumberFormat('vi-VN', {
        style:'currency', currency:"VND"
    }).format(n||0);
}
export function formatDate(v: string){
    return dayjs(v).format("DD/MM/YYYY");
}
export function formatDateTime(v: string){
    return dayjs(v).format('DD/MM/YYYY HH:mm');
}