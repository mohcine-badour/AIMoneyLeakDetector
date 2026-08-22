import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kichta/features/auth/data/guest_session_repository.dart';
import 'package:kichta/features/auth/data/local_anonymous_auth.dart';

void main() {
  test('guest session is created once and reused', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final sessions = GuestSessionRepository(prefs);
    final auth = LocalAnonymousAuth(sessions);

    expect(sessions.hasSession, isFalse);
    await auth.signInAnonymously();
    expect(sessions.hasSession, isTrue);
    final first = sessions.id;
    await auth.signInAnonymously();
    expect(sessions.id, first);
    await sessions.clear();
    expect(sessions.hasSession, isFalse);
  });
}
