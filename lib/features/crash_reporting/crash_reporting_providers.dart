import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/providers/shared_preferences_provider.dart';
import 'data/disabled_crash_reporter.dart';
import 'domain/crash_reporter.dart';

/// The active crash reporter. Overridden in main() with the instance the global
/// error handlers use; defaults to disabled so tests never record.
final crashReporterProvider = Provider<CrashReporter>((ref) {
  return const DisabledCrashReporter();
});

/// Opt-in flag for crash reporting, persisted on this device. Off by default.
final crashReportingEnabledProvider =
    NotifierProvider<CrashReportingEnabledController, bool>(
      CrashReportingEnabledController.new,
    );

class CrashReportingEnabledController extends Notifier<bool> {
  static const storageKey = 'crashReporting/enabled';

  SharedPreferences get _prefs => ref.read(sharedPreferencesProvider);

  @override
  bool build() {
    return ref.watch(sharedPreferencesProvider).getBool(storageKey) ?? false;
  }

  Future<void> setEnabled(bool value) async {
    state = value;
    await _prefs.setBool(storageKey, value);
  }
}
