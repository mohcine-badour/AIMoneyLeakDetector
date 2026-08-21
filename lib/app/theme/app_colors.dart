import 'package:flutter/material.dart';

/// Centralized BillKiller AI color tokens.
///
/// Do not hard-code colors in widgets. Read from [AppColors] or
/// [ThemeData.colorScheme] instead.
abstract final class AppColors {
  static const Color navy = Color(0xFF0B1F3A);
  static const Color primary = Color(0xFF1A4B8C);
  static const Color success = Color(0xFF1F7A4D);
  static const Color warning = Color(0xFFC4841D);
  static const Color danger = Color(0xFFB42318);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color onNavy = Color(0xFFFFFFFF);

  static const Color background = Color(0xFFF4F6F8);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color mutedText = Color(0xFF5C6B7A);
  static const Color border = Color(0xFFD8DEE6);

  static const Color backgroundDark = Color(0xFF071322);
  static const Color surfaceDark = Color(0xFF122033);
  static const Color onSurfaceDark = Color(0xFFF4F6F8);
  static const Color mutedTextDark = Color(0xFF9AA8B5);
  static const Color borderDark = Color(0xFF2A3B50);
}
