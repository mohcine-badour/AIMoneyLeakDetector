import 'package:flutter/material.dart';

import '../constants/app_icons.dart';

enum AppButtonVariant { primary, secondary, tertiary }

class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.expand = true,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool expand;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final child = isLoading
        ? SizedBox(
            width: AppIcons.md,
            height: AppIcons.md,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: variant == AppButtonVariant.primary
                  ? Theme.of(context).colorScheme.onPrimary
                  : Theme.of(context).colorScheme.onSurface,
            ),
          )
        : Text(label);

    final callback = isLoading ? null : onPressed;

    final button = switch (variant) {
      AppButtonVariant.primary => FilledButton(
          onPressed: callback,
          child: child,
        ),
      AppButtonVariant.secondary => OutlinedButton(
          onPressed: callback,
          child: child,
        ),
      AppButtonVariant.tertiary => TextButton(
          onPressed: callback,
          child: child,
        ),
    };

    if (!expand) {
      return button;
    }

    return SizedBox(width: double.infinity, child: button);
  }
}
