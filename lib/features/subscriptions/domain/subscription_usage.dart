class SubscriptionUsage {
  const SubscriptionUsage({
    required this.subscriptionId,
    required this.useCount,
    required this.updatedAt,
  });

  factory SubscriptionUsage.create({
    required String subscriptionId,
    required int useCount,
    DateTime? updatedAt,
  }) {
    return SubscriptionUsage(
      subscriptionId: subscriptionId,
      useCount: useCount,
      updatedAt: updatedAt ?? DateTime.now().toUtc(),
    );
  }

  final String subscriptionId;
  final int useCount;
  final DateTime updatedAt;

  SubscriptionUsage copyWith({
    int? useCount,
    DateTime? updatedAt,
  }) {
    return SubscriptionUsage(
      subscriptionId: subscriptionId,
      useCount: useCount ?? this.useCount,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
