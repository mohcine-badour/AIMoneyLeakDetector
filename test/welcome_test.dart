import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/theme/app_tokens.dart';
import 'package:kichta/core/brand/brand_registry.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/core/widgets/app_tab_bar.dart';
import 'package:kichta/features/analytics/data/recording_analytics.dart';
import 'package:kichta/features/analytics/domain/analytics_event.dart';
import 'package:kichta/features/auth/data/guest_session_repository.dart';
import 'package:kichta/features/auth/domain/anonymous_auth.dart';
import 'package:kichta/features/onboarding/data/onboarding_repository.dart';
import 'package:kichta/features/welcome/domain/featured_brands.dart';
import 'package:kichta/features/welcome/presentation/welcome_screen.dart';
import 'package:kichta/features/welcome/presentation/works_with_grid.dart';

import 'helpers/pump_app.dart';

class _FailingAuth implements AnonymousAuth {
  @override
  Future<void> signInAnonymously() {
    return Future.error(StateError('offline'));
  }
}

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  testWidgets('cold launch shows centered welcome without tabs or old copy', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(tester, analytics: analytics);

    expect(find.text(AppStrings.appName), findsOneWidget);
    expect(find.text(AppStrings.tagline), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
    expect(find.text(AppStrings.worksWith.toUpperCase()), findsOneWidget);
    expect(find.text(AppStrings.dataStaysOnThisPhone), findsOneWidget);
    expect(find.text(AppStrings.privateByDefault), findsOneWidget);
    expect(find.text(AppStrings.alreadyHaveAccount), findsNothing);
    expect(find.text(AppStrings.signIn), findsNothing);
    expect(find.text(AppStrings.terms), findsOneWidget);
    expect(find.text(AppStrings.privacyPolicy), findsOneWidget);
    expect(find.text("Find the money you're wasting."), findsNothing);
    expect(find.text('Get Started'), findsNothing);
    expect(find.byType(AppTabBar), findsNothing);
    expect(find.byType(MoreBrandsChip), findsOneWidget);
    expect(analytics.has(AnalyticsEvent.welcomeView), isTrue);
  });

  testWidgets('Get started creates a guest session and opens onboarding', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    final harness = await pumpKichtaApp(tester, analytics: analytics);

    await tester.tap(find.byKey(const Key('get-started')));
    await tester.pumpAndSettle();

    expect(find.text('THE GAP'), findsOneWidget);
    expect(GuestSessionRepository(harness.$2).hasSession, isTrue);
    expect(analytics.has(AnalyticsEvent.getStartedPress), isTrue);
    expect(analytics.has(AnalyticsEvent.anonymousSignInSuccess), isTrue);
  });

  testWidgets('failed guest session shows a friendly alert', (tester) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(
      tester,
      analytics: analytics,
      anonymousAuth: _FailingAuth(),
    );

    await tester.tap(find.byKey(const Key('get-started')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.couldNotContinueTitle), findsOneWidget);
    expect(find.text(AppStrings.couldNotContinueMessage), findsOneWidget);
    expect(find.text(AppStrings.getStarted), findsOneWidget);
    expect(analytics.has(AnalyticsEvent.anonymousSignInError), isTrue);
  });

  testWidgets('Terms and Privacy open their own in-app documents', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(tester, analytics: analytics);

    await tester.tap(find.byKey(const Key('welcome-terms')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.termsOfUseTitle), findsWidgets);
    expect(find.text(AppStrings.privacyPolicy), findsNothing);
    expect(
      find.textContaining('This version of Kichta is free', findRichText: true),
      findsWidgets,
    );
    expect(find.textContaining(r'$19.99'), findsNothing);
    expect(analytics.has(AnalyticsEvent.termsPress), isTrue);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('welcome-privacy')));
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.privacyPolicy), findsWidgets);
    expect(analytics.has(AnalyticsEvent.privacyPress), isTrue);
  });

  testWidgets('brand tiles keep brand color and do not navigate', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    await pumpKichtaApp(tester, analytics: analytics);

    await tester.tap(find.byKey(const Key('featured-brand-netflix')));
    await tester.pump();

    expect(find.text(AppStrings.getStarted), findsOneWidget);
    expect(analytics.has(AnalyticsEvent.featuredBrandTap), isTrue);
    expect(analytics.propertiesFor(AnalyticsEvent.featuredBrandTap), {
      'kind': FeaturedBrands.slugs.first,
    });
    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is Container &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color ==
                BrandRegistry.bySlug['netflix']!.tileBg,
      ),
      findsWidgets,
    );
  });

  testWidgets('CTA uses accent fill, not a muted background', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester);

    final button = tester.widget<FilledButton>(
      find.byKey(const Key('get-started')),
    );
    final style = button.style;
    expect(style?.backgroundColor?.resolve({}), AppTokens.dark.accent);
  });

  testWidgets('completed onboarding flashes welcome then opens home', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(
      tester,
      prefs: {OnboardingRepository.completedKey: true},
      settle: false,
    );

    expect(find.text(AppStrings.getStarted), findsOneWidget);

    await tester.pump(WelcomeScreen.authenticatedFlash);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.noRenewalsThisWeek), findsOneWidget);
  });
}
