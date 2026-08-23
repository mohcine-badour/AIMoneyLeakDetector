class PrivacyPolicySection {
  const PrivacyPolicySection({
    required this.title,
    required this.body,
    required this.group,
  });

  final String title;
  final String body;
  final String group;
}

/// In-app privacy policy. Keep this English-only for V1.
abstract final class PrivacyPolicy {
  static const String title = 'Privacy Policy';
  static const String lastUpdated = 'August 23, 2026';

  static const String groupDevice = 'On this device';
  static const String groupNotCollected = 'What we do not collect';
  static const String groupProduct = 'How the app works';
  static const String groupControl = 'Your control';

  static const List<PrivacyPolicySection> sections = [
    PrivacyPolicySection(
      title: 'Overview',
      group: groupDevice,
      body:
          'Kichta tracks subscriptions on this device. We collect as little as we can and do not send receipts or money amounts to analytics.',
    ),
    PrivacyPolicySection(
      title: 'Data stored on this device',
      group: groupDevice,
      body:
          'Subscriptions, trials, usage counts, and onboarding answers stay in an encrypted local database on your phone. The encryption key is stored in the system Keychain, not in SharedPreferences. They are used to calculate spend, upcoming payments, and reminders.',
    ),
    PrivacyPolicySection(
      title: 'Data we do not collect',
      group: groupNotCollected,
      body:
          'We do not ask for bank logins. We do not create a Kichta account. We do not keep raw receipt images after a scan. We do not put financial amounts, merchant names, or documents into analytics.',
    ),
    PrivacyPolicySection(
      title: 'Receipts and documents',
      group: groupNotCollected,
      body:
          'The camera and photo library are used only to scan a receipt. Text is read on this phone. The image is held in memory for that scan, then discarded. Receipt files are not saved in the app database.',
    ),
    PrivacyPolicySection(
      title: 'Analytics',
      group: groupProduct,
      body:
          'Product analytics may record event names such as app opened or paywall viewed. Allowed details are limited to plan, source, success, and reminder kind. Amounts, merchants, and documents are stripped before anything is recorded. This build logs those event names on the device only.',
    ),
    PrivacyPolicySection(
      title: 'Purchases',
      group: groupProduct,
      body:
          'Pro is sold through the App Store. Apple validates the purchase. If a RevenueCat public SDK key is configured later, RevenueCat may also see store account and product identifiers to restore entitlement. This app never stores an AI API key or a RevenueCat secret key.',
    ),
    PrivacyPolicySection(
      title: 'Ads',
      group: groupProduct,
      body:
          'This version does not show advertisements and does not load an advertising SDK.',
    ),
    PrivacyPolicySection(
      title: 'AI processing',
      group: groupProduct,
      body:
          'Spend math stays in the app. This version does not send your data to an AI provider. Flutter does not contain AI API secrets.',
    ),
    PrivacyPolicySection(
      title: 'Sharing',
      group: groupControl,
      body:
          'This version does not upload your subscription list to a Kichta account. Outbound links use HTTPS only.',
    ),
    PrivacyPolicySection(
      title: 'Deletion',
      group: groupControl,
      body:
          'You can delete the data on this device in Settings. There is no cloud account, so deletion is local only. App Store subscriptions are billed by Apple and are not cancelled by deleting app data.',
    ),
    PrivacyPolicySection(
      title: 'Contact',
      group: groupControl,
      body:
          'Use the Support row in Settings (GitHub issues), or App Store support for this app. Privacy Policy and Terms of Use are also available in the app.',
    ),
  ];
}
