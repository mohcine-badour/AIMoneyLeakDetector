import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/crash_reporting/data/crash_reporter_factory.dart';
import 'package:kichta/features/crash_reporting/data/disabled_crash_reporter.dart';
import 'package:kichta/features/crash_reporting/data/recording_crash_reporter.dart';

void main() {
  test('disabled factory returns a no-op reporter', () async {
    final reporter = CrashReporterFactory.create(enabled: false);
    expect(reporter, isA<DisabledCrashReporter>());
    // A no-op must accept a report without throwing.
    await reporter.recordError(StateError('x'), StackTrace.current);
  });

  test('enabled factory sanitizes before logging', () {
    expect(
      CrashReporterFactory.create(enabled: true),
      isA<SanitizingCrashReporter>(),
    );
  });

  test('recording reporter captures error, fatal flag and context', () async {
    final reporter = RecordingCrashReporter();
    final error = const FormatException('bad');

    await reporter.recordError(
      error,
      StackTrace.current,
      fatal: true,
      context: 'bootstrap.database',
    );

    expect(reporter.reports, hasLength(1));
    expect(reporter.last.error, same(error));
    expect(reporter.last.fatal, isTrue);
    expect(reporter.last.context, 'bootstrap.database');
  });

  test('sanitizing reporter bounds a long message and caps the stack', () async {
    final inner = RecordingCrashReporter();
    final reporter = SanitizingCrashReporter(
      inner,
      maxMessageChars: 20,
      maxStackFrames: 3,
    );
    final bigStack = StackTrace.fromString(
      List.generate(50, (i) => '#$i frame').join('\n'),
    );

    await reporter.recordError(StateError('e' * 500), bigStack, context: 'x');

    expect(inner.last.error.toString().length, lessThanOrEqualTo(21));
    expect(inner.last.stackTrace.toString().split('\n'), hasLength(3));
    expect(inner.last.context, 'x');
  });
}
