import 'privacy_policy.dart';

/// In-app terms of use. Keep this English-only for V1.
///
/// Written to App Store Review Guideline 3.1.2 (auto-renewable subscriptions)
/// and Apple’s Licensed Application EULA: name the service, each plan length
/// and price, cancel path, refunds, and what the user is buying.
abstract final class TermsOfUse {
  static const String lastUpdated = 'August 23, 2026';
  static const String hostedUrl =
      'https://mohcine-badour.github.io/AIMoneyLeakDetector/terms.html';

  static const String groupProduct = 'The app';
  static const String groupBilling = 'Kichta Pro';
  static const String groupLimits = 'What Kichta does not do';
  static const String groupRules = 'Other rules';

  static const List<PrivacyPolicySection> sections = [
    PrivacyPolicySection(
      title: 'Using Kichta',
      group: groupProduct,
      body:
          'Kichta is a local subscription tracker on this phone. You add subscriptions and trials yourself. There is no Kichta account and no cloud sync in this version. By downloading or using Kichta you agree to these Terms and the Privacy Policy.',
    ),
    PrivacyPolicySection(
      title: 'License',
      group: groupProduct,
      body:
          'We grant you a personal, non-exclusive, non-transferable, revocable license to use Kichta on Apple devices you own or control, as allowed by the App Store and Apple’s Licensed Application End User License Agreement. These Terms supplement that EULA. If they conflict, Apple’s EULA controls for the licensed application, except for the auto-renewable subscription terms required by Guideline 3.1.2.',
    ),
    PrivacyPolicySection(
      title: 'Your records',
      group: groupProduct,
      body:
          'You are responsible for the accuracy of the names, amounts, and dates you enter or confirm after a receipt scan. Kichta uses those records to show spend, upcoming payments, and reminders. Receipt text is read on this phone and can be wrong. Check the review screen before you save.',
    ),
    PrivacyPolicySection(
      title: 'Reminders',
      group: groupProduct,
      body:
          'Reminders are local notifications. They are a best-effort ping, not a guarantee that you will cancel a merchant or avoid a charge. You can turn them off in Settings.',
    ),
    PrivacyPolicySection(
      title: 'Ads',
      group: groupProduct,
      body:
          'The free version may show Google AdMob banners on Trials and Upcoming. Ads are requested as non-personalized. Pro removes ads. Ad content is provided by Google, not by Kichta.',
    ),
    PrivacyPolicySection(
      title: 'What Pro includes',
      group: groupBilling,
      body:
          'Kichta Pro is the paid auto-renewable App Store subscription for this app. Pro removes ads and unlocks the paid features shown on the paywall before you buy, including unlimited subscriptions and extra trial tracking. Free limits, when enabled, cap how many subscriptions and trials you can save and may require Pro for receipt scan. The paywall is the offer you accept.',
    ),
    PrivacyPolicySection(
      title: 'Auto-renewable subscription',
      group: groupBilling,
      body:
          'Kichta Pro is an auto-renewable App Store subscription. Yearly is \$19.99 per year. Monthly is \$2.99 per month. Weekly is \$0.99 per week, or the equivalent price Apple shows you in your local currency on the paywall and the App Store. Payment is charged to your Apple ID at confirmation of purchase. The subscription renews unless you turn off auto-renew at least 24 hours before the end of the current period. Apple may charge the renewal within 24 hours before the period ends.',
    ),
    PrivacyPolicySection(
      title: 'How to cancel Pro',
      group: groupBilling,
      body:
          'Manage or cancel Kichta Pro in your Apple ID subscription settings. The Manage subscription row in Settings opens that page. Deleting data in Kichta does not cancel an App Store subscription. After you cancel, Pro stays active until the end of the paid period.',
    ),
    PrivacyPolicySection(
      title: 'Restore and refunds',
      group: groupBilling,
      body:
          'Use Restore purchases on the paywall to unlock Pro again on a device signed into the same Apple ID. Refunds are handled by Apple, not by Kichta.',
    ),
    PrivacyPolicySection(
      title: 'Merchants',
      group: groupLimits,
      body:
          'Kichta does not cancel Netflix, Spotify, or any other merchant for you. Cancellation links open the merchant or Apple. You finish cancellation on their site or in Settings.',
    ),
    PrivacyPolicySection(
      title: 'Not financial advice',
      group: groupLimits,
      body:
          'Kichta is a tracker, not a bank, accountant, or advisor. Totals and reminder dates depend on what you enter. We are not responsible for merchant charges, missed cancellations, or decisions you make from the numbers on screen.',
    ),
    PrivacyPolicySection(
      title: 'Third-party services',
      group: groupLimits,
      body:
          'Apple handles billing. Google serves ads on the free version. Support and cancellation links open other sites. Those parties have their own terms. We do not control their content or availability.',
    ),
    PrivacyPolicySection(
      title: 'Eligibility',
      group: groupRules,
      body:
          'You must be at least 13 and able to agree to these Terms. Kichta is not directed at children under 13 and is not in the App Store Kids category. If you are not of legal age to enter an App Store contract, a parent or guardian must approve the download and any purchase.',
    ),
    PrivacyPolicySection(
      title: 'Acceptable use',
      group: groupRules,
      body:
          'Use Kichta only to track subscriptions and trials you are allowed to record. Do not misuse the app, attempt to break it, or store a child’s personal information in it.',
    ),
    PrivacyPolicySection(
      title: 'Disclaimer',
      group: groupRules,
      body:
          'Kichta is provided as is, to the maximum extent permitted by law. We do not warrant that reminders will fire, that a scan will read a receipt correctly, or that the app will be uninterrupted. We are not liable for ad content, merchant billing, or data loss after you delete the app or use Delete my data.',
    ),
    PrivacyPolicySection(
      title: 'Changes',
      group: groupRules,
      body:
          'We may update these Terms. We will change the last-updated date in the app and at the public URL. If we change Kichta Pro prices or plan lengths, Apple will show the new offer before you buy or when a plan changes. Continued use after an update means you accept the new Terms.',
    ),
    PrivacyPolicySection(
      title: 'Contact',
      group: groupRules,
      body:
          'Questions: use the Support row in Settings, which opens GitHub issues, or App Store support for this app. The Privacy Policy is in Settings and at the public URL listed in App Store Connect.',
    ),
  ];
}
