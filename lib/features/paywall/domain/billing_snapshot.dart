/// Store-validated billing facts. Map these in Dart; do not trust a local flag.
class BillingSnapshot {
  const BillingSnapshot({
    this.hasEntitlementRecord = false,
    this.isActive = false,
    this.willRenew = false,
    this.hasBillingIssue = false,
    this.isIntroductory = false,
    this.expiresAt,
    this.productId,
  });

  final bool hasEntitlementRecord;
  final bool isActive;
  final bool willRenew;
  final bool hasBillingIssue;
  final bool isIntroductory;
  final DateTime? expiresAt;
  final String? productId;
}
