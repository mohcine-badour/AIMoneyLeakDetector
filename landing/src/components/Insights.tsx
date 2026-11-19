"use client";

import { useRef } from "react";
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { useGSAP } from "@gsap/react";
import CountUp from "@/components/reactbits/CountUp";
import Reveal from "@/components/Reveal";
import { EXAMPLE_BY_CATEGORY, EXAMPLE_MONTHLY, EXAMPLE_SUBS, money } from "@/lib/example";

gsap.registerPlugin(ScrollTrigger, useGSAP);

const BAR_COLORS = ["#4f7cff", "#8b7cf6", "#1f9d6b", "#e0703a", "#9c9c95"];

export default function Insights() {
  const root = useRef<HTMLElement>(null);
  const top = [...EXAMPLE_SUBS].sort((a, b) => b.amount - a.amount).slice(0, 3);

  useGSAP(
    () => {
      const mm = gsap.matchMedia();
      mm.add("(prefers-reduced-motion: no-preference)", () => {
        gsap.from("[data-bar]", {
          scaleX: 0,
          duration: 1.2,
          ease: "power3.out",
          stagger: 0.1,
          scrollTrigger: { trigger: "[data-bars]", start: "top 80%", once: true },
        });
      });
      return () => mm.revert();
    },
    { scope: root },
  );

  return (
    <section ref={root} className="container-page pt-8 pb-24 sm:pt-12 sm:pb-32">
      <div className="grid gap-12 lg:grid-cols-[0.8fr_1.2fr] lg:items-center lg:gap-16">
        <Reveal stagger={0.1}>
          <p className="eyebrow text-glow">Insights</p>
          <h2 className="mt-4 text-[clamp(2.1rem,4.6vw,3.6rem)] font-semibold leading-[1.04] tracking-[-0.03em]">
            Know the number <span className="serif-accent text-ink-2">behind</span> the small amounts.
          </h2>
          <p className="mt-6 max-w-[460px] text-[17px] leading-relaxed text-ink-2">
            A few dollars here and there add up. Insights shows your spend per month or per year, where it goes and
            what costs the most, and points out overlaps like two subscriptions doing the same job.
          </p>
        </Reveal>

        <Reveal className="grid gap-4 sm:grid-cols-2" stagger={0.1}>
          {/* Spend */}
          <div className="rounded-[28px] bg-ink p-6 text-white sm:col-span-2">
            <div className="flex items-baseline justify-between">
              <p className="text-[13px] text-white/60">Spend · this month</p>
              <p className="eyebrow text-white/40">Example</p>
            </div>
            <p className="mt-2 text-[clamp(2.6rem,6vw,3.6rem)] font-semibold leading-none tracking-[-0.03em] tabular-nums">
              $<CountUp to={EXAMPLE_MONTHLY} decimals={2} duration={1.6} separator="," />
            </p>
            <p className="mt-3 text-[14px] text-white/60">
              That&rsquo;s <span className="font-medium text-white">{money(EXAMPLE_MONTHLY * 12)}</span> a year.
            </p>
          </div>

          {/* Where it goes */}
          <div data-bars className="rounded-[28px] border border-line bg-card p-6">
            <p className="text-[15px] font-semibold">Where it goes</p>
            <ul className="mt-4 space-y-3.5">
              {EXAMPLE_BY_CATEGORY.map((row, i) => (
                <li key={row.category}>
                  <div className="flex items-baseline justify-between text-[13px]">
                    <span className="text-ink-2">{row.category}</span>
                    <span className="font-medium tabular-nums">{Math.round(row.share * 100)}%</span>
                  </div>
                  <div className="mt-1.5 h-2 overflow-hidden rounded-full bg-subtle">
                    <span
                      data-bar
                      className="block h-full origin-left rounded-full"
                      style={{ width: `${row.share * 100}%`, background: BAR_COLORS[i % BAR_COLORS.length] }}
                    />
                  </div>
                </li>
              ))}
            </ul>
          </div>

          <div className="grid gap-4">
            {/* Top by cost */}
            <div className="rounded-[28px] border border-line bg-card p-6">
              <p className="text-[15px] font-semibold">Top by cost</p>
              <ol className="mt-3 divide-y divide-line">
                {top.map((sub, i) => (
                  <li key={sub.name} className="flex items-center gap-3 py-2.5">
                    <span className="w-4 text-[12px] text-ink-3 tabular-nums">{i + 1}</span>
                    <span className="tile h-7 w-7 rounded-[9px] text-[12px]" style={{ background: sub.color }}>
                      {sub.letter}
                    </span>
                    <span className="flex-1 text-[14px]">{sub.name}</span>
                    <span className="text-[14px] font-semibold tabular-nums">{money(sub.amount)}</span>
                  </li>
                ))}
              </ol>
            </div>

            {/* Overlap insight (insight_copy.dart wording) */}
            <div className="rounded-[28px] bg-indigo-bg p-5 text-indigo">
              <p className="text-[15px] font-semibold">You have 2 entertainment subs</p>
              <p className="mt-1 text-[14px] opacity-80">Consolidate to save up to $11.99/month.</p>
            </div>
          </div>
        </Reveal>
      </div>
    </section>
  );
}
