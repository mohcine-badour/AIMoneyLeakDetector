import '../../../core/constants/app_strings.dart';
import '../domain/subscription.dart';

extension BillingCycleLabel on BillingCycle {
  String get label => switch (this) {
        BillingCycle.weekly => AppStrings.billingWeekly,
        BillingCycle.monthly => AppStrings.billingMonthly,
        BillingCycle.quarterly => AppStrings.billingQuarterly,
        BillingCycle.yearly => AppStrings.billingYearly,
        BillingCycle.custom => AppStrings.billingCustom,
      };
}

extension SubscriptionCategoryLabel on SubscriptionCategory {
  String get label => switch (this) {
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
