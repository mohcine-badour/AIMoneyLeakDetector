import 'package:flutter/material.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';

class PaywallFinePrint extends StatelessWidget {
  const PaywallFinePrint({
    required this.restoring,
    required this.onRestore,
    required this.onTerms,
    required this.onPrivacy,
    super.key,
  });

  final bool restoring;
  final VoidCallback onRestore;
  final VoidCallback onTerms;
  final VoidCallback onPrivacy;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 22),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          _Link(
            key: const Key('restore-purchases'),
            label: AppStrings.restorePurchases,
            loading: restoring,
            weight: FontWeight.w500,
            color: tokens.textSecondary,
            onTap: restoring ? null : onRestore,
          ),
          _Dot(color: tokens.textMuted),
          _Link(
            key: const Key('paywall-terms'),
            label: AppStrings.terms,
            color: tokens.textMuted,
            onTap: onTerms,
          ),
          _Dot(color: tokens.textMuted),
          _Link(
            key: const Key('paywall-privacy'),
            label: AppStrings.privacyShort,
            color: tokens.textMuted,
            onTap: onPrivacy,
          ),
        ],
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 3,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _Link extends StatelessWidget {
  const _Link({
    required this.label,
    required this.color,
    required this.onTap,
    this.loading = false,
    this.weight = FontWeight.w400,
    super.key,
  });

  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool loading;
  final FontWeight weight;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: loading
            ? SizedBox(
                width: 12,
                height: 12,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: color,
                ),
              )
            : Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: weight,
                  color: color,
                ),
              ),
      ),
    );
  }
}
