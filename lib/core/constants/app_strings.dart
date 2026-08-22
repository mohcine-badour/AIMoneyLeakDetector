import '../copy/welcome_copy.dart';

/// User-facing copy for Kichta.
///
/// English-only for V1. Centralizing strings here prepares the app
/// for localization without introducing a localization package yet.
abstract final class AppStrings {
  static const String appName = 'Kichta';
  static const String tagline = WelcomeCopy.tagline;
  static const String getStarted = 'Get started — free';
  static const String worksWith = 'Works with';
  static const String bankLevelSecurity = 'Bank-level security';
  static const String privateByDefault = 'Private by default';
  static const String alreadyHaveAccount = 'Already have an account?';
  static const String signIn = 'Sign in';
  static const String createAccount = 'Create account';
  static const String noAccountYet = "Don't have an account?";
  static const String authWelcomeBack = 'Welcome back';
  static const String authCreateHeadline = 'Start on this phone';
  static const String authContinueOnPhone = 'Continue on this phone.';
  static const String fieldEmail = 'Email';
  static const String fieldPassword = 'Password';
  static const String fieldConfirmPassword = 'Confirm password';
  static const String emailHint = 'you@example.com';
  static const String passwordHint = 'At least 8 characters';
  static const String authLocalNote =
      'Your data stays on this phone. There is no Kichta cloud account yet.';
  static const String errorEmailInvalid = 'Enter a valid email.';
  static const String errorPasswordShort = 'Use at least 8 characters.';
  static const String errorPasswordMismatch = 'Passwords do not match.';
  static const String authOr = 'or';
  static const String continueWithApple = 'Continue with Apple';
  static const String continueWithGoogle = 'Continue with Google';
  static const String continueWithFacebook = 'Continue with Facebook';
  static const String socialSignInUnavailable =
      'Apple, Google, and Facebook sign-in is not available yet. Use email on this phone.';
  static const String legalContinuingPrefix = 'By continuing, you agree to our';
  static const String legalAnd = 'and';
  static const String couldNotContinueTitle = 'Could not continue';
  static const String couldNotContinueMessage =
      'Something went wrong setting up your account. Check your connection and try again.';
  static String moreBrandsCount(int count) => '+$count';

  static const String onboardingTitle = 'Onboarding';
  static const String dashboardTitle = 'Dashboard';
  static const String subscriptionsTitle = 'Subscriptions';
  static const String addSubscriptionTitle = 'Add subscription';
  static const String subscriptionDetailTitle = 'Subscription';
  static const String trialsTitle = 'Trials';
  static const String savingsTitle = 'Savings';
  static const String settingsTitle = 'Settings';
  static const String tabHome = 'Home';
  static const String tabSubscriptions = 'Subscriptions';
  static const String tabInsights = 'Insights';
  static const String tabSettings = 'Settings';
  static const String insightsTitle = 'Insights';
  static const String spendLabel = 'Spend';
  static const String whereItGoes = 'Where it goes';
  static const String topByCost = 'Top by cost';
  static const String forYou = 'For you';
  static const String sixMoAvgLabel = '6-mo avg';
  static const String renewalsLabel = 'Renewals';
  static const String timeframeTitle = 'Timeframe';
  static const String insightsComing = 'Insights coming';
  static const String insightsEmptyMessage =
      'Add a few subscriptions to see where your money goes.';
  static const String addSubscriptionCta = 'Add subscription';
  static const String review = 'Review';
  static const String dismiss = 'Dismiss';
  static const String resetDismissedInsights = 'Reset dismissed insights';
  static String categoryCount(int count) {
    if (count == 1) {
      return '1 category';
    }
    return '$count categories';
  }

  static String percentOfTotal(int percent) => '$percent% of total';
  static String suggestionCount(int count) {
    if (count == 1) {
      return '1 suggestion';
    }
    return '$count suggestions';
  }

