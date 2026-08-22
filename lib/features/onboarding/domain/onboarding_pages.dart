import '../../../core/utils/money_format.dart';
import '../../welcome/domain/featured_brands.dart';

enum OnboardingPageId { awareness, capability, intelligence, safety }

enum OnboardingCompleteVia { skip, ctaFinal }

extension OnboardingCompleteViaX on OnboardingCompleteVia {
  String get source => switch (this) {
    OnboardingCompleteVia.skip => 'skip',
    OnboardingCompleteVia.ctaFinal => 'cta_final',
  };
}

enum OnboardingAdvanceMethod { cta, swipe }

extension OnboardingAdvanceMethodX on OnboardingAdvanceMethod {
  String get source => name;
}

enum OnboardingIcon {
  chartBar,
  apps,
  sparkles,
  shieldCheck,
  arrowRight,
  check,
  info,
  swipe,
}

class OnboardingCategoryBadgeData {
  const OnboardingCategoryBadgeData({required this.label, required this.icon});

  final String label;
  final OnboardingIcon icon;
}

class RealityCheckBar {
  const RealityCheckBar({required this.label, required this.amount});

  final String label;
  final double amount;
}

class RealityCheckPayload {
  const RealityCheckPayload({required this.estimated, required this.actual});

  final RealityCheckBar estimated;
  final RealityCheckBar actual;

  /// Estimated bar width as a fraction of the actual (100%) bar.
  double get estimatedFraction {
    if (actual.amount <= 0) {
      return 0;
    }
    return (estimated.amount / actual.amount).clamp(0.0, 1.0);
  }
}

sealed class OnboardingHero {
  const OnboardingHero();
}

class HeroStatPayload extends OnboardingHero {
  const HeroStatPayload({
    required this.value,
    required this.interval,
    this.realityCheck,
  });

  final String value;
  final String interval;
  final RealityCheckPayload? realityCheck;
}

class HeroBrandGridPayload extends OnboardingHero {
  const HeroBrandGridPayload({
    required this.featuredSlugs,
    required this.moreCount,
  });

  final List<String> featuredSlugs;
  final int moreCount;
}

class HeroAiPayload extends OnboardingHero {
  const HeroAiPayload({
    required this.brandSlug,
    required this.title,
    required this.subtitle,
  });

  final String brandSlug;
  final String title;
  final String subtitle;
}

class HeroShieldPayload extends OnboardingHero {
  const HeroShieldPayload({
    required this.exampleTrialName,
    required this.exampleTrialDaysLeft,
    required this.exampleTrialAmountCents,
  });

  final String exampleTrialName;
  final int exampleTrialDaysLeft;
  final int exampleTrialAmountCents;

  double get exampleTrialAmount => exampleTrialAmountCents / 100;
}

class OnboardingPage {
  const OnboardingPage({
    required this.id,
    required this.categoryBadge,
    required this.setupLine,
    required this.hero,
    required this.body,
    required this.ctaLabel,
    this.source,
    this.ctaIcon,
  });

  final OnboardingPageId id;
  final OnboardingCategoryBadgeData categoryBadge;
  final String setupLine;
  final OnboardingHero hero;
  final String body;
  final String? source;
  final String ctaLabel;
  final OnboardingIcon? ctaIcon;
}

/// Single source of truth for walkthrough copy. Do not inline strings in widgets.
abstract final class OnboardingPages {
  static const String skip = 'Skip';
  static const String swipeHint = 'Swipe or tap to continue';
  static const String realityCheck = 'The reality check';
  static const String exampleInsight = 'Example insight';
  static const String now = 'Now';
  static const String review = 'Review';
  static const String dismiss = 'Dismiss';
  static const String sourcePrefix = 'Source:';

  static String sourceLine(String source) => '$sourcePrefix $source';

  static String trialNotificationBody(HeroShieldPayload payload) {
    final unit = payload.exampleTrialDaysLeft == 1 ? 'day' : 'days';
    return '${payload.exampleTrialName} trial ends in '
        '${payload.exampleTrialDaysLeft} $unit. Tap to keep it or cancel.';
  }

  static final List<OnboardingPage> all = [
    OnboardingPage(
      id: OnboardingPageId.awareness,
      categoryBadge: const OnboardingCategoryBadgeData(
        label: 'The gap',
        icon: OnboardingIcon.chartBar,
      ),
      setupLine:
          'The average person underestimates their subscription spend by',
      hero: HeroStatPayload(
        value: MoneyFormat.short(133),
        interval: '/mo',
        realityCheck: const RealityCheckPayload(
          estimated: RealityCheckBar(
            label: 'What most think they spend',
            amount: 86,
          ),
          actual: RealityCheckBar(
            label: 'What they actually spend',
            amount: 219,
          ),
        ),
      ),
      body:
          "That's ${MoneyFormat.short(1596)} a year on services people already forgot they had.",
      source: 'C+R Research, 2022',
      ctaLabel: 'See mine',
      ctaIcon: OnboardingIcon.arrowRight,
    ),
    OnboardingPage(
      id: OnboardingPageId.capability,
      categoryBadge: const OnboardingCategoryBadgeData(
        label: 'One place',
        icon: OnboardingIcon.apps,
      ),
      setupLine: 'Every subscription, every renewal — visible at last.',
      hero: HeroBrandGridPayload(
        featuredSlugs: FeaturedBrands.slugs.take(8).toList(),
        moreCount: FeaturedBrands.otherCount,
      ),
      body:
          'Netflix, Spotify, ChatGPT, iCloud — and more out of the box. Or add anything custom.',
      ctaLabel: 'Next',
      ctaIcon: OnboardingIcon.arrowRight,
    ),
    const OnboardingPage(
      id: OnboardingPageId.intelligence,
      categoryBadge: OnboardingCategoryBadgeData(
        label: 'Insights',
        icon: OnboardingIcon.sparkles,
      ),
      setupLine: 'Most people pay for overlapping apps in the same category.',
      hero: HeroAiPayload(
        brandSlug: 'netflix',
        title: 'Netflix and Hulu in the same month',
        subtitle:
            'Overlapping entertainment is common. Review before both renew.',
      ),
      body:
          'Kichta flags overlapping services and large yearly renewals from what you entered. It does not watch whether you opened an app.',
      ctaLabel: 'Next',
      ctaIcon: OnboardingIcon.arrowRight,
    ),
    const OnboardingPage(
      id: OnboardingPageId.safety,
      categoryBadge: OnboardingCategoryBadgeData(
        label: 'Never surprised',
        icon: OnboardingIcon.shieldCheck,
      ),
      setupLine:
          'Free trials that auto-charge are how apps quietly win. Not on our watch.',
      hero: HeroShieldPayload(
        exampleTrialName: 'Disney+',
        exampleTrialDaysLeft: 2,
        exampleTrialAmountCents: 1099,
      ),
      body:
          'Get a reminder before a free trial ends. Kichta does not cancel for you — you finish on their site.',
      ctaLabel: "I'm in",
      ctaIcon: OnboardingIcon.check,
    ),
  ];
}
