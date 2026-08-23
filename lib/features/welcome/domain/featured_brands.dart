import '../../subscriptions/domain/subscription_catalog.dart';

/// Curated Works With tiles. Order is for recognition, not alphabet or category.
abstract final class FeaturedBrands {
  static const List<String> slugs = [
    'netflix',
    'spotify',
    'openai',
    'icloud',
    'youtube',
    'adobecreativecloud',
    'notion',
    'figma',
    'disneyplus',
  ];

  static const int gridColumns = 5;
  static const int gridRows = 2;
  static const int maxTiles = 10;

  static List<String> get row1 => slugs.sublist(0, 5);

  static List<String> get row2 => slugs.sublist(5);

  /// Remaining catalog services, rounded down to the nearest 10.
  static int get otherCount {
    final remaining = SubscriptionCatalog.all.length - slugs.length;
    if (remaining <= 0) {
      return 0;
    }
    return (remaining ~/ 10) * 10;
  }
}
