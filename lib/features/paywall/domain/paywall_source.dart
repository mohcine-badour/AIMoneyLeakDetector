enum PaywallSource {
  unlimitedGate,
  aiGate,
  settings,
  onboarding,
  insightCta,
  scannerGate,
}

extension PaywallSourceX on PaywallSource {
  String get query => switch (this) {
    PaywallSource.unlimitedGate => 'unlimited_gate',
    PaywallSource.aiGate => 'ai_gate',
    PaywallSource.settings => 'settings',
    PaywallSource.onboarding => 'onboarding',
    PaywallSource.insightCta => 'insight_cta',
    PaywallSource.scannerGate => 'scanner_gate',
  };

  static PaywallSource parse(String? raw) {
    for (final value in PaywallSource.values) {
      if (value.query == raw || value.name == raw) {
        return value;
      }
    }
    return PaywallSource.settings;
  }
}
