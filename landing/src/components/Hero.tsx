"use client";

import Image from "next/image";
import { useRef } from "react";
import { gsap } from "gsap";
import { useGSAP } from "@gsap/react";
import LightRays from "@/components/reactbits/LightRays";
import RotatingText from "@/components/reactbits/RotatingText";
import ShinyText from "@/components/reactbits/ShinyText";
import SplitText from "@/components/reactbits/SplitText";
import PhoneMock from "@/components/PhoneMock";
import StoreButton from "@/components/StoreButton";
import { IconArrowDown } from "@/components/icons";
import { MIN_IOS } from "@/lib/site";

gsap.registerPlugin(useGSAP);

const PAID_FOR = ["streaming", "music", "the gym", "cloud storage", "software", "free trials"];

const headline = {
  splitType: "words" as const,
  tag: "span" as const,
  trigger: "load" as const,
  textAlign: "left" as const,
  duration: 1.1,
  ease: "power4.out",
  from: { opacity: 0, y: 48, rotate: 4 },
  to: { opacity: 1, y: 0, rotate: 0 },
};

export default function Hero() {
  const root = useRef<HTMLElement>(null);

  useGSAP(
    () => {
      const mm = gsap.matchMedia();
      mm.add("(prefers-reduced-motion: no-preference)", () => {
        const tl = gsap.timeline({ defaults: { ease: "power3.out" } });
        tl.from("[data-hero-fade]", { autoAlpha: 0, y: 18, duration: 0.9, stagger: 0.12 }, 0.55)
          .from("[data-hero-phone]", { autoAlpha: 0, y: 80, rotate: -4, duration: 1.4, ease: "expo.out" }, 0.35)
          .from("[data-hero-note]", { autoAlpha: 0, y: -26, scale: 0.94, duration: 0.8, ease: "back.out(1.6)" }, 1.5);

        // A gentle float once everything is in place.
        gsap.to("[data-hero-note]", { y: -8, duration: 2.6, ease: "sine.inOut", yoyo: true, repeat: -1, delay: 2.4 });
      });
      return () => mm.revert();
    },
    { scope: root },
  );

  return (
    <section
      ref={root}
      id="top"
      className="relative isolate overflow-hidden rounded-b-[36px] bg-night text-white sm:rounded-b-[56px]"
    >
      <div className="absolute inset-0 -z-10">
        <LightRays
          raysOrigin="top-center"
          raysColor="#8fb0ff"
          raysSpeed={0.7}
          lightSpread={1.1}
          rayLength={2.6}
          intensity={1.5}
          glow={0.9}
          followMouse
          mouseInfluence={0.06}
          noiseAmount={0.04}
          distortion={0.03}
          maxDevicePixelRatio={1.5}
        />
      </div>
      <div
        aria-hidden="true"
        className="absolute inset-0 -z-10 bg-[linear-gradient(to_bottom,transparent_45%,var(--color-night)_95%)]"
      />

      <div className="container-page grid min-h-[100svh] items-center gap-16 pt-32 pb-24 lg:grid-cols-[1.3fr_0.7fr] lg:gap-10 lg:pt-28">
        <div className="max-w-[640px]">
          <p data-hero-fade>
            <span className="inline-flex items-center gap-2 rounded-full border border-white/12 bg-white/[0.04] px-3.5 py-1.5 text-[13px] backdrop-blur">
              <span className="h-1.5 w-1.5 rounded-full bg-glow shadow-[0_0_10px_2px_rgb(79_124_255/0.8)]" />
              <ShinyText text="Free on the App Store · No account needed" color="#aab8e6" shineColor="#ffffff" speed={3.2} />
            </span>
          </p>

          <h1 className="mt-7 text-[clamp(2.6rem,5vw,4.75rem)] font-semibold leading-[0.98] tracking-[-0.035em]">
            <span className="block">
              <SplitText text="Every subscription," {...headline} delay={60} />
            </span>
            <span className="block">
              <SplitText text="every renewal," {...headline} delay={60} />
            </span>
            <span className="serif-accent block pt-1 text-[1.08em] text-glow-soft">
              <SplitText text="in one calm place." {...headline} delay={80} />
            </span>
          </h1>

          <div data-hero-fade className="mt-8 flex flex-wrap items-center gap-x-3 gap-y-2 text-[17px] text-white/70 sm:text-[19px]">
            <span>A reminder before you pay for</span>
            <RotatingText
              texts={PAID_FOR}
              highlight
              highlightColor="rgb(79 124 255 / 0.32)"
              mainClassName="text-white font-medium"
              splitBy="words"
              rotationInterval={2200}
            />
          </div>

          <p data-hero-fade className="mt-5 max-w-[540px] text-[16px] leading-relaxed text-white/60 sm:text-[17px]">
            Kichta keeps your subscriptions and free trials in one list, shows what they cost each month and
            year, and notifies you before you&rsquo;re charged. No bank login. Everything stays on your device.
          </p>

          <div data-hero-fade className="mt-9 flex flex-wrap items-center gap-x-6 gap-y-4">
            <StoreButton />
            <p className="text-[13px] leading-snug text-white/50">
              iPhone &amp; iPad
              <br />
              iOS {MIN_IOS} or later
            </p>
          </div>
        </div>

        <div className="relative mx-auto flex justify-center lg:justify-end">
          <div data-hero-phone className="relative">
            <PhoneMock />
            <div
              data-hero-note
              className="absolute -left-8 top-[40px] w-[290px] rounded-[22px] border border-white/40 bg-white/80 p-3 text-ink shadow-[0_24px_60px_-20px_rgb(0_0_0/0.6)] backdrop-blur-xl sm:-left-28"
              role="img"
              aria-label="Example notification: A subscription renews tomorrow. Open Kichta to review it."
            >
              <div className="flex items-start gap-2.5" aria-hidden="true">
                <Image src="/app-icon.png" alt="" width={38} height={38} className="rounded-[10px]" />
                <div className="min-w-0 flex-1">
                  <div className="flex items-baseline justify-between text-[11px] text-ink-2">
                    <span className="font-semibold uppercase tracking-wide">Kichta</span>
                    <span>now</span>
                  </div>
                  <p className="mt-0.5 text-[14px] font-semibold leading-snug">A subscription renews tomorrow</p>
                  <p className="text-[13px] text-ink-2">Open Kichta to review it.</p>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <a
        href="#statement"
        className="absolute bottom-6 left-1/2 hidden -translate-x-1/2 items-center gap-2 rounded-full px-3 py-2 text-[12px] text-white/45 transition-colors hover:text-white/80 md:flex"
      >
        <IconArrowDown width={16} height={16} />
        Scroll
      </a>
    </section>
  );
}
