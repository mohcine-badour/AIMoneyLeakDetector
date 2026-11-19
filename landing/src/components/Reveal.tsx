"use client";

import { useRef, type ElementType, type ReactNode } from "react";
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";
import { useGSAP } from "@gsap/react";

gsap.registerPlugin(ScrollTrigger, useGSAP);

type RevealProps = {
  children: ReactNode;
  as?: ElementType;
  className?: string;
  /** Animate direct children one after another instead of the block as a whole. */
  stagger?: number;
  delay?: number;
  y?: number;
};

/**
 * Fades content up as it scrolls into view (GSAP + ScrollTrigger).
 * Content is visible in the HTML; the animation only runs once script is ready and
 * never with "Reduce motion".
 */
export default function Reveal({ children, as: Tag = "div", className = "", stagger, delay = 0, y = 28 }: RevealProps) {
  const ref = useRef<HTMLElement>(null);

  useGSAP(
    () => {
      const el = ref.current;
      if (!el) return;
      const mm = gsap.matchMedia();
      mm.add("(prefers-reduced-motion: no-preference)", () => {
        const targets = stagger ? Array.from(el.children) : el;
        gsap.from(targets, {
          autoAlpha: 0,
          y,
          duration: 0.9,
          ease: "power3.out",
          delay,
          stagger: stagger ?? 0,
          scrollTrigger: { trigger: el, start: "top 85%", once: true },
        });
      });
      return () => mm.revert();
    },
    { scope: ref },
  );

  return (
    <Tag ref={ref} className={className}>
      {children}
    </Tag>
  );
}
