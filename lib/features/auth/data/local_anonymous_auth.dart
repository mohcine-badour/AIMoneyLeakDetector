import '../domain/anonymous_auth.dart';
import 'guest_session_repository.dart';

class LocalAnonymousAuth implements AnonymousAuth {
  const LocalAnonymousAuth(this._sessions);

  final GuestSessionRepository _sessions;

  @override
  Future<void> signInAnonymously() async {
    await _sessions.create();
  }
}
