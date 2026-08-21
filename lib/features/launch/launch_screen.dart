import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';

/// Minimal branded launch screen shown on first open.
///
/// The Get Started CTA is visual only. Onboarding is added later.
class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
          child: Column(
            children: [
              const Spacer(flex: 3),
              const _BrandMark(),
              const SizedBox(height: AppSpacing.xxl),
              Text(
                AppStrings.appName,
                textAlign: TextAlign.center,
                style: textTheme.displaySmall,
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                AppStrings.tagline,
                textAlign: TextAlign.center,
                style: textTheme.titleMedium,
              ),
              const Spacer(flex: 4),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: _onGetStarted,
                  child: const Text(AppStrings.getStarted),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  void _onGetStarted() {
    // Onboarding is implemented in a later step.
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppSpacing.brandMark,
      height: AppSpacing.brandMark,
      decoration: const BoxDecoration(
        color: AppColors.navy,
        borderRadius: AppRadius.mark,
      ),
      child: const Icon(
        Icons.trending_down_rounded,
        color: AppColors.onNavy,
        size: AppSpacing.xxl,
      ),
    );
  }
}
