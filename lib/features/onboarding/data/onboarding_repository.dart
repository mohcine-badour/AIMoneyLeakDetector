import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../domain/onboarding_answers.dart';

final onboardingRepositoryProvider = Provider<OnboardingRepository>((ref) {
  return OnboardingRepository(ref.watch(sharedPreferencesProvider));
});

class OnboardingRepository {
  OnboardingRepository(this._prefs);

  final SharedPreferences _prefs;

  static const completedKey = 'onboarding.completed';
  static const spendingKey = 'onboarding.spendingRange';
  static const savingsKey = 'onboarding.savingsGoal';
  static const entryPathKey = 'onboarding.entryPath';
  static const completedAtKey = 'onboarding.completedAt';

  bool get isCompleted => _prefs.getBool(completedKey) ?? false;

  OnboardingAnswers? read() {
    if (!isCompleted) {
      return null;
    }

    final spending = _byName(
      SpendingRange.values,
      _prefs.getString(spendingKey),
    );
    final savings = _byName(SavingsGoal.values, _prefs.getString(savingsKey));
    final entryPath = _byName(
      OnboardingEntryPath.values,
      _prefs.getString(entryPathKey),
    );
    final completedAtRaw = _prefs.getString(completedAtKey);
    final completedAt = completedAtRaw == null
        ? null
        : DateTime.tryParse(completedAtRaw);

    if (spending == null ||
        savings == null ||
        entryPath == null ||
        completedAt == null) {
      return null;
    }

    return OnboardingAnswers(
      spendingRange: spending,
      savingsGoal: savings,
      entryPath: entryPath,
      completedAt: completedAt,
    );
  }

  Future<void> markComplete() async {
    await _prefs.setBool(completedKey, true);
    await _prefs.setString(
      completedAtKey,
      DateTime.now().toUtc().toIso8601String(),
    );
  }

  Future<void> save(OnboardingAnswers answers) async {
    await markComplete();
    await _prefs.setString(spendingKey, answers.spendingRange.name);
    await _prefs.setString(savingsKey, answers.savingsGoal.name);
    await _prefs.setString(entryPathKey, answers.entryPath.name);
    await _prefs.setString(
      completedAtKey,
      answers.completedAt.toUtc().toIso8601String(),
    );
  }

  Future<void> clear() async {
    await _prefs.remove(completedKey);
    await _prefs.remove(spendingKey);
    await _prefs.remove(savingsKey);
    await _prefs.remove(entryPathKey);
    await _prefs.remove(completedAtKey);
  }

  T? _byName<T extends Enum>(List<T> values, String? name) {
    if (name == null) {
      return null;
    }
    for (final value in values) {
      if (value.name == name) {
        return value;
      }
    }
    return null;
  }
}
