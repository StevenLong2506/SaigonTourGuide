'use client';

import { TopPlaceOrderBy, TopPlaceResponse } from "@/types/stat";
import { Bar, BarChart, CartesianGrid, ResponsiveContainer, Tooltip, XAxis, YAxis } from "recharts";

const METRIC_FIELD: Record<TopPlaceOrderBy, keyof TopPlaceResponse> = {
    VIEWS: 'total_views',
    RATING: 'average_rating',
    REVIEWS: 'total_reviews',
    FAVORITES: 'favorite_count'
}

const METRIC_LABEL: Record<TopPlaceOrderBy, string> = {
    VIEWS: 'Lượt xem',
    RATING: 'Rating trung bình',
    REVIEWS: 'Số đánh giá',
    FAVORITES: 'Lượt yêu thích'
}

interface Props {
    data: TopPlaceResponse[];
    metric: TopPlaceOrderBy;
}

export default function TopPlacesBarChart({ data, metric }: Props) {
    const field = METRIC_FIELD[metric];
    const chartData = data.map((p) => ({ name: p.name, value: Number(p[field]) }));

    return (
        <ResponsiveContainer width='100%' height={300}>
            <BarChart data={chartData} margin={{ top: 8, right: 16, bottom: 60, left: 8 }}>
                <CartesianGrid strokeDasharray='3 3' />
                <XAxis dataKey='name' angle={-30} textAnchor="end" interval={0} height={70} tick={{ fontSize: 12 }} />
                <YAxis />
                <Tooltip />
                <Bar dataKey='value' name={METRIC_LABEL[metric]} fill="#1677ff" radius={[4, 4, 0, 0]} />
            </BarChart>
        </ResponsiveContainer>
    )
}