import '../../../core/constants/app_strings.dart';
import 'billing_exception.dart';

/// Maps store error codes to copy a person can act on.
abstract final class BillingCopy {
  static String forException(BillingException error) {
    if (error.message == AppStrings.billingNotConfigured) {
      return AppStrings.billingNotConfigured;
    }
    return forCode(error.code) ??
        (error.message.trim().isEmpty
            ? AppStrings.purchaseSomethingWrong
            : error.message);
  }

  static String? forCode(String? code) {
    return switch (code) {
      'purchaseNotAllowedError' => AppStrings.purchaseNotAllowed,
      'networkError' || 'offlineConnectionError' => AppStrings.purchaseNetwork,
      'paymentPendingError' => AppStrings.purchasePending,
      'storeProblemError' => AppStrings.purchaseStoreProblem,
      _ => null,
    };
  }
}
