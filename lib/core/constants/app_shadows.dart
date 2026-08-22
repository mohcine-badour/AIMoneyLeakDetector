import 'package:flutter/material.dart';

/// Shadows are opt-in. Prefer contrast and spacing for hierarchy.
abstract final class AppShadows {
  static const List<BoxShadow> none = [];

  static const List<BoxShadow> card = none;

  static const List<BoxShadow> cardDark = none;

  static List<BoxShadow> forBrightness(Brightness brightness) {
    return none;
  }
}
