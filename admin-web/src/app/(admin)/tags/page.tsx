'use client';

import api, { getErrorMessage } from '@/lib/api';
import { formatDate } from '@/lib/format';
import { TagCreate, TagResponse, TagUpdate } from '@/types/tag';
import { PlusOutlined } from '@ant-design/icons';
import { Button, Card, Form, Input, message, Modal, Popconfirm, Space, Tag } from 'antd';
import Table, { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';

interface TagFormValue {
    name: string;
}

export default function TagsPage() {
    const [tags, setTags] = useState<TagResponse[]>([]);
    const [loading, setLoading] = useState(false);
    const [modalOpen, setModalOpen] = useState(false);
    const [editing, setEditing] = useState<TagResponse | null>(null);
    const [submitting, setSubmitting] = useState(false);
    const [form] = Form.useForm<TagFormValue>();


    const loadTags = async () => {
        setLoading(true);
        try {
            const { data } = await api.get<TagResponse[]>('/tags/', { params: { limit: 100 } });
            setTags(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setLoading(false);
        }
    }


    useEffect(() => {
        loadTags();
    }, [])

    const openCreateModal = () => {
        setEditing(null);
        setModalOpen(true);
    }

    const openEditModal = (record: TagResponse) => {
        setEditing(record);
        setModalOpen(true);
    }

    const handleDelete = async (id: number) => {
        try {
            await api.delete(`/tags/${id}`);
            message.success('Đã xóa tag');
            loadTags();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
    }


    const onFinish = async (values: TagFormValue) => {
        setSubmitting(true);
        try {
            if (editing) {
                const payload: TagUpdate = { name: values.name };
                await api.put(`/tags/${editing.id}`, payload);
                message.success('Đã cập nhật tag');
            }
            else {
                const payload: TagCreate = { name: values.name };
                await api.post('/tags/', payload);
                message.success('Đã tạo tag');
            }
            setModalOpen(false);
            loadTags();
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setSubmitting(false);
        }
    }

    const columns: ColumnsType<TagResponse> = [
        { title: 'Tên', dataIndex: 'name', key: 'name' },
        { title: 'Ngày tạo', dataIndex: 'created_at', key: 'created_at', render: (v: string) => formatDate(v) },
        { 
            title: 'Đang dùng', 
            key: 'usage', 
            render: (_, record) => (
                <Tag color={(record.place_count > 0 || record.user_count > 0) ? "orange" : 'default'}>
                    {record.place_count} địa điểm, {record.user_count} người dùng
                </Tag>
            )
        },
        {
            title: 'Hành động',
            key: 'actions',
            render: (_, record) => (
                <Space>
                    <Button size='small' onClick={() => openEditModal(record)}>
                        Sửa
                    </Button>
                    <Popconfirm title={(record.place_count > 0 || record.user_count > 0) ? 
                        `Tag đang được dùng bởi ${record.place_count} địa điểm và ${record.user_count} người dùng, hệ thống sẽ từ chối xóa. Vẫn thử xóa?` : 'Xóa tag này?'} onConfirm={() => handleDelete(record.id)}>
                        <Button size='small' danger>
                            Xóa
                        </Button>
                    </Popconfirm>
                </Space>
            )
        }
    ];


    return (
        <Card
            title='Tag sở thích'
            extra={
                <Button type='primary' icon={<PlusOutlined />} onClick={openCreateModal}>
                    Thêm tag
                </Button>
            }
        >
            <Table rowKey='id' columns={columns} dataSource={tags} loading={loading} />

            <Modal
                title={editing ? 'Sửa tag' : 'Thêm tag'}
                open={modalOpen}
                onCancel={() => setModalOpen(false)}
                onOk={() => form.submit()}
                confirmLoading={submitting}
                destroyOnHidden
                afterOpenChange={(open) => {
                    if (open) {
                        if (editing) {
                            form.setFieldsValue({ name: editing.name });
                        } else {
                            form.resetFields();
                        }
                    }
                }}
            >

                <Form form={form} layout='vertical' onFinish={onFinish}>
                    <Form.Item name='name' label='Tên tag' rules={[{ required: true, message: 'Nhập tên tag' }]}>
                        <Input />
                    </Form.Item>
                </Form>

            </Modal>
        </Card>
    );
}