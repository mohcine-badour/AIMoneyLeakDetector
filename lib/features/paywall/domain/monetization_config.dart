import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import 'paywall_plan.dart';

/// Centralized prices, free limits, and store product identifiers.
///
/// Keep product IDs out of widgets. The RevenueCat secret API key must never
/// be stored here — only the public Apple SDK key via dart-define.
class MonetizationConfig {
  const MonetizationConfig({
    this.weeklyPrice = 0.99,
    this.monthlyPrice = 2.99,
    this.yearlyPrice = 19.99,
    this.currencyCode = MoneyFormat.defaultCurrencyCode,
    this.freeSubscriptionLimit = 5,
    this.freeTrialLimit = 1,
    this.scannerRequiresPro = true,
    this.aiAnalysisRequiresPro = true,
    this.trialProtectionRequiresPro = true,
    this.yearlyIntroTrialDays,
    this.weeklyProductId = 'billkiller_pro_weekly',
    this.monthlyProductId = 'billkiller_pro_monthly',
    this.yearlyProductId = 'billkiller_pro_yearly',
    this.proEntitlementId = 'pro',
    this.revenueCatAppleApiKey = '',
  });

  static const MonetizationConfig defaults = MonetizationConfig(
    revenueCatAppleApiKey: String.fromEnvironment('REVENUECAT_APPLE_API_KEY'),
  );

  final double weeklyPrice;
  final double monthlyPrice;
  final double yearlyPrice;
  final String currencyCode;
  final int freeSubscriptionLimit;
  final int freeTrialLimit;
  final bool scannerRequiresPro;
  final bool aiAnalysisRequiresPro;
  final bool trialProtectionRequiresPro;

  /// Store-confirmed free trial length in days. Null or 0 means no trial copy.
  final int? yearlyIntroTrialDays;

  /// App Store product identifiers. Keep these out of widgets.
  final String weeklyProductId;
  final String monthlyProductId;
  final String yearlyProductId;

  /// RevenueCat entitlement identifier. Keep this out of widgets.
  final String proEntitlementId;

  /// Public RevenueCat Apple SDK key. Never store the secret API key here.
  final String revenueCatAppleApiKey;

  bool get isStoreBillingConfigured => revenueCatAppleApiKey.isNotEmpty;

  String productIdFor(PaywallPlan plan) {
    return switch (plan) {
      PaywallPlan.weekly => weeklyProductId,
      PaywallPlan.monthly => monthlyProductId,
      PaywallPlan.yearly => yearlyProductId,
    };
  }

  PaywallPlan? planForProductId(String? productId) {
    if (productId == null || productId.isEmpty) {
      return null;
    }
    if (productId == weeklyProductId) {
      return PaywallPlan.weekly;
    }
    if (productId == monthlyProductId) {
      return PaywallPlan.monthly;
    }
    if (productId == yearlyProductId) {
      return PaywallPlan.yearly;
    }
    return null;
  }

  String get weeklyPriceLabel =>
      '${MoneyFormat.format(weeklyPrice, currencyCode: currencyCode)}'
      '${AppStrings.compactPerWeek}';

  String get monthlyPriceLabel =>
      '${MoneyFormat.format(monthlyPrice, currencyCode: currencyCode)}'
      '${AppStrings.compactPerMonth}';

  String get yearlyPriceLabel =>
      '${MoneyFormat.format(yearlyPrice, currencyCode: currencyCode)}'
      '${AppStrings.compactPerYear}';

  String priceLabel(PaywallPlan plan) {
    return switch (plan) {
      PaywallPlan.weekly => weeklyPriceLabel,
      PaywallPlan.monthly => monthlyPriceLabel,
      PaywallPlan.yearly => yearlyPriceLabel,
    };
  }
}
