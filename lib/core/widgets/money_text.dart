import 'package:flutter/material.dart';

import '../utils/money_format.dart';

/// Displays a financial amount with strong contrast.
///
/// Formatting is deterministic. Do not pass AI-generated strings here.
class MoneyText extends StatelessWidget {
  const MoneyText({
    required this.amount,
    this.currencyCode = MoneyFormat.defaultCurrencyCode,
    this.suffix,
    this.compact = false,
    super.key,
  });

  final double amount;
  final String currencyCode;
  final String? suffix;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final value = MoneyFormat.format(amount, currencyCode: currencyCode);
    final label = suffix == null ? value : '$value $suffix';

    return Text(
      label,
      style: compact ? textTheme.bodyMedium : textTheme.headlineSmall,
    );
  }
}
