import type { Metadata } from "next";
import "./globals.css";
import { AntdRegistry } from "@ant-design/nextjs-registry";
import { ConfigProvider } from "antd";
import viVN from 'antd/locale/vi_VN';
import { AuthProvider } from "@/context/AuthContext";

export const metadata: Metadata = {
  title: "Sai Gon Tour Guide - Admin",
  description: "Trang quản trị",
};

export default function RootLayout({ children }: { children: React.ReactNode }) {
  return (
    <html lang="vi">
      <body>
        <AntdRegistry>
          <ConfigProvider locale={viVN}>
            <AuthProvider>{children}</AuthProvider>
          </ConfigProvider>
        </AntdRegistry>
      </body>
    </html>
  );
}