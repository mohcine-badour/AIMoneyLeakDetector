import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_colors.dart';
import '../../core/constants/app_icons.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import '../../core/constants/app_strings.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_scaffold.dart';

class LaunchScreen extends StatelessWidget {
  const LaunchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.page),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Spacer(flex: 2),
          const _BrandMark(),
          const SizedBox(height: AppSpacing.xl),
          Text(AppStrings.appName, style: textTheme.headlineMedium),
          const SizedBox(height: AppSpacing.md),
          Text(AppStrings.tagline, style: textTheme.titleMedium),
          const Spacer(flex: 3),
          AppButton(
            label: AppStrings.getStarted,
            onPressed: () => context.push(AppRoutes.onboarding),
          ),
          const SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
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
        AppIcons.savings,
        color: AppColors.onNavy,
        size: AppIcons.lg,
      ),
    );
  }
}
