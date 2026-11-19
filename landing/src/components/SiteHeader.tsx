import Image from "next/image";
import { APP_STORE_URL } from "@/lib/site";

const LINKS = [
  { href: "#reminders", label: "Reminders" },
  { href: "#features", label: "Features" },
  { href: "#privacy", label: "Privacy" },
  { href: "#faq", label: "FAQ" },
];

/** A floating dark-glass bar: readable over the night hero and the paper sections. */
export default function SiteHeader() {
  return (
    <header className="fixed inset-x-0 top-3 z-50 px-3 sm:top-4">
      <nav
        aria-label="Main"
        className="mx-auto flex h-14 max-w-[1100px] items-center justify-between gap-3 rounded-2xl border border-white/10 bg-night/85 pl-2.5 pr-2 text-white shadow-[0_10px_40px_-14px_rgb(0_0_0/0.55)] backdrop-blur-xl"
      >
        <a href="#top" className="flex items-center gap-2.5 rounded-xl pr-2" aria-label="Kichta, back to top">
          <Image src="/app-icon.png" alt="" width={34} height={34} className="rounded-[9px]" priority />
          <span className="text-[17px] font-semibold tracking-tight">Kichta</span>
        </a>
        <ul className="hidden items-center gap-1 text-[14px] text-white/70 md:flex">
          {LINKS.map((link) => (
            <li key={link.href}>
              <a href={link.href} className="rounded-lg px-3 py-2 transition-colors hover:bg-white/8 hover:text-white">
                {link.label}
              </a>
            </li>
          ))}
        </ul>
        <a
          href={APP_STORE_URL}
          rel="noopener"
          className="rounded-xl bg-white px-4 py-2.5 text-[14px] font-semibold text-night transition-transform hover:scale-[1.03]"
        >
          Get the app
        </a>
      </nav>
    </header>
  );
}
