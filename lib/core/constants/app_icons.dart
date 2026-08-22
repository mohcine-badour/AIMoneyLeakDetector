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

  static const IconData home = Icons.home_outlined;
  static const IconData savings = Icons.insights_outlined;
  static const IconData subscriptions = Icons.repeat_rounded;
  static const IconData upcoming = Icons.calendar_month_outlined;
  static const IconData trials = Icons.timer_outlined;
  static const IconData settings = Icons.settings_outlined;
  static const IconData add = Icons.add_rounded;
  static const IconData empty = Icons.inbox_outlined;
  static const IconData error = Icons.error_outline_rounded;
  static const IconData search = Icons.search_rounded;
  static const IconData filter = Icons.tune_rounded;
  static const IconData sort = Icons.swap_vert_rounded;
  static const IconData list = Icons.view_list_rounded;
  static const IconData grid = Icons.grid_view_rounded;
  static const IconData chevronDown = Icons.keyboard_arrow_down_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData pause = Icons.pause_rounded;
  static const IconData filterOff = Icons.filter_list_off_rounded;
  static const IconData camera = Icons.photo_camera_outlined;
  static const IconData gallery = Icons.photo_library_outlined;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData check = Icons.check_rounded;
}
