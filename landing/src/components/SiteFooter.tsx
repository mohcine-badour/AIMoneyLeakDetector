import Image from "next/image";
import Link from "next/link";
import { APP_STORE_URL, PRIVACY_URL, SUPPORT_EMAIL, SUPPORT_URL, TERMS_URL } from "@/lib/site";

const LINKS = [
  { href: APP_STORE_URL, label: "App Store" },
  { href: PRIVACY_URL, label: "Privacy" },
  { href: TERMS_URL, label: "Terms" },
  { href: SUPPORT_URL, label: "Support" },
  { href: `mailto:${SUPPORT_EMAIL}`, label: "Contact" },
];

const linkClass = "transition-colors hover:text-ink";

export default function SiteFooter() {
  return (
    <footer className="container-page pt-14 pb-12 text-[14px] text-ink-2">
      <div className="flex flex-col gap-8 sm:flex-row sm:items-center sm:justify-between">
        <Link href="/" className="flex items-center gap-2.5 self-start rounded-xl" aria-label="Kichta home">
          <Image src="/app-icon.png" alt="" width={32} height={32} className="rounded-[8px]" />
          <span className="text-[16px] font-semibold text-ink">Kichta</span>
        </Link>
        <nav aria-label="Footer">
          <ul className="flex flex-wrap gap-x-6 gap-y-2">
            {LINKS.map((link) => (
              <li key={link.label}>
                {/* Pages of this site use Link; the App Store and email open outside it. */}
                {link.href.startsWith("/") ? (
                  <Link href={link.href} className={linkClass}>
                    {link.label}
                  </Link>
                ) : (
                  <a href={link.href} className={linkClass} rel={link.href.startsWith("http") ? "noopener" : undefined}>
                    {link.label}
                  </a>
                )}
              </li>
            ))}
          </ul>
        </nav>
      </div>
      <div className="mt-10 flex flex-col gap-2 border-t border-line pt-6 text-[12px] text-ink-3 sm:flex-row sm:justify-between">
        <p>© {new Date().getFullYear()} Kichta. Illustrations use example data.</p>
        <p>Apple, iPhone, iPad and App Store are trademarks of Apple Inc.</p>
      </div>
    </footer>
  );
}
