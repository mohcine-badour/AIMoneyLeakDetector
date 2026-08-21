import 'dart:math';

/// Local unique IDs. Not a backend identifier.
abstract final class IdGenerator {
  static final Random _random = Random.secure();

  static String next() {
    final timestamp = DateTime.now().toUtc().microsecondsSinceEpoch;
    final entropy = _random.nextInt(1 << 32).toRadixString(16);
    return '$timestamp-$entropy';
  }
}
