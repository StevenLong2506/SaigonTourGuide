'use client';

import api, { getErrorMessage } from "@/lib/api";
import { formatVND } from "@/lib/format";
import { CategoryResponse } from "@/types/category";
import { AGE_GROUP_LABELS, AgeGroup, PLACE_STATUS_LABELS, PlaceCreate, PlaceResponse, PlaceStatus } from "@/types/place";
import { TagResponse } from "@/types/tag";
import { MinusCircleOutlined, PlusOutlined } from "@ant-design/icons";
import { Button, Card, Col, Form, Input, InputNumber, message, Row, Select, Slider, Switch, TimePicker } from "antd";
import type { Dayjs } from "dayjs";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";

const { TextArea } = Input;
const AGE_GROUP_KEYS = Object.keys(AGE_GROUP_LABELS) as AgeGroup[];
const SUITABILITY_LABELS: Record<number, string> = {
    1: "Không phù hợp",
    2: "Ít phù hợp",
    3: "Bình thường",
    4: "Phù hợp",
    5: "Rất phù hợp",
};

interface PlaceFormValues {
    name: string;
    description: string;
    address: string;
    ward: string;
    link_google_map: string;
    phone: string;
    website?: string;
    open_days: string;
    price_min: number;
    price_max: number;
    opening_time: Dayjs;
    closing_time: Dayjs;
    is_featured: boolean;
    status: PlaceStatus;
    category_ids: number[];
    tags: { tag_id: number; relevance: number }[];
    ageGroups: { age_group: AgeGroup; suitability: number }[];
}

