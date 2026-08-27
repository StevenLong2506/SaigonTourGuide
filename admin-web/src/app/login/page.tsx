'use client';

import { useAuth } from "@/context/AuthContext";
import { getErrorMessage } from "@/lib/api";
import { Button, Card, Form, Input, message } from "antd";
import { useRouter } from "next/navigation";
import { useState } from "react";

interface LoginFormValues {
    identifier: string;
    password: string;
}

export default function LoginPage() {
    const { login } = useAuth();
    const router = useRouter();
    const [submitting, setSubmitting] = useState(false);

    async function onFinish(values: LoginFormValues) {
        setSubmitting(true);
        try {
            await login(values.identifier, values.password);
            router.push('/');
        }
        catch (e) {
            message.error(e instanceof Error ? e.message : getErrorMessage(e));
        }finally{
            setSubmitting(false);
        }
    }

    return(
        <div style={{minHeight:'100vh', display:'flex', alignItems:'center', justifyContent:'center', background:'#f5f5f5'}}>
            <Card title='Đăng nhập' style={{width:380}}>
                <Form layout="vertical" onFinish={onFinish}>
                    <Form.Item name="identifier" label='Tài khoản' rules={[{required:true, message:'Vui lòng nhập username hoặc email'}]}>
                        <Input placeholder="Username hoặc email" autoFocus />
                    </Form.Item>

                    <Form.Item name="password" label='Mật khẩu' rules={[{required:true, message:'Vui lòng nhập mật khẩu'}]}>
                        <Input placeholder="Mật khẩu" type='password' autoComplete="off"/>
                    </Form.Item>

                    <Form.Item>
                        <Button type="primary" htmlType="submit" loading={submitting} block>
                            Đăng nhập
                        </Button>
                    </Form.Item>
                </Form>
            </Card>

        </div>
    )
}