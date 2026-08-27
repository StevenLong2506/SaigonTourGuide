'use client';

import api, { getErrorMessage } from "@/lib/api";
import { formatDateTime } from "@/lib/format";
import { PlaceSummaryResponse } from "@/types/place";
import { REVIEW_STATUS_LABELS, ReviewResponse, ReviewStatus } from "@/types/review";
import { UserResponse } from "@/types/user";
import { Button, Card, message, Popconfirm, Rate, Select, Space, Tag, Typography } from "antd";
import Table, { ColumnsType } from "antd/es/table";
import { useEffect, useState } from "react";

const STATUS_COLORS: Record<ReviewStatus, string> = {
    APPROVED: 'green',
    PENDING: 'gold',
    REJECTED: 'red'
}

export default function ReviewsPage() {
    const [reviews, setReviews] = useState<ReviewResponse[]>([]);
    const [loading, setLoading] = useState(false);
    const [placeMap, setPlaceMap] = useState<Map<number, string>>(new Map());
    const [userMap, setUserMap] = useState<Map<number, string>>(new Map());
    const [statusFilter, setStatusFilter] = useState<ReviewStatus | undefined>();

    const loadReviews = async (status?: ReviewStatus) => {
        setLoading(true);
        try {
            const { data } = await api.get<ReviewResponse[]>('/admin/reviews', {
                params: { limit: 100, review_status: status }
            });
            setReviews(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setLoading(false);
        }
    }

    useEffect(() => {
        loadReviews();

        api.get<PlaceSummaryResponse[]>('/places/admin/all', { params: { limit: 100 } })
            .then(({ data }) => {
                setPlaceMap(new Map(data.map((p) => [p.id, p.name])));
            });

        api.get<UserResponse[]>('/admin/users/', { params: { limit: 200 } })
            .then(({ data }) => {
                setUserMap(
                    new Map(data.map((u) => [u.id, `${u.name} (${u.username})`]))
                );
            })

    }, []);

    const handleFilterChange = (status: ReviewStatus | undefined) => {
        setStatusFilter(status);
        loadReviews(status);
    };

    const updateStatus = async (id: number, status: ReviewStatus) => {
        try {
            const { data } = await api.patch<ReviewResponse>(`/admin/reviews/${id}/status`, { status });
            setReviews((prev) => prev.map((r) => (r.id === id ? data : r)));
            message.success('Đã cập nhật trạng thái');
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }

    const handleDelete = async (id: number) => {
        try {
            await api.delete(`/admin/reviews/${id}`);
            message.success('Đã xóa đánh giá');
            setReviews((prev) => prev.filter((r) => r.id !== id));
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }


    const columns: ColumnsType<ReviewResponse> = [
        {
            title: 'Địa điểm',
            dataIndex: 'place_id',
            key: 'place_id',
            render: (id: number) => placeMap.get(id) ?? `#${id}`
        },
        {
            title: 'Người đánh giá',
            dataIndex: 'user_id',
            key: 'user_id',
            render: (id: number) => userMap.get(id) ?? `#${id}`
        },
        {
            title: 'Sao',
            dataIndex: 'rating',
            key: 'rating',
            render: (v: number) => <Rate disabled defaultValue={v} style={{ fontSize: 14 }} />
        },
        {
            title: 'Tiêu đề',
            dataIndex: 'title',
            key: 'title',
            render: (v: string | null) => v ?? '-'
        },
        {
            title: 'Nội dung',
            dataIndex: 'content',
            key: 'content',
            render: (v: number) => (
                <Typography.Paragraph ellipsis={{ rows: 2 }} style={{ marginBottom: 0, maxWidth: 280 }}>
                    {v ?? '-'}
                </Typography.Paragraph>
            )
        },
        {
            title: 'Trạng thái',
            dataIndex: 'status',
            key: 'status',
            render: (status: ReviewStatus) => <Tag color={STATUS_COLORS[status]}>{REVIEW_STATUS_LABELS[status]}</Tag>
        },
        {
            title: 'Ngày tạo',
            dataIndex: 'created_at',
            key: 'created_at',
            render: (v: string) => formatDateTime(v)
        },
        {
            title: 'Hành động',
            key: 'actions',
            render: (_, recored) => (
                <Space>
                    {recored.status === 'PENDING' && (
                        <>
                            <Button size="small" onClick={() => updateStatus(recored.id, 'APPROVED')}>
                                Duyệt
                            </Button>
                            <Button size="small" onClick={() => updateStatus(recored.id, 'REJECTED')}>
                                Từ chối
                            </Button>
                        </>
                    )}
                    <Popconfirm title='Xóa đánh giá này?' onConfirm={() => handleDelete(recored.id)}>
                        <Button size="small" danger>
                            Xóa
                        </Button>
                    </Popconfirm>
                </Space>
            )
        },
    ];

    return (
        <Card
            title='Đánh giá'
            extra={
                <Select
                    placeholder='Lọc theo trạng thái'
                    allowClear
                    style={{ width: 180 }}
                    value={statusFilter}
                    onChange={handleFilterChange}
                    options={(Object.keys(REVIEW_STATUS_LABELS) as ReviewStatus[]).map((s) => ({
                        label: REVIEW_STATUS_LABELS[s],
                        value: s
                    }))}
                />
            }
        >
            <Table rowKey='id' columns={columns} dataSource={reviews} loading={loading} />
        </Card>
    );
}