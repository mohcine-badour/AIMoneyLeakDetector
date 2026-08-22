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
  static const String lastUpdated = 'August 22, 2026';

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
          'Subscriptions, trials, usage counts, and onboarding answers stay in local storage on your phone. They are used to calculate spend, upcoming payments, and savings suggestions.',
    ),
    PrivacyPolicySection(
      title: 'Data we do not collect',
      group: groupNotCollected,
      body:
          'We do not ask for bank logins. We do not keep raw receipt images after a scan. We do not put financial amounts, merchant names, or documents into analytics.',
    ),
    PrivacyPolicySection(
      title: 'Receipts and documents',
      group: groupNotCollected,
      body:
          'The camera and photo library are used only to scan a receipt. The image is held in memory for that scan, then discarded. Receipt files are not saved in the app database.',
    ),
    PrivacyPolicySection(
      title: 'Analytics',
      group: groupProduct,
      body:
          'Product analytics may record event names such as app opened or paywall viewed. Allowed details are limited to plan, source, success, and reminder kind. Amounts, merchants, and documents are stripped before anything is recorded.',
    ),
    PrivacyPolicySection(
      title: 'Purchases',
      group: groupProduct,
      body:
          'Pro is sold through the App Store. Apple and the billing provider validate the purchase. This app never stores an AI API key or a RevenueCat secret key. Public store identifiers may be used to restore purchases.',
    ),
    PrivacyPolicySection(
      title: 'Ads',
      group: groupProduct,
      body:
          'Free users may see a labeled banner on browsing screens. Ads are not shown during add, edit, scan, cancellation, paywall, or other sensitive money flows.',
    ),
    PrivacyPolicySection(
      title: 'AI processing',
      group: groupProduct,
      body:
          'Money math stays in the app. When a server is connected later, OCR and AI explanations will run there. Flutter will not contain AI API secrets.',
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
          'You can delete the data on this device in Settings. Delete account removes the same local data. There is no cloud account yet, so a server deletion request is queued for when cloud sync exists. App Store subscriptions are billed by Apple and are not cancelled by deleting app data.',
    ),
    PrivacyPolicySection(
      title: 'Contact',
      group: groupControl,
      body:
          'Until a public support email is published, use App Store support for this app. A hosted privacy policy URL will be added before App Store submission.',
    ),
  ];
}
