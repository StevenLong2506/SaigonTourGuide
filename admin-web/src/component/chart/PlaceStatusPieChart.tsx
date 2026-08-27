'use client';

import { OverviewResponse } from "@/types/stat";
import { Cell, Pie, PieChart, ResponsiveContainer } from "recharts";


const COLORS = ['#52c41a', '#faad14', '#8c8c8c'];

interface Props {
    overview: OverviewResponse;
}

export default function PlaceStatusPieChart({ overview }: Props) {
    const closed = Math.max(overview.total_places - overview.active_places - overview.pending_places, 0);
    const data = [
        {name:'Hoạt động', value: overview.active_places},
        {name:'Chờ duyệt', value: overview.pending_places},
        {name:'Đã đóng', value: closed},
    ];

    return (
        <ResponsiveContainer width="100%" height={260}>
            <PieChart>
                <Pie data={data} dataKey='value' nameKey='name' cx='50%' cy='50%' outerRadius={90} label >
                    {data.map((entry, idx)=>(
                        <Cell key={entry.name} fill={COLORS[idx % COLORS.length]} />
                    ))}
                </Pie>
            </PieChart>
        </ResponsiveContainer>
    );
}