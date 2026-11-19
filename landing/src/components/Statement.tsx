"use client";

import ScrollReveal from "@/components/reactbits/ScrollReveal";
import Reveal from "@/components/Reveal";
import { useReducedMotion } from "@/lib/useReducedMotion";

const LINE = "Your subscriptions are costing more than you think.";

export default function Statement() {
  const reduced = useReducedMotion();

  return (
    <section id="statement" className="container-page pt-28 pb-8 sm:pt-36 sm:pb-12">
      <p className="eyebrow text-ink-3">Why Kichta</p>
      {reduced ? (
        <h2 className="mt-5 max-w-[920px] text-[clamp(2rem,5.2vw,4.1rem)] font-semibold leading-[1.08] tracking-[-0.03em]">
          {LINE}
        </h2>
      ) : (
        <ScrollReveal
          baseOpacity={0.12}
          baseRotation={2}
          blurStrength={5}
          containerClassName="!mt-5 !mb-0 max-w-[920px]"
          textClassName="!text-[clamp(2rem,5.2vw,4.1rem)] !leading-[1.08] !font-semibold tracking-[-0.03em]"
          rotationEnd="bottom 60%"
          wordAnimationEnd="bottom 55%"
        >
          {LINE}
        </ScrollReveal>
      )}

      <Reveal className="mt-14 grid gap-4 sm:grid-cols-3" stagger={0.12}>
        {[
          ["A free trial", "that quietly turns into a charge."],
          ["A yearly plan", "that renews before you remember it."],
          ["A price", "that went up without anyone telling you."],
        ].map(([lead, rest]) => (
          <p key={lead} className="rounded-3xl border border-line bg-card p-6 text-[17px] leading-snug text-ink-2">
            <span className="font-semibold text-ink">{lead}</span> {rest}
          </p>
        ))}
      </Reveal>
      <Reveal className="mt-6 max-w-[620px] text-[17px] leading-relaxed text-ink-2" delay={0.1}>
        <p>Kichta puts every renewal in front of you, early enough to decide whether it&rsquo;s still worth it.</p>
      </Reveal>
    </section>
  );
}
