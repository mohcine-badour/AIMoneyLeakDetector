import 'legal_identity.dart';

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
///
/// Written to App Store Review Guideline 5.1.1(i): name the data, how it is
/// collected, every use, every third party, equal protection, retention,
/// and how to revoke consent or delete.
abstract final class PrivacyPolicy {
  static const String title = 'Privacy Policy';
  static const String lastUpdated = 'August 23, 2026';
  static const String hostedUrl =
      'https://mohcine-badour.github.io/AIMoneyLeakDetector/privacy.html';

  static const String groupWho = 'Who we are';
  static const String groupDevice = 'On this device';
  static const String groupNotCollected = 'What we do not collect';
  static const String groupLeavesDevice = 'Data that leaves this device';
  static const String groupControl = 'Your control';
  static const String groupRules = 'Children and other rules';

  static const List<PrivacyPolicySection> sections = [
    PrivacyPolicySection(
      title: 'Who provides Kichta',
      group: groupWho,
      body:
          'Kichta is a local subscription tracker published by ${LegalIdentity.publisher} on the Apple App Store. There is no parent company and no Kichta cloud account in this version.',
    ),
    PrivacyPolicySection(
      title: 'Contact',
      group: groupWho,
      body:
          'Privacy questions: email ${LegalIdentity.email}. You can also use the Support page or the Support row in Settings. Privacy Policy and Terms of Use are in Settings and at the public URL listed in App Store Connect.',
    ),
    PrivacyPolicySection(
      title: 'Overview',
      group: groupDevice,
      body:
          'Kichta tracks subscriptions on this device. We collect as little as we can and do not send receipts or money amounts off this device. Kichta does not require an account or authentication.',
    ),
    PrivacyPolicySection(
      title: 'Data stored on this device',
      group: groupDevice,
      body:
          'Subscriptions, trials, and usage counts are stored in an encrypted local database on your phone. The encryption key is stored in the iOS Keychain. Onboarding answers and the reminder preference are stored in local app preferences on this device. They are used to calculate spend, upcoming payments, and reminders. There is no Kichta account.',
    ),
    PrivacyPolicySection(
      title: 'How we collect it',
      group: groupDevice,
      body:
          'You type names, amounts, and dates, or you confirm them after a receipt scan. We do not import bank accounts or read other apps. Camera and photo library access are used only to scan a receipt. Notification permission is used only for local trial and renewal reminders.',
    ),
    PrivacyPolicySection(
      title: 'Receipts and documents',
      group: groupDevice,
      body:
          'The camera and photo library are used only to scan a receipt. Text is read on this phone. The image is held in memory for that scan, then discarded. Receipt files are not saved in the app database.',
    ),
    PrivacyPolicySection(
      title: 'Reminders',
      group: groupDevice,
      body:
          'Local notifications may show a subscription or trial name on the lock screen. Those titles stay on the device. Kichta does not send remote push notifications.',
    ),
    PrivacyPolicySection(
      title: 'Security',
      group: groupDevice,
      body:
          'Subscription records are stored in an encrypted database. The key is in the iOS Keychain. Outbound links use HTTPS only. This app does not allow cleartext HTTP.',
    ),
    PrivacyPolicySection(
      title: 'Data we do not collect',
      group: groupNotCollected,
      body:
          'We do not ask for bank logins. We do not create a Kichta account. We do not keep raw receipt images after a scan. We do not send financial amounts, merchant names, or documents off this device. We do not sell your personal data.',
    ),
    PrivacyPolicySection(
      title: 'Links you open',
      group: groupLeavesDevice,
      body:
          'Cancellation and Support open HTTPS pages in Safari. Those sites receive a normal web visit. We do not attach your subscription list to those requests.',
    ),
    PrivacyPolicySection(
      title: 'Third-party protection',
      group: groupLeavesDevice,
      body:
          'In this version the only parties that may receive data are sites you open such as the Support page. We confirm that any third party with whom this app shares user data will provide the same or equal protection of user data as stated in this policy and required by the App Store Review Guidelines.',
    ),
    PrivacyPolicySection(
      title: 'Retention',
      group: groupControl,
      body:
          'Data on this phone is kept until you delete it in Settings or uninstall Kichta. Uninstalling removes the local database and Keychain items for this app. We do not keep a server copy of your subscription list.',
    ),
    PrivacyPolicySection(
      title: 'Deletion',
      group: groupControl,
      body:
          'You can delete the data on this device in Settings with Delete my data. Deletion is immediate and local. There is no cloud account, so there is no separate account-deletion flow.',
    ),
    PrivacyPolicySection(
      title: 'Revoke consent',
      group: groupControl,
      body:
          'Turn off Reminders in Settings to stop local notifications, or disable notifications for Kichta in iOS Settings. Revoke camera or photo access in iOS Settings; scan will stop using them.',
    ),
    PrivacyPolicySection(
      title: 'Sharing',
      group: groupControl,
      body:
          'This version does not upload your subscription list to a Kichta account. We do not sell personal data. Outbound links use HTTPS only.',
    ),
    PrivacyPolicySection(
      title: 'Children',
      group: groupRules,
      body:
          'Kichta is not directed at children under 13, and we do not knowingly collect personal data from children. The app is not in the App Store Kids category. Do not use Kichta to store a child’s personal information.',
    ),
    PrivacyPolicySection(
      title: 'International transfers',
      group: groupRules,
      body:
          'Data you store in Kichta stays on this phone unless you open a link.',
    ),
    PrivacyPolicySection(
      title: 'Changes',
      group: groupRules,
      body:
          'If this policy changes, we update the in-app document, the public URL, and the last-updated date. Continued use after an update means you are using the app under the new policy.',
    ),
  ];
}
