import '../../../core/brand/brand_registry.dart';
import 'subscription_catalog.dart';

/// Curated add-form shortcuts. Recognition order, not alphabet.
abstract final class PopularApps {
  static const List<String> slugs = SubscriptionCatalog.popularSlugs;

  static List<Brand> get popular {
    return [
      for (final service in SubscriptionCatalog.popular)
        SubscriptionCatalog.brandFor(service),
    ];
  }

  static List<Brand> get catalog {
    return [
      for (final service in SubscriptionCatalog.all)
        SubscriptionCatalog.brandFor(service),
    ];
  }

  static String tileLabel(Brand brand) {
    return switch (brand.slug) {
      'openai' => 'ChatGPT',
      'youtube' => 'YouTube',
      'adobecreativecloud' => 'Adobe',
      'amazonprime' => 'Prime',
      'amazonprimevideo' => 'Prime Video',
      'applemusic' => 'Music',
      'googledrive' => 'Google One',
      'discord' => 'Discord',
      'nytimes' => 'NYT',
      'paramountplus' => 'Paramount+',
      _ => brand.displayName,
    };
  }
}
