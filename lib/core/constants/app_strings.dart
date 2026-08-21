/// User-facing copy for BillKiller AI.
///
/// English-only for V1. Centralizing strings here prepares the app
/// for localization without introducing a localization package yet.
abstract final class AppStrings {
  static const String appName = 'BillKiller AI';
  static const String tagline = "Find the money you're wasting.";
  static const String getStarted = 'Get Started';

  static const String onboardingTitle = 'Onboarding';
  static const String dashboardTitle = 'Dashboard';
  static const String subscriptionsTitle = 'Subscriptions';
  static const String addSubscriptionTitle = 'Add Subscription';
  static const String subscriptionDetailTitle = 'Subscription';
  static const String trialsTitle = 'Trials';
  static const String savingsTitle = 'Savings';
  static const String settingsTitle = 'Settings';
  static const String paywallTitle = 'Paywall';

  static const String placeholderBody = 'This screen is a placeholder.';
  static const String notFoundTitle = 'Page not found';
  static const String goHome = 'Go home';
  static const String retry = 'Try again';
  static const String loading = 'Loading';
  static const String continueLabel = 'Continue';

  static const String onboardingHeadline =
      'Your subscriptions are costing\nmore than you think.';
  static const String onboardingFindOut = 'Find out';
  static const String onboardingSpendingTitle =
      'How much do you spend\non subscriptions?';
  static const String onboardingSavingsTitle = 'What do you want to save?';
  static const String onboardingEntryTitle =
      "Let's find your recurring payments.";

  static const String spendingUnder25 = 'Less than \$25';
  static const String spending25to50 = '\$25–\$50';
  static const String spending50to100 = '\$50–\$100';
  static const String spending100to200 = '\$100–\$200';
  static const String spendingOver200 = '\$200+';

  static const String savings25 = '\$25/month';
  static const String savings50 = '\$50/month';
  static const String savings100 = '\$100/month';
  static const String savings200 = '\$200/month';

  static const String entryAddManually = 'Add manually';
  static const String entryScanReceipt = 'Scan a receipt';
  static const String entryImportLater = 'Import later';

  static const String categoryEntertainment = 'Entertainment';
  static const String categoryProductivity = 'Productivity';
  static const String categoryCloudStorage = 'Cloud Storage';
  static const String categoryFitness = 'Fitness';
  static const String categoryEducation = 'Education';
  static const String categorySoftware = 'Software';
  static const String categoryNews = 'News';
  static const String categoryGaming = 'Gaming';
  static const String categoryFinance = 'Finance';
  static const String categoryOther = 'Other';

  static const String save = 'Save';
  static const String select = 'Select';
  static const String fieldName = 'Name';
  static const String fieldMerchant = 'Merchant';
  static const String fieldMerchantHint = 'Defaults to name';
  static const String fieldAmount = 'Amount';
  static const String fieldCurrency = 'Currency';
  static const String fieldBillingCycle = 'Billing cycle';
  static const String fieldNextBillingDate = 'Next billing date';
  static const String fieldCategory = 'Category';

  static const String billingWeekly = 'Weekly';
  static const String billingMonthly = 'Monthly';
  static const String billingQuarterly = 'Quarterly';
  static const String billingYearly = 'Yearly';
  static const String billingCustom = 'Custom';

  static const String errorNameRequired = 'Enter a name.';
  static const String errorAmountInvalid = 'Enter an amount greater than 0.';
  static const String errorBillingCycleRequired = 'Choose a billing cycle.';
  static const String errorDateRequired = 'Choose the next billing date.';
  static const String errorCategoryRequired = 'Choose a category.';
}
