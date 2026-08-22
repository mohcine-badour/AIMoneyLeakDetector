import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../domain/onboarding_pages.dart';

class OnboardingHeroAi extends ConsumerWidget {
  const OnboardingHeroAi({required this.payload, super.key});

  final HeroAiPayload payload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          OnboardingPages.exampleInsight.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
            color: tokens.textMuted,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          decoration: BoxDecoration(
            color: tokens.warningBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: tokens.borderWarning, width: 0.5),
          ),
          child: Stack(
            children: [
              Positioned.fill(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        tokens.textPrimary.withValues(alpha: 0.06),
                        tokens.textPrimary.withValues(alpha: 0),
                      ],
                    ),
                  ),
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BrandIcon(slug: payload.brandSlug, size: 28),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payload.title,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.1,
                            color: tokens.warningText,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          payload.subtitle,
                          style: TextStyle(
                            fontSize: 11,
                            height: 1.4,
                            color: tokens.warningText.withValues(alpha: 0.85),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            _MockAction(
                              key: const Key('onboarding-example-review'),
                              label: OnboardingPages.review,
                              filled: true,
                              color: tokens.warningText,
                              onTap: () => _tap(ref, 'review'),
                            ),
                            const SizedBox(width: 6),
                            _MockAction(
                              key: const Key('onboarding-example-dismiss'),
                              label: OnboardingPages.dismiss,
                              filled: false,
                              color: tokens.warningText.withValues(alpha: 0.7),
                              onTap: () => _tap(ref, 'dismiss'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _tap(WidgetRef ref, String action) {
    HapticFeedback.selectionClick();
    ref.read(analyticsProvider).track(
      AnalyticsEvent.onboardingExampleTap,
      properties: {'kind': action},
    );
  }
}

class _MockAction extends StatelessWidget {
  const _MockAction({
    required this.label,
    required this.filled,
    required this.color,
    required this.onTap,
    super.key,
  });

  final String label;
  final bool filled;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? color.withValues(alpha: 0.12) : Colors.transparent,
      borderRadius: BorderRadius.circular(6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: color,
            ),
          ),
        ),
      ),
    );
  }
}
