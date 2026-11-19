import type { ReactNode } from "react";
import SiteFooter from "@/components/SiteFooter";
import SiteHeader from "@/components/SiteHeader";

type DocPageProps = {
  eyebrow: string;
  title: string;
  intro?: ReactNode;
  children: ReactNode;
};

/** Long-form pages (privacy, terms, support): a night band with the title, then the text on paper. */
export default function DocPage({ eyebrow, title, intro, children }: DocPageProps) {
  return (
    <>
      <SiteHeader onDoc />
      <main id="main">
        <section className="relative isolate overflow-hidden rounded-b-[36px] bg-night pt-36 pb-16 text-white sm:rounded-b-[56px] sm:pt-40 sm:pb-20">
          <div
            aria-hidden="true"
            className="absolute -top-40 left-1/2 -z-10 h-[460px] w-[820px] -translate-x-1/2 rounded-full bg-glow/25 blur-[120px]"
          />
          <div className="container-page">
            <p className="eyebrow text-glow-soft">{eyebrow}</p>
            <h1 className="mt-4 max-w-[820px] text-[clamp(2.4rem,5.5vw,4.2rem)] font-semibold leading-[1.02] tracking-[-0.035em]">
              {title}
            </h1>
            {intro && <div className="mt-5 max-w-[640px] text-[17px] leading-relaxed text-white/65">{intro}</div>}
          </div>
        </section>
        <div className="container-page py-14 sm:py-20">
          <article className="doc max-w-[760px]">{children}</article>
        </div>
      </main>
      <SiteFooter />
    </>
  );
}
