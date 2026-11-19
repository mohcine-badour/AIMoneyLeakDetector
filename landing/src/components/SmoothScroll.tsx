"use client";

import { useEffect } from "react";
import Lenis from "lenis";
import { gsap } from "gsap";
import { ScrollTrigger } from "gsap/ScrollTrigger";

gsap.registerPlugin(ScrollTrigger);

/**
 * Lenis smooth scrolling, driven by the GSAP ticker so ScrollTrigger stays in sync.
 * With "Reduce motion" turned on, Lenis is not started and the browser scrolls natively.
 */
export default function SmoothScroll() {
  useEffect(() => {
    const query = window.matchMedia("(prefers-reduced-motion: reduce)");
    let lenis: Lenis | null = null;
    let tick: ((time: number) => void) | null = null;

    const start = () => {
      if (lenis) return;
      lenis = new Lenis({ lerp: 0.11, anchors: { offset: -72 }, autoRaf: false });
      lenis.on("scroll", ScrollTrigger.update);
      const instance = lenis;
      tick = (time: number) => instance.raf(time * 1000);
      gsap.ticker.add(tick);
      gsap.ticker.lagSmoothing(0);
    };

    const stop = () => {
      if (tick) gsap.ticker.remove(tick);
      gsap.ticker.lagSmoothing(500, 33);
      lenis?.destroy();
      lenis = null;
      tick = null;
    };

    const apply = () => (query.matches ? stop() : start());
    apply();
    query.addEventListener("change", apply);
    return () => {
      query.removeEventListener("change", apply);
      stop();
    };
  }, []);

  return null;
}