  static String renewalsThisWeek(int count) => '$count this wk';
  static const String attentionSubtitle =
      "Here's what deserves your attention today.";
  static const String youCouldSave = 'You could save';
  static const String reviewSubscription = 'Review subscription';
  static const String sortByPrefix = 'Sort:';
  static const String sortBy = 'Sort by';
  static const String privacyPolicy = 'Privacy Policy';
  static const String privacySection = 'Privacy';
  static const String yourDataSection = 'Your data';
  static const String planSection = 'Plan';
  static const String dismissedInsightsReset =
      'Dismissed insights are visible again.';
  static const String privacyLastUpdated = 'Last updated';
  static const String privacyMinimalCollection =
      'We keep collection small. Analytics never receive amounts, merchants, or receipts.';
  static const String deleteMyData = 'Delete my data';
  static const String deleteAccount = 'Delete account';
  static const String deleteMyDataTitle = 'Delete data on this device?';
  static const String deleteMyDataMessage =
      'Subscriptions, trials, usage, and onboarding answers on this phone will be removed. App Store billing does not change.';
  static const String deleteAccountTitle = 'Delete your account?';
  static const String deleteAccountMessage =
      'This removes data on this device. There is no cloud account yet. A server deletion request will be sent when cloud sync exists. App Store subscriptions stay with Apple until you cancel them there.';
  static const String deleteDataExplanation =
      'You can remove the information stored on this phone at any time.';
  static const String appStoreBillingNotice =
      'Pro is billed by Apple. Deleting app data does not cancel an App Store subscription.';
  static const String deleteDataFailed =
      'Could not delete data on this device.';
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
  static const String categoryMusic = 'Music';
  static const String categoryAi = 'AI';
  static const String categoryStorage = 'Storage';
  static const String categoryDeveloper = 'Developer';

  static const String save = 'Save';
  static const String select = 'Select';
  static const String fieldName = 'Name';
  static const String fieldMerchant = 'Merchant';
  static const String fieldMerchantHint = 'Defaults to name';
  static const String mostPopular = 'Most popular';
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
  static const String billingHintWeekly = 'Every week';
  static const String billingHintMonthly = 'Every month';
  static const String billingHintQuarterly = 'Every 3 months';
  static const String billingHintYearly = 'Every year';
  static const String billingHintCustom = 'Irregular schedule';

  static const String errorNameRequired = 'Enter a name.';
  static const String errorAmountInvalid = 'Enter an amount greater than 0.';
  static const String errorBillingCycleRequired = 'Choose a billing cycle.';
  static const String errorDateRequired = 'Choose the next billing date.';
  static const String errorCategoryRequired = 'Choose a category.';

  static const String searchSubscriptions = 'Search subscriptions';
  static const String filterAll = 'All';
  static const String sortNextPayment = 'Next payment';
  static const String sortHighestCost = 'Highest cost';
  static const String sortAlphabetical = 'Alphabetical';
  static const String sortRecentlyAdded = 'Recently added';
  static const String sortNextDate = 'Next date';
  static const String sortMonthlyCost = 'Monthly cost';
  static const String nextPayment = 'Next payment:';
  static const String emptySubscriptionsTitle = 'No subscriptions yet';
  static const String addFirstSubscriptionTitle = 'Add your first subscription';
  static const String addFirstSubscriptionMessage =
      'Track renewals, spot forgotten trials.';
  static const String emptySubscriptionsMessage =
      'Add a recurring payment to see where your money goes.';
  static const String noMatchingSubscriptionsTitle = 'No subscriptions match';
  static const String noMatchingSubscriptionsMessage =
      'Try a different category or search';
  static const String noSearchMatchesTitle = 'No matches';
  static const String noSearchMatchesMessage =
      'Try a different name or category';
  static const String resetFilters = 'Reset filters';
  static const String filterAndSort = 'Filter and sort';
  static const String showInactive = 'Show inactive';
  static const String applyFilters = 'Apply';
  static const String recentSearches = 'Recent searches';
  static const String comingSoon = 'Coming soon';
  static const String pause = 'Pause';
  static const String resume = 'Resume';
  static const String pausedLabel = 'Paused';
  static const String details = 'Details';
  static const String totalLabel = 'Total';
  static const String perYearFooterLabel = 'Per year';
  static const String weeklyTypicalWarning =
      'Most of these services bill monthly. Confirm this is billed weekly.';
  static const String errorLoadSubscriptions = 'Could not load subscriptions.';

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
  static const String monthlyLabel = 'Monthly:';
  static const String usesLabel = 'Uses';
  static const String costPerUseLabel = 'Cost per use';
  static const String logAUse = 'Log a use';
  static const String costPerUseUnavailable = 'Add uses to see cost per use.';
  static const String usesHint = 'Not recorded';
  static const String errorUsesInvalid = 'Enter a whole number of 0 or more.';

  static const String sourceManual = 'Manual';
  static const String sourceScan = 'Scan';
  static const String sourceImport = 'Import';

