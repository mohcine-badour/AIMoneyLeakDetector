import 'package:flutter/material.dart';

/// Canonical icon sizes and icon choices.
///
/// Prefer outlined/rounded Material icons. Do not mix filled cartoon-style
/// icons into financial screens.
abstract final class AppIcons {
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;

  static const IconData savings = Icons.trending_down_rounded;
  static const IconData subscriptions = Icons.repeat_rounded;
  static const IconData upcoming = Icons.calendar_month_outlined;
  static const IconData trials = Icons.timer_outlined;
  static const IconData settings = Icons.settings_outlined;
  static const IconData add = Icons.add_rounded;
  static const IconData empty = Icons.inbox_outlined;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
}
