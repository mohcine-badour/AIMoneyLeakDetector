import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import 'data/onboarding_repository.dart';
import 'domain/onboarding_pages.dart';

final onboardingControllerProvider =
    NotifierProvider.autoDispose<OnboardingController, OnboardingFlowState>(
      OnboardingController.new,
    );

class OnboardingFlowState {
  const OnboardingFlowState({
    this.index = 0,
    this.shownHeroes = const {},
  });

  final int index;
  final Set<OnboardingPageId> shownHeroes;

  bool get isFirst => index == 0;
  bool get isLast => index >= OnboardingPages.all.length - 1;
  int get total => OnboardingPages.all.length;
  OnboardingPage get page => OnboardingPages.all[index];

  OnboardingFlowState copyWith({
    int? index,
    Set<OnboardingPageId>? shownHeroes,
  }) {
    return OnboardingFlowState(
      index: index ?? this.index,
      shownHeroes: shownHeroes ?? this.shownHeroes,
    );
  }
}

class OnboardingController extends Notifier<OnboardingFlowState> {
  @override
  OnboardingFlowState build() => const OnboardingFlowState();

  void trackPageView() {
    final page = state.page;
    ref.read(analyticsProvider).track(
      AnalyticsEvent.onboardingPageView,
      properties: {'kind': page.id.name},
    );
  }

  void goToNext() {
    if (state.isLast) {
      return;
    }
    _trackAdvance(OnboardingAdvanceMethod.cta);
    state = state.copyWith(index: state.index + 1);
    trackPageView();
  }

  void goToPrevious() {
    if (state.isFirst) {
      return;
    }
    ref.read(analyticsProvider).track(
      AnalyticsEvent.onboardingBack,
      properties: {'kind': state.page.id.name},
    );
    state = state.copyWith(index: state.index - 1);
    trackPageView();
  }

  void goToPage(int index) {
    if (index < 0 || index >= state.total || index == state.index) {
      return;
    }
    ref.read(analyticsProvider).track(
      AnalyticsEvent.onboardingJump,
      properties: {
        'source': state.page.id.name,
        'kind': OnboardingPages.all[index].id.name,
      },
    );
    state = state.copyWith(index: index);
    trackPageView();
  }

  void syncFromUserScroll(int index) {
    if (index < 0 || index >= state.total || index == state.index) {
      return;
    }
    if (index > state.index) {
      _trackAdvance(OnboardingAdvanceMethod.swipe);
    } else {
      ref.read(analyticsProvider).track(
        AnalyticsEvent.onboardingBack,
        properties: {'kind': state.page.id.name},
      );
    }
    state = state.copyWith(index: index);
    trackPageView();
  }

  void markHeroShown(OnboardingPageId id) {
    if (state.shownHeroes.contains(id)) {
      return;
    }
    state = state.copyWith(shownHeroes: {...state.shownHeroes, id});
  }

  Future<void> complete(OnboardingCompleteVia via) async {
    final lastPage = state.page.id.name;
    if (via == OnboardingCompleteVia.skip) {
      await ref.read(analyticsProvider).track(
        AnalyticsEvent.onboardingSkipPress,
        properties: {'kind': lastPage},
      );
    }
    await ref.read(onboardingRepositoryProvider).markComplete();
    await ref.read(analyticsProvider).track(
      AnalyticsEvent.onboardingCompleted,
      properties: {'source': via.source, 'kind': lastPage},
    );
  }

  void _trackAdvance(OnboardingAdvanceMethod method) {
    ref.read(analyticsProvider).track(
      AnalyticsEvent.onboardingAdvance,
      properties: {
        'source': method.source,
        'kind': state.page.id.name,
      },
    );
  }
}
