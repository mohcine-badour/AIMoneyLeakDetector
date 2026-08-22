import '../constants/app_strings.dart';

/// Deterministic date display. Do not use AI for this.
abstract final class AppDateFormat {
  static const List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  static String short(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}, ${date.year}';
  }

  static String monthDay(DateTime date) {
    return '${_months[date.month - 1]} ${date.day.toString().padLeft(2, '0')}';
  }

  static String upcomingLabel(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) {
      return AppStrings.today;
    }
    if (diff == 1) {
      return AppStrings.tomorrow;
    }
    return monthDay(date);
  }

  static String relative(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    final diff = target.difference(today).inDays;
    if (diff == 0) {
      return AppStrings.relativeToday;
    }
    if (diff == 1) {
      return AppStrings.relativeTomorrow;
    }
    if (diff == -1) {
      return AppStrings.relativeYesterday;
    }
    if (diff > 1 && diff <= 14) {
      return AppStrings.inDays(diff);
    }
    if (diff < -1 && diff >= -14) {
      return AppStrings.daysAgo(-diff);
    }
    return '';
  }

  static String monthDayShort(DateTime date) {
    return '${_months[date.month - 1]} ${date.day}';
  }
}
