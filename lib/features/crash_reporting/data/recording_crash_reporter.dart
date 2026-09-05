import 'package:flutter/foundation.dart';

import '../domain/crash_report.dart';
import '../domain/crash_reporter.dart';

/// In-memory crash reporter for tests.
class RecordingCrashReporter implements CrashReporter {
  final List<CrashReport> reports = [];

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? context,
  }) async {
    reports.add(
      CrashReport(
        error,
        stackTrace: stackTrace,
        fatal: fatal,
        context: context,
        timestamp: DateTime.now(),
      ),
    );
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

  bool get isEmpty => reports.isEmpty;
  CrashReport get last => reports.last;
}