export default function NewPlacePage() {
    const router = useRouter();
    const [form] = Form.useForm<PlaceFormValues>();
    const [cates, setCates] = useState<CategoryResponse[]>([]);
    const [tags, setTags] = useState<TagResponse[]>([]);
    const [submitting, setSubmitting] = useState(false);

    useEffect(() => {
        Promise.all([
            api.get<CategoryResponse[]>('/categories/', { params: { limit: 100 } }),
            api.get<TagResponse[]>('/tags/', { params: { limit: 100 } }),
        ]).then(([catRes, tagRes]) => {
            setCates(catRes.data);
            setTags(tagRes.data);
        })
    }, []);

    const onFinish = async (values: PlaceFormValues) => {
        setSubmitting(true);
        const payload: PlaceCreate = {
            name: values.name,
            description: values.description,
            address: values.address,
            ward: values.ward,
            link_google_map: values.link_google_map,
            phone: values.phone ?? '',
            website: values.website,
            open_days: values.open_days,
            price_min: String(values.price_min ?? 0),
            price_max: String(values.price_max ?? 0),
            opening_time: values.opening_time.format('HH:mm:ss'),
            closing_time: values.closing_time.format('HH:mm:ss'),
            is_featured: values.is_featured ?? false,
            status: values.status,
            category_ids: values.category_ids ?? [],
            tags: (values.tags ?? []).map((t) => ({ tag_id: t.tag_id, relevance: String(t.relevance ?? 1) })),
            age_groups: values.ageGroups.map((a) => ({ age_group: a.age_group, suitability: a.suitability }))
        };

        try {
            const { data } = await api.post<PlaceResponse>('/places/', payload);
            message.success("Tạo địa điểm thành công");
            router.push(`/places/${data.id}`);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setSubmitting(false);
        }
    }

    return (
        <Card title='Thêm địa điểm'>
            <Form<PlaceFormValues>
                form={form}
                layout="vertical"
                onFinish={onFinish}
                initialValues={{
                    status: 'ACTIVE',
                    is_featured: false,
                    price_min: 0,
                    price_max: 0,
                    ageGroups: AGE_GROUP_KEYS.map((k) => ({ age_group: k, suitability: 3 }))
                }}
            >
                <Row gutter={16}>
                    <Col span={12}>
                        <Form.Item name='name' label='Tên địa điểm' rules={[{ required: true }]}>
                            <Input />
                        </Form.Item>
                    </Col>
                    <Col span={12}>
                        <Form.Item name='address' label='Địa chỉ' rules={[{ required: true }]}>
                            <Input />
                        </Form.Item>
                    </Col>
                </Row>
                <Form.Item name='description' label='Mô tả' rules={[{ required: true }]}>
                    <TextArea rows={4} />
                </Form.Item>

                <Row gutter={16}>
                    <Col span={12}>
                        <Form.Item name='ward' label='Phường' rules={[{ required: true }]}>
                            <Input />
                        </Form.Item>
                    </Col>
                    <Col span={12}>
                        <Form.Item name='phone' label='Số điện thoại'>
                            <Input />
                        </Form.Item>
                    </Col>
                </Row>

                <Row gutter={16}>
                    <Col span={12}>
                        <Form.Item name='link_google_map' label='Link google map' rules={[{ required: true }]}>
                            <Input />
                        </Form.Item>
                    </Col>

                    <Col span={12}>
                        <Form.Item name='website' label='Website'>
                            <Input />
                        </Form.Item>
                    </Col>
                </Row>

                <Row gutter={16}>
                    <Col span={6}>
                        <Form.Item name='price_min' label='Giá thấp nhất (VND)'>
                            <InputNumber<number>
                                min={0} step={1000} style={{ width: '100%' }}
                                formatter={(val) => formatVND(val ?? 0)}
                                parser={(value) => Number((value ?? '').replace(/[^\d-]/g, ''))}
                            />
                        </Form.Item>
                    </Col>

                    <Col span={6}>
                        <Form.Item name='price_max' label='Giá cao nhất (VND)'>
                            <InputNumber<number>
                                min={0} step={1000}
                                style={{ width: '100%' }}
                                formatter={(val) => formatVND(val ?? 0)}
                                parser={(value) => Number((value ?? '').replace(/[^\d-]/g, ''))}
                            />
                        </Form.Item>
                    </Col>

                    <Col span={6}>
                        <Form.Item name='opening_time' label='Giờ mở cửa' rules={[{ required: true }]}>
                            <TimePicker format='HH:mm' style={{ width: '100%' }} />
                        </Form.Item>
                    </Col>

                    <Col span={6}>
                        <Form.Item name='closing_time' label='Giờ đóng cửa' rules={[{ required: true }]}>
                            <TimePicker format='HH:mm' style={{ width: '100%' }} />
                        </Form.Item>
                    </Col>
                </Row>


                <Row gutter={16}>
                    <Col span={8}>
                        <Form.Item name='open_days' label='Ngày mở cửa' rules={[{ required: true }]}>
                            <Input placeholder="VD: Hằng ngày" />
                        </Form.Item>
                    </Col>

                    <Col span={8}>
                        <Form.Item name='status' label='Trạng thái' rules={[{ required: true }]}>
                            <Select
                                options={(Object.keys(PLACE_STATUS_LABELS) as PlaceStatus[]).map((s) => ({
                                    label: PLACE_STATUS_LABELS[s],
                                    value: s
                                }))}
                            />
                        </Form.Item>
                    </Col>

                    <Col span={8}>
                        <Form.Item name='is_featured' label='Nổi bật' valuePropName="checked">
                            <Switch />
                        </Form.Item>
                    </Col>
                </Row>


                <Form.Item name='category_ids' label='Danh mục' rules={[{ required: true, message: "Chọn ít nhất 1 danh mục" }]}>
                    <Select mode="multiple" allowClear options={cates.map((c) => ({
                        label: c.name,
                        value: c.id
                    }))} />
                </Form.Item>

                <Form.Item label='Tag sở thích'>
                    <Form.List name='tags'>
                        {(fields, { add, remove }) => (
                            <>
                                {fields.map((field) => (
                                    <Row gutter={8} key={field.key} style={{ marginBottom: 8 }}>
                                        <Col span={12}>
                                            <Form.Item name={[field.name, 'tag_id']} rules={[{ required: true, message: 'Chọn tag' }]} noStyle>
                                                <Select
                                                    placeholder='Chọn tag'
                                                    options={tags.map((t) => ({
                                                        label: t.name,
                                                        value: t.id
                                                    }))}
                                                    style={{ width: '100%' }}
                                                />
                                            </Form.Item>
                                        </Col>

                                        <Col span={8}>
                                            <Form.Item name={[field.name, 'relevance']} initialValue={1} noStyle>
                                                <InputNumber min={0} max={1} step={0.1} style={{ width: '100%' }} placeholder="Độ liên quan (0-1)" />
                                            </Form.Item>
                                        </Col>

                                        <Col span={4}>
                                            <MinusCircleOutlined onClick={() => remove(field.name)} />
                                        </Col>
                                    </Row>
                                ))}

                                <Button type="dashed" onClick={() => add({ relevance: 1 })} icon={<PlusOutlined />}>
                                    Thêm tag
                                </Button>
                            </>
                        )}
                    </Form.List>
                </Form.Item>

                <Form.Item label='Độ phù hợp nhóm tuổi'>
                    <Form.List name='ageGroups'>
                        {(fields) => (
                            <>
                                {fields.map((field, idx) => (
                                    <Row gutter={8} key={field.key} align='middle' style={{ marginBottom: 8 }}>
                                        <Col span={4}>{AGE_GROUP_LABELS[AGE_GROUP_KEYS[idx]]}</Col>
                                        <Col span={16}>
                                            <Form.Item name={[field.name, 'suitability']} noStyle>
                                                <Slider
                                                    min={1}
                                                    max={5}
                                                    marks={{ 1: '1', 2: '2', 3: '3', 4: '4', 5: '5' }}
                                                    tooltip={{ formatter: (v) => SUITABILITY_LABELS[v ?? 3] }}
                                                />
                                            </Form.Item>
                                        </Col>

                                        <Form.Item name={[field.name, 'age_group']} hidden>
                                            <Input />
                                        </Form.Item>
                                    </Row>
                                ))}
                            </>
                        )}
                    </Form.List>
                </Form.Item>

                <Form.Item>
                    <Button type="primary" htmlType="submit" loading={submitting}>
                        Tạo địa điểm
                    </Button>
                </Form.Item>
            </Form>
        </Card>
    );
}