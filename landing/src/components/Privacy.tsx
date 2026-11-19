import Reveal from "@/components/Reveal";
import { IconCheck, IconLock } from "@/components/icons";
import { PRIVACY_URL } from "@/lib/site";

// Each point restates the privacy policy (docs/PRIVACY.md).
const POINTS = [
  ["Encrypted on your device", "Subscriptions and trials are kept in an encrypted database. The key stays in the iOS Keychain."],
  ["No account", "No sign-up and no email. There is no Kichta server holding a copy of your list."],
  ["No bank connection", "You type a subscription in or confirm a receipt scan. Kichta never asks for bank logins."],
  ["Receipts aren't kept", "A scanned receipt is read on the device, then the image is discarded."],
  ["Local reminders", "Notifications are scheduled on your device. Kichta sends no remote push."],
  ["Delete any time", "Settings → Delete my data clears everything on the device, immediately."],
];

export default function Privacy() {
  return (
    <section id="privacy" className="px-3 sm:px-4">
      <div className="relative isolate mx-auto max-w-[1400px] overflow-hidden rounded-[36px] bg-night-2 py-24 text-white sm:rounded-[56px] sm:py-32">
        <div
          aria-hidden="true"
          className="absolute -top-40 left-1/2 -z-10 h-[520px] w-[820px] -translate-x-1/2 rounded-full bg-glow/25 blur-[120px]"
        />
        <div className="container-page">
          <Reveal className="max-w-[760px]" stagger={0.1}>
            <span className="grid h-12 w-12 place-items-center rounded-2xl bg-white/8 text-glow-soft ring-1 ring-white/10">
              <IconLock width={24} height={24} />
            </span>
            <p className="eyebrow mt-8 text-glow-soft">Privacy</p>
            <h2 className="mt-4 text-[clamp(2.1rem,4.6vw,3.6rem)] font-semibold leading-[1.04] tracking-[-0.03em]">
              What Kichta knows <span className="serif-accent text-glow-soft">stays with you.</span>
            </h2>
            <p className="mt-6 max-w-[560px] text-[17px] leading-relaxed text-white/60">
              Your subscriptions say a lot about you. Kichta keeps them on your device, and never sends amounts,
              merchant names or receipts anywhere.
            </p>
          </Reveal>

          <Reveal as="ul" className="mt-14 grid gap-x-10 gap-y-8 sm:grid-cols-2 lg:grid-cols-3" stagger={0.07}>
            {POINTS.map(([title, body]) => (
              <li key={title} className="border-t border-night-line pt-6">
                <p className="flex items-center gap-2.5 text-[17px] font-semibold">
                  <IconCheck width={18} height={18} className="text-glow-soft" />
                  {title}
                </p>
                <p className="mt-2 text-[15px] leading-relaxed text-white/55">{body}</p>
              </li>
            ))}
          </Reveal>

          <p className="mt-12 text-[14px] text-white/45">
            Read the full{" "}
            <a href={PRIVACY_URL} className="text-white/80 underline decoration-white/30 underline-offset-4 hover:decoration-white">
              privacy policy
            </a>
            .
          </p>
        </div>
      </div>
    </section>
  );
}
