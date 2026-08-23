import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_brand_icon.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../domain/onboarding_pages.dart';
import 'onboarding_icons.dart';

class OnboardingHeroShield extends ConsumerWidget {
  const OnboardingHeroShield({required this.payload, super.key});

  final HeroShieldPayload payload;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        children: [
          Text(
            OnboardingPages.exampleNotification.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              color: tokens.positiveBg,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x4D000000),
                  offset: Offset(0, 4),
                  blurRadius: 16,
                ),
              ],
            ),
            child: Icon(
              OnboardingIcon.shieldCheck.data,
              size: 44,
              color: tokens.positiveText,
            ),
          ),
          Transform.translate(
            offset: const Offset(20, -20),
            child: Transform.rotate(
              angle: 0.052,
              child: Align(
                alignment: Alignment.centerRight,
                child: _MockNotification(
                  payload: payload,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    ref.read(analyticsProvider).track(
                      AnalyticsEvent.onboardingTrialExampleTap,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MockNotification extends StatelessWidget {
  const _MockNotification({required this.payload, required this.onTap});

  final HeroShieldPayload payload;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.bgSubtle,
      elevation: 2,
      shadowColor: const Color(0x33000000),
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        key: const Key('onboarding-trial-notification'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const AppBrandIcon(size: 18),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      AppStrings.appName,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    OnboardingPages.now,
                    style: TextStyle(fontSize: 9, color: tokens.textMuted),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                OnboardingPages.trialNotificationBody(payload),
                style: TextStyle(
                  fontSize: 11,
                  height: 1.35,
                  color: tokens.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
