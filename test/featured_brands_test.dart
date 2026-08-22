import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/brand/brand_registry.dart';
import 'package:kichta/features/welcome/domain/featured_brands.dart';

void main() {
  test('featured slugs stay in registry in the intended order', () {
    expect(FeaturedBrands.slugs, [
      'netflix',
      'spotify',
      'openai',
      'icloud',
      'youtube',
      'adobecreativecloud',
      'notion',
      'figma',
      'disneyplus',
    ]);
    for (final slug in FeaturedBrands.slugs) {
      expect(BrandRegistry.bySlug.containsKey(slug), isTrue, reason: slug);
    }
    expect(
      FeaturedBrands.slugs.toSet().length,
      FeaturedBrands.slugs.length,
    );
    expect(
      FeaturedBrands.row1.length + FeaturedBrands.row2.length + 1,
      lessThanOrEqualTo(FeaturedBrands.maxTiles),
    );
  });

  test('other count is rounded down to the nearest 10 from the registry', () {
    final remaining = BrandRegistry.bySlug.length - FeaturedBrands.slugs.length;
    expect(FeaturedBrands.otherCount, (remaining ~/ 10) * 10);
    expect(FeaturedBrands.otherCount, isNot(240));
  });
}
