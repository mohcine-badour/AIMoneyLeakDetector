"use client";

import Image from "next/image";
import { useRef } from "react";
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { useGSAP } from "@gsap/react";
import Reveal from "@/components/Reveal";

gsap.registerPlugin(ScrollTrigger, useGSAP);

// The app's lead times and notification wording (reminder_copy.dart, app_strings.dart).
const STEPS = [
  { when: "3 days before", title: "A subscription renews in 3 days" },
  { when: "24 hours before", title: "A subscription renews tomorrow" },
  { when: "2 hours before", title: "A trial ends in 2 hours" },
];

export default function Reminders() {
  const root = useRef<HTMLElement>(null);

  useGSAP(
    () => {
      const mm = gsap.matchMedia();
      mm.add("(prefers-reduced-motion: no-preference)", () => {
        // The line fills as you scroll through the timeline...
        gsap.fromTo(
          "[data-line-fill]",
          { scaleY: 0 },
          {
            scaleY: 1,
            ease: "none",
            scrollTrigger: { trigger: "[data-timeline]", start: "top 70%", end: "bottom 60%", scrub: 0.6 },
          },
        );
        // ...and each reminder slides in when the line reaches it.
        gsap.utils.toArray<HTMLElement>("[data-step]").forEach((step) => {
          gsap.from(step.querySelector("[data-step-card]"), {
            autoAlpha: 0,
            x: 40,
            duration: 0.8,
            ease: "power3.out",
            scrollTrigger: { trigger: step, start: "top 72%", once: true },
          });
          gsap.from(step.querySelector("[data-step-dot]"), {
            scale: 0,
            duration: 0.5,
            ease: "back.out(2)",
            scrollTrigger: { trigger: step, start: "top 72%", once: true },
          });
        });
      });
      return () => mm.revert();
    },
    { scope: root },
  );

  return (
    <section ref={root} id="reminders" className="container-page grid overflow-x-clip gap-14 py-24 sm:py-32 lg:grid-cols-[0.9fr_1.1fr] lg:gap-20">
      <Reveal className="lg:sticky lg:top-32 lg:self-start" stagger={0.1}>
        <p className="eyebrow text-glow">Reminders</p>
        <h2 className="mt-4 text-[clamp(2.1rem,4.6vw,3.6rem)] font-semibold leading-[1.04] tracking-[-0.03em]">
          Three nudges, <span className="serif-accent text-ink-2">before</span> every charge.
        </h2>
        <p className="mt-6 max-w-[460px] text-[17px] leading-relaxed text-ink-2">
          For every renewal and every free trial, Kichta schedules reminders 3 days, 24 hours and 2 hours ahead.
          Enough time to keep it, switch plans or cancel it yourself.
        </p>
        <p className="mt-4 max-w-[460px] text-[15px] leading-relaxed text-ink-3">
          Reminders are local notifications scheduled on your device. Turn them off any time in Settings.
        </p>
      </Reveal>

      <div data-timeline className="relative pl-10 sm:pl-14">
        <span aria-hidden="true" className="absolute left-[11px] top-3 bottom-3 w-[2px] rounded-full bg-line-strong sm:left-[15px]" />
        <span
          aria-hidden="true"
          data-line-fill
          className="absolute left-[11px] top-3 bottom-3 w-[2px] origin-top rounded-full bg-gradient-to-b from-glow to-violet sm:left-[15px]"
        />

        <ol className="space-y-10 sm:space-y-14">
          {STEPS.map((step) => (
            <li key={step.when} data-step className="relative">
              <span
                data-step-dot
                aria-hidden="true"
                className="absolute -left-10 top-1 grid h-6 w-6 place-items-center rounded-full bg-paper sm:-left-14 sm:h-8 sm:w-8"
              >
                <span className="h-3 w-3 rounded-full bg-glow shadow-[0_0_0_5px_rgb(79_124_255/0.16)] sm:h-3.5 sm:w-3.5" />
              </span>
              <p className="eyebrow text-ink-3">{step.when}</p>
              <div
                data-step-card
                className="mt-3 flex max-w-[440px] items-start gap-3 rounded-[24px] border border-line bg-card/90 p-4 shadow-[0_18px_50px_-24px_rgb(0_0_0/0.25)] backdrop-blur"
              >
                <Image src="/app-icon.png" alt="" width={42} height={42} className="rounded-[11px]" />
                <div className="min-w-0 flex-1">
                  <div className="flex items-baseline justify-between text-[12px] text-ink-3">
                    <span className="font-semibold uppercase tracking-wide">Kichta</span>
                    <span>notification</span>
                  </div>
                  <p className="mt-0.5 text-[16px] font-semibold leading-snug">{step.title}</p>
                  <p className="text-[14px] text-ink-2">Open Kichta to review it.</p>
                </div>
              </div>
            </li>
          ))}
          <li data-step className="relative">
            <span
              data-step-dot
              aria-hidden="true"
              className="absolute -left-10 top-0 grid h-6 w-6 place-items-center rounded-full bg-ink text-[11px] text-white sm:-left-14 sm:h-8 sm:w-8"
            >
              $
            </span>
            <div data-step-card>
              <p className="eyebrow text-ink-3">Charge day</p>
              <p className="mt-2 text-[20px] font-semibold tracking-tight">No surprises.</p>
            </div>
          </li>
        </ol>
      </div>
    </section>
  );
}
