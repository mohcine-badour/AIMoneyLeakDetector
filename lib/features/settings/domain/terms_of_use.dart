import 'privacy_policy.dart';

/// In-app terms of use. Keep this English-only for V1.
abstract final class TermsOfUse {
  static const String lastUpdated = 'August 22, 2026';

  static const String groupProduct = 'The app';
  static const String groupBilling = 'Kichta Pro';
  static const String groupLimits = 'What Kichta does not do';

  static const List<PrivacyPolicySection> sections = [
    PrivacyPolicySection(
      title: 'Using Kichta',
      group: groupProduct,
      body:
          'Kichta is a local subscription tracker on this phone. You add subscriptions and trials yourself. There is no Kichta account and no cloud sync in this version.',
    ),
    PrivacyPolicySection(
      title: 'Your records',
      group: groupProduct,
      body:
          'You are responsible for the accuracy of the names, amounts, and dates you enter. Kichta uses those records to show spend, upcoming payments, and reminders.',
    ),
    PrivacyPolicySection(
      title: 'Auto-renewable subscription',
      group: groupBilling,
      body:
          'Kichta Pro is an auto-renewable App Store subscription. Yearly is \$19.99 per year. Monthly is \$2.99 per month. Weekly is \$0.99 per week. Payment is charged to your Apple ID at confirmation of purchase. The subscription renews unless you turn off auto-renew at least 24 hours before the end of the current period. Apple may charge the renewal within 24 hours before the period ends.',
    ),
    PrivacyPolicySection(
      title: 'How to cancel Pro',
      group: groupBilling,
      body:
          'Manage or cancel Kichta Pro in your Apple ID subscription settings. Deleting data in Kichta does not cancel an App Store subscription. Refunds are handled by Apple.',
    ),
    PrivacyPolicySection(
      title: 'Merchants',
      group: groupLimits,
      body:
          'Kichta does not cancel Netflix, Spotify, or any other merchant for you. Cancellation links open the merchant or Apple. You finish cancellation on their site or in Settings.',
    ),
  ];
}
