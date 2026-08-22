import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/settings/domain/package_privacy_review.dart';

void main() {
  test('every runtime package has a privacy note', () {
    final pubspec = File('pubspec.yaml').readAsStringSync();
    final start = pubspec.indexOf('\ndependencies:');
    final end = pubspec.indexOf('\ndev_dependencies:');
    expect(start, greaterThanOrEqualTo(0));
    expect(end, greaterThan(start));

    final names = <String>{};
    for (final line in pubspec.substring(start, end).split('\n')) {
      final match = RegExp(r'^  ([a-z0-9_]+):').firstMatch(line);
      if (match == null || match[1] == 'flutter') {
        continue;
      }
      names.add(match[1]!);
    }

    expect(names, PackagePrivacyReview.packageNames);
    expect(
      PackagePrivacyReview.notes
          .where((note) => note.leavesDevice)
          .map((note) => note.package),
      {'purchases_flutter', 'url_launcher'},
    );
  });
}
