import 'package:flutter/material.dart';

/// Corner-radius scale. Avoid oversized capsules.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;

  static const BorderRadius button = BorderRadius.all(Radius.circular(md));
  static const BorderRadius card = BorderRadius.all(Radius.circular(lg));
  static const BorderRadius field = BorderRadius.all(Radius.circular(md));
  static const BorderRadius mark = BorderRadius.all(Radius.circular(md));
  static const BorderRadius hero = BorderRadius.all(Radius.circular(xl));
}
