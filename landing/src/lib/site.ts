// Site-wide constants. Every product claim on the page comes from the app's code
// (lib/) and docs/APP_STORE_CONNECT.md; keep them in sync when the app changes.

export const APP_NAME = "Kichta";

/** The live App Store page (id 6804477920). */
export const APP_STORE_URL = "https://apps.apple.com/app/id6804477920";

/** Public origin of this site (Vercel project kichta-landing). Used for canonical and OG URLs. */
export const SITE_URL: string = "https://kichta-landing.vercel.app";

/** Legal and support pages on this site (src/app/privacy, terms, support). */
export const PRIVACY_URL = "/privacy/";
export const TERMS_URL = "/terms/";
export const SUPPORT_URL = "/support/";
export const SUPPORT_EMAIL = "mohcinebadour@gmail.com";

/** From the Xcode project: IPHONEOS_DEPLOYMENT_TARGET and TARGETED_DEVICE_FAMILY = 1,2. */
export const MIN_IOS = "15";

/** The app's own welcome tagline (lib/core/copy/welcome_copy.dart). */
export const TAGLINE = "Every subscription, every renewal — in one calm place.";

export const SITE_DESCRIPTION =
  "Kichta is a private subscription tracker for iPhone and iPad. Track subscriptions and free trials, scan a receipt, see upcoming payments and get reminders before you're charged. No bank connection, no account.";

/** Reminder lead times (lib/features/upcoming/domain/payment_reminder_scheduler.dart). */
export const REMINDER_OFFSETS = ["3 days before", "24 hours before", "2 hours before"] as const;
