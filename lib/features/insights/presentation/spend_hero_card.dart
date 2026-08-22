import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../domain/insights_timeframe.dart';
import '../domain/spend_metrics.dart';

class SpendHeroCard extends StatelessWidget {
  const SpendHeroCard({required this.metrics, required this.now, super.key});

  final SpendMetrics metrics;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final amount = MoneyFormat.format(
      metrics.periodTotal,
      currencyCode: metrics.currencyCode,
    );

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: tokens.bgCard,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: tokens.border, width: 0.5),
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
                      AppStrings.spendLabel.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: tokens.textMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          amount,
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w500,
                            letterSpacing: -0.9,
                            color: tokens.textPrimary,
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          metrics.timeframe.amountSuffix,
                          style: TextStyle(
                            fontSize: 12,
                            color: tokens.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (metrics.monthDelta.abs() >= 1)
                _TrendPill(
                  delta: metrics.monthDelta,
                  currency: metrics.currencyCode,
                ),
            ],
          ),
          const SizedBox(height: 12),
          _SparkChart(values: metrics.spark.values, now: now),
          const SizedBox(height: 6),
          Divider(height: 1, thickness: 0.5, color: tokens.border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _Stat(
                label: AppStrings.perYearLabel,
                value: MoneyFormat.format(
                  metrics.totalYearly,
                  currencyCode: metrics.currencyCode,
                ),
              ),
              _Stat(
                label: AppStrings.sixMoAvgLabel,
                value: MoneyFormat.format(
                  metrics.avg6mo,
                  currencyCode: metrics.currencyCode,
                ),
              ),
              _Stat(
                label: AppStrings.renewalsLabel,
                value: AppStrings.renewalsThisWeek(metrics.renewalsThisWeek),
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
            MoneyFormat.short(delta.abs(), currencyCode: currency),
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
      height: 48,
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
                    : tokens.bgHover,
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
              heightFactor: fraction == 0 ? 0.04 : fraction,
              widthFactor: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            fontWeight: isCurrent ? FontWeight.w500 : FontWeight.w400,
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
        const SizedBox(height: 2),
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
