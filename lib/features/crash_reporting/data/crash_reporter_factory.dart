import '../domain/crash_reporter.dart';
import 'disabled_crash_reporter.dart';
import 'logging_crash_reporter.dart';

/// Builds the crash reporter from the opt-in flag.
///
/// Off by default (privacy-first): opted out records nothing. When opted in,
/// reports are bounded by [SanitizingCrashReporter] and logged; swap
/// [LoggingCrashReporter] for a real SDK adapter here when one is added.
abstract final class CrashReporterFactory {
  static CrashReporter create({required bool enabled}) {
    if (!enabled) {
      return const DisabledCrashReporter();
    }
    return const SanitizingCrashReporter(LoggingCrashReporter());
  }
}
