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
}
