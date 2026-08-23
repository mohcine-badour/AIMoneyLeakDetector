import 'package:flutter/material.dart';

import '../../app/theme/app_tokens.dart';
import '../constants/app_icons.dart';
import '../constants/app_strings.dart';

class AppFilledField extends StatelessWidget {
  const AppFilledField({
    required this.fieldKey,
    required this.label,
    required this.controller,
    this.onChanged,
    this.hint,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.suffix,
    super.key,
  });

  final Key fieldKey;
  final String label;
  final TextEditingController controller;
  final VoidCallback? onChanged;
  final String? hint;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: tokens.bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: errorText == null ? tokens.border : tokens.borderDanger,
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.fromLTRB(14, 0, 6, 0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  key: fieldKey,
                  controller: controller,
                  keyboardType: keyboardType,
                  textInputAction: textInputAction,
                  autocorrect: false,
                  enableSuggestions: false,
                  onTapOutside: (_) =>
                      FocusManager.instance.primaryFocus?.unfocus(),
                  onChanged: onChanged == null ? null : (_) => onChanged!(),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    height: 1.2,
                    letterSpacing: -0.2,
                    color: tokens.textPrimary,
                  ),
                  cursorColor: tokens.textPrimary,
                  decoration: InputDecoration(
                    isDense: true,
                    filled: false,
                    fillColor: Colors.transparent,
                    hintText: hint,
                    hintStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                      height: 1.2,
                      color: tokens.textMuted,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    focusedErrorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
              ?suffix,
            ],
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                fontSize: 12,
                height: 1.3,
                color: tokens.dangerText,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class AppCurrencyChip extends StatelessWidget {
  const AppCurrencyChip({required this.value, required this.onTap, super.key});

  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.bgMuted,
      borderRadius: BorderRadius.circular(9),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(9),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 6, 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: tokens.textPrimary,
                ),
              ),
              Icon(AppIcons.chevronDown, size: 16, color: tokens.textMuted),
            ],
          ),
        ),
      ),
    );
  }
}

class AppPickerField extends StatelessWidget {
  const AppPickerField({
    required this.fieldKey,
    required this.label,
    required this.onTap,
    required this.icon,
    this.value,
    this.placeholder,
    this.errorText,
    super.key,
  });

  final Key fieldKey;
  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final String? value;
  final String? placeholder;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final filled = value != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(
            label.toUpperCase(),
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.5,
              color: tokens.textMuted,
            ),
          ),
        ),
        Material(
          color: tokens.bgCard,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            key: fieldKey,
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: errorText == null
                      ? tokens.border
                      : tokens.borderDanger,
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 18, color: tokens.textSecondary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      value ?? placeholder ?? AppStrings.select,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: filled ? tokens.textPrimary : tokens.textMuted,
                      ),
                    ),
                  ),
                  Icon(
                    AppIcons.chevronRight,
                    size: 16,
                    color: tokens.textMuted,
                  ),
                ],
              ),
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 4),
            child: Text(
              errorText!,
              style: TextStyle(
                fontSize: 12,
                height: 1.3,
                color: tokens.dangerText,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class AppAccentButton extends StatelessWidget {
  const AppAccentButton({
    required this.label,
    required this.onPressed,
    this.pending = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool pending;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: tokens.accent,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: pending ? null : onPressed,
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: Center(
            child: pending
                ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: tokens.accentText,
                    ),
                  )
                : Text(
                    label,
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w500,
                      letterSpacing: -0.1,
                      color: tokens.accentText,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
