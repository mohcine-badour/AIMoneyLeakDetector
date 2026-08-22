abstract final class InsightCopy {
  static String unusedTitle(String name, int days) =>
      "Haven't opened $name in $days days";

  static String unusedSubtitle(String yearly) =>
      'Canceling would save $yearly/year.';

  static String priceHikeTitle(String name, String delta) =>
      '$name went up $delta/month';

  static const String priceHikeSubtitle =
      "Review the new pricing to decide if it's still worth it.";

  static String overlapTitle(int count, String category) =>
      'You have $count ${category.toLowerCase()} subs';

  static String overlapSubtitle(String savings) =>
      'Consolidate to save up to $savings/month.';

  static String yearlyRenewalTitle(String name, int days, String amount) =>
      '$name renews in $days days for $amount';

  static const String yearlyRenewalSubtitle =
      'Good time to review if you still want it.';

  static String wrongCycleTitle(String name) =>
      'Confirm $name is billed weekly';

  static String wrongCycleSubtitle(String category) =>
      'Most ${category.toLowerCase()} services bill monthly.';
}
