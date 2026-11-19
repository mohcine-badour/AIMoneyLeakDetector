import type { Metadata } from "next";
import DocPage from "@/components/DocPage";
import { Markdown, readDoc } from "@/lib/markdown";

const doc = readDoc("terms");

export const metadata: Metadata = {
  title: "Terms of Use · Kichta",
  description: "The terms for using Kichta, the private subscription tracker for iPhone and iPad.",
  alternates: { canonical: "/terms/" },
};

export default function TermsPage() {
  return (
    <DocPage
      eyebrow="Terms"
      title={doc.title}
      intro={doc.updated ? <>Last updated {doc.updated}. The same text is in the app, under Settings.</> : undefined}
    >
      <Markdown source={doc.body} />
    </DocPage>
  );
}
