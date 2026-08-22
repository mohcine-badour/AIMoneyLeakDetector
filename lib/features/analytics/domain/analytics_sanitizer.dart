/// Drops financial and document fields before anything is recorded.
abstract final class AnalyticsSanitizer {
  static const Set<String> allowedKeys = {'plan', 'source', 'success', 'kind'};

  static const Set<String> blockedKeys = {
    'amount',
    'merchant',
    'name',
    'currency',
    'image',
    'bytes',
    'receipt',
    'document',
    'price',
    'spend',
    'savings',
    'monthly',
    'annual',
  };

  static Map<String, Object>? sanitize(Map<String, Object>? properties) {
    if (properties == null || properties.isEmpty) {
      return null;
    }
    final cleaned = <String, Object>{};
    for (final entry in properties.entries) {
      if (blockedKeys.contains(entry.key) || !allowedKeys.contains(entry.key)) {
        continue;
      }
      final value = entry.value;
      if (value is bool || value is String) {
        cleaned[entry.key] = value;
      }
    }
    return cleaned.isEmpty ? null : cleaned;
  }
}
