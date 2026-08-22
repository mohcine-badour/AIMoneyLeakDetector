import '../../../core/utils/money_format.dart';
import 'monetization_config.dart';
import 'yearly_savings.dart';

class PaywallOfferings {
  const PaywallOfferings({
    required this.weeklyPrice,
    required this.monthlyPrice,
    required this.yearlyPrice,
    required this.currencyCode,
    this.yearlyIntroTrialDays,
  });

  final double weeklyPrice;
  final double monthlyPrice;
  final double yearlyPrice;
  final String currencyCode;
  final int? yearlyIntroTrialDays;

  factory PaywallOfferings.fromConfig(MonetizationConfig config) {
    return PaywallOfferings(
      weeklyPrice: config.weeklyPrice,
      monthlyPrice: config.monthlyPrice,
      yearlyPrice: config.yearlyPrice,
      currencyCode: config.currencyCode,
      yearlyIntroTrialDays: config.yearlyIntroTrialDays,
    );
  }

  String get weeklyPriceString =>
      MoneyFormat.format(weeklyPrice, currencyCode: currencyCode);

  String get monthlyPriceString =>
      MoneyFormat.format(monthlyPrice, currencyCode: currencyCode);

  String get yearlyPriceString =>
      MoneyFormat.format(yearlyPrice, currencyCode: currencyCode);

  bool get hasYearlyTrial =>
      yearlyIntroTrialDays != null && yearlyIntroTrialDays! > 0;

  YearlySavings get savings => YearlySavingsMath.compute(
    monthlyPrice: monthlyPrice,
    yearlyPrice: yearlyPrice,
  );
}
