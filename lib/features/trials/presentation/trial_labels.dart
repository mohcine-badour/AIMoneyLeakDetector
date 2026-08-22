import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../domain/trial.dart';
import '../domain/trial_countdown.dart';

abstract final class TrialLabels {
  static String remaining({required Trial trial, required DateTime now}) {
    final status = TrialCountdown.displayStatus(
      stored: trial.status,
      trialEndDate: trial.trialEndDate,
      now: now,
    );
    if (status == TrialStatus.cancelled) {
      return AppStrings.trialCancelled;
    }
    final days = TrialCountdown.remainingDays(trial.trialEndDate, now);
    if (days < 0) {
      return AppStrings.trialExpired;
    }
    if (days == 0) {
      return AppStrings.trialEndsToday;
    }
    if (days == 1) {
      return AppStrings.trialDayRemaining;
    }
    return AppStrings.trialDaysRemaining(days);
  }

  static String afterTrialAmount(Trial trial) {
    return '${MoneyFormat.format(trial.amountAfterTrial, currencyCode: trial.currency)}${AppStrings.compactPerMonth}';
  }
}
