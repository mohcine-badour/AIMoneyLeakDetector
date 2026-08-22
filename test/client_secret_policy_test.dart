import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/core/security/client_secret_policy.dart';

void main() {
  test('AI and billing secret names are forbidden in Flutter', () {
    expect(ClientSecretPolicy.isForbiddenName('OPENAI_API_KEY'), isTrue);
    expect(ClientSecretPolicy.isForbiddenName('REVENUECAT_SECRET'), isTrue);
    expect(ClientSecretPolicy.isForbiddenName('OCR_API_KEY'), isTrue);
    expect(
      ClientSecretPolicy.isAllowedDartDefine('REVENUECAT_APPLE_API_KEY'),
      isTrue,
    );
    expect(
      ClientSecretPolicy.isAllowedDartDefine('ADMOB_BANNER_UNIT_ID'),
      isTrue,
    );
    expect(ClientSecretPolicy.isAllowedDartDefine('OPENAI_API_KEY'), isFalse);
  });

  test('lib does not embed AI secrets or secret dart-defines', () {
    final dartFiles = Directory('lib')
        .listSync(recursive: true)
        .whereType<File>()
        .where((file) => file.path.endsWith('.dart'));

    final definePattern = RegExp(r"String\.fromEnvironment\('([^']+)'\)");

    for (final file in dartFiles) {
      if (file.path.endsWith('client_secret_policy.dart')) {
        continue;
      }
      final source = file.readAsStringSync();
      for (final name in ClientSecretPolicy.forbiddenNames) {
        expect(
          source.contains(name),
          isFalse,
          reason: '${file.path} must not mention $name',
        );
      }
      for (final match in definePattern.allMatches(source)) {
        final name = match.group(1)!;
        expect(
          ClientSecretPolicy.isAllowedDartDefine(name),
          isTrue,
          reason: '${file.path} uses an unapproved dart-define $name',
        );
      }
    }
  });
}
