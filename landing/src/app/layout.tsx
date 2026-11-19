import type { Metadata, Viewport } from "next";
import { Geist, Geist_Mono, Instrument_Serif } from "next/font/google";
import SmoothScroll from "@/components/SmoothScroll";
import { APP_NAME, SITE_DESCRIPTION, SITE_URL } from "@/lib/site";
import "./globals.css";

// next/font downloads these at build time and serves them from this site.
const geist = Geist({ subsets: ["latin"], variable: "--font-geist", display: "swap" });
const geistMono = Geist_Mono({ subsets: ["latin"], variable: "--font-geist-mono", display: "swap" });
const instrumentSerif = Instrument_Serif({
  subsets: ["latin"],
  weight: "400",
  style: ["normal", "italic"],
  variable: "--font-instrument-serif",
  display: "swap",
});

const TITLE = `${APP_NAME}: subscription tracker and renewal reminders`;

export const metadata: Metadata = {
  ...(SITE_URL ? { metadataBase: new URL(SITE_URL) } : {}),
  title: TITLE,
  description: SITE_DESCRIPTION,
  applicationName: APP_NAME,
  appleWebApp: { title: APP_NAME },
  itunes: { appId: "6804477920" },
  openGraph: {
    title: TITLE,
    description: SITE_DESCRIPTION,
    type: "website",
    siteName: APP_NAME,
  },
  twitter: { card: "summary", title: TITLE, description: SITE_DESCRIPTION },
};

export const viewport: Viewport = {
  themeColor: "#050812",
  colorScheme: "light",
};

export default function RootLayout({ children }: LayoutProps<"/">) {
  return (
    <html lang="en" className={`${geist.variable} ${geistMono.variable} ${instrumentSerif.variable}`}>
      <body>
        {/* The hero headline is revealed by script; without it, show it right away. */}
        <noscript>
          <style>{".split-parent{visibility:visible!important}"}</style>
        </noscript>
        <a href="#main" className="skip-link">
          Skip to content
        </a>
        <SmoothScroll />
        {children}
      </body>
    </html>
  );
}
