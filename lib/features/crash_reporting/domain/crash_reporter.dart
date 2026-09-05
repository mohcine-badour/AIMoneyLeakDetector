import 'package:flutter/foundation.dart';

/// Error and crash reporting port.
///
/// Callers pass only an error and its stack — never receipts, merchant names,
/// or money amounts. Reporting is opt-in and off by default; see
/// `CrashReporterFactory`. A later adapter can forward to a service (Sentry,
/// Crashlytics) behind the same opt-in.
abstract class CrashReporter {
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? context,
  });

  Future<void> recordFlutterError(FlutterErrorDetails details);
}
