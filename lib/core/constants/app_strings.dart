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

  static const String searchSubscriptions = 'Search';
  static const String filterAll = 'All';
  static const String sortNextDate = 'Next date';
  static const String sortMonthlyCost = 'Monthly cost';
  static const String nextPayment = 'Next payment:';
  static const String emptySubscriptionsTitle = 'No subscriptions yet';
  static const String emptySubscriptionsMessage =
      'Add a recurring payment to see where your money goes.';
  static const String noMatchingSubscriptionsTitle = 'No matches';
  static const String noMatchingSubscriptionsMessage =
      'Try a different search or category.';
  static const String errorLoadSubscriptions =
      'Could not load subscriptions.';

  static const String perWeek = '/ week';
  static const String perMonth = '/ month';
  static const String perQuarter = '/ quarter';
  static const String perYear = '/ year';
  static const String perCustom = '/ custom';

  static const String compactPerWeek = '/week';
  static const String compactPerMonth = '/month';
  static const String compactPerQuarter = '/quarter';
  static const String compactPerYear = '/year';
  static const String compactPerCustom = '/custom';

  static const String fieldMonthlyEquivalent = 'Monthly equivalent';
  static const String fieldAnnualEquivalent = 'Annual equivalent';
  static const String fieldCreated = 'Created';
  static const String fieldSource = 'Source';
  static const String annualLabel = 'Annual:';

  static const String sourceManual = 'Manual';
  static const String sourceScan = 'Scan';
  static const String sourceImport = 'Import';

  static const String edit = 'Edit';
  static const String editSubscriptionTitle = 'Edit Subscription';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String deleteSubscriptionTitle = 'Delete this subscription?';
  static const String deleteSubscriptionMessage =
      'This removes it from BillKiller. It does not cancel the merchant.';
  static const String cancellationGuide = 'Cancellation guide';
  static const String cancellationGuidePlaceholder =
      'This guide is not available yet.';
  static const String subscriptionNotFound = 'This subscription was not found.';
  static const String backToList = 'Back to list';

  static const String goodMorning = 'Good morning';
  static const String goodAfternoon = 'Good afternoon';
  static const String goodEvening = 'Good evening';
  static const String yourSubscriptions = 'Your subscriptions';
  static const String monthlySpending = 'Monthly spending';
  static const String annualSpending = 'Annual spending';
  static const String upcomingPayments = 'Upcoming payments';
  static const String categoryBreakdown = 'Category breakdown';
  static const String potentialSavings = 'Potential savings';
  static const String potentialSavingsPlaceholder =
      'AI leak detection will appear here.';
  static const String viewAll = 'View all';
  static const String today = 'Today';
  static const String tomorrow = 'Tomorrow';
  static const String noUpcomingPayments = 'No upcoming payments.';
  static const String emptyUpcomingTitle = 'Nothing coming up';
  static const String emptyUpcomingMessage =
      'Active subscriptions will show here, sorted by the next payment date.';
  static const String emptyCategoryBreakdown =
      'Add a subscription to see where the money goes.';
}
