'use client';

import api, { getErrorMessage } from "@/lib/api";
import { CategoryResponse } from "@/types/category";
import { AGE_GROUP_LABELS, AgeGroup, PLACE_STATUS_LABELS, PlaceResponse, PlaceStatus, PlaceUpdate } from "@/types/place";
import { TagResponse } from "@/types/tag";
import { Button, Card, Col, Form, Image, Input, InputNumber, message, Popconfirm, Result, Row, Select, Slider, Spin, Switch, Tag, TimePicker, Upload } from "antd";
import { UploadProps } from "antd/lib/upload";
import dayjs, { Dayjs } from "dayjs";
import { useParams, useRouter } from "next/navigation";
import { useCallback, useEffect, useState } from "react";
import { MinusCircleOutlined, PlusOutlined, UploadOutlined } from "@ant-design/icons";

const { TextArea } = Input;
const AGE_GROUP_KEYS = Object.keys(AGE_GROUP_LABELS) as AgeGroup[];
const SUITABILITY_LABELS: Record<number, string> = {
    1: "Không phù hợp",
    2: "Ít phù hợp",
    3: "Bình thường",
    4: "Phù hợp",
    5: "Rất phù hợp",
};

interface PlaceEditFormValues {
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
    category_ids: number[];
    tags: { tag_id: number; relevance: number }[];
    ageGroups: { age_group: AgeGroup; suitability: number }[];
}

const mapPlaceToForm = (p: PlaceResponse) => {
    return {
        name: p.name,
        description: p.description,
        address: p.address,
        ward: p.ward,
        link_google_map: p.link_google_map,
        phone: p.phone ?? "",
        website: p.website ?? undefined,
        open_days: p.open_days,
        price_min: Number(p.price_min),
        price_max: Number(p.price_max),
        opening_time: dayjs(p.opening_time, "HH:mm:ss"),
        closing_time: dayjs(p.closing_time, "HH:mm:ss"),
        category_ids: p.categories.map((c) => c.id),
        tags: p.tags.map((t) => ({ tag_id: t.tag.id, relevance: Number(t.relevance) })),
        ageGroups: AGE_GROUP_KEYS.map((k) => {
            const found = p.age_groups.find((g) => g.age_group === k);
            return { age_group: k, suitability: found?.suitability ?? 3 };
        }),
    }
}

const sameCategoryIds = (a: number[], b: number[]) => {
    const as = [...a].sort((x, y) => x - y);
    const bs = [...b].sort((x, y) => x - y);
    return JSON.stringify(as) === JSON.stringify(bs);
}

const sameTags = (a: PlaceEditFormValues['tags'], b: PlaceEditFormValues['tags']) => {
    const norm = (t: PlaceEditFormValues['tags']) =>
        [...t].map((x) => ({ tag_id: x.tag_id, relevance: Number(x.relevance ?? 1) }))
            .sort((x, y) => x.tag_id - y.tag_id);
    return JSON.stringify(norm(a)) === JSON.stringify(norm(b));
}

const sameAgeGroups = (a: PlaceEditFormValues['ageGroups'], b: PlaceEditFormValues['ageGroups']) => {
    return a.length === b.length && a.every((x, i) => x.suitability === b[i].suitability);
}

const buildUpdatePayload = (
    original: PlaceEditFormValues,
    values: PlaceEditFormValues
): Partial<PlaceUpdate> => {
    const payload: Partial<PlaceUpdate> = {};

    if (values.name !== original.name)
        payload.name = values.name;
    if (values.description !== original.description)
        payload.description = values.description;
    if (values.address !== original.address)
        payload.address = values.address;
    if (values.ward !== original.ward)
        payload.ward = values.ward;
    if (values.link_google_map !== original.link_google_map)
        payload.link_google_map = values.link_google_map;
    if (values.open_days !== original.open_days)
        payload.open_days = values.open_days;
    if ((values.price_min ?? 0) !== (original.price_min ?? 0))
        payload.price_min = String(values.price_min ?? 0);
    if ((values.price_max ?? 0) !== (original.price_max ?? 0))
        payload.price_max = String(values.price_max ?? 0);

    const phone = values.phone ? values.phone : null;
    const originalPhone = original.phone ? original.phone : null;
    if (phone !== originalPhone)
        payload.phone = phone;

    const website = values.website ? values.website : null;
    const originalWeb = original.website ? original.website : null;
    if (website !== originalWeb)
        payload.website = website;

    const openingTime = values.opening_time.format("HH:mm:ss");
    const originalOpeningTime = original.opening_time.format("HH:mm:ss");
    if (openingTime !== originalOpeningTime)
        payload.opening_time = openingTime;

    const closingTime = values.closing_time.format("HH:mm:ss");
    const originalClosingTime = original.closing_time.format("HH:mm:ss");
    if (closingTime !== originalClosingTime)
        payload.closing_time = closingTime;

    const cate_ids = values.category_ids ?? [];
    const originalCate_ids = original.category_ids ?? [];
    if (!sameCategoryIds(cate_ids, originalCate_ids))
        payload.category_ids = values.category_ids ?? [];

    const tags = values.tags ?? [];
    const originalTags = original.tags ?? [];
    if (!sameTags(tags, originalTags)) {
        payload.tags = (values.tags ?? []).map((t) => ({ tag_id: t.tag_id, relevance: String(t.relevance ?? 1) }));
    }

    if (!sameAgeGroups(values.ageGroups, original.ageGroups)) {
        payload.age_groups = values.ageGroups.map((a) => ({ age_group: a.age_group, suitability: a.suitability }));
    }

    return payload;
}

