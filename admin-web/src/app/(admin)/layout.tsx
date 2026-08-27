'use client';

import { useAuth } from "@/context/AuthContext";
import { Avatar, Breadcrumb, Button, Layout, Menu, Spin, Typography } from "antd";
import Link from "next/link";
import { usePathname, useRouter } from "next/navigation";
import React, { useEffect } from "react";
import { BookOutlined, DashboardOutlined, EnvironmentOutlined, StarOutlined, TagOutlined, UserOutlined } from "@ant-design/icons";

const { Sider, Header, Content } = Layout;
const { Text } = Typography;

const BREADCRUMB_LABELS: Record<string, string> = {
    places: 'Địa điểm',
    new: 'Thêm mới',
    categories: "Danh mục",
    tags: 'Tag sở thích',
    reviews: 'Đánh giá',
    users: 'Người dùng'
};

const buildBreadcrumpItems = (pathname: string) => {
    const segments = pathname.split('/').filter(Boolean);
    const items = [{ title: <Link href='/'>Trang chủ</Link> }];
    let acc = '';
    for (let seg of segments) {
        acc += `/${seg}`;
        const isId = /^\d+$/.test(seg);
        const label = isId ? 'Chi tiết' : (BREADCRUMB_LABELS[seg] ?? seg);
        items.push({ title: <Link href={acc}>{label}</Link> });
    }
    return items;
}

export default function AdminLayout({ children }: { children: React.ReactNode }) {
    const { user, loading, logout } = useAuth();
    const router = useRouter();
    const pathname = usePathname();

    useEffect(() => {
        if (!loading && !user)
            router.replace('/login');
    }, [loading, user, router]);

    if (loading || !user) {
        return (
            <div style={{ minHeight: '100vh', display: 'flex', alignItems: 'center', justifyContent: 'center' }}>
                <Spin size="large" />
            </div>
        );
    }

    const handleLogout = async () => {
        await logout();
        router.push('/login');
    }

    return (
        <Layout style={{ minHeight: '100vh' }}>
            <Sider collapsible breakpoint="lg">
                <div style={{ color: '#fff', textAlign: 'center', padding: 16, fontWeight: 600 }}>
                    Saigon Tour Guide Admin
                </div>
                <Menu theme="dark" mode="inline"
                    selectedKeys={[pathname === '/' ? '/' : `/${pathname.split('/')[1]}`]}
                    items={[
                        { key: '/', icon: <DashboardOutlined />, label: <Link href='/'>Dashboard</Link> },
                        { key: '/places', icon: <EnvironmentOutlined />, label: <Link href='/places'>Địa điểm</Link> },
                        { key: '/categories', icon: <TagOutlined />, label: <Link href='/categories'>Danh mục</Link> },
                        { key: '/tags', icon: <BookOutlined />, label: <Link href='/tags'>Tag sở thích</Link> },
                        { key: '/reviews', icon: <StarOutlined />, label: <Link href='/reviews'>Đánh giá</Link> },
                        { key: '/users', icon: <UserOutlined />, label: <Link href='/users'>Người dùng</Link> },
                    ]}
                />
            </Sider>

            <Layout>
                <Header style={{ background: '#fff', display: 'flex', alignItems: 'center', justifyContent: 'flex-end', gap: 12, padding: '0 24px' }}>
                    <Avatar src={user.avatar ?? undefined} icon={!user.avatar ? <UserOutlined /> : undefined} />
                    <Text strong>{user.name}</Text>
                    <Button onClick={handleLogout}>Đăng xuất</Button>
                </Header>

                <Content style={{ padding: 24 }}>
                    <Breadcrumb items={buildBreadcrumpItems(pathname)} style={{ marginBottom: 16 }} />
                    {children}
                </Content>
            </Layout>
        </Layout>
    );
}