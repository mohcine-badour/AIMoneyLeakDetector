import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/subscription.dart';
import 'subscription_labels.dart';

Future<BillingCycle?> showBillingCycleSheet({
  required BuildContext context,
  BillingCycle? current,
}) {
  final tokens = AppTokens.of(context);
  return showModalBottomSheet<BillingCycle>(
    context: context,
    backgroundColor: tokens.bgCard,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => BillingCycleSheet(current: current),
  );
}

class BillingCycleSheet extends StatelessWidget {
  const BillingCycleSheet({this.current, super.key});

  final BillingCycle? current;

  static const _gridCycles = [
    BillingCycle.weekly,
    BillingCycle.monthly,
    BillingCycle.quarterly,
    BillingCycle.yearly,
  ];

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return SingleChildScrollView(
      child: Padding(
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
              AppStrings.fieldBillingCycle.toUpperCase(),
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
                for (final cycle in _gridCycles)
                  _CycleTile(
                    cycle: cycle,
                    selected: cycle == current,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop(cycle);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
            _CycleTile(
              cycle: BillingCycle.custom,
              selected: current == BillingCycle.custom,
              wide: true,
              onTap: () {
                HapticFeedback.selectionClick();
                Navigator.of(context).pop(BillingCycle.custom);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _CycleTile extends StatelessWidget {
  const _CycleTile({
    required this.cycle,
    required this.selected,
    required this.onTap,
    this.wide = false,
  });

  final BillingCycle cycle;
  final bool selected;
  final VoidCallback onTap;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: selected ? tokens.indigoBg : tokens.bgMuted,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: Key('billing-cycle-${cycle.name}'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: wide
              ? const EdgeInsets.fromLTRB(14, 12, 12, 12)
              : const EdgeInsets.fromLTRB(12, 12, 10, 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: selected ? tokens.borderIndigo : tokens.border,
              width: 0.5,
            ),
          ),
          child: wide ? _wideContent(tokens) : _gridContent(tokens),
        ),
      ),
    );
  }

  Widget _gridContent(AppTokens tokens) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                cycle.label,
                maxLines: 1,
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
          cycle.hint,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: selected ? tokens.indigoText : tokens.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _wideContent(AppTokens tokens) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cycle.label,
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.15,
                  color: tokens.textPrimary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                cycle.hint,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: selected ? tokens.indigoText : tokens.textMuted,
                ),
              ),
            ],
          ),
        ),
        if (selected) Icon(AppIcons.check, size: 16, color: tokens.indigoText),
      ],
    );
  }
}
