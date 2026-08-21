import 'trial.dart';
import 'trial_countdown.dart';

abstract final class TrialList {
  static List<Trial> sorted(List<Trial> trials, DateTime now) {
    final items = [...trials];
    items.sort((left, right) {
      final leftStatus = TrialCountdown.displayStatus(
        stored: left.status,
        trialEndDate: left.trialEndDate,
        now: now,
      );
      final rightStatus = TrialCountdown.displayStatus(
        stored: right.status,
        trialEndDate: right.trialEndDate,
        now: now,
      );
      final byStatus = _rank(leftStatus).compareTo(_rank(rightStatus));
      if (byStatus != 0) {
        return byStatus;
      }
      return left.trialEndDate.compareTo(right.trialEndDate);
    });
    return items;
  }

  static int _rank(TrialStatus status) {
    return switch (status) {
      TrialStatus.endingSoon => 0,
      TrialStatus.active => 1,
      TrialStatus.expired => 2,
      TrialStatus.cancelled => 3,
    };
  }
}
