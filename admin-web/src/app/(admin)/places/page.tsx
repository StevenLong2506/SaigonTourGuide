'use client';

import api, { getErrorMessage } from "@/lib/api";
import { WardCountResponse, PLACE_STATUS_LABELS, PlaceStatus, PlaceSummaryResponse } from "@/types/place";
import { Button, Input, message, Popconfirm, Select, Space, Switch, Tag } from "antd";
import Table, { ColumnsType } from "antd/es/table";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { PlusOutlined } from "@ant-design/icons";
import { CategoryResponse } from "@/types/category";

const STATUS_COLORS: Record<PlaceStatus, string> = {
    ACTIVE: "green",
    PENDING: "gold",
    CLOSED: 'defailt'
};

export default function PlacesPage() {
    const router = useRouter();
    const [cates, setCates] = useState<CategoryResponse[]>([]);
    const [catetoryFilter, setCategoryFilter] = useState<number | undefined>();
    const [place, setPlace] = useState<PlaceSummaryResponse[]>([]);
    const [ward, setWard] = useState<WardCountResponse[]>([]);
    const [loading, setLoading] = useState(false);
    const [search, setSearch] = useState('');
    const [wardFilter, setWardFilter] = useState<string | undefined>();
    const [statusFilter, setStatusFilter] = useState<PlaceStatus | undefined>();
    const [togglingId, setTogglingId] = useState<number | null>(null);


    const loadPlaces = async (params?: { ward?: string, categoryId?: number }) => {
        const wardParam = params?.ward !== undefined ? params.ward : wardFilter;
        const categoryParam = params?.categoryId !== undefined ? params.categoryId : catetoryFilter;
        try {
            setLoading(true);
            const { data } = await api.get<PlaceSummaryResponse[]>('/places/admin/all', {
                params: { limit: 100, ward: ward || undefined, category_id: categoryParam || undefined }
            });

            setPlace(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setLoading(false);
        }
    }


    useEffect(() => {
        loadPlaces();
        api.get<WardCountResponse[]>('/places/wards')
            .then(({ data }) => setWard(data))
            .catch(() => { });
        api.get<CategoryResponse[]>('/categories/', { params: { limit: 100 } })
            .then(({ data }) => setCates(data))
            .catch(() => { });
    }, []);

    const toggleFeatured = async (record: PlaceSummaryResponse) => {

        try {
            setTogglingId(record.id);
            await api.patch(`/places/${record.id}/featured`, { is_featured: !record.is_featured });
            setPlace((prev) => prev.map(
                (p) => (p.id === record.id ? { ...p, is_featured: !p.is_featured } : p)
            ));
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setTogglingId(null);
        }
    }

    const handleDelete = async (id: number) => {
        try {
            await api.delete(`/places/${id}`);
            message.success('Đã xóa địa điểm');
            loadPlaces();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }

    const filtered = place
        .filter((p) => p.name.toLowerCase().includes(search.toLowerCase()))
        .filter((p) => !statusFilter || p.status === statusFilter);

    const columns: ColumnsType<PlaceSummaryResponse> = [
        {
            title: 'Tên',
            dataIndex: 'name',
            key: 'name',
            render: (name: string, record) => <Link href={`/places/${record.id}`}>{name}</Link>
        },
        {
            'title': 'Phường',
            dataIndex: 'ward',
            key: 'ward'
        },
        {
            title: 'Đánh giá',
            dataIndex: 'average_rating',
            key: 'average_rating',
            render: (v: string) => Number(v).toFixed(1)
        },
        {
            title: 'Trạng thái',
            dataIndex: 'status',
            key: 'status',
            render: (status: PlaceStatus) => <Tag color={STATUS_COLORS[status]}>{PLACE_STATUS_LABELS[status]}</Tag>
        },
        {
            title: 'Nổi bật',
            dataIndex: 'is_featured',
            key: 'is_featured',
            render: (_, record) => (
                <Switch checked={record.is_featured} loading={togglingId === record.id} size="small" onChange={() => toggleFeatured(record)} />
            )
        },
        {
            title: 'Hành động',
            key: 'action',
            render: (_, record) => (
                <Space>
                    <Button size="small" onClick={() => router.push(`/places/${record.id}`)}>
                        Sửa
                    </Button>

                    <Popconfirm title='Xóa địa điểm này?' onConfirm={() => handleDelete(record.id)}>
                        <Button size="small" danger>
                            Xóa
                        </Button>
                    </Popconfirm>
                </Space>
            )
        }
    ];

    return (
        <div>
            <Space style={{ marginBottom: 16 }} wrap>
                <Input.Search
                    placeholder="Tìm theo tên"
                    value={search}
                    onChange={(e) => setSearch(e.target.value)}
                    style={{ width: 240 }}
                    allowClear
                />

                <Select
                    placeholder='Phường'
                    allowClear
                    style={{ width: 200 }}
                    value={wardFilter}
                    onChange={(value) => {
                        setWardFilter(value);
                        loadPlaces({ward: value});
                    }}
                    options={ward.map((d) => (
                        { label: `${d.ward} (${d.total})`, value: d.ward }
                    ))}
                />

                <Select
                    placeholder='Danh mục'
                    allowClear
                    style={{ width: 200 }}
                    value={catetoryFilter}
                    onChange={(value) => {
                        setCategoryFilter(value);
                        loadPlaces({categoryId: value});
                    }}
                    options={cates.map((c) => (
                        { label: c.name, value: c.id }
                    ))}
                />


                <Select
                    placeholder='Trạng thái'
                    allowClear
                    style={{ width: 160 }}
                    value={statusFilter}
                    onChange={setStatusFilter}
                    options={(Object.keys(PLACE_STATUS_LABELS) as PlaceStatus[]).map((s) => (
                        { label: PLACE_STATUS_LABELS[s], value: s }
                    ))}
                />
                <Button type="primary" icon={<PlusOutlined />} onClick={() => router.push('/places/new')}>
                    Thêm địa điểm
                </Button>
            </Space>
            <Table rowKey='id' columns={columns} dataSource={filtered} loading={loading} />
        </div>
    )
}