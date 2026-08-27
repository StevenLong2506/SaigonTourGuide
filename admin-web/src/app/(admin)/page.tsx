"use client";

import api, { getErrorMessage } from "@/lib/api";
import { KeywordStatResponse, OverviewResponse, TopPlaceOrderBy, TopPlaceResponse } from "@/types/stat";
import { Card, Col, InputNumber, message, Row, Select, Spin, Statistic, Typography } from "antd";
import Table, { ColumnsType } from "antd/es/table";
import dynamic from "next/dynamic";
import { useEffect, useState } from "react";

const ChartFallBack = () => (
    <div style={{ textAlign: 'center', padding: 24 }}>
        <Spin />
    </div>
);

const TopPlacesBarChart = dynamic(() => import('@/component/chart/TopPlacesBarChart'), {
    ssr: false,
    loading: ChartFallBack
});

const PlaceStatusPieChart = dynamic(() => import('@/component/chart/PlaceStatusPieChart'), {
    ssr: false,
    loading: ChartFallBack
});


const ORDER_BY_LABELS: Record<TopPlaceOrderBy, string> = {
    VIEWS: 'Lượt xem',
    RATING: 'Đánh giá',
    REVIEWS: 'Số đánh giá',
    FAVORITES: 'Yêu thích'
};


export default function DashboardPage() {
    const [overview, setOverview] = useState<OverviewResponse | null>(null);
    const [topPlaces, setTopPlaces] = useState<TopPlaceResponse[]>([]);
    const [orderBy, setOrderBy] = useState<TopPlaceOrderBy>('VIEWS');
    const [topLoading, setTopLoading] = useState(false);
    const [popularKeywords, setPopularKeywords] = useState<KeywordStatResponse[]>([]);
    const [zeroResultKeywords, setZeroResultKeywords] = useState<KeywordStatResponse[]>([]);
    const [days, setDays] = useState<number | undefined>();


    const getOverview = async () => {
        try {
            const { data } = await api.get<OverviewResponse>('/admin/stats/overview');
            setOverview(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }

    useEffect(() => {
        getOverview();
    }, []);



    const loadTopPlaces = async (order: TopPlaceOrderBy) => {
        setTopLoading(true);
        try {
            const { data } = await api.get<TopPlaceResponse[]>('/admin/stats/top-places', {
                params: { order_by: order, limit: 10 }
            });

            setTopPlaces(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setTopLoading(false);
        }
    }

    useEffect(() => {
        loadTopPlaces(orderBy);
    }, [orderBy]);

    const loadKeywords = async (d?: number) => {
        try {
            const [popularRes, zeroRes] = await Promise.all([
                api.get<KeywordStatResponse[]>('/admin/stats/popular-keywords', { params: { limit: 20, days: d } }),
                api.get<KeywordStatResponse[]>('/admin/stats/zero-result-keywords', { params: { limit: 20, days: d } })
            ])

            setPopularKeywords(popularRes.data);
            setZeroResultKeywords(zeroRes.data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }

    useEffect(() => {
        loadKeywords();
    }, []);


    const handleDaysChange = (val: number | null) => {
        const d = val ?? undefined;
        setDays(d);
        loadKeywords(d);
    }

    const topPlaceColumns: ColumnsType<TopPlaceResponse> = [
        {
            title: 'Tên',
            dataIndex: 'name',
            key: 'name',
        },
        {
            title: 'Phường',
            dataIndex: 'ward',
            key: 'ward',
        },
        {
            title: 'Lượt xem',
            dataIndex: 'total_views',
            key: 'total_views',
        },
        {
            title: 'Số đánh giá',
            dataIndex: 'total_reviews',
            key: 'total_reviews',
        },
        {
            title: 'Rating trung bình',
            dataIndex: 'average_rating',
            key: 'average_rating',
            render: (v: number) => v.toFixed(1)
        },
        {
            title: 'Yêu thích',
            dataIndex: 'favorite_count',
            key: 'favorite_count'
        },
    ];

    const keywordColumns: ColumnsType<KeywordStatResponse> = [
        {
            title: 'Từ khóa',
            dataIndex: 'keyword',
            key: 'keyword'
        },
        {
            title: 'Số lượt',
            dataIndex: 'count',
            key: 'count',
            width: 100
        },
    ]


    return (
        <div>
            <Row gutter={[16, 16]}>
                <Col span={6}>
                    <Card>
                        <Statistic title='Tổng địa điểm' value={overview?.total_places ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Đang hoạt động' value={overview?.active_places ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Chờ duyệt' value={overview?.pending_places ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Nổi bật' value={overview?.featured_places ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Tổng đánh giá' value={overview?.total_reviews ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Đánh giá chờ duyệt' value={overview?.pending_reviews ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Tổng người dùng' value={overview?.total_users ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Tổng lượt xem' value={overview?.total_views ?? 0} />
                    </Card>
                </Col>

                <Col span={6}>
                    <Card>
                        <Statistic title='Đánh giá trung bình' value={overview?.average_rating ?? 0} precision={1} />
                    </Card>
                </Col>
            </Row>

            {overview && (
                <Card title='Phân bố trạng thái địa điểm' style={{ marginTop: 16 }}>
                    <PlaceStatusPieChart overview={overview} />
                </Card>
            )}

            <Card
                title='Top địa điểm'
                style={{ marginTop: 18 }}
                extra={
                    <Select<TopPlaceOrderBy>
                        value={orderBy}
                        style={{ width: 160 }}
                        onChange={setOrderBy}
                        options={(Object.keys(ORDER_BY_LABELS) as TopPlaceOrderBy[]).map((k) => ({
                            label: ORDER_BY_LABELS[k],
                            value: k
                        }))}
                    />
                }
            >

                <TopPlacesBarChart data={topPlaces} metric={orderBy} />
                <Table rowKey='id' columns={topPlaceColumns} dataSource={topPlaces} loading={topLoading} pagination={false} />

            </Card>


            <Row gutter={16} style={{ marginTop: 16 }}>
                <Col span={12}>
                    <Card
                        title='Từ khóa phổ biến'
                        extra={
                            <InputNumber
                                placeholder="Số ngày gần đây"
                                min={1}
                                value={days}
                                onChange={handleDaysChange}
                                style={{ width: 140 }}
                            />
                        }
                    >
                        <Table rowKey='keyword' columns={keywordColumns} dataSource={popularKeywords} pagination={false} size="small" />
                    </Card>
                </Col>

                <Col span={12}>
                    <Card title='Từ khóa 0 kết quả'>
                        <Table rowKey='keyword' columns={keywordColumns} dataSource={zeroResultKeywords} pagination={false} size="small" />
                    </Card>
                </Col>
            </Row>
        </div>
    );
}