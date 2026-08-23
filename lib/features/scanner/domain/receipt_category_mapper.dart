import '../../../core/brand/brand_registry.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/domain/subscription_brand.dart';

/// Deterministic merchant → category mapping. Do not use AI for this.
abstract final class ReceiptCategoryMapper {
  static SubscriptionCategory fromMerchant(String merchant) {
    final slug = BrandRegistry.slugFor(name: merchant, merchant: merchant);
    final brand = BrandRegistry.getBrand(slug);
    if (brand != null) {
      return SubscriptionBrand.storedCategory(brand.category);
    }
    return switch (merchant.trim().toLowerCase()) {
      'netflix' ||
      'hulu' ||
      'spotify' ||
      'disney+' => SubscriptionCategory.entertainment,
      _ => SubscriptionCategory.other,
    };
  }
}
