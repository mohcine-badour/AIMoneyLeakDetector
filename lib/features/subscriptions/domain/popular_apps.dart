import '../../../core/brand/brand_registry.dart';
import '../../welcome/domain/featured_brands.dart';

/// Curated add-form shortcuts. Recognition order, not alphabet.
abstract final class PopularApps {
  static const List<String> slugs = [
    ...FeaturedBrands.slugs,
    'hbo',
    'applemusic',
    'hulu',
    'amazonprimevideo',
    'dropbox',
    'googledrive',
    'slack',
    'discord',
    'github',
    'twitch',
    'paramount',
    'audible',
    'nytimes',
    'headspace',
    'peloton',
    'strava',
    'linear',
    'patreon',
    'substack',
  ];

  static String tileLabel(Brand brand) {
    return switch (brand.slug) {
      'openai' => 'ChatGPT',
      'youtube' => 'YouTube',
      'adobecreativecloud' => 'Adobe',
      'amazonprimevideo' => 'Prime',
      'applemusic' => 'Music',
      'googledrive' => 'Drive',
      'discord' => 'Discord',
      'nytimes' => 'NYT',
      'paramountplus' => 'Paramount+',
      _ => brand.displayName,
    };
  }
}
