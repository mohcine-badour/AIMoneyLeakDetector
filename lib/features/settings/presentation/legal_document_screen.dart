import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../cancellation/cancellation_providers.dart';
import '../domain/privacy_policy.dart';
import '../domain/terms_of_use.dart';

class LegalDocumentScreen extends ConsumerStatefulWidget {
  const LegalDocumentScreen({
    required this.title,
    required this.headline,
    required this.lastUpdated,
    required this.intro,
    required this.sections,
    super.key,
  });

  final String title;
  final String headline;
  final String lastUpdated;
  final String intro;
  final List<PrivacyPolicySection> sections;

  @override
  ConsumerState<LegalDocumentScreen> createState() =>
      _LegalDocumentScreenState();
}

class _LegalDocumentScreenState extends ConsumerState<LegalDocumentScreen> {
  final _groupKeys = <String, GlobalKey>{};

  Map<String, List<PrivacyPolicySection>> get _groups {
    final groups = <String, List<PrivacyPolicySection>>{};
    for (final section in widget.sections) {
      groups.putIfAbsent(section.group, () => []).add(section);
    }
    return groups;
  }

  bool get _isPrivacy => widget.title == AppStrings.privacyPolicy;

  Future<void> _jumpTo(String group) async {
    HapticFeedback.selectionClick();
    final context = _groupKeys.putIfAbsent(group, GlobalKey.new).currentContext;
    if (context == null) {
      return;
    }
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      alignment: 0.08,
    );
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final groups = _groups;

    return AppScaffold(
      title: widget.title,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.xxl,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          _HeroCard(
            isPrivacy: _isPrivacy,
            kicker: widget.title,
            headline: widget.headline,
            lastUpdated: widget.lastUpdated,
            intro: widget.intro,
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppStrings.legalOnThisPage,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final group in groups.keys)
                _JumpChip(
                  label: group,
                  icon: _LegalLook.iconForGroup(group),
                  onTap: () => _jumpTo(group),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          for (final entry in groups.entries) ...[
            _GroupBlock(
              key: _groupKeys.putIfAbsent(entry.key, GlobalKey.new),
              group: entry.key,
              sections: entry.value,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
          ],
        ),
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({
    required this.isPrivacy,
    required this.kicker,
    required this.headline,
    required this.lastUpdated,
    required this.intro,
  });

  final bool isPrivacy;
  final String kicker;
  final String headline;
  final String lastUpdated;
  final String intro;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
      decoration: BoxDecoration(
        color: tokens.bgCard,
        borderRadius: AppRadius.hero,
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: tokens.indigoBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isPrivacy ? AppIcons.lock : AppIcons.infinity,
                  size: 20,
                  color: tokens.indigoText,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      kicker.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: tokens.indigoText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${AppStrings.privacyLastUpdated}  ·  $lastUpdated',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.3,
                        color: tokens.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            headline,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.4,
              height: 1.2,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            intro,
            style: TextStyle(
              fontSize: 14.5,
              height: 1.45,
              color: tokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _JumpChip extends StatelessWidget {
  const _JumpChip({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.bgCard,
      borderRadius: BorderRadius.circular(999),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Container(
          padding: const EdgeInsets.fromLTRB(10, 7, 12, 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 13, color: tokens.textSecondary),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
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

class _GroupBlock extends StatelessWidget {
  const _GroupBlock({
    required this.group,
    required this.sections,
    super.key,
  });

  final String group;
  final List<PrivacyPolicySection> sections;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final icon = _LegalLook.iconForGroup(group);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: tokens.indigoText),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                group.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.55,
                  color: tokens.textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: tokens.bgCard,
            borderRadius: AppRadius.card,
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (var i = 0; i < sections.length; i++) ...[
                if (i > 0) Divider(height: 1, color: tokens.border),
                _SectionArticle(section: sections[i]),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionArticle extends StatelessWidget {
  const _SectionArticle({required this.section});

  final PrivacyPolicySection section;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: tokens.bgMuted,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              _LegalLook.iconForTitle(section.title),
              size: 14,
              color: tokens.textSecondary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: TextStyle(
                    fontSize: 15.5,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.25,
                    height: 1.25,
                    color: tokens.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                _LinkedBody(text: section.body),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LinkedBody extends ConsumerWidget {
  const _LinkedBody({required this.text});

  final String text;

  static final _links = RegExp(
    r'https://[^\s]+|[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}',
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final matches = _links.allMatches(text);
    if (matches.isEmpty) {
      return Text(
        text,
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: tokens.textSecondary,
        ),
      );
    }

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      final raw = match.group(0)!;
      final href = raw.replaceFirst(RegExp(r'[.,;:]+$'), '');
      final uri = href.contains('@') && !href.startsWith('http')
          ? Uri(scheme: 'mailto', path: href)
          : Uri.parse(href);
      spans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.baseline,
          baseline: TextBaseline.alphabetic,
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              if (uri.scheme == 'mailto') {
                launchUrl(uri);
              } else {
                ref.read(cancellationLinkOpenerProvider).open(uri);
              }
            },
            child: Text(
              href,
              style: TextStyle(
                fontSize: 14,
                height: 1.5,
                color: tokens.indigoText,
                decoration: TextDecoration.underline,
                decorationColor: tokens.indigoText.withValues(alpha: 0.45),
              ),
            ),
          ),
        ),
      );
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }

    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 14,
          height: 1.5,
          color: tokens.textSecondary,
        ),
        children: spans,
      ),
    );
  }
}

abstract final class _LegalLook {
  static IconData iconForGroup(String group) {
    return switch (group) {
      PrivacyPolicy.groupWho => AppIcons.mail,
      PrivacyPolicy.groupDevice => AppIcons.lock,
      PrivacyPolicy.groupNotCollected => AppIcons.visibilityOff,
      PrivacyPolicy.groupLeavesDevice => AppIcons.share,
      PrivacyPolicy.groupControl => AppIcons.delete,
      PrivacyPolicy.groupRules => AppIcons.shieldCheck,
      TermsOfUse.groupProduct => AppIcons.home,
      TermsOfUse.groupFree => AppIcons.infinity,
      TermsOfUse.groupLimits => AppIcons.close,
      TermsOfUse.groupRules => AppIcons.info,
      _ => AppIcons.info,
    };
  }

  static IconData iconForTitle(String title) {
    return switch (title) {
      'Contact' => AppIcons.mail,
      'Data stored on this device' || 'Security' || 'License' => AppIcons.lock,
      'How we collect it' || 'Your records' => AppIcons.edit,
      'Receipts and documents' => AppIcons.scan,
      'Reminders' => AppIcons.bellRinging,
      'Data we do not collect' => AppIcons.visibilityOff,
      'Analytics' => AppIcons.chartBar,
      'Ads' => AppIcons.ads,
      'App Store purchases' ||
      'App Store Privacy labels' ||
      'Who provides Kichta' => AppIcons.apple,
      'Links you open' || 'Sharing' || 'Third-party services' => AppIcons.share,
      'AI processing' => AppIcons.sparkles,
      'Third-party protection' ||
      'Children' ||
      'Eligibility' => AppIcons.shieldCheck,
      'Retention' || 'Changes' => AppIcons.upcoming,
      'Deletion' => AppIcons.delete,
      'Revoke consent' => AppIcons.visibility,
      'This version is free' => AppIcons.infinity,
      'Merchants' => AppIcons.close,
      'International transfers' => AppIcons.wifiOff,
      _ => AppIcons.info,
    };
  }
}
