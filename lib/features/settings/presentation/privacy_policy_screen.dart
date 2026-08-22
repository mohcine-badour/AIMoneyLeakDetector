import 'package:flutter/material.dart';

import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../domain/privacy_policy.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: AppStrings.privacyPolicy,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: ListView(
        children: [
          Text(
            '${AppStrings.privacyLastUpdated} ${PrivacyPolicy.lastUpdated}',
            style: textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xl),
          for (var i = 0; i < PrivacyPolicy.sections.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    PrivacyPolicy.sections[i].title,
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    PrivacyPolicy.sections[i].body,
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}
