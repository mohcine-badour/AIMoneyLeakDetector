import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/brand/brand_registry.dart';
import 'package:kichta/features/subscriptions/domain/subscription_catalog.dart';

void main() {
  test('catalog has unique slugs and about 150 services', () {
    final slugs = SubscriptionCatalog.all.map((service) => service.slug);
    expect(slugs.toSet().length, slugs.length);
    expect(SubscriptionCatalog.all.length, greaterThanOrEqualTo(140));
    expect(SubscriptionCatalog.all.length, lessThan(180));
    for (final slug in SubscriptionCatalog.popularSlugs) {
      expect(SubscriptionCatalog.bySlug[slug], isNotNull, reason: slug);
    }
  });

  test('search can finds Canva Pro first', () {
    final results = SubscriptionCatalog.search('Can');
    expect(results, isNotEmpty);
    expect(results.first.slug, 'canvapro');
    expect(results.first.name, 'Canva Pro');
    expect(
      results.map((service) => service.slug),
      isNot(contains('netflix')),
    );
  });

  test('aliases map receipt text onto the canonical service', () {
    expect(SubscriptionCatalog.match('NETFLIX.COM/AMSTERDAM')?.slug, 'netflix');
    expect(SubscriptionCatalog.match('SPOTIFY AB')?.slug, 'spotify');
    expect(SubscriptionCatalog.match('SPOTIFY USA')?.name, 'Spotify');
    expect(
      SubscriptionCatalog.slugFor(name: 'Amazon Prime Video'),
      'amazonprimevideo',
    );
    expect(SubscriptionCatalog.slugFor(name: 'Amazon Prime'), 'amazonprime');
    expect(
      SubscriptionCatalog.brandForSlug('canvapro')?.displayName,
      'Canva Pro',
    );
    expect(
      SubscriptionCatalog.brandForSlug('canvapro')?.category,
      BrandCategory.productivity,
    );
  });
}
