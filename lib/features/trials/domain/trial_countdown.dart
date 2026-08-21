import 'trial.dart';

/// Deterministic trial countdown and display status. Do not use AI for this.
///
/// `endingSoon` is the last 3 days, matching the later reminder offsets.
abstract final class TrialCountdown {
  static const int endingSoonDays = 3;

  static int remainingDays(DateTime trialEndDate, DateTime now) {
    final end = DateTime.utc(
      trialEndDate.year,
      trialEndDate.month,
      trialEndDate.day,
    );
    final today = DateTime.utc(now.year, now.month, now.day);
    return end.difference(today).inDays;
  }

  static TrialStatus displayStatus({
    required TrialStatus stored,
    required DateTime trialEndDate,
    required DateTime now,
  }) {
    if (stored == TrialStatus.cancelled) {
      return TrialStatus.cancelled;
    }
    final days = remainingDays(trialEndDate, now);
    if (days < 0) {
      return TrialStatus.expired;
    }
    if (days <= endingSoonDays) {
      return TrialStatus.endingSoon;
    }
    return TrialStatus.active;
  }
}
