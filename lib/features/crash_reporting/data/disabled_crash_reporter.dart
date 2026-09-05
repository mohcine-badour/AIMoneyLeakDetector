import 'package:flutter/foundation.dart';

import '../domain/crash_reporter.dart';

/// Used when crash reporting is opted out (the default). Records nothing.
class DisabledCrashReporter implements CrashReporter {
  const DisabledCrashReporter();

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? context,
  }) async {}

  @override
  Future<void> recordFlutterError(FlutterErrorDetails details) async {}
}

/// Bounds report size before forwarding, so a stray large string can never turn
/// a crash report into a data dump. Passes through only the error and stack the
/// caller supplied.
class SanitizingCrashReporter implements CrashReporter {
  const SanitizingCrashReporter(
    this._inner, {
    this.maxMessageChars = 1000,
    this.maxStackFrames = 40,
  });

  final CrashReporter _inner;
  final int maxMessageChars;
  final int maxStackFrames;

  @override
  Future<void> recordError(
    Object error,
    StackTrace? stackTrace, {
    bool fatal = false,
    String? context,
  }) {
    return _inner.recordError(
      _boundedError(error),
      _boundedStack(stackTrace),
      fatal: fatal,
      context: context,
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

  Object _boundedError(Object error) {
    final text = error.toString();
    if (text.length <= maxMessageChars) {
      return text;
    }
    return '${text.substring(0, maxMessageChars)}…';
  }

  StackTrace? _boundedStack(StackTrace? stackTrace) {
    if (stackTrace == null) {
      return null;
    }
    final lines = stackTrace.toString().split('\n');
    if (lines.length <= maxStackFrames) {
      return stackTrace;
    }
    return StackTrace.fromString(lines.take(maxStackFrames).join('\n'));
  }
}
