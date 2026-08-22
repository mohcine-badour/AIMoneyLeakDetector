/// Privacy implications of every runtime package. Keep in sync with pubspec.yaml.
class PackagePrivacyNote {
  const PackagePrivacyNote({
    required this.package,
    required this.purpose,
    required this.data,
    required this.leavesDevice,
  });

  final String package;
  final String purpose;
  final String data;
  final bool leavesDevice;
}

abstract final class PackagePrivacyReview {
  static const List<PackagePrivacyNote> notes = [
    PackagePrivacyNote(
      package: 'drift',
      purpose: 'Local SQLite subscriptions, trials, and usage',
      data: 'Merchant names, amounts, dates, and usage counts on device',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'drift_flutter',
      purpose: 'On-device Drift database',
      data: 'Same local records as drift',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'flutter_local_notifications',
      purpose: 'Trial and renewal reminders',
      data: 'Notification title and body on device; no remote push',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'flutter_riverpod',
      purpose: 'In-memory app state',
      data: 'Does not persist or transmit user data',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'flutter_timezone',
      purpose: 'Local timezone for reminder clocks',
      data: 'Device timezone identifier',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'go_router',
      purpose: 'In-app navigation',
      data: 'Does not persist or transmit user data',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'image_picker',
      purpose: 'Camera or photo library for a receipt scan',
      data: 'Temporary image bytes for the current scan',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'shared_preferences',
      purpose: 'Onboarding flags and simple settings',
      data: 'Non-secret preferences. Never used for tokens or receipts',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'timezone',
      purpose: 'Reminder wall-clock conversion',
      data: 'Does not persist user financial records',
      leavesDevice: false,
    ),
    PackagePrivacyNote(
      package: 'purchases_flutter',
      purpose: 'App Store purchase, restore, and entitlement status',
      data: 'Store account and receipt validation via RevenueCat/Apple',
      leavesDevice: true,
    ),
    PackagePrivacyNote(
      package: 'url_launcher',
      purpose: 'Open official cancellation pages and future policy URLs',
      data: 'HTTPS URLs only; no request body',
      leavesDevice: true,
    ),
    PackagePrivacyNote(
      package: 'flutter_svg',
      purpose: 'Draw bundled brand logos on subscription tiles',
      data: 'SVG path data shipped in the app. No network calls',
      leavesDevice: false,
    ),
  ];

  static Set<String> get packageNames => {
    for (final note in notes) note.package,
  };
}
