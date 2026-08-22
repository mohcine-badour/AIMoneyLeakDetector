import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../domain/privacy_policy.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final groups = <String, List<PrivacyPolicySection>>{};
    for (final section in PrivacyPolicy.sections) {
      groups.putIfAbsent(section.group, () => []).add(section);
    }

    return AppScaffold(
      title: AppStrings.privacyPolicy,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.lg,
      ),
      body: ListView(
        children: [
          const _DateChip(),
          const SizedBox(height: 10),
          Text(
            AppStrings.privacyMinimalCollection,
            style: TextStyle(
              fontSize: 13.5,
              height: 1.4,
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final entry in groups.entries) ...[
            _GroupLabel(entry.key),
            const SizedBox(height: AppSpacing.sm),
            _GroupCard(sections: entry.value),
            const SizedBox(height: AppSpacing.xl),
          ],
        ],
      ),
    );
  }
}

class _DateChip extends StatelessWidget {
  const _DateChip();

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.fromLTRB(10, 8, 12, 8),
        decoration: BoxDecoration(
          color: tokens.indigoBg,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: tokens.borderIndigo, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(AppIcons.upcoming, size: 14, color: tokens.indigoText),
            const SizedBox(width: 6),
            Text(
              AppStrings.privacyLastUpdated,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: tokens.indigoText.withValues(alpha: 0.85),
              ),
            ),
            Text(
              '  ·  ',
              style: TextStyle(fontSize: 12, color: tokens.indigoText),
            ),
            Text(
              PrivacyPolicy.lastUpdated,
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: tokens.indigoText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GroupLabel extends StatelessWidget {
  const _GroupLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Text(
      label.toUpperCase(),
      style: TextStyle(
        fontSize: 10.5,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        color: tokens.textMuted,
      ),
    );
  }
}

class _GroupCard extends StatelessWidget {
  const _GroupCard({required this.sections});

  final List<PrivacyPolicySection> sections;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: tokens.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (var i = 0; i < sections.length; i++) ...[
            if (i > 0) Divider(height: 1, color: tokens.border),
            _SectionRow(section: sections[i]),
          ],
        ],
      ),
    );
  }
}

class _SectionRow extends StatelessWidget {
  const _SectionRow({required this.section});

  final PrivacyPolicySection section;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: tokens.bgMuted,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              _iconFor(section.title),
              size: 16,
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.15,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  section.body,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.45,
                    color: tokens.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

IconData _iconFor(String title) {
  return switch (title) {
    'Overview' => AppIcons.lock,
    'Data stored on this device' => AppIcons.empty,
    'Data we do not collect' => AppIcons.shieldCheck,
    'Receipts and documents' => AppIcons.scan,
    'Analytics' => AppIcons.chartBar,
    'Purchases' => AppIcons.apple,
    'Ads' => AppIcons.ads,
    'AI processing' => AppIcons.sparkles,
    'Sharing' => AppIcons.share,
    'Deletion' => AppIcons.delete,
    'Contact' => AppIcons.mail,
    _ => AppIcons.info,
  };
}
