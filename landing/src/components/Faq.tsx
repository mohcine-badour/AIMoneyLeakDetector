import Reveal from "@/components/Reveal";
import { MIN_IOS, SUPPORT_EMAIL } from "@/lib/site";

const QUESTIONS: { q: string; a: string }[] = [
  {
    q: "Is Kichta free?",
    a: "Yes. Kichta is free on the App Store and every feature in this version is included. You don't need an account.",
  },
  {
    q: "Does Kichta connect to my bank?",
    a: "No. You type a subscription in, or scan a receipt and confirm what Kichta found. It never asks for bank logins and doesn't read other apps.",
  },
  {
    q: "Can Kichta cancel a subscription for me?",
    a: "No, and it never will behind your back. It shows how to cancel, opens the cancellation page and can draft a message that you send yourself.",
  },
  {
    q: "When do reminders arrive?",
    a: "3 days, 24 hours and 2 hours before a renewal or the end of a free trial. They're local notifications, and you can turn them off in Settings.",
  },
  {
    q: "Where is my data stored?",
    a: "In an encrypted database on your device, with the key in the iOS Keychain. There's no cloud copy. Settings → Delete my data removes it immediately, and uninstalling the app removes it too.",
  },
  {
    q: "Which devices does it work on?",
    a: `iPhone and iPad with iOS ${MIN_IOS} or later. The app is in English.`,
  },
];

export default function Faq() {
  return (
    <section id="faq" className="container-page grid gap-12 py-24 sm:py-32 lg:grid-cols-[0.8fr_1.2fr] lg:gap-20">
      <Reveal stagger={0.1}>
        <p className="eyebrow text-glow">FAQ</p>
        <h2 className="mt-4 text-[clamp(2.1rem,4.6vw,3.6rem)] font-semibold leading-[1.04] tracking-[-0.03em]">
          Good <span className="serif-accent text-ink-2">questions.</span>
        </h2>
        <p className="mt-6 text-[16px] leading-relaxed text-ink-2">
          Something else? Write to{" "}
          <a href={`mailto:${SUPPORT_EMAIL}`} className="font-medium text-ink underline decoration-line-strong underline-offset-4 hover:decoration-ink">
            {SUPPORT_EMAIL}
          </a>
          .
        </p>
      </Reveal>

      <Reveal className="divide-y divide-line-strong border-y border-line-strong" stagger={0.06}>
        {QUESTIONS.map(({ q, a }) => (
          <details key={q} className="faq group">
            <summary className="flex items-center justify-between gap-6 py-6 text-[18px] font-semibold tracking-tight">
              {q}
              <span
                aria-hidden="true"
                className="faq-plus grid h-8 w-8 flex-none place-items-center rounded-full bg-subtle text-[20px] font-normal leading-none transition-transform duration-300"
              >
                +
              </span>
            </summary>
            <p className="-mt-1 max-w-[620px] pb-6 text-[16px] leading-relaxed text-ink-2">{a}</p>
          </details>
        ))}
      </Reveal>
    </section>
  );
}
