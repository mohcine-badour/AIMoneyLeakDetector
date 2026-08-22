/// HTTPS-only outbound communication. Cleartext is never allowed.
class ApiSecurityException implements Exception {
  const ApiSecurityException(this.message);

  final String message;

  @override
  String toString() => message;
}

abstract final class ApiSecurityPolicy {
  static const Set<String> allowedSchemes = {'https'};
  static const bool allowCleartext = false;

  static bool isSecure(Uri uri) {
    return allowedSchemes.contains(uri.scheme);
  }

  static void assertSecure(Uri uri) {
    if (!isSecure(uri)) {
      throw ApiSecurityException(
        'Refusing insecure URL. Only HTTPS is allowed.',
      );
    }
  }
}
