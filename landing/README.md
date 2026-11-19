# Kichta landing page

One-page site for Kichta, built with Next.js 16 (App Router, static export), Tailwind CSS 4,
GSAP + ScrollTrigger, Lenis smooth scrolling and React Bits components.

```bash
npm install
npm run dev      # http://localhost:3000
npm run build    # static site in out/
npm run lint
```

## Where things are

- `src/app/page.tsx`: the sections in order (Hero, Statement, Reminders, Features, Insights,
  Privacy, FAQ, closing call).
- `src/lib/site.ts`: App Store URL, legal/support links, tagline, reminder lead times.
  Set `SITE_URL` once the site has a domain (canonical and Open Graph URLs).
- `src/lib/example.ts`: the example subscriptions shown in the illustrations (generic names,
  no third-party brands).
- `src/components/reactbits/`: React Bits components copied from the registry
  (`https://reactbits.dev/r/<Name>-TS-TW.json`). Keep them unchanged so they can be updated.
- `src/components/SmoothScroll.tsx`: Lenis, driven by the GSAP ticker.

Every animation is skipped with "Reduce motion" turned on.

## Keeping it truthful

Each product claim matches the app: reminder lead times and wording
(`lib/features/notifications`), insight wording (`lib/features/insights`), privacy points
(`docs/PRIVACY.md`). Update the page when those change.

## Deploying

`out/` is a plain static site: Vercel, Netlify, GitHub Pages or any static host.
