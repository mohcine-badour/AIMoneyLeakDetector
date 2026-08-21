import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_icons.dart';
import '../../core/constants/app_radius.dart';
import '../../core/constants/app_spacing.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Material 3 light and dark themes for BillKiller AI.
abstract final class AppTheme {
  static ThemeData light() {
    const colorScheme = ColorScheme.light(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.navy,
      onSecondary: AppColors.onNavy,
      error: AppColors.danger,
      onError: AppColors.onPrimary,
      surface: AppColors.surface,
      onSurface: AppColors.navy,
      onSurfaceVariant: AppColors.mutedText,
      outline: AppColors.border,
      primaryContainer: AppColors.navy,
      onPrimaryContainer: AppColors.onNavy,
    );

    return _base(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.background,
      textPrimary: AppColors.navy,
      textSecondary: AppColors.mutedText,
      buttonBackground: AppColors.navy,
      buttonForeground: AppColors.onNavy,
      overlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  static ThemeData dark() {
    const colorScheme = ColorScheme.dark(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
      secondary: AppColors.surfaceDark,
      onSecondary: AppColors.onSurfaceDark,
      error: AppColors.danger,
      onError: AppColors.onPrimary,
      surface: AppColors.surfaceDark,
      onSurface: AppColors.onSurfaceDark,
      onSurfaceVariant: AppColors.mutedTextDark,
      outline: AppColors.borderDark,
      primaryContainer: AppColors.navy,
      onPrimaryContainer: AppColors.onNavy,
    );

    return _base(
      colorScheme: colorScheme,
      scaffoldBackground: AppColors.backgroundDark,
      textPrimary: AppColors.onSurfaceDark,
      textSecondary: AppColors.mutedTextDark,
      buttonBackground: AppColors.primary,
      buttonForeground: AppColors.onPrimary,
      overlayStyle: SystemUiOverlayStyle.light,
    );
  }

  static ThemeData _base({
    required ColorScheme colorScheme,
    required Color scaffoldBackground,
    required Color textPrimary,
    required Color textSecondary,
    required Color buttonBackground,
    required Color buttonForeground,
    required SystemUiOverlayStyle overlayStyle,
  }) {
    final buttonShape = const RoundedRectangleBorder(
      borderRadius: AppRadius.button,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(
        backgroundColor: scaffoldBackground,
        foregroundColor: textPrimary,
        elevation: 0,
        scrolledUnderElevation: 0,
        systemOverlayStyle: overlayStyle,
      ),
      textTheme: AppTypography.textTheme(
        primary: textPrimary,
        secondary: textSecondary,
      ),
      iconTheme: IconThemeData(
        color: textPrimary,
        size: AppIcons.lg,
      ),
      cardTheme: CardThemeData(
        color: colorScheme.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.card,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colorScheme.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: colorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: colorScheme.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.field,
          borderSide: BorderSide(color: colorScheme.error),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: buttonBackground,
          foregroundColor: buttonForeground,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          shape: buttonShape,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: textPrimary,
          minimumSize: const Size.fromHeight(AppSpacing.buttonHeight),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
          side: BorderSide(color: colorScheme.outline),
          shape: buttonShape,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: textPrimary,
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.2,
          ),
        ),
      ),
    );
  }
}
