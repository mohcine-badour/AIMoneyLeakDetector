import 'package:shared_preferences/shared_preferences.dart';

class GuestSessionRepository {
  GuestSessionRepository(this._prefs);

  final SharedPreferences _prefs;

  static const idKey = 'auth.guestId';

  String? get id => _prefs.getString(idKey);

  bool get hasSession {
    final value = id;
    return value != null && value.isNotEmpty;
  }

  Future<String> create() async {
    final existing = id;
    if (existing != null && existing.isNotEmpty) {
      return existing;
    }
    final created = 'guest_${DateTime.now().toUtc().microsecondsSinceEpoch}';
    await _prefs.setString(idKey, created);
    return created;
  }

  Future<void> clear() => _prefs.remove(idKey);
}
