import 'package:flutter/foundation.dart';

import '../domain/crash_reporter.dart';

/// Debug stand-in. Prints to the console so crashes are visible in development.
/// A later adapter can forward these to a service (Sentry, Crashlytics) here,
/// behind the same opt-in.
class LoggingCrashReporter implements CrashReporter {
  const LoggingCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? context,
  }) async {
    final where = context == null ? '' : ' [$context]';
    debugPrint('crash${fatal ? ' (fatal)' : ''}$where: $error');
    if (stackTrace != null) {
      debugPrintStack(stackTrace: stackTrace, label: 'crash');
    }
  }

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) {
    return recordError(
      details.exception,
      details.stack,
      fatal: true,
      context: details.context?.toDescription(),
    );
  }
}
