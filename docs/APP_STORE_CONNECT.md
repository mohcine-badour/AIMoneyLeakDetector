# App Store Connect checklist

Paste these after GitHub Pages is live from `docs/`:

- Privacy Policy URL: `https://mohcine-badour.github.io/AIMoneyLeakDetector/privacy.html`
- Terms of Use URL (or use Apple’s standard EULA): `https://mohcine-badour.github.io/AIMoneyLeakDetector/terms.html`
- Support URL: `https://github.com/mohcine-badour/AIMoneyLeakDetector/issues`

Enable Pages: repo Settings → Pages → Source = GitHub Actions. The workflow `.github/workflows/pages.yml` deploys `docs/`.

Also fill:

- Screenshots of Welcome, Home, Add subscription, Settings. Do not screenshot a paywall in this version.
- Description: local subscription tracker. Users add records or scan a receipt. Kichta does not cancel merchants.
- Age rating: 4+. Do not put the app in the Kids category. The privacy policy says Kichta is not directed at children under 13.
- App Privacy (must match the privacy policy):
  - Photos — App Functionality — receipt scan, not saved
  - Camera — App Functionality — receipt scan, not saved
  - Do not declare Purchases in this version (no in-app purchase is offered)
  - Do not declare Advertising Data in this version (ads are off)
  - Do not declare Tracking (no ATT, no cross-app tracking)
  - Do not declare financial amounts, merchant names, or email as data collected by Kichta
- This version is free. Leave Kichta Pro products in draft. Do not submit them as an active offer until `featureGatesEnabled` is on and Terms list the live price, length, and auto-renew copy.
