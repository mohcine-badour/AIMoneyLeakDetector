import type { ComponentType, SVGProps } from "react";
import SpotlightCard from "@/components/reactbits/SpotlightCard";
import Reveal from "@/components/Reveal";
import { IconChart, IconDoor, IconHourglass, IconScale, IconScan, IconStack } from "@/components/icons";

type Feature = { icon: ComponentType<SVGProps<SVGSVGElement>>; title: string; body: string; tint: string };

// Each claim maps to a shipped screen: subscriptions, trials, scanner, insights,
// before_subscribe and cancellation (lib/features/*).
const FEATURES: Feature[] = [
  {
    icon: IconStack,
    title: "Every subscription, one list",
    body: "Weekly, monthly, quarterly, yearly or a custom cycle. Each one shows its monthly cost, so you can compare them side by side.",
    tint: "bg-indigo-bg text-indigo",
  },
  {
    icon: IconHourglass,
    title: "Free trials, tracked",
    body: "Log a trial when you start it. Kichta reminds you before it ends, so you decide before it turns into a charge.",
    tint: "bg-warn-bg text-warn",
  },
  {
    icon: IconScan,
    title: "Scan a receipt",
    body: "Take a photo or pick one. The text is read on your device, you confirm the details, and the image is discarded.",
    tint: "bg-pos-bg text-pos",
  },
  {
    icon: IconChart,
    title: "See where it goes",
    body: "Monthly and yearly spend, a breakdown by category and your most expensive subscriptions first.",
    tint: "bg-indigo-bg text-indigo",
  },
  {
    icon: IconScale,
    title: "Before you subscribe",
    body: "Thinking about a new one? Check what you already spend in that category and whether it overlaps with something you pay for.",
    tint: "bg-danger-bg text-danger",
  },
  {
    icon: IconDoor,
    title: "Help to cancel",
    body: "Steps, a link to the cancellation page and a message draft you can send. You stay in charge: Kichta never cancels for you.",
    tint: "bg-subtle text-ink",
  },
];

export default function Features() {
  return (
    <section id="features" className="container-page py-24 sm:py-32">
      <Reveal className="max-w-[720px]" stagger={0.1}>
        <p className="eyebrow text-glow">Features</p>
        <h2 className="mt-4 text-[clamp(2.1rem,4.6vw,3.6rem)] font-semibold leading-[1.04] tracking-[-0.03em]">
          Small app. <span className="serif-accent text-ink-2">Clear</span> picture.
        </h2>
        <p className="mt-6 max-w-[560px] text-[17px] leading-relaxed text-ink-2">
          Add what you pay for in seconds, then let Kichta keep watch over the dates and the totals.
        </p>
      </Reveal>

      <Reveal className="mt-14 grid gap-4 sm:grid-cols-2 lg:grid-cols-3" stagger={0.08}>
        {FEATURES.map(({ icon: Icon, title, body, tint }) => (
          <SpotlightCard
            key={title}
            theme="light"
            spotlightColor="rgba(79, 124, 255, 0.16)"
            className="h-full border border-line !p-7"
          >
            <span className={`grid h-11 w-11 place-items-center rounded-2xl ${tint}`}>
              <Icon width={22} height={22} />
            </span>
            <h3 className="mt-6 text-[19px] font-semibold tracking-tight">{title}</h3>
            <p className="mt-2 text-[15px] leading-relaxed text-ink-2">{body}</p>
          </SpotlightCard>
        ))}
      </Reveal>
    </section>
  );
}
