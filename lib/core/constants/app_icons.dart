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
  static const IconData chevronLeft = Icons.chevron_left_rounded;
  static const IconData chevronRight = Icons.chevron_right_rounded;
  static const IconData arrowRight = Icons.arrow_forward_rounded;
  static const IconData close = Icons.close_rounded;
  static const IconData chartBar = Icons.bar_chart_rounded;
  static const IconData apps = Icons.apps_rounded;
  static const IconData info = Icons.info_outline_rounded;
  static const IconData swipe = Icons.swipe_rounded;
  static const IconData pause = Icons.pause_rounded;
  static const IconData filterOff = Icons.filter_list_off_rounded;
  static const IconData camera = Icons.photo_camera_outlined;
  static const IconData gallery = Icons.photo_library_outlined;
  static const IconData edit = Icons.edit_outlined;
  static const IconData delete = Icons.delete_outline_rounded;
  static const IconData check = Icons.check_rounded;
  static const IconData copy = Icons.content_copy_rounded;
  static const IconData sparkles = Icons.auto_awesome_outlined;
  static const IconData chartLine = Icons.show_chart_rounded;
  static const IconData shieldCheck = Icons.verified_user_outlined;
  static const IconData lock = Icons.lock_outline_rounded;
  static const IconData bellRinging = Icons.notifications_active_outlined;
  static const IconData scan = Icons.document_scanner_outlined;
  static const IconData infinity = Icons.all_inclusive_rounded;
  static const IconData wifiOff = Icons.wifi_off_rounded;
  static const IconData apple = Icons.apple;
}
