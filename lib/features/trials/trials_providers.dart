import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/clock_provider.dart';
import 'data/drift_trial_repository.dart';
import 'domain/trial.dart';
import 'domain/trial_list.dart';

final trialsProvider = FutureProvider<List<Trial>>((ref) {
  return ref.watch(trialRepositoryProvider).getAll();
});

final trialByIdProvider = FutureProvider.family<Trial?, String>((ref, id) {
  return ref.watch(trialRepositoryProvider).getById(id);
});

final visibleTrialsProvider = Provider<AsyncValue<List<Trial>>>((ref) {
  final now = ref.watch(appNowProvider);
  return ref.watch(trialsProvider).whenData((trials) {
    return TrialList.sorted(trials, now);
  });
});
