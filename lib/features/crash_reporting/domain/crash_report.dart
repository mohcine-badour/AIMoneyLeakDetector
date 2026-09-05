import 'package:flutter/foundation.dart';

/// A single captured error or crash.
///
/// Holds only the error, its stack, and a developer-supplied tag — never app
/// state, receipts, or money amounts.
@immutable
class CrashReport {
  const CrashReport(
    this.error, {
    this.stackTrace,
    this.fatal = false,
    this.context,
    this.timestamp,
  });

  final Object error;
  final StackTrace? stackTrace;

  /// Whether the error escaped uncaught / crashed a frame.
  final bool fatal;

  /// Where it happened, e.g. 'bootstrap.database'.
  final String? context;

  final DateTime? timestamp;
}
