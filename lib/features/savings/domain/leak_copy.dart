import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../trials/domain/trial.dart';

/// Copy for leak recommendations. Keep claims factual.
abstract final class LeakCopy {
  static String categoryLabel(SubscriptionCategory category) {
    return switch (category) {
      SubscriptionCategory.entertainment => AppStrings.categoryEntertainment,
      SubscriptionCategory.productivity => AppStrings.categoryProductivity,
      SubscriptionCategory.cloudStorage => AppStrings.categoryCloudStorage,
      SubscriptionCategory.fitness => AppStrings.categoryFitness,
      SubscriptionCategory.education => AppStrings.categoryEducation,
      SubscriptionCategory.software => AppStrings.categorySoftware,
      SubscriptionCategory.news => AppStrings.categoryNews,
      SubscriptionCategory.gaming => AppStrings.categoryGaming,
      SubscriptionCategory.finance => AppStrings.categoryFinance,
      SubscriptionCategory.other => AppStrings.categoryOther,
    };
  }

  static String overlappingTitle({
    required String amount,
    required String category,
  }) {
    return AppStrings.leakOverlappingTitle(amount, category);
  }

  static String expensiveTitle({required String name, required String amount}) {
    return AppStrings.leakExpensiveTitle(name, amount);
  }

  static String duplicateTitle({required String merchant, required int count}) {
    return AppStrings.leakDuplicateTitle(count, merchant);
  }

  static String renewalTitle({required String name, required int days}) {
    if (days == 0) {
      return AppStrings.leakRenewsToday(name);
    }
    if (days == 1) {
      return AppStrings.leakRenewsTomorrow(name);
    }
    return AppStrings.leakRenewsInDays(name, days);
  }

  static String trialTitle({required String name, required int days}) {
    if (days == 0) {
      return AppStrings.leakTrialEndsToday(name);
    }
    if (days == 1) {
      return AppStrings.leakTrialEndsTomorrow(name);
    }
    return AppStrings.leakTrialEndsInDays(name, days);
  }

  static String trialReason(Trial trial) {
    final amount =
        '${MoneyFormat.format(trial.amountAfterTrial, currencyCode: trial.currency)}${AppStrings.compactPerMonth}';
    return AppStrings.leakTrialReason(amount);
  }

  static String money(double amount, String currencyCode) {
    return MoneyFormat.format(amount, currencyCode: currencyCode);
  }

  static String lowUsageTitle({required String name, required int uses}) {
    return AppStrings.leakLowUsageTitle(name, uses);
  }
}
