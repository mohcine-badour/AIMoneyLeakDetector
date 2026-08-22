import '../../../core/brand/brand_registry.dart';
import 'subscription.dart';

/// Brand registry wins. Stored "Software" never appears in the UI.
abstract final class SubscriptionBrand {
  static const orderedCategories = [
    BrandCategory.entertainment,
    BrandCategory.music,
    BrandCategory.ai,
    BrandCategory.productivity,
    BrandCategory.storage,
    BrandCategory.news,
    BrandCategory.fitness,
    BrandCategory.gaming,
    BrandCategory.developer,
    BrandCategory.other,
  ];

  static String slugFor(Subscription subscription) {
    return BrandRegistry.slugFor(
      name: subscription.name,
      merchant: subscription.merchant,
    );
  }

  static Brand? brandFor(Subscription subscription) {
    return BrandRegistry.getBrand(slugFor(subscription));
  }

  static BrandCategory categoryFor(Subscription subscription) {
    return brandFor(subscription)?.category ??
        fromStored(subscription.category);
  }

  static BrandCategory fromStored(SubscriptionCategory category) {
    return switch (category) {
      SubscriptionCategory.entertainment => BrandCategory.entertainment,
      SubscriptionCategory.productivity => BrandCategory.productivity,
      SubscriptionCategory.cloudStorage => BrandCategory.storage,
      SubscriptionCategory.fitness => BrandCategory.fitness,
      SubscriptionCategory.news => BrandCategory.news,
      SubscriptionCategory.gaming => BrandCategory.gaming,
      SubscriptionCategory.education ||
      SubscriptionCategory.software ||
      SubscriptionCategory.finance ||
      SubscriptionCategory.other => BrandCategory.other,
    };
  }

  static SubscriptionCategory storedCategory(BrandCategory category) {
    return switch (category) {
      BrandCategory.entertainment ||
      BrandCategory.music => SubscriptionCategory.entertainment,
      BrandCategory.productivity ||
      BrandCategory.developer ||
      BrandCategory.ai => SubscriptionCategory.productivity,
      BrandCategory.storage => SubscriptionCategory.cloudStorage,
      BrandCategory.fitness => SubscriptionCategory.fitness,
      BrandCategory.news => SubscriptionCategory.news,
      BrandCategory.gaming => SubscriptionCategory.gaming,
      BrandCategory.other => SubscriptionCategory.other,
    };
  }
}
