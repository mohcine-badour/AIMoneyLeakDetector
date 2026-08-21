import '../../subscriptions/domain/subscription.dart';

/// Deterministic merchant → category mapping. Do not use AI for this.
abstract final class ReceiptCategoryMapper {
  static SubscriptionCategory fromMerchant(String merchant) {
    return switch (merchant.trim().toLowerCase()) {
      'netflix' || 'hulu' || 'spotify' || 'disney+' =>
        SubscriptionCategory.entertainment,
      _ => SubscriptionCategory.other,
    };
  }
}