  static const String edit = 'Edit';
  static const String editSubscriptionTitle = 'Edit subscription';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String deleteSubscriptionTitle = 'Delete this subscription?';
  static const String deleteSubscriptionMessage =
      'This removes it from Kichta. It does not cancel the merchant.';
  static const String cancellationGuide = 'Cancellation guide';
  static const String cancellationDidNotHappen =
      'Kichta does not cancel this for you.';
  static const String cancellationEstimatedTime = 'Estimated time';
  static const String cancellationInstructions = 'Instructions';
  static const String cancellationNotes = 'Notes';
  static const String howToCancel = 'How to cancel';
  static const String goodToKnow = 'Good to know';
  static const String openCancellationPage = 'Open cancellation page';
  static const String generateCancellationMessage =
      'Generate cancellation message';
  static const String draftMessage = 'Draft message';
  static const String copyMessage = 'Copy message';
  static const String cancellationOpenFailed =
      'Could not open the cancellation page.';
  static const String cancellationMessageDisclaimer =
      'This is a draft for you to send. Kichta does not send it or cancel the merchant.';
  static const String cancellationMessageCopied =
      'Copied. Send it yourself — Kichta did not cancel this.';
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
  static const String viewAll = 'View all';
  static const String today = 'Today';
  static const String tomorrow = 'Tomorrow';
  static const String relativeToday = 'today';
  static const String relativeTomorrow = 'tomorrow';
  static const String relativeYesterday = 'yesterday';
  static String daysAgo(int days) => '$days days ago';
  static const String thisMonth = 'This month';
  static const String perYearLabel = 'Per year';
  static const String activeLabel = 'Active';
  static const String highestLabel = 'Highest';
  static const String renewingSoon = 'Renewing soon';
  static const String next7Days = 'Next 7 days';
  static const String allSubscriptions = 'All subscriptions';
  static const String noRenewalsThisWeek =
      'No renewals this week — enjoy the quiet';
  static const String noActiveSubscriptionsYet = 'No active subscriptions yet';
  static String renewalCount(int count) {
    if (count == 1) {
      return '1 renewal in the next 7 days';
    }
    return '$count renewals in the next 7 days';
  }

  static String activeCountLabel(int count) => '$count active';
  static String seeAllSubscriptions(int count) =>
      'See all $count subscriptions';
  static String unusedInsightTitle(String name, int days) =>
      "You haven't opened $name in $days days";
  static String unusedInsightSubtitle(String amount) =>
      'Cancel to save $amount/month.';
  static String priceHikeTitle(String name, String delta) =>
      '$name went up $delta this month';
  static const String priceHikeSubtitle = 'Review the new pricing.';
  static String overlapTitle(int count, String category) =>
      'You have $count ${category.toLowerCase()} subs';
  static String overlapSubtitle(String amount) =>
      'Save $amount/month by consolidating.';

  static String inDays(int days) => 'in $days days';
  static const String noUpcomingPayments = 'No upcoming payments.';
  static const String emptyUpcomingTitle = 'Nothing coming up';
  static const String emptyUpcomingMessage =
      'Active subscriptions will show here, sorted by the next payment date.';
  static const String emptyCategoryBreakdown =
      'Add a subscription to see where the money goes.';

  static const String addTrialTitle = 'Add trial';
  static const String trialNameHint = 'ChatGPT, Hulu, Disney+';
  static const String chooseDate = 'Choose a date';
  static const String fieldAmountAfterTrial = 'Amount after trial';
  static const String fieldTrialEndDate = 'Trial end date';
  static const String errorTrialEndRequired = 'Choose the trial end date.';
  static const String freeTrialBadge = 'FREE TRIAL';
  static const String afterTrial = 'After trial:';
  static const String trialEndsToday = 'Ends today';
  static const String trialExpired = 'Expired';
  static const String trialCancelled = 'Cancelled';
  static const String trialDayRemaining = '1 day remaining';
  static const String emptyTrialsTitle = 'No free trials yet';
  static const String emptyTrialsMessage =
      'Track a trial so you can cancel before it converts.';
  static const String errorLoadTrials = 'Could not load trials.';
  static const String markTrialCancelled = 'Mark as cancelled';
  static const String trialNotFound = 'This trial was not found.';
  static const String deleteTrialTitle = 'Delete this trial?';
  static const String deleteTrialMessage =
      'This removes it from Kichta. It does not cancel the merchant.';

  static String trialDaysRemaining(int days) => '$days days remaining';

  static const String reminderLeadIn3Days = 'in 3 days';
  static const String reminderLeadTomorrow = 'tomorrow';
  static const String reminderLeadIn2Hours = 'in 2 hours';
  static const String reminderLeadSoon = 'soon';

  static String renewalReminderTitle(String name, String lead) =>
      '$name renews $lead';
  static String renewalReminderBody(String amount) =>
      '$amount will be charged.';
  static String trialReminderTitle(String name, String lead) =>
      '$name trial ends $lead';
  static String trialReminderBody(String amount) =>
      'Cancel before it converts to $amount.';

