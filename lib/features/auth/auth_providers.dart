import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/shared_preferences_provider.dart';
import 'data/guest_session_repository.dart';
import 'data/local_anonymous_auth.dart';
import 'domain/anonymous_auth.dart';

final guestSessionRepositoryProvider = Provider<GuestSessionRepository>((ref) {
  return GuestSessionRepository(ref.watch(sharedPreferencesProvider));
});

final anonymousAuthProvider = Provider<AnonymousAuth>((ref) {
  return LocalAnonymousAuth(ref.watch(guestSessionRepositoryProvider));
});
