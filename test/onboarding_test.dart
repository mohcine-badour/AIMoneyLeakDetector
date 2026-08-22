import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/analytics/data/recording_analytics.dart';
import 'package:kichta/features/analytics/domain/analytics_event.dart';
import 'package:kichta/features/auth/data/guest_session_repository.dart';
import 'package:kichta/features/onboarding/data/onboarding_repository.dart';
import 'package:kichta/features/onboarding/domain/onboarding_answers.dart';
import 'package:kichta/features/onboarding/domain/onboarding_pages.dart';
import 'package:kichta/features/paywall/domain/paywall_source.dart';

import 'helpers/pump_app.dart';

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

OnboardingPage get _awareness => OnboardingPages.all.first;
OnboardingPage get _capability => OnboardingPages.all[1];
OnboardingPage get _intelligence => OnboardingPages.all[2];
OnboardingPage get _safety => OnboardingPages.all[3];

int _count(RecordingAnalytics analytics, AnalyticsEvent event) {
  return analytics.records.where((record) => record.event == event).length;
}

Future<void> _advance(WidgetTester tester) async {
  await tester.tap(find.byKey(const Key('onboarding-cta')));
  await tester.pumpAndSettle();
}

void main() {
  test('OnboardingRepository persists answers locally', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = OnboardingRepository(prefs);

    expect(repository.isCompleted, isFalse);
    expect(repository.read(), isNull);

    await repository.save(
      OnboardingAnswers(
        spendingRange: SpendingRange.from50to100,
        savingsGoal: SavingsGoal.amount50,
        entryPath: OnboardingEntryPath.addManually,
        completedAt: DateTime.utc(2026, 8, 21),
      ),
    );

    expect(repository.isCompleted, isTrue);
    final stored = repository.read();
    expect(stored, isNotNull);
    expect(stored!.spendingRange, SpendingRange.from50to100);
    expect(stored.savingsGoal, SavingsGoal.amount50);
    expect(stored.entryPath, OnboardingEntryPath.addManually);
  });

  test('markComplete is enough to skip onboarding on relaunch', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final repository = OnboardingRepository(prefs);

    await repository.markComplete();

    expect(repository.isCompleted, isTrue);
    expect(repository.read(), isNull);
  });

  test('reality check bars stay proportional to payload amounts', () {
    final awareness = _awareness.hero as HeroStatPayload;
    expect(awareness.realityCheck!.estimatedFraction, closeTo(86 / 219, 0.001));

    const resized = RealityCheckPayload(
      estimated: RealityCheckBar(label: 'a', amount: 100),
      actual: RealityCheckBar(label: 'b', amount: 200),
    );
    expect(resized.estimatedFraction, 0.5);
  });

  test('onboarding copy is externalized and not accusatory', () {
    expect(_awareness.setupLine, contains('average person'));
    expect(_awareness.source, 'C+R Research, 2022');
    expect(
      OnboardingPages.all.where((page) => page.source != null),
      hasLength(1),
    );
    for (final page in OnboardingPages.all) {
      expect(page.setupLine.toLowerCase(), isNot(contains('you are wasting')));
      expect(page.body.toLowerCase(), isNot(contains("you're wasting")));
      expect(page.body.toLowerCase(), isNot(contains('one tap')));
      expect(page.body.toLowerCase(), isNot(contains('ai reviews')));
    }
    expect(_awareness.ctaLabel, 'See mine');
    expect(_capability.ctaLabel, 'Next');
    expect(_intelligence.ctaLabel, 'Next');
    expect(_safety.ctaLabel, "I'm in");
  });

  testWidgets('awareness page renders stat, evidence, skip, and CTA', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.onboarding);

    expect(find.text('THE GAP'), findsOneWidget);
    expect(find.text(_awareness.setupLine), findsOneWidget);
    expect(
      find.text(((_awareness.hero as HeroStatPayload).value)),
      findsOneWidget,
    );
    expect(find.text('/mo'), findsOneWidget);
    expect(
      find.text(OnboardingPages.realityCheck.toUpperCase()),
      findsOneWidget,
    );
    expect(find.text('What most think they spend'), findsOneWidget);
    expect(find.text('What they actually spend'), findsOneWidget);
    expect(find.textContaining('C+R Research, 2022'), findsOneWidget);
    expect(find.text(_awareness.ctaLabel), findsOneWidget);
    expect(find.text(OnboardingPages.skip), findsOneWidget);
    expect(find.text(OnboardingPages.swipeHint), findsOneWidget);
    expect(find.byKey(const Key('onboarding-back')), findsNothing);
    expect(
      find.text('Your subscriptions are costing more than you think.'),
      findsNothing,
    );
    expect(find.text(AppStrings.onboardingFindOut), findsNothing);
  });

  testWidgets('CTA advances pages and final CTA opens the paywall', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    final harness = await pumpKichtaApp(
      tester,
      location: AppRoutes.onboarding,
      analytics: analytics,
    );

    expect(analytics.has(AnalyticsEvent.onboardingStarted), isTrue);
    expect(analytics.has(AnalyticsEvent.onboardingPageView), isTrue);

    await _advance(tester);
    expect(find.text('ONE PLACE'), findsOneWidget);
    expect(find.byKey(const Key('onboarding-back')), findsOneWidget);
    expect(find.text(_capability.ctaLabel), findsOneWidget);

    await _advance(tester);
    expect(find.text('INSIGHTS'), findsOneWidget);
    expect(
      find.text(OnboardingPages.exampleInsight.toUpperCase()),
      findsOneWidget,
    );
    expect(
      find.text((_intelligence.hero as HeroAiPayload).title),
      findsOneWidget,
    );

    await _advance(tester);
    expect(find.text('NEVER SURPRISED'), findsOneWidget);
    expect(find.text(_safety.ctaLabel), findsOneWidget);
    expect(find.text(OnboardingPages.swipeHint), findsNothing);

    await _advance(tester);

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(OnboardingRepository(harness.$2).isCompleted, isTrue);
    expect(analytics.has(AnalyticsEvent.onboardingCompleted), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.onboardingCompleted), {
      'source': 'cta_final',
      'kind': OnboardingPageId.safety.name,
    });
    expect(analytics.propertiesFor(AnalyticsEvent.paywallViewed), {
      'source': PaywallSource.onboarding.query,
    });
    expect(_count(analytics, AnalyticsEvent.onboardingPageView), 4);
    expect(_count(analytics, AnalyticsEvent.onboardingAdvance), 3);
    expect(_count(analytics, AnalyticsEvent.onboardingCompleted), 1);
  });

  testWidgets('Skip completes onboarding and still opens the paywall', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    final harness = await pumpKichtaApp(tester, analytics: analytics);

    await tester.tap(find.byKey(const Key('get-started')));
    await tester.pumpAndSettle();

    expect(GuestSessionRepository(harness.$2).hasSession, isTrue);

    await tester.tap(find.byKey(const Key('onboarding-skip')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.paywallHeadline), findsOneWidget);
    expect(OnboardingRepository(harness.$2).isCompleted, isTrue);
    expect(GuestSessionRepository(harness.$2).hasSession, isTrue);
    expect(analytics.has(AnalyticsEvent.onboardingSkipPress), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.onboardingCompleted), {
      'source': 'skip',
      'kind': OnboardingPageId.awareness.name,
    });
  });

  testWidgets('back on the first page returns to welcome', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester);

    await tester.tap(find.text(AppStrings.getStarted));
    await tester.pumpAndSettle();
    expect(find.text('THE GAP'), findsOneWidget);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.getStarted), findsOneWidget);
    expect(find.text(AppStrings.appName), findsOneWidget);
  });

  testWidgets('tapping a progress pill jumps to that page', (tester) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(
      tester,
      location: AppRoutes.onboarding,
      analytics: analytics,
    );

    await tester.tap(find.byKey(const Key('onboarding-pill-3')));
    await tester.pumpAndSettle();

    expect(find.text('NEVER SURPRISED'), findsOneWidget);
    expect(find.text(_safety.ctaLabel), findsOneWidget);
    expect(analytics.has(AnalyticsEvent.onboardingJump), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.onboardingJump), {
      'source': OnboardingPageId.awareness.name,
      'kind': OnboardingPageId.safety.name,
    });
  });
}
