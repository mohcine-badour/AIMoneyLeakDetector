import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/trials/domain/trial.dart';
import 'package:billkiller_ai/features/trials/domain/trial_countdown.dart';
import 'package:billkiller_ai/features/trials/domain/trial_list.dart';

void main() {
  final now = DateTime.utc(2026, 8, 21);

  Trial trial({
    required String id,
    required DateTime end,
    TrialStatus status = TrialStatus.active,
  }) {
    return Trial.create(
      id: id,
      subscriptionName: id,
      amountAfterTrial: 20,
      trialEndDate: end,
      status: status,
    );
  }

  test('remaining days uses calendar dates only', () {
    expect(
      TrialCountdown.remainingDays(DateTime.utc(2026, 8, 26), now),
      5,
    );
    expect(
      TrialCountdown.remainingDays(DateTime.utc(2026, 8, 21), now),
      0,
    );
    expect(
      TrialCountdown.remainingDays(DateTime.utc(2026, 8, 20), now),
      -1,
    );
  });

  test('display status is derived from remaining days unless cancelled', () {
    expect(
      TrialCountdown.displayStatus(
        stored: TrialStatus.active,
        trialEndDate: DateTime.utc(2026, 8, 26),
        now: now,
      ),
      TrialStatus.active,
    );
    expect(
      TrialCountdown.displayStatus(
        stored: TrialStatus.active,
        trialEndDate: DateTime.utc(2026, 8, 24),
        now: now,
      ),
      TrialStatus.endingSoon,
    );
    expect(
      TrialCountdown.displayStatus(
        stored: TrialStatus.active,
        trialEndDate: DateTime.utc(2026, 8, 20),
        now: now,
      ),
      TrialStatus.expired,
    );
    expect(
      TrialCountdown.displayStatus(
        stored: TrialStatus.cancelled,
        trialEndDate: DateTime.utc(2026, 8, 20),
        now: now,
      ),
      TrialStatus.cancelled,
    );
  });

  test('sorts ending soon before active, then expired, then cancelled', () {
    final sorted = TrialList.sorted(
      [
        trial(id: 'cancelled', end: DateTime.utc(2026, 8, 22), status: TrialStatus.cancelled),
        trial(id: 'active', end: DateTime.utc(2026, 8, 30)),
        trial(id: 'expired', end: DateTime.utc(2026, 8, 10)),
        trial(id: 'soon', end: DateTime.utc(2026, 8, 23)),
      ],
      now,
    );

    expect(sorted.map((item) => item.id).toList(), [
      'soon',
      'active',
      'expired',
      'cancelled',
    ]);
  });
}
