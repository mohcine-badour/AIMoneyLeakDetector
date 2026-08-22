import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/app/config/app_config.dart';
import 'package:billkiller_ai/core/security/api_security_policy.dart';
import 'package:billkiller_ai/features/cancellation/data/https_link_opener.dart';
import 'package:billkiller_ai/features/cancellation/domain/cancellation_link_opener.dart';

class _RecordingOpener implements CancellationLinkOpener {
  Uri? last;

  @override
  Future<bool> open(Uri uri) async {
    last = uri;
    return true;
  }
}

void main() {
  test('HTTPS URLs are allowed and cleartext is not', () {
    expect(
      ApiSecurityPolicy.isSecure(
        Uri.parse('https://www.netflix.com/cancelplan'),
      ),
      isTrue,
    );
    expect(
      ApiSecurityPolicy.isSecure(Uri.parse('http://example.com')),
      isFalse,
    );
    expect(ApiSecurityPolicy.allowCleartext, isFalse);
    expect(AppConfig.allowCleartextTraffic, isFalse);
    expect(
      () => ApiSecurityPolicy.assertSecure(Uri.parse('http://example.com')),
      throwsA(isA<ApiSecurityException>()),
    );
  });

  test('HTTPS wrapper blocks cleartext before the inner opener runs', () async {
    final inner = _RecordingOpener();
    final opener = HttpsLinkOpener(inner);

    expect(await opener.open(Uri.parse('http://example.com/cancel')), isFalse);
    expect(inner.last, isNull);

    final secure = Uri.parse('https://www.netflix.com/cancelplan');
    expect(await opener.open(secure), isTrue);
    expect(inner.last, secure);
  });
}
