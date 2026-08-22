import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import 'auth_providers.dart';

final authFormActionProvider =
    NotifierProvider<AuthFormActionController, AuthFormActionState>(
      AuthFormActionController.new,
      isAutoDispose: true,
    );

class AuthFormActionState {
  const AuthFormActionState({this.pending = false});

  final bool pending;
}

class AuthFormActionController extends Notifier<AuthFormActionState> {
  @override
  AuthFormActionState build() => const AuthFormActionState();

  Future<bool> continueLocally() async {
    if (state.pending) {
      return false;
    }
    state = const AuthFormActionState(pending: true);
    try {
      await ref.read(anonymousAuthProvider).signInAnonymously();
      await ref
          .read(analyticsProvider)
          .track(AnalyticsEvent.anonymousSignInSuccess);
      state = const AuthFormActionState();
      return true;
    } on Object {
      await ref
          .read(analyticsProvider)
          .track(AnalyticsEvent.anonymousSignInError);
      state = const AuthFormActionState();
      return false;
    }
  }
}
