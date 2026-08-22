import '../../../core/brand/brand_registry.dart';
import '../../subscriptions/domain/subscription.dart';

enum InsightKind { unused, priceHike, overlap, yearlyRenewal, wrongCycle }

class InsightItem {
  const InsightItem({
    required this.id,
    required this.kind,
    required this.featured,
    this.subscriptions = const [],
    this.category,
    this.daysUnused,
    this.monthlySavings,
    this.delta,
    this.daysUntil,
    this.renewalAmount,
    this.potentialSavings,
  });

  final String id;
  final InsightKind kind;
  final Subscription featured;
  final List<Subscription> subscriptions;
  final BrandCategory? category;
  final int? daysUnused;
  final double? monthlySavings;
  final double? delta;
  final int? daysUntil;
  final double? renewalAmount;
  final double? potentialSavings;

  int get priority => switch (kind) {
    InsightKind.unused => 0,
    InsightKind.priceHike => 1,
    InsightKind.overlap => 2,
    InsightKind.yearlyRenewal => 3,
    InsightKind.wrongCycle => 4,
  };

  Set<String> get involvedIds => {
    featured.id,
    for (final item in subscriptions) item.id,
  };
}