  static const String scanReceiptTitle = 'Scan Receipt';
  static const String scanExtractedTitle = 'Extracted Data';
  static const String scanSourceMessage =
      'Take a photo or choose one from your library.';
  static const String scanUseCamera = 'Camera';
  static const String scanUseGallery = 'Gallery';
  static const String scanUseThisPhoto = 'Use this photo';
  static const String scanRetake = 'Retake';
  static const String scanProcessing = 'Reading the receipt…';
  static const String scanConfirm = 'Confirm';
  static const String scanFailed =
      'Could not read this receipt. Try another photo.';
  static const String scanFieldDate = 'Date';
  static const String scanFieldBilling = 'Billing';
  static const String scanConfidence = 'Confidence';

  static const String emptyLeaksTitle = 'No review suggestions yet';
  static const String emptyLeaksMessage =
      'Add subscriptions and trials to see overlap, renewals, and trial conversions.';
  static const String leakOverlappingReason =
      'You may want to review overlapping services.';
  static const String leakExpensiveReason =
      'This active subscription is at or above \$50/month.';
  static const String leakDuplicateReason =
      'This can be a duplicate charge. Confirm you still need both.';
  static const String leakRenewalReason =
      'Upcoming renewals are a good time to review this subscription.';
  static const String errorLoadLeaks = 'Could not load savings suggestions.';

  static String leakOverlappingTitle(String amount, String category) =>
      'You spend $amount/month on $category subscriptions.';
  static String leakExpensiveTitle(String name, String amount) =>
      '$name is $amount/month.';
  static String leakDuplicateTitle(int count, String merchant) =>
      'You have $count active $merchant subscriptions.';
  static String leakRenewsToday(String name) => '$name renews today.';
  static String leakRenewsTomorrow(String name) => '$name renews tomorrow.';
  static String leakRenewsInDays(String name, int days) =>
      '$name renews in $days days.';
  static String leakTrialEndsToday(String name) => '$name trial ends today.';
  static String leakTrialEndsTomorrow(String name) =>
      '$name trial ends tomorrow.';
  static String leakTrialEndsInDays(String name, int days) =>
      '$name trial ends in $days days.';
  static String leakTrialReason(String amount) =>
      'After the trial it converts to $amount.';
  static String leakLowUsageTitle(String name, int uses) {
    if (uses == 1) {
      return '$name was used 1 time.';
    }
    return '$name was used $uses times.';
  }

  static const String leakLowUsageReason =
      'Low declared usage can mean this subscription is worth reviewing.';

  static const String moneyLeakReportTitle = 'Your Money Leak Report';
  static const String youSpend = 'You spend:';
  static const String potentialSavingsLabel = 'Potential savings:';
  static const String weFound = 'We found';
  static const String analysisReadOnlyNotice =
      'This report does not change your subscriptions.';
  static const String analysisProcessing = 'Analyzing your money leaks…';
  static const String errorLoadAnalysis =
      'Could not load the money leak report.';
  static const String analysisOverlapExplanation =
      'These services sit in the same category. Confirm you still need each one before the next renewal.';
  static const String analysisExpensiveExplanation =
      'This monthly price is at or above the \$50 review line. Check that the value still matches what you pay.';
  static const String analysisDuplicateExplanation =
      'More than one active subscription shares this merchant. Confirm you still need each one.';
  static const String analysisRenewalExplanation =
      'This renewal is close. Review whether you still want it before you are billed again.';
  static const String analysisTrialExplanation =
      'This trial will convert to a paid plan unless you cancel. The amount below is what it costs after the trial.';
  static const String analysisLowUsageExplanation =
      'Declared usage is low. Check whether this subscription still earns its monthly cost.';

  static String subscriptionsToReview(int count) {
    if (count == 1) {
      return '1 subscription to review';
    }
    return '$count subscriptions to review';
  }

  static String possibleOverlaps(int count) {
    if (count == 1) {
      return '1 possible overlap';
    }
    return '$count possible overlaps';
  }

  static String upcomingExpensiveRenewals(int count) {
    if (count == 1) {
      return '1 upcoming expensive renewal';
    }
    return '$count upcoming expensive renewals';
  }

  static const String beforeYouSubscribeTitle = 'Before you subscribe';
  static const String reviewBeforeAdding = 'Review before adding';
  static const String addThisSubscription = 'Add this subscription';
  static const String afterAdding = 'After adding:';
  static const String annualImpact = 'Annual impact:';
  static const String beforeSubscribeNotice =
      'This is advice only. Nothing is saved until you add the subscription.';
  static const String beforeSubscribeMissing =
      'There is no subscription to review.';
  static const String errorLoadAdvice = 'Could not load this recommendation.';

