import type { Metadata } from "next";
import DocPage from "@/components/DocPage";
import { Markdown, readDoc } from "@/lib/markdown";

const doc = readDoc("privacy");

export const metadata: Metadata = {
  title: "Privacy Policy · Kichta",
  description: "What Kichta keeps on your device, what it never collects, and how to delete your data.",
  alternates: { canonical: "/privacy/" },
};

export default function PrivacyPage() {
  return (
    <DocPage
      eyebrow="Privacy"
      title={doc.title}
      intro={doc.updated ? <>Last updated {doc.updated}. The same text is in the app, under Settings.</> : undefined}
    >
      <Markdown source={doc.body} />
    </DocPage>
  );
}
