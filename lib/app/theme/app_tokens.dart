import 'package:flutter/material.dart';

class AppTokens {
  const AppTokens({
    required this.bgApp,
    required this.bgCard,
    required this.bgSubtle,
    required this.bgMuted,
    required this.bgHover,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.border,
    required this.borderStrong,
    required this.accent,
    required this.accentText,
    required this.positiveBg,
    required this.positiveText,
    required this.warningBg,
    required this.warningText,
    required this.dangerBg,
    required this.dangerText,
    required this.filterDot,
  });

  final Color bgApp;
  final Color bgCard;
  final Color bgSubtle;
  final Color bgMuted;
  final Color bgHover;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color border;
  final Color borderStrong;
  final Color accent;
  final Color accentText;
  final Color positiveBg;
  final Color positiveText;
  final Color warningBg;
  final Color warningText;
  final Color dangerBg;
  final Color dangerText;
  final Color filterDot;

  static AppTokens of(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark ? dark : light;
  }

  static const light = AppTokens(
    bgApp: Color(0xFFF7F5F0),
    bgCard: Color(0xFFFFFFFF),
    bgSubtle: Color(0xFFF1EFE8),
    bgMuted: Color(0xFFEBE9E1),
    bgHover: Color(0xFFF3F1EA),
    textPrimary: Color(0xFF1A1A1A),
    textSecondary: Color(0xFF5F5E5A),
    textMuted: Color(0xFF9C9C95),
    border: Color(0x0F000000),
    borderStrong: Color(0x17000000),
    accent: Color(0xFF1A1A1A),
    accentText: Color(0xFFFFFFFF),
    positiveBg: Color(0xFFEAF3DE),
    positiveText: Color(0xFF27500A),
    warningBg: Color(0xFFFAEEDA),
    warningText: Color(0xFF854F0B),
    dangerBg: Color(0xFFFCEBEB),
    dangerText: Color(0xFFA32D2D),
    filterDot: Color(0xFF5B5BD6),
  );

  static const dark = AppTokens(
    bgApp: Color(0xFF0B0B0B),
    bgCard: Color(0xFF161616),
    bgSubtle: Color(0xFF131313),
    bgMuted: Color(0xFF1F1F1F),
    bgHover: Color(0xFF1C1C1C),
    textPrimary: Color(0xFFF5F5F5),
    textSecondary: Color(0xFFB4B2A9),
    textMuted: Color(0xFF888780),
    border: Color(0x12FFFFFF),
    borderStrong: Color(0x1CFFFFFF),
    accent: Color(0xFFF5F5F5),
    accentText: Color(0xFF0B0B0B),
    positiveBg: Color(0x2E1F8F4D),
    positiveText: Color(0xFFC0DD97),
    warningBg: Color(0x2EBA7517),
    warningText: Color(0xFFFAC775),
    dangerBg: Color(0x2EE24B4A),
    dangerText: Color(0xFFF7C1C1),
    filterDot: Color(0xFF5B5BD6),
  );
}
