import 'package:flutter/material.dart';

/// Subtle elevation only. Avoid heavy shadows and glass effects.
abstract final class AppShadows {
  static const List<BoxShadow> card = [
    BoxShadow(
      color: Color(0x140B1F3A),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> cardDark = [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 16,
      offset: Offset(0, 4),
    ),
  ];

  static List<BoxShadow> forBrightness(Brightness brightness) {
    return brightness == Brightness.dark ? cardDark : card;
  }
}
