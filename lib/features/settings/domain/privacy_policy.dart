class PrivacyPolicySection {
  const PrivacyPolicySection({required this.title, required this.body});

  final String title;
  final String body;
}

/// In-app privacy policy. Keep this English-only for V1.
abstract final class PrivacyPolicy {
  static const String title = 'Privacy Policy';
  static const String lastUpdated = 'August 22, 2026';

  static const List<PrivacyPolicySection> sections = [
    PrivacyPolicySection(
      title: 'Overview',
      body:
          'BillKiller AI is an AI money leak detector. This version stores your subscription data on this device. We collect as little as we can and do not send receipts or money amounts to analytics.',
    ),
    PrivacyPolicySection(
      title: 'Data stored on this device',
      body:
          'Subscriptions, trials, usage counts, and onboarding answers stay in local storage on your phone. They are used to calculate spend, upcoming payments, and savings suggestions.',
    ),
    PrivacyPolicySection(
      title: 'Data we do not collect',
      body:
          'We do not ask for bank logins. We do not keep raw receipt images after a scan. We do not put financial amounts, merchant names, or documents into analytics.',
    ),
    PrivacyPolicySection(
      title: 'Receipts and documents',
      body:
          'The camera and photo library are used only to scan a receipt. The image is held in memory for that scan, then discarded. Receipt files are not saved in the app database.',
    ),
    PrivacyPolicySection(
      title: 'Analytics',
      body:
          'Product analytics may record event names such as app opened or paywall viewed. Allowed details are limited to plan, source, success, and reminder kind. Amounts, merchants, and documents are stripped before anything is recorded.',
    ),
    PrivacyPolicySection(
      title: 'Purchases',
      body:
          'Pro is sold through the App Store. Apple and the billing provider validate the purchase. This app never stores an AI API key or a RevenueCat secret key. Public store identifiers may be used to restore purchases.',
    ),
    PrivacyPolicySection(
      title: 'Ads',
      body:
          'Free users may see a labeled banner on browsing screens. Ads are not shown during add, edit, scan, cancellation, paywall, or other sensitive money flows.',
    ),
    PrivacyPolicySection(
      title: 'AI processing',
      body:
          'Money math stays in the app. When a server is connected later, OCR and AI explanations will run there. Flutter will not contain AI API secrets.',
    ),
    PrivacyPolicySection(
      title: 'Sharing',
      body:
          'This version does not upload your subscription list to a BillKiller account. Outbound links use HTTPS only.',
    ),
    PrivacyPolicySection(
      title: 'Deletion',
      body:
          'You can delete the data on this device in Settings. Delete account removes the same local data. There is no cloud account yet, so a server deletion request is queued for when cloud sync exists. App Store subscriptions are billed by Apple and are not cancelled by deleting app data.',
    ),
    PrivacyPolicySection(
      title: 'Contact',
      body:
          'Until a public support email is published, use App Store support for this app. A hosted privacy policy URL will be added before App Store submission.',
    ),
  ];
}
