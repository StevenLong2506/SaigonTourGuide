'use client';

import api, { getErrorMessage } from '@/lib/api';
import { formatDate } from '@/lib/format';
import { CategoryCreate, CategoryResponse, CategoryUpdate } from '@/types/category';
import { PlusOutlined } from '@ant-design/icons';
import { Button, Card, Form, Input, message, Modal, Popconfirm, Select, Space, Tag } from 'antd';
import Table, { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';


interface CategoryFormValues {
    name: string;
    description?: string;
    parent_id?: number;
}

export default function CategoriesPage() {
    const [cates, setCates] = useState<CategoryResponse[]>([]);
    const [loading, setLoading] = useState(false);
    const [modalOpen, setModalOpen] = useState(false);
    const [editing, setEditing] = useState<CategoryResponse | null>(null);
    const [submitting, setSubmitting] = useState(false);
    const [form] = Form.useForm<CategoryFormValues>();

    const loadCates = async () => {
        setLoading(true);
        try {
            const { data } = await api.get<CategoryResponse[]>('/categories/', { params: { limit: 100 } });
            setCates(data);
        } catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setLoading(false);
        }
    }

    useEffect(() => {
        loadCates();
    }, []);

    const openCreateModal = () => {
        setEditing(null);
        setModalOpen(true);
    };

    const openEditModal = (record: CategoryResponse) => {
        setEditing(record);
        setModalOpen(true);
    }

    const handleDelete = async (id: number) => {
        try {
            await api.delete(`/categories/${id}`);
            message.success('Đã xóa danh mục');
            loadCates();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }

    const onFinish = async (values: CategoryFormValues) => {
        setSubmitting(true);
        try {
            if (editing) {
                const payload: CategoryUpdate = {
                    name: values.name,
                    description: values.description ?? null,
                    parent_id: values.parent_id ?? null,
                };
                await api.put(`/categories/${editing.id}`, payload);
                message.success('Đã cập nhật danh mục');
            }
            else {
                const payload: CategoryCreate = {
                    name: values.name,
                    description: values.description ?? null,
                    parent_id: values.parent_id ?? null,
                };
                await api.post('/categories/', payload);
                message.success('Đã tạo danh mục');
            }
            setModalOpen(false);
            loadCates();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setSubmitting(false);
        }
    }

    const columns: ColumnsType<CategoryResponse> = [
        { title: 'Tên', dataIndex: 'name', key: 'name' },
        { title: 'Mô tả', dataIndex: 'description', key: 'description', render: (v: string | null) => v ?? '-' },
        {
            title: 'Danh mục cha',
            dataIndex: 'parent',
            key: 'parent',
            render: (parent: CategoryResponse['parent']) => parent?.name ?? '—',
        },
        { title: 'Ngày tạo', dataIndex: 'created_at', key: 'created_at', render: (v: string) => formatDate(v) },
        {
            title: 'Đang dùng',
            dataIndex: 'place_count',
            key: 'place_count',
            render: (v: number) => <Tag color={v > 0 ? 'orange' : 'default'}>{v} địa điểm</Tag>
        },
        {
            title: 'Hành động',
            key: 'actions',
            render: (_, record) => (
                <Space>
                    <Button size='small' onClick={() => openEditModal(record)}>
                        Sửa
                    </Button>
                    <Popconfirm title={record.place_count > 0 ?
                        `Danh mục đang được ${record.place_count} địa điểm sử dụng, hệ thống sẽ từ chối xóa. Vẫn thử xóa?` :
                        'Xóa danh mục này?'
                    } onConfirm={() => handleDelete(record.id)}>
                        <Button size='small' danger>
                            Xóa
                        </Button>
                    </Popconfirm>
                </Space>
            )
        },
    ];

    return (
        <Card
            title='Danh mục'
            extra={
                <Button type='primary' icon={<PlusOutlined />} onClick={openCreateModal}>
                    Thêm danh mục
                </Button>
            }
        >
            <Table rowKey='id' columns={columns} dataSource={cates} loading={loading} />

            <Modal
                title={editing ? 'Sửa danh mục' : 'Thêm danh mục'}
                open={modalOpen}
                onCancel={() => setModalOpen(false)}
                onOk={() => form.submit()}
                confirmLoading={submitting}
                destroyOnHidden
                afterOpenChange={(open) => {
                    if (open) {
                        if (editing) {
                            form.setFieldsValue({
                                name: editing.name,
                                description: editing.description ?? undefined,
                                parent_id: editing.parent?.id ?? undefined,
                            });
                        } else {
                            form.resetFields();
                        }
                    }
                }}
            >
                <Form form={form} layout='vertical' onFinish={onFinish}>
                    <Form.Item name='name' label='Tên danh mục' rules={[{ required: true, message: 'Nhập tên danh mục' }]}>
                        <Input />
                    </Form.Item>

                    <Form.Item name='description' label='Mô tả'>
                        <Input.TextArea rows={3} />
                    </Form.Item>

                    <Form.Item name='parent_id' label='Danh mục cha (tuỳ chọn)'>
                        <Select
                            allowClear
                            placeholder='Không có (danh mục gốc)'
                            options={cates
                                .filter((c) => c.id !== editing?.id)
                                .map((c) => ({ label: c.name, value: c.id }))}
                        />
                    </Form.Item>
                </Form>
            </Modal>
        </Card>
    );
}