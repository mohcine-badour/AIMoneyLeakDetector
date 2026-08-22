# App Store Connect checklist

Paste these after GitHub Pages is live from `docs/`:

- Privacy Policy URL: `https://mohcine-badour.github.io/AIMoneyLeakDetector/privacy.html`
- Terms of Use URL (or use Apple’s standard EULA): `https://mohcine-badour.github.io/AIMoneyLeakDetector/terms.html`
- Support URL: `https://github.com/mohcine-badour/AIMoneyLeakDetector/issues`

Enable Pages: repo Settings → Pages → Source = GitHub Actions. The workflow `.github/workflows/pages.yml` deploys `docs/`.

Also fill:

- Screenshots of Welcome, Home, Add subscription, Paywall, Settings
- Description: local subscription tracker. Users add records. Kichta does not cancel merchants and does not scan receipts in this version.
- Age rating: likely 4+
- App Privacy: Purchases for App Functionality if StoreKit is used. Do not declare ads, photos, or tracking.
- Subscription group localization: Yearly $19.99, Monthly $2.99, Weekly $0.99, auto-renew, cancel in Apple ID settings
- Create `billkiller_pro_weekly` in the same Kichta Pro subscription group (1 week, $0.99). Keep existing monthly and yearly IDs.
