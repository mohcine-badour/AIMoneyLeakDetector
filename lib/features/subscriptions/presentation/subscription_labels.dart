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

  String get hint => switch (this) {
    BillingCycle.weekly => AppStrings.billingHintWeekly,
    BillingCycle.monthly => AppStrings.billingHintMonthly,
    BillingCycle.quarterly => AppStrings.billingHintQuarterly,
    BillingCycle.yearly => AppStrings.billingHintYearly,
    BillingCycle.custom => AppStrings.billingHintCustom,
  };

  String get periodSuffix => switch (this) {
    BillingCycle.weekly => AppStrings.perWeek,
    BillingCycle.monthly => AppStrings.perMonth,
    BillingCycle.quarterly => AppStrings.perQuarter,
    BillingCycle.yearly => AppStrings.perYear,
    BillingCycle.custom => AppStrings.perCustom,
  };

  String get rowCycle => switch (this) {
    BillingCycle.weekly => 'weekly',
    BillingCycle.monthly => 'monthly',
    BillingCycle.quarterly => 'quarterly',
    BillingCycle.yearly => 'yearly',
    BillingCycle.custom => 'custom',
  };

  String get listInterval => switch (this) {
    BillingCycle.weekly => 'weekly',
    BillingCycle.monthly => 'monthly',
    BillingCycle.quarterly => 'quarterly',
    BillingCycle.yearly => 'annual',
    BillingCycle.custom => 'custom',
  };

  String get compactPeriod => switch (this) {
    BillingCycle.weekly => AppStrings.compactPerWeek,
    BillingCycle.monthly => AppStrings.compactPerMonth,
    BillingCycle.quarterly => AppStrings.compactPerQuarter,
    BillingCycle.yearly => AppStrings.compactPerYear,
    BillingCycle.custom => AppStrings.compactPerCustom,
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

extension SubscriptionSourceLabel on SubscriptionSource {
  String get label => switch (this) {
    SubscriptionSource.manual => AppStrings.sourceManual,
    SubscriptionSource.scan => AppStrings.sourceScan,
    SubscriptionSource.import => AppStrings.sourceImport,
  };
}
