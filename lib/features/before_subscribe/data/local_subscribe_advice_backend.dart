import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../savings/domain/leak_copy.dart';
import '../domain/subscribe_advisor.dart';
import '../domain/subscribe_impact.dart';

/// Local stand-in for before-you-subscribe AI advice.
///
/// Money figures are copied from local facts. A remote client replaces this
/// in a later step.
class LocalSubscribeAdviceBackend implements SubscribeAdviceBackend {
  const LocalSubscribeAdviceBackend({this.delay = Duration.zero});

  final Duration delay;

  @override
  Future<Map<String, dynamic>> advise(SubscribeImpact impact) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    return {
      'monthly_amount': impact.monthlyAmount,
      'current_category_spend': impact.currentCategoryMonthly,
      'after_category_spend': impact.afterCategoryMonthly,
      'annual_impact': impact.annualImpact,
      'currency': impact.currencyCode,
      'mutates_data': false,
      'recommendation': recommendationFor(impact),
    };
  }

  static String recommendationFor(SubscribeImpact impact) {
    final category = LeakCopy.categoryLabel(impact.candidate.category);
    final monthly = MoneyFormat.format(
      impact.monthlyAmount,
      currencyCode: impact.currencyCode,
    );
    final current = MoneyFormat.format(
      impact.currentCategoryMonthly,
      currencyCode: impact.currencyCode,
    );
    final after = MoneyFormat.format(
      impact.afterCategoryMonthly,
      currencyCode: impact.currencyCode,
    );
    final annual = MoneyFormat.format(
      impact.annualImpact,
      currencyCode: impact.currencyCode,
    );

    if (impact.wouldDuplicate) {
      return AppStrings.beforeSubscribeDuplicate(impact.candidate.merchant);
    }
    if (impact.wouldOverlap) {
      return AppStrings.beforeSubscribeOverlap(
        current: current,
        after: after,
        category: category,
      );
    }
    if (impact.isExpensive) {
      return AppStrings.beforeSubscribeExpensive(monthly);
    }
    return AppStrings.beforeSubscribeClear(
      monthly: monthly,
      annual: annual,
      category: category,
    );
  }
}
