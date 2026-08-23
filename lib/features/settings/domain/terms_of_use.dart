import 'legal_identity.dart';
import 'privacy_policy.dart';

/// In-app terms of use. Keep this English-only for V1.
///
/// This build is free and does not sell in-app purchases. If a paid plan
/// ships later, add Guideline 3.1.2 price, length, and auto-renew copy
/// before that offer goes live.
abstract final class TermsOfUse {
  static const String lastUpdated = 'August 23, 2026';
  static const String hostedUrl =
      'https://mohcine-badour.github.io/AIMoneyLeakDetector/terms.html';

  static const String groupProduct = 'The app';
  static const String groupFree = 'This version is free';
  static const String groupLimits = 'What Kichta does not do';
  static const String groupRules = 'Other rules';

  static const List<PrivacyPolicySection> sections = [
    PrivacyPolicySection(
      title: 'Using Kichta',
      group: groupProduct,
      body:
          'Kichta is a local subscription tracker published by ${LegalIdentity.publisher}. You add subscriptions and trials yourself. There is no Kichta account and no cloud sync in this version. By downloading or using Kichta you agree to these Terms and the Privacy Policy.',
    ),
    PrivacyPolicySection(
      title: 'License',
      group: groupProduct,
      body:
          'We grant you a personal, non-exclusive, non-transferable, revocable license to use Kichta on Apple devices you own or control, as allowed by the App Store and Apple’s Licensed Application End User License Agreement. These Terms supplement that EULA. If they conflict, Apple’s EULA controls for the licensed application.',
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
          'This version does not show ads. All features are available without paying.',
    ),
    PrivacyPolicySection(
      title: 'No in-app purchases',
      group: groupFree,
      body:
          'This version of Kichta is free. It does not show ads. It does not offer in-app purchases. You can add subscriptions, trials, and scans without paying.',
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
          'Support and cancellation links open other sites. Those parties have their own terms. We do not control their content or availability.',
    ),
    PrivacyPolicySection(
      title: 'Eligibility',
      group: groupRules,
      body:
          'You must be at least 13 and able to agree to these Terms. Kichta is not directed at children under 13 and is not in the App Store Kids category. If you are not of legal age to enter an App Store contract, a parent or guardian must approve the download.',
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
          'Kichta is provided as is, to the maximum extent permitted by law. We do not warrant that reminders will fire, that a scan will read a receipt correctly, or that the app will be uninterrupted. We are not liable for merchant billing or data loss after you delete the app or use Delete my data.',
    ),
    PrivacyPolicySection(
      title: 'Changes',
      group: groupRules,
      body:
          'We may update these Terms. We will change the last-updated date in the app and at the public URL. Continued use after an update means you accept the new Terms.',
    ),
    PrivacyPolicySection(
      title: 'Contact',
      group: groupRules,
      body:
          'Kichta is published by ${LegalIdentity.publisher}. Questions: email ${LegalIdentity.email}. You can also use the Support page or the Support row in Settings. The Privacy Policy is in Settings and at the public URL listed in App Store Connect.',
    ),
  ];
}
