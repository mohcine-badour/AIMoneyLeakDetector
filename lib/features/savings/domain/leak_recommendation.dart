enum LeakKind {
  trialConversion,
  upcomingRenewal,
  overlappingCategory,
  suspiciousDuplicate,
  expensive,
  lowUsage,
}

class LeakRecommendation {
  const LeakRecommendation({
    required this.kind,
    required this.title,
    required this.reason,
    this.subscriptionId,
    this.trialId,
  });

  final LeakKind kind;
  final String title;
  final String reason;
  final String? subscriptionId;
  final String? trialId;
}
