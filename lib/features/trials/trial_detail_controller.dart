import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/drift_trial_repository.dart';
import 'domain/trial.dart';
import 'trials_providers.dart';

final trialDetailControllerProvider = Provider<TrialDetailController>((ref) {
  return TrialDetailController(ref);
});

class TrialDetailController {
  TrialDetailController(this._ref);

  final Ref _ref;

  Future<void> markCancelled(Trial trial) async {
    await _ref
        .read(trialRepositoryProvider)
        .save(
          trial.copyWith(
            status: TrialStatus.cancelled,
            updatedAt: DateTime.now().toUtc(),
          ),
        );
    _ref.invalidate(trialByIdProvider(trial.id));
    _ref.invalidate(trialsProvider);
  }

  Future<void> delete(String id) async {
    await _ref.read(trialRepositoryProvider).deleteById(id);
    _ref.invalidate(trialByIdProvider(id));
    _ref.invalidate(trialsProvider);
  }
}
