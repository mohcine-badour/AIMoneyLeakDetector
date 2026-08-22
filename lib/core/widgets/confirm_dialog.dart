import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/theme/app_tokens.dart';
import '../constants/app_icons.dart';
import '../constants/app_spacing.dart';
import '../constants/app_strings.dart';

Future<bool?> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = AppStrings.delete,
  String cancelLabel = AppStrings.cancel,
  Key? confirmKey,
  IconData icon = AppIcons.delete,
}) {
  return showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.55),
    builder: (context) => ConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      confirmKey: confirmKey,
      icon: icon,
    ),
  );
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.title,
    required this.message,
    this.confirmLabel = AppStrings.delete,
    this.cancelLabel = AppStrings.cancel,
    this.confirmKey,
    this.icon = AppIcons.delete,
    super.key,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final Key? confirmKey;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Dialog(
      backgroundColor: tokens.bgCard,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: tokens.border, width: 0.5),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: tokens.dangerBg,
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(color: tokens.borderDanger, width: 0.5),
                  ),
                  child: Icon(icon, size: 18, color: tokens.dangerText),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.25,
                      height: 1.2,
                      color: tokens.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                fontSize: 13.5,
                height: 1.45,
                color: tokens.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                Expanded(
                  child: _DialogButton(
                    label: cancelLabel,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _DialogButton(
                    key: confirmKey,
                    label: confirmLabel,
                    danger: true,
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.onPressed,
    this.danger = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final background = danger ? tokens.dangerBg : tokens.bgMuted;
    final foreground = danger ? tokens.dangerText : tokens.textPrimary;
    final border = danger ? tokens.borderDanger : tokens.border;
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: AppSpacing.buttonHeight,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: border, width: 0.5),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14.5,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.1,
              color: foreground,
            ),
          ),
        ),
      ),
    );
  }
}
