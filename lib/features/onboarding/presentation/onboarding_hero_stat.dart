import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/utils/money_format.dart';
import '../domain/onboarding_pages.dart';

class OnboardingHeroStat extends StatelessWidget {
  const OnboardingHeroStat({
    required this.payload,
    required this.hasBeenShown,
    required this.onShown,
    super.key,
  });

  final HeroStatPayload payload;
  final bool hasBeenShown;
  final VoidCallback onShown;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                payload.value,
                style: TextStyle(
                  fontSize: 78,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -3,
                  height: 1,
                  color: tokens.textPrimary,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
              const SizedBox(width: 4),
              Text(
                payload.interval,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.5,
                  color: tokens.textMuted,
                ),
              ),
            ],
          ),
        ),
        if (payload.realityCheck != null) ...[
          const SizedBox(height: 24),
          OnboardingRealityCheckCard(
            payload: payload.realityCheck!,
            hasBeenShown: hasBeenShown,
            onShown: onShown,
          ),
        ],
      ],
    );
  }
}

class OnboardingRealityCheckCard extends StatefulWidget {
  const OnboardingRealityCheckCard({
    required this.payload,
    required this.hasBeenShown,
    required this.onShown,
    super.key,
  });

  final RealityCheckPayload payload;
  final bool hasBeenShown;
  final VoidCallback onShown;

  @override
  State<OnboardingRealityCheckCard> createState() =>
      _OnboardingRealityCheckCardState();
}

class _OnboardingRealityCheckCardState extends State<OnboardingRealityCheckCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    if (widget.hasBeenShown) {
      _controller.value = 1;
    } else {
      _controller.forward();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          widget.onShown();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final estimated = widget.payload.estimated;
    final actual = widget.payload.actual;
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: tokens.bgSubtle,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: tokens.border, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            OnboardingPages.realityCheck.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          _BarRow(
            label: estimated.label,
            amount: estimated.amount,
            fraction: widget.payload.estimatedFraction,
            fill: tokens.textPrimary.withValues(alpha: 0.25),
            emphasize: false,
            progress: _controller,
          ),
          const SizedBox(height: 12),
          _BarRow(
            label: actual.label,
            amount: actual.amount,
            fraction: 1,
            fill: tokens.filterDot,
            emphasize: true,
            progress: _controller,
          ),
        ],
      ),
    );
  }
}

class _BarRow extends StatelessWidget {
  const _BarRow({
    required this.label,
    required this.amount,
    required this.fraction,
    required this.fill,
    required this.emphasize,
    required this.progress,
  });

  final String label;
  final double amount;
  final double fraction;
  final Color fill;
  final bool emphasize;
  final Animation<double> progress;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final color = emphasize ? tokens.textPrimary : tokens.textSecondary;
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: emphasize ? FontWeight.w500 : FontWeight.w400,
                  color: color,
                ),
              ),
            ),
            Text(
              MoneyFormat.short(amount),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: color,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: ColoredBox(
            color: tokens.textPrimary.withValues(alpha: 0.04),
            child: SizedBox(
              height: 6,
              width: double.infinity,
              child: AnimatedBuilder(
                animation: progress,
                builder: (context, child) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: FractionallySizedBox(
                      widthFactor: fraction * progress.value,
                      child: child,
                    ),
                  );
                },
                child: ColoredBox(color: fill, child: const SizedBox.expand()),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
