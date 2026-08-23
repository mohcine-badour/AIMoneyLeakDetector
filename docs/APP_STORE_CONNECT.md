# App Store Connect checklist

Paste these after GitHub Pages is live from `docs/`:

- Privacy Policy URL: `https://mohcine-badour.github.io/AIMoneyLeakDetector/privacy.html`
- Terms of Use URL (or use Apple’s standard EULA): `https://mohcine-badour.github.io/AIMoneyLeakDetector/terms.html`
- Support URL: `https://github.com/mohcine-badour/AIMoneyLeakDetector/issues`

Enable Pages: repo Settings → Pages → Source = GitHub Actions. The workflow `.github/workflows/pages.yml` deploys `docs/`.

Also fill:

- Screenshots of Welcome, Home, Add subscription, Paywall, Settings
- Description: local subscription tracker. Users add records or scan a receipt. Kichta does not cancel merchants.
- Age rating: 4+. Do not put the app in the Kids category. The privacy policy says Kichta is not directed at children under 13.
- App Privacy (must match the privacy policy):
  - Purchases — App Functionality — Apple billing / restore
  - Photos — App Functionality — receipt scan, not saved
  - Camera — App Functionality — receipt scan, not saved
  - Advertising Data — Third-Party Advertising — Google AdMob banners (non-personalized)
  - Do not declare Tracking (no ATT, no cross-app tracking)
  - Do not declare financial amounts, merchant names, or email as data collected by Kichta
- Subscription group localization must match Terms of Use (Guideline 3.1.2): title Kichta Pro; Yearly $19.99 / 1 year; Monthly $2.99 / 1 month; Weekly $0.99 / 1 week; auto-renew; cancel in Apple ID settings; Privacy and Terms URLs functional
- Create `billkiller_pro_weekly` in the same Kichta Pro subscription group (1 week, $0.99). Keep existing monthly and yearly IDs.
