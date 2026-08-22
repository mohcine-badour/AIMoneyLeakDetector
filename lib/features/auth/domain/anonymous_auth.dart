/// Creates a local guest session so the user can reach onboarding without
/// Apple, Google, or email. Cloud auth is not wired yet.
abstract class AnonymousAuth {
  Future<void> signInAnonymously();
}
