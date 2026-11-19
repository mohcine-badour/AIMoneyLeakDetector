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
- `/privacy`, `/terms`, `/support`: `src/app/<page>/page.tsx`. Privacy and Terms render
  `src/content/privacy.md` and `terms.md`, copies of `docs/PRIVACY.md` and `docs/TERMS.md` (the in-app
  texts) without the repo-only lines. Copy them again when the app's texts change.

Every animation is skipped with "Reduce motion" turned on.

## Keeping it truthful

Each product claim matches the app: reminder lead times and wording
(`lib/features/notifications`), insight wording (`lib/features/insights`), privacy points
(`docs/PRIVACY.md`). Update the page when those change.

## Deploying

Live at https://kichta-landing.vercel.app (Vercel project `kichta-landing`, personal team
"mohcine's projects"). Deploys are made from this folder with the CLI; pushes to GitHub
don't deploy on their own.

```bash
vercel deploy --prod --scope mohcines-projects-19346ce4
```

`out/` is also a plain static site that any static host can serve.
