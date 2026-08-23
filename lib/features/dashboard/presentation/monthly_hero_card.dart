import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../domain/spending_summary.dart';

class MonthlyHeroCard extends StatefulWidget {
  const MonthlyHeroCard({required this.summary, required this.now, super.key});

  final SpendingSummary summary;
  final DateTime now;

  @override
  State<MonthlyHeroCard> createState() => _MonthlyHeroCardState();
}

class _MonthlyHeroCardState extends State<MonthlyHeroCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spark = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..forward();

  @override
  void dispose() {
    _spark.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final summary = widget.summary;
    final split = MoneyFormat.split(
      summary.monthTotal,
      currencyCode: summary.currencyCode,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 8, 20, 8),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: tokens.bgSubtle,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.thisMonth.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: tokens.textSecondary,
                      ),
                    ),
                    if (summary.activeCount == 0) ...[
                      const SizedBox(height: 6),
                      Text(
                        AppStrings.noActiveSubscriptionsYet,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: tokens.textSecondary,
                        ),
                      ),
                    ],
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          split.whole,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.9,
                            color: tokens.textPrimary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        Text(
                          split.cents,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: tokens.textSecondary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (summary.monthDelta.abs() >= 0.005)
                _TrendPill(
                  delta: summary.monthDelta,
                  currency: summary.currencyCode,
                ),
            ],
          ),
          const SizedBox(height: 12),
          SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: _spark,
              curve: Curves.easeOutCubic,
            ),
            alignment: Alignment.topCenter,
            child: _SparkChart(values: summary.spark, now: widget.now),
          ),
          const SizedBox(height: 6),
          Text(
            AppStrings.spendEstimatedFromRecords,
            style: TextStyle(
              fontSize: 11,
              height: 1.35,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 6),
          Divider(height: 1, thickness: 0.5, color: tokens.border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(
                label: AppStrings.perYearLabel,
                value: MoneyFormat.format(
                  summary.yearTotal,
                  currencyCode: summary.currencyCode,
                ),
              ),
              _Stat(
                label: AppStrings.activeLabel,
                value: '${summary.activeCount} subs',
              ),
              _Stat(
                label: AppStrings.highestLabel,
                value: MoneyFormat.format(
                  summary.highest,
                  currencyCode: summary.currencyCode,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TrendPill extends StatelessWidget {
  const _TrendPill({required this.delta, required this.currency});

  final double delta;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final down = delta < 0;
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 3, 8, 3),
      decoration: BoxDecoration(
        color: down ? tokens.positiveBg : tokens.dangerBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            down ? Icons.south_east_rounded : Icons.north_east_rounded,
            size: 11,
            color: down ? tokens.positiveText : tokens.dangerText,
          ),
          const SizedBox(width: 2),
          Text(
            MoneyFormat.format(delta.abs(), currencyCode: currency),
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: down ? tokens.positiveText : tokens.dangerText,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}

class _SparkChart extends StatelessWidget {
  const _SparkChart({required this.values, required this.now});

  final List<double> values;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final max = values.fold<double>(
      0,
      (sum, value) => value > sum ? value : sum,
    );
    return SizedBox(
      height: 44,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (var i = 0; i < values.length; i++) ...[
            if (i > 0) const SizedBox(width: 5),
            Expanded(
              child: _SparkColumn(
                value: values[i],
                max: max,
                label: _monthLetter(
                  DateTime(now.year, now.month - (values.length - 1 - i)),
                ),
                isCurrent: i == values.length - 1,
                barColor: i == values.length - 1
                    ? tokens.textPrimary
                    : tokens.textPrimary.withValues(alpha: 0.18),
                labelColor: i == values.length - 1
                    ? tokens.textPrimary
                    : tokens.textMuted,
              ),
            ),
          ],
        ],
      ),
    );
  }

  static const _letters = [
    'J',
    'F',
    'M',
    'A',
    'M',
    'J',
    'J',
    'A',
    'S',
    'O',
    'N',
    'D',
  ];

  static String _monthLetter(DateTime date) => _letters[date.month - 1];
}

class _SparkColumn extends StatelessWidget {
  const _SparkColumn({
    required this.value,
    required this.max,
    required this.label,
    required this.isCurrent,
    required this.barColor,
    required this.labelColor,
  });

  final double value;
  final double max;
  final String label;
  final bool isCurrent;
  final Color barColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final fraction = max <= 0 ? 0.0 : (value / max).clamp(0.0, 1.0);
    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: fraction == 0 ? 0.08 : fraction,
              child: Container(
                width: 7,
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
            letterSpacing: 0.2,
            color: labelColor,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
            color: tokens.textMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: tokens.textPrimary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ],
    );
  }
}
