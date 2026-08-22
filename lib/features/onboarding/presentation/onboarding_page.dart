import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../domain/onboarding_pages.dart';
import 'onboarding_category_badge.dart';
import 'onboarding_hero_ai.dart';
import 'onboarding_hero_brand_grid.dart';
import 'onboarding_hero_shield.dart';
import 'onboarding_hero_stat.dart';
import 'onboarding_icons.dart';

class OnboardingPageView extends StatelessWidget {
  const OnboardingPageView({
    required this.page,
    required this.heroShown,
    required this.onHeroShown,
    super.key,
  });

  final OnboardingPage page;
  final bool heroShown;
  final VoidCallback onHeroShown;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final centered = page.hero is HeroShieldPayload;
    return Padding(
      padding: const EdgeInsets.fromLTRB(28, 20, 28, 20),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
              crossAxisAlignment: centered
                  ? CrossAxisAlignment.center
                  : CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OnboardingCategoryBadge(badge: page.categoryBadge),
                const SizedBox(height: 20),
                Text(
                  page.setupLine,
                  textAlign: centered ? TextAlign.center : TextAlign.start,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.4,
                    height: 26 / 20,
                    color: tokens.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                _hero(),
                const SizedBox(height: 16),
                OnboardingBodyText(
                  text: page.body,
                  textAlign: centered ? TextAlign.center : TextAlign.start,
                ),
                if (page.source != null) ...[
                  const SizedBox(height: 8),
                  _SourceRow(source: page.source!),
                ],
              ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _hero() {
    return switch (page.hero) {
      HeroStatPayload payload => OnboardingHeroStat(
        payload: payload,
        hasBeenShown: heroShown,
        onShown: onHeroShown,
      ),
      HeroBrandGridPayload payload => OnboardingHeroBrandGrid(payload: payload),
      HeroAiPayload payload => OnboardingHeroAi(payload: payload),
      HeroShieldPayload payload => OnboardingHeroShield(payload: payload),
    };
  }
}

class OnboardingBodyText extends StatelessWidget {
  const OnboardingBodyText({
    required this.text,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String text;
  final TextAlign textAlign;

  static final _money = RegExp(r'\$[\d,]+(?:\.\d+)?');

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final base = TextStyle(
      fontSize: 13,
      fontWeight: FontWeight.w400,
      letterSpacing: -0.05,
      height: 19.5 / 13,
      color: tokens.textMuted,
    );
    final matches = _money.allMatches(text).toList();
    if (matches.isEmpty) {
      return Text(text, textAlign: textAlign, style: base);
    }

    final spans = <InlineSpan>[];
    var cursor = 0;
    for (final match in matches) {
      if (match.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, match.start)));
      }
      spans.add(
        TextSpan(
          text: match.group(0),
          style: TextStyle(
            color: tokens.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
      );
      cursor = match.end;
    }
    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return Text.rich(
      TextSpan(style: base, children: spans),
      textAlign: textAlign,
    );
  }
}

class _SourceRow extends StatelessWidget {
  const _SourceRow({required this.source});

  final String source;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Row(
      children: [
        Icon(OnboardingIcon.info.data, size: 10, color: tokens.textMuted),
        const SizedBox(width: 4),
        Flexible(
          child: Text(
            OnboardingPages.sourceLine(source),
            style: TextStyle(
              fontSize: 10.5,
              letterSpacing: -0.05,
              color: tokens.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
