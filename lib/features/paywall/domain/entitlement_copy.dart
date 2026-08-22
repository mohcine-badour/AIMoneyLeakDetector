import '../../../core/constants/app_strings.dart';
import 'entitlement.dart';

/// Status copy for a store-validated entitlement.
abstract final class EntitlementCopy {
  static String? status(Entitlement entitlement) {
    if (entitlement.period == EntitlementPeriod.gracePeriod) {
      return AppStrings.billingGrace;
    }
    if (entitlement.period == EntitlementPeriod.expired) {
      return AppStrings.expiredPro;
    }
    if (!entitlement.isPro) {
      return null;
    }
    if (entitlement.isIntroductory) {
      return AppStrings.introOfferActive;
    }
    if (!entitlement.willRenew) {
      return AppStrings.wontRenew;
    }
    return AppStrings.alreadyPro;
  }
}
