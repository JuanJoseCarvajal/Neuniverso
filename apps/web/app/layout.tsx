import type { Metadata } from "next";
import "./globals.css";

export const metadata: Metadata = {
  title: "Neuniverso | Inteligencia, consciencia y creacion digital",
  description:
    "Neuniverso es un ecosistema digital para conectar inteligencia, creatividad, tecnologia y expansion humana.",
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="es">
      <body>{children}</body>
    </html>
  );
}
