'use client';

import { useAuth } from '@/context/AuthContext';
import api, { getErrorMessage } from '@/lib/api';
import { formatDate } from '@/lib/format';
import { UserResponse } from '@/types/user';
import { UserOutlined } from '@ant-design/icons';
import { Alert, Avatar, Card, Drawer, Input, message, Popconfirm, Space, Switch, Tag, Typography } from 'antd';
import Table, { ColumnsType } from 'antd/es/table';
import { useEffect, useState } from 'react';

export default function UsersPage() {
    const { user: currentAdmin } = useAuth();
    const [users, setUsers] = useState<UserResponse[]>([]);
    const [loading, setLoading] = useState(false);
    const [search, setSearch] = useState('');
    const [selected, setSelected] = useState<UserResponse | null>(null);
    const [drawerOpen, setDrawerOpen] = useState(false);
    const [togglingId, setTogglingId] = useState<number | null>(null);


    const loadUsers = async () => {
        try {
            setLoading(true);
            const { data } = await api.get<UserResponse[]>('/admin/users/', { params: { limit: 200 } });
            setUsers(data);
        }
        catch (e) {
            message.error(getErrorMessage(e));
        } finally {
            setLoading(false);
        }
    }
    const toggleActive = async (record: UserResponse) => {
        try {
            setTogglingId(record.id);
            const { data } = await api.patch<UserResponse>(`/admin/users/${record.id}/status`, {
                is_active: !record.is_active
            });
            setUsers(
                (prev) => prev.map((u) => (u.id === record.id ? data : u))
            );
            message.success(data.is_active ? 'Đã mở khóa tài khoản' : 'Đã khóa tài khoản');
        }
        catch (e) {
            message.error(getErrorMessage(e));
        }
        finally {
            setTogglingId(null);
        }
    }

    useEffect(() => {
        loadUsers();
    }, [])


    const filtered = users.filter((u) => {
        const q = search.toLowerCase();
        return u.name.toLowerCase().includes(q) || u.email.toLowerCase().includes(q) || u.username.toLowerCase().includes(q);
    })

    const columns: ColumnsType<UserResponse> = [
        {
            title: 'Avatar',
            dataIndex: 'avatar',
            key: 'avatar',
            render: (v: string | null) => <Avatar src={v ?? undefined} icon={!v ? <UserOutlined /> : undefined} />
        },
        {
            title: 'Tên',
            dataIndex: 'name',
            key: 'name',
        },
        {
            title: 'Username',
            dataIndex: 'username',
            key: 'username',
        },
        {
            title: 'Email',
            dataIndex: 'email',
            key: 'email',
        },
        {
            title: 'SDT',
            dataIndex: 'phone',
            key: 'phone',
        },
        {
            title: 'Vai trò',
            dataIndex: 'user_role',
            key: 'user_role',
            render: (role: string) => <Tag color={role === "ADMIN" ? 'purple' : 'default'}>{role}</Tag>
        },
        {
            title: 'Trạng thái',
            dataIndex: 'is_active',
            key: 'is_active',
            render: (isActive: boolean, record) => {
                const isSelf = record.id === currentAdmin?.id;
                const switchEl = (
                    <Switch
                        checked={isActive}
                        loading={togglingId === record.id}
                        disabled={isSelf}
                        checkedChildren='Hoạt động'
                        unCheckedChildren='Đã khóa'
                    />
                    
                );
                return (
                    <span onClick={(e) => e.stopPropagation()}>
                        {isSelf ? (
                            switchEl
                        ) : (
                            <Popconfirm
                                title={isActive ? 'Khóa tài khoản này?' : 'Mở khóa tài khoản này?'}
                                onConfirm={() => toggleActive(record)}
                            >
                                {switchEl}
                            </Popconfirm>
                        )}
                    </span>
                );
            }
        }, ,
        {
            title: 'Ngày tạo',
            dataIndex: 'created_at',
            key: 'created_at',
            render: (v: string) => formatDate(v)
        },
    ];

    return (
        <Card title='Người dùng'>
            <Input.Search
                placeholder='Tìm theo tên, email, username'
                value={search}
                onChange={(e) => setSearch(e.target.value)}
                style={{ width: 320, marginBottom: 16 }}
                allowClear
            />

            <Table
                rowKey='id'
                columns={columns}
                dataSource={filtered}
                loading={loading}
                onRow={(record) => ({
                    onClick: () => {
                        setSelected(record);
                        setDrawerOpen(true);
                    },
                    style: { cursor: 'pointer' }
                })}
            />

            <Drawer title='Chi tiết người dùng' open={drawerOpen} onClose={() => setDrawerOpen(false)} size={420}>
                {selected && (
                    <>
                        <Typography.Paragraph>
                            <strong>Tên:</strong> {selected.name}
                            <br />
                            <strong>Username:</strong> {selected.username}
                            <br />
                            <strong>Email:</strong> {selected.email}
                            <br />
                            <strong>SDT:</strong> {selected.phone}
                            <br />
                            <strong>Giới tính:</strong> {selected.gender}
                            <br />
                            <strong>Ngày sinh:</strong> {formatDate(selected.date_of_birth)}
                            <br />
                            <strong>Trạng thái:</strong> {selected.is_active ? 'Hoạt động' : 'Đã khóa'}
                            <br />
                            <strong>Ngày tạo:</strong> {formatDate(selected.created_at)}
                        </Typography.Paragraph>

                        {selected.travel_profile && (
                            <>
                                <Typography.Title level={5}>Hồ sơ du lịch</Typography.Title>
                                <Typography.Paragraph>
                                    Phong cách: {selected.travel_profile.travel_style ?? '-'}
                                    <br />
                                    Ngân sách: {selected.travel_profile.budget_level ?? '-'}
                                    <br />
                                    Đi cùng trẻ em: {selected.travel_profile.with_children ? 'Có' : 'Không'}
                                    <br />
                                    Đi cùng người lớn tuổi: {selected.travel_profile.with_elderly ? 'Có' : 'Không'}
                                </Typography.Paragraph>
                            </>
                        )}

                        {selected.interests.length > 0 && (
                            <>
                                <Typography.Title level={5}>Sở thích</Typography.Title>
                                <Space wrap>
                                    {selected.interests.map((i) => (
                                        <Tag key={i.tag.id}>
                                            {i.tag.name} (ưu tiên {i.priority})
                                        </Tag>
                                    ))}
                                </Space>
                            </>
                        )}
                    </>
                )}
            </Drawer>
        </Card>
    );
}