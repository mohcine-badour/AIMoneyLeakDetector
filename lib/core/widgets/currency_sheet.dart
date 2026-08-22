import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_tokens.dart';
import '../constants/app_icons.dart';
import '../constants/app_strings.dart';
import '../utils/money_format.dart';

Future<String?> showCurrencySheet({
  required BuildContext context,
  required String current,
}) {
  final tokens = AppTokens.of(context);
  return showModalBottomSheet<String>(
    context: context,
    backgroundColor: tokens.bgCard,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    showDragHandle: false,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => CurrencySheet(current: current),
  );
}

class CurrencySheet extends StatelessWidget {
  const CurrencySheet({required this.current, super.key});

  final String current;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final codes = MoneyFormat.supportedCurrencyCodes.toList();
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
              AppStrings.fieldCurrency.toUpperCase(),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: tokens.textMuted,
              ),
            ),
            const SizedBox(height: 12),
            for (var i = 0; i < codes.length; i++) ...[
              _CurrencyRow(
                code: codes[i],
                selected: codes[i] == current,
                onTap: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop(codes[i]);
                },
              ),
              if (i != codes.length - 1)
                Divider(height: 1, color: tokens.border),
            ],
          ],
        ),
      ),
    );
  }
}

class _CurrencyRow extends StatelessWidget {
  const _CurrencyRow({
    required this.code,
    required this.selected,
    required this.onTap,
  });

  final String code;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final symbol = MoneyFormat.symbolFor(code);
    return InkWell(
      key: Key('currency-$code'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected ? tokens.indigoBg : tokens.bgMuted,
                borderRadius: BorderRadius.circular(11),
                border: Border.all(
                  color: selected ? tokens.borderIndigo : tokens.border,
                  width: 0.5,
                ),
              ),
              child: Text(
                symbol,
                style: TextStyle(
                  fontSize: symbol.length > 2 ? 11 : 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.2,
                  color: selected ? tokens.indigoText : tokens.textPrimary,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    code,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.15,
                      color: tokens.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    MoneyFormat.nameFor(code),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: tokens.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(AppIcons.check, size: 18, color: tokens.indigoText),
          ],
        ),
      ),
    );
  }
}
