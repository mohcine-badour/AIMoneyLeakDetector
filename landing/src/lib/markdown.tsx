import { readFileSync } from "node:fs";
import { join } from "node:path";
import type { ReactNode } from "react";

/**
 * The legal texts in src/content/*.md, read at build time. They are copies of docs/PRIVACY.md and
 * docs/TERMS.md (the in-app texts); keep them in sync when those change.
 */
export function readDoc(name: "privacy" | "terms") {
  const raw = readFileSync(join(process.cwd(), "src", "content", `${name}.md`), "utf8");
  const lines = raw.split("\n");
  const title = (lines.find((l) => l.startsWith("# ")) ?? "").slice(2).trim();
  const updatedLine = lines.find((l) => l.startsWith("Last updated:"));
  const body = lines
    .filter((l) => !l.startsWith("# ") && l !== updatedLine)
    .join("\n")
    .trim();
  return { title, updated: updatedLine?.replace("Last updated:", "").trim(), body };
}

/** Inline text: [label](url) links and `code`. */
function inline(text: string, key: string): ReactNode[] {
  const out: ReactNode[] = [];
  const re = /\[([^\]]+)\]\(([^)]+)\)|`([^`]+)`/g;
  let last = 0;
  let m: RegExpExecArray | null;
  let i = 0;
  while ((m = re.exec(text))) {
    if (m.index > last) out.push(text.slice(last, m.index));
    if (m[1]) {
      out.push(
        <a key={`${key}-${i++}`} href={m[2]} rel={m[2].startsWith("http") ? "noopener" : undefined}>
          {m[1]}
        </a>,
      );
    } else {
      out.push(<code key={`${key}-${i++}`}>{m[3]}</code>);
    }
    last = m.index + m[0].length;
  }
  if (last < text.length) out.push(text.slice(last));
  return out;
}

/** Minimal Markdown for these documents: ## headings, paragraphs, "- " lists, links. */
export function Markdown({ source }: { source: string }) {
  const blocks = source.split(/\n{2,}/).map((b) => b.trim()).filter(Boolean);
  return (
    <>
      {blocks.map((block, i) => {
        const key = `b${i}`;
        if (block.startsWith("## ")) {
          const text = block.slice(3).trim();
          const id = text.toLowerCase().replace(/[^a-z0-9]+/g, "-").replace(/(^-|-$)/g, "");
          return (
            <h2 key={key} id={id}>
              {text}
            </h2>
          );
        }
        if (block.split("\n").every((l) => l.startsWith("- "))) {
          return (
            <ul key={key}>
              {block.split("\n").map((l, j) => (
                <li key={`${key}-${j}`}>{inline(l.slice(2), `${key}-${j}`)}</li>
              ))}
            </ul>
          );
        }
        return <p key={key}>{inline(block.replace(/\n/g, " "), key)}</p>;
      })}
    </>
  );
}
