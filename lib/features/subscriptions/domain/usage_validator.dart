abstract final class UsageValidator {
  static int? parseCount(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) {
      return null;
    }
    return int.tryParse(trimmed);
  }

  static bool isValidCount(int? count) {
    return count != null && count >= 0;
  }
}