  static String currentCategorySpending(String category) =>
      'Current ${category.toLowerCase()} spending:';

  static String beforeSubscribeDuplicate(String merchant) =>
      'You already have an active $merchant subscription. Adding another can be a duplicate charge.';

  static String beforeSubscribeOverlap({
    required String current,
    required String after,
    required String category,
  }) =>
      'You already spend $current/month on $category. Adding this would make $after/month in that category. Review overlap before you add it.';

  static String beforeSubscribeExpensive(String monthly) =>
      'This is at or above \$50/month ($monthly/month). Check that the value matches what you will pay.';

  static String beforeSubscribeClear({
    required String monthly,
    required String annual,
    required String category,
  }) =>
      'This would add $monthly/month ($annual/year). No overlapping $category subscriptions are on file.';

  static String continueWithPrice(String price, String period) =>
      '${AppStrings.continueLabel} · $price$period';

  static String savePercent(int percent) => 'Save $percent%';

  static String justPerMonth(String amount) =>
      'Just $amount/month · billed annually';

  static String trialThenYearly(int days, String price) =>
      '$days-day free trial · then $price/year';

  static String startFreeTrial(int days) => 'Start $days-day free trial';

  static String trialNotChargedToday(String date) =>
      "You won't be charged today. Cancel anytime before $date to avoid the charge.";

  static const String paywallHeadline = 'Everything, in one place.';
  static const String paywallSubheadline =
      'Trial alerts, unlimited tracking, and no ads — for less than most subscriptions you track.';
  static const String paywallProBadge = 'Pro';
  static const String paywallUnlock = 'Unlock:';
  static const String unlockPro = 'Unlock Pro';
  static const String unlockProSubtitle =
      'Trial alerts, unlimited tracking, and no ads.';
  static const String yearlyPlan = 'Yearly';
  static const String monthlyPlan = 'Monthly';
  static const String billedAnnually = 'billed annually';
  static const String cancelAnytime = 'Cancel anytime';
  static const String securedByAppStore = 'Secured by App Store';
  static const String securedByGooglePlay = 'Secured by Google Play';
  static const String terms = 'Terms';
  static const String privacyShort = 'Privacy';
  static const String perkUnlimitedSubscriptions = 'Unlimited subscriptions';
  static const String perkTrialProtection = 'Trial protection';
  static const String perkNoAds = 'No ads';
  static const String perkTrialProtectionDetail =
      'Get reminded before free trials auto-charge. Track more than one.';
  static const String perkUnlimitedDetail =
      'Track as many as you have — no cap.';
  static const String perkNoAdsDetail = 'Browsing screens stay clear.';
  static const String trackAFreeTrial = 'Track a free trial';
  static const String restorePurchases = 'Restore purchases';
  static const String restoreSuccessTitle = 'Purchases restored';
  static const String restoreSuccessMessage = 'You now have Pro access.';
  static const String restoreNoneTitle = 'Nothing to restore';
  static const String restoreNone =
      "We couldn't find a previous purchase on this account.";
  static const String purchaseFailedTitle = 'Purchase failed';
  static const String restoreFailedTitle = 'Restore failed';
  static const String billingNotConfigured =
      'App Store billing is not configured yet.';
  static const String purchaseFailed = 'The purchase could not be completed.';
  static const String purchaseSomethingWrong =
      'Something went wrong. Try again in a moment.';
  static const String purchaseNotAllowed =
      "This device isn't allowed to make purchases. Check Screen Time or family settings.";
  static const String purchaseNetwork =
      "Couldn't reach the App Store. Check your connection and try again.";
  static const String purchasePending =
      "Your purchase is pending approval. You'll get access once it's approved.";
  static const String purchaseStoreProblem =
      "The App Store had a problem. Try again in a moment.";
  static const String restoreFailed = 'Purchases could not be restored.';
  static const String alreadyPro = "You're already on Pro.";
  static const String offersLoadTitle = "Can't load offers";
  static const String offersLoadMessage =
      'Check your connection and try again.';
  static const String billingGrace =
      'Billing is retrying. Pro stays active during the grace period.';
  static const String wontRenew =
      'Auto-renew is off. Pro stays active until the period ends.';
  static const String expiredPro = 'Your Pro subscription has ended.';
  static const String introOfferActive = "You're on an introductory offer.";
  static const String introOfferAvailable =
      'Introductory pricing applies when offered by the App Store.';
  static const String adLabel = 'Ad';
  static const String adRemoveHint = 'Upgrade to Pro to remove ads.';
}
