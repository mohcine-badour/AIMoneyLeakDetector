import '../../../core/security/api_security_policy.dart';
import '../domain/cancellation_link_opener.dart';

/// Blocks cleartext URLs before any link opener runs.
class HttpsLinkOpener implements CancellationLinkOpener {
  const HttpsLinkOpener(this._inner);

  final CancellationLinkOpener _inner;

  @override
  Future<bool> open(Uri uri) {
    if (!ApiSecurityPolicy.isSecure(uri)) {
      return Future.value(false);
    }
    return _inner.open(uri);
  }
}