export default function EditPlacePage() {
    const params = useParams<{ id: string }>();
    const placeId = Number(params.id);
    const router = useRouter();
    const [form] = Form.useForm<PlaceEditFormValues>();
    const [place, setPlace] = useState<PlaceResponse | null>(null);
    const [cates, setCates] = useState<CategoryResponse[]>([]);
    const [tags, setTags] = useState<TagResponse[]>([]);
    const [loading, setLoading] = useState(false);
    const [notFound, setNotFound] = useState(false);
    const [submitting, setSubmitting] = useState(false);
    const [statusUpdating, setStatusUpdating] = useState(false);
    const [featuredUpdating, setFeaturedUpdating] = useState(false);
    const [originalValues, setOriginalValues] = useState<PlaceEditFormValues | null>(null);


    const loadPlace = useCallback(async () => {
        try {
            setLoading(true);
            const { data } = await api.get<PlaceResponse>(`/places/admin/${placeId}`);
            setPlace(data);
        }
        catch {
            setNotFound(true);
        }
        finally {
            setLoading(false);
        }
    }, [placeId]);

    useEffect(() => {
        loadPlace();
        Promise.all([
            api.get<CategoryResponse[]>('/categories/', { params: { limit: 100 } }),
            api.get<TagResponse[]>('/tags/', { params: { limit: 100 } })
        ]).then(([catRes, tagRes]) => {
            setCates(catRes.data);
            setTags(tagRes.data);
        });
    }, [loadPlace]);

    useEffect(() => {
        if (place) {
            const mapped = mapPlaceToForm(place);
            form.setFieldsValue(mapped);
            setOriginalValues(mapped);
        }
    }, [place, form]);

    const handleStatusChange = async (status: PlaceStatus) => {
        setStatusUpdating(true);
        try {
            const { data } = await api.patch<PlaceResponse>(`/places/${placeId}/status`, { status });
            setPlace(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setStatusUpdating(false);
        }
    }

    const handleFeaturedChange = async (is_featured: boolean) => {
        try {
            setFeaturedUpdating(true);
            const { data } = await api.patch<PlaceResponse>(`/places/${placeId}/featured`, { is_featured });
            setPlace(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setFeaturedUpdating(false);
        }
    }

    const onFinish = async (values: PlaceEditFormValues) => {
        if(!originalValues) return;
        const payload = buildUpdatePayload(originalValues, values);
        if(Object.keys(payload).length===0){
            message.info('Không có thay đổi nào để lưu');
            return;
        }
        setSubmitting(true);


        try {
            await api.patch(`/places/${placeId}`, payload);
            message.success('Đã lưu thay đổi');
            loadPlace();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setSubmitting(false);
        }
    }

    const setPrimary = async (imgId: number) => {
        try {
            await api.patch(`/places/${placeId}/images/${imgId}/primary`);
            loadPlace();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }

    const deleteImage = async (imgId: number) => {
        try {
            await api.delete(`/places/${placeId}/images/${imgId}`);
            loadPlace();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }

    const uploadProps: UploadProps = {
        multiple: true,
        accept: 'image/jpeg,image/png,image/jpg',
        showUploadList: false,
        customRequest: async (options) => {
            const { file, onSuccess, onError } = options;
            const formData = new FormData();
            formData.append('files', file as File);
            try {


                await api.post(`/places/${placeId}/images`, formData, {
                    headers: { 'Content-Type': 'multipart/form-data' }
                });

                onSuccess?.({});
                loadPlace();
            }
            catch (e) {
                onError?.(e as Error);
                message.error(getErrorMessage(e));
            }
        }
    };

    if (!place) {
        if (notFound) {
            return (
                <Result
                    status='404'
                    title='Không tìm thấy địa điểm'
                    extra={
                        <Button type="primary" onClick={() => router.push('/places')}>
                            Về danh sách
                        </Button>
                    }
                />
            );
        }
        return (
            <div style={{ textAlign: 'center', padding: 48 }}>
                <Spin size="large" />
            </div>
        );
    }

    return (
        <Spin spinning={loading} description="Đang tải lại...">
            <Card style={{ marginBottom: 16 }}>
                <Row gutter={16} align='middle'>
                    <Col>
                        <span style={{ marginRight: 8 }}>Trạng thái:</span>
                        <Select
                            value={place.status}
                            loading={statusUpdating}
                            style={{ width: 160 }}
                            onChange={handleStatusChange}
                            options={(Object.keys(PLACE_STATUS_LABELS) as PlaceStatus[]).map((s) => ({
                                label: PLACE_STATUS_LABELS[s],
                                value: s
                            }))}
                        />
                    </Col>
                    <Col>
                        <span style={{ marginRight: 8 }}>Nổi bật</span>
                        <Switch checked={place.is_featured} loading={featuredUpdating} onChange={handleFeaturedChange} />
                    </Col>
                </Row>
            </Card>


            <Card title='Thông tin địa điểm' style={{ marginBottom: 16 }}>
                <Form<PlaceEditFormValues> form={form} layout="vertical" onFinish={onFinish}>
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
                            <Form.Item name="price_min" label="Giá thấp nhất (VND)">
                                <InputNumber min={0} step={1000} style={{ width: "100%" }} />
                            </Form.Item>
                        </Col>
                        <Col span={6}>
                            <Form.Item name="price_max" label="Giá cao nhất (VND)">
                                <InputNumber min={0} step={1000} style={{ width: "100%" }} />
                            </Form.Item>
                        </Col>
                        <Col span={6}>
                            <Form.Item name="opening_time" label="Giờ mở cửa" rules={[{ required: true }]}>
                                <TimePicker format="HH:mm" style={{ width: "100%" }} />
                            </Form.Item>
                        </Col>
                        <Col span={6}>
                            <Form.Item name="closing_time" label="Giờ đóng cửa" rules={[{ required: true }]}>
                                <TimePicker format="HH:mm" style={{ width: "100%" }} />
                            </Form.Item>
                        </Col>
                    </Row>


                    <Form.Item name="open_days" label="Ngày mở cửa" rules={[{ required: true }]}>
                        <Input placeholder="VD: Hằng ngày" />
                    </Form.Item>

                    <Form.Item name="category_ids" label="Danh mục" rules={[{ required: true, message: "Chọn ít nhất 1 danh mục" }]}>
                        <Select mode="multiple" allowClear options={cates.map((c) => ({ label: c.name, value: c.id }))} />
                    </Form.Item>

                    <Form.Item label='Tag sở thích'>
                        <Form.List name='tags'>
                            {(fields, { add, remove }) => (
                                <>
                                    {fields.map((field) => (
                                        <Row gutter={8} key={field.key} style={{ marginBottom: 8 }}>
                                            <Col span={12}>
                                                <Form.Item name={[field.name, "tag_id"]} rules={[{ required: true, message: "Chọn tag" }]} noStyle>
                                                    <Select
                                                        placeholder="Chọn tag"
                                                        options={tags.map((t) => ({ label: t.name, value: t.id }))}
                                                        style={{ width: "100%" }}
                                                    />
                                                </Form.Item>
                                            </Col>

                                            <Col span={8}>
                                                <Form.Item name={[field.name, "relevance"]} initialValue={1} noStyle>
                                                    <InputNumber min={0} max={1} step={0.1} style={{ width: "100%" }} placeholder="Độ liên quan (0-1)" />
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
                                    {fields.map((field, index) => (
                                        <Row gutter={8} key={field.key} align="middle" style={{ marginBottom: 8 }}>
                                            <Col span={4}>{AGE_GROUP_LABELS[AGE_GROUP_KEYS[index]]}</Col>
                                            <Col span={16}>
                                                <Form.Item name={[field.name, "suitability"]} noStyle>
                                                    <Slider
                                                        min={1}
                                                        max={5}
                                                        marks={{ 1: "1", 2: "2", 3: "3", 4: "4", 5: "5" }}
                                                        tooltip={{ formatter: (v) => SUITABILITY_LABELS[v ?? 3] }}
                                                    />
                                                </Form.Item>
                                            </Col>
                                            <Form.Item name={[field.name, "age_group"]} hidden>
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
                            Lưu thay đổi
                        </Button>
                    </Form.Item>
                </Form>
            </Card>

            <Card title='Ảnh địa điểm'>
                <Upload {...uploadProps}>
                    <Button icon={<UploadOutlined />}>Tải ảnh lên</Button>
                </Upload>

                <Row gutter={16} style={{ marginTop: 16 }}>
                    {place.images.map((img) => (
                        <Col key={img.id}>
                            <div style={{ textAlign: 'center' }}>
                                <Image src={img.img_url} width={120} height={90} style={{ objectFit: 'cover' }} />
                                <div style={{ marginTop: 4 }}>
                                    {img.is_primary ? (
                                        <Tag color='blue'>Đại diện</Tag>
                                    ) : (
                                        <Button size="small" type="link" onClick={() => setPrimary(img.id)}>
                                            Đặt ảnh đại diện
                                        </Button>
                                    )}
                                    <Popconfirm title='Xóa ảnh này?' onConfirm={() => deleteImage(img.id)}>
                                        <Button size="small" type="link" danger>
                                            Xóa
                                        </Button>
                                    </Popconfirm>
                                </div>
                            </div>
                        </Col>
                    ))}
                </Row>
            </Card>
        </Spin>
    )
}