import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_strings.dart';
import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import '../auth/auth_providers.dart';

final welcomeActionProvider =
    NotifierProvider<WelcomeActionController, WelcomeActionState>(
      WelcomeActionController.new,
      isAutoDispose: true,
    );

class WelcomeActionState {
  const WelcomeActionState({this.pending = false, this.error});

  final bool pending;
  final String? error;
}

class WelcomeActionController extends Notifier<WelcomeActionState> {
  @override
  WelcomeActionState build() => const WelcomeActionState();

  Future<bool> startAnonymous() async {
    if (state.pending) {
      return false;
    }
    state = const WelcomeActionState(pending: true);
    await ref.read(analyticsProvider).track(AnalyticsEvent.getStartedPress);
    try {
      await ref.read(anonymousAuthProvider).signInAnonymously();
      await ref
          .read(analyticsProvider)
          .track(AnalyticsEvent.anonymousSignInSuccess);
      state = const WelcomeActionState();
      return true;
    } on Object {
      await ref
          .read(analyticsProvider)
          .track(AnalyticsEvent.anonymousSignInError);
      state = const WelcomeActionState(
        error: AppStrings.couldNotContinueMessage,
      );
      return false;
    }
  }
}
