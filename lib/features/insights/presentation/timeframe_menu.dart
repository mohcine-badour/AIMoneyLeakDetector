import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/insights_timeframe.dart';

Future<InsightsTimeframe?> showTimeframeMenu({
  required BuildContext context,
  required InsightsTimeframe current,
}) {
  final tokens = AppTokens.of(context);
  return showModalBottomSheet<InsightsTimeframe>(
    context: context,
    backgroundColor: tokens.bgCard,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => TimeframeSheet(current: current),
  );
}

class TimeframeSheet extends StatelessWidget {
  const TimeframeSheet({required this.current, super.key});

  final InsightsTimeframe current;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        10,
        20,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: tokens.borderStrong,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.timeframeTitle.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.7,
            children: [
              for (final value in InsightsTimeframe.values)
                _TimeframeTile(
                  timeframe: value,
                  selected: value == current,
                  onTap: () {
                    HapticFeedback.selectionClick();
                    Navigator.of(context).pop(value);
                  },
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimeframeTile extends StatelessWidget {
  const _TimeframeTile({
    required this.timeframe,
    required this.selected,
    required this.onTap,
  });

  final InsightsTimeframe timeframe;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: selected ? tokens.indigoBg : tokens.bgMuted,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: Key('timeframe-${timeframe.name}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? tokens.borderIndigo : tokens.border,
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      timeframe.label,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.15,
                        height: 1.2,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(AppIcons.check, size: 16, color: tokens.indigoText),
                ],
              ),
              const Spacer(),
              Text(
                timeframe.amountSuffix,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? tokens.indigoText : tokens.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
