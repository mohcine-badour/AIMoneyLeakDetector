import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/app/router/app_routes.dart';
import 'package:kichta/core/constants/app_strings.dart';
import 'package:kichta/features/analytics/data/recording_analytics.dart';
import 'package:kichta/features/analytics/domain/analytics_event.dart';
import 'package:kichta/features/auth/data/guest_session_repository.dart';
import 'package:kichta/features/auth/domain/auth_form_validator.dart';

import 'helpers/pump_app.dart';

void _largeScreen(WidgetTester tester) {
  tester.view.physicalSize = const Size(800, 2000);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}

void main() {
  test('sign-in validator requires email and a long enough password', () {
    final empty = AuthFormValidator.validate(email: '', password: '');
    expect(empty.email, AppStrings.errorEmailInvalid);
    expect(empty.password, AppStrings.errorPasswordShort);
    expect(empty.confirmPassword, isNull);

    final ok = AuthFormValidator.validate(
      email: 'ada@example.com',
      password: 'password1',
    );
    expect(ok.hasErrors, isFalse);
  });

  test('register validator requires matching passwords', () {
    final mismatch = AuthFormValidator.validate(
      email: 'ada@example.com',
      password: 'password1',
      confirmPassword: 'password2',
      isRegister: true,
    );
    expect(mismatch.confirmPassword, AppStrings.errorPasswordMismatch);

    final ok = AuthFormValidator.validate(
      email: 'ada@example.com',
      password: 'password1',
      confirmPassword: 'password1',
      isRegister: true,
    );
    expect(ok.hasErrors, isFalse);
  });

  testWidgets('empty sign-in shows validation errors', (tester) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.signIn);

    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.errorEmailInvalid), findsOneWidget);
    expect(find.text(AppStrings.errorPasswordShort), findsOneWidget);
    expect(find.text(AppStrings.authWelcomeBack), findsOneWidget);
  });

  testWidgets('valid sign-in starts a local session and opens onboarding', (
    tester,
  ) async {
    _largeScreen(tester);
    final analytics = RecordingAnalytics();
    final harness = await pumpKichtaApp(
      tester,
      location: AppRoutes.signIn,
      analytics: analytics,
    );

    await tester.enterText(
      find.byKey(const Key('auth-email')),
      'ada@example.com',
    );
    await tester.enterText(find.byKey(const Key('auth-password')), 'password1');
    await tester.tap(find.byKey(const Key('auth-submit')));
    await tester.pumpAndSettle();

    expect(find.text('THE GAP'), findsOneWidget);
    expect(GuestSessionRepository(harness.$2).hasSession, isTrue);
    expect(analytics.has(AnalyticsEvent.anonymousSignInSuccess), isTrue);
  });

  testWidgets(
    'create account shows confirm field and switches back to sign in',
    (tester) async {
      _largeScreen(tester);
      await pumpKichtaApp(tester, location: AppRoutes.signIn);

      await tester.tap(find.byKey(const Key('auth-switch')));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.authCreateHeadline), findsOneWidget);
      expect(find.byKey(const Key('auth-confirm-password')), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('auth-email')),
        'ada@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('auth-password')),
        'password1',
      );
      await tester.enterText(
        find.byKey(const Key('auth-confirm-password')),
        'nope',
      );
      await tester.tap(find.byKey(const Key('auth-submit')));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.errorPasswordMismatch), findsOneWidget);
      expect(find.text(AppStrings.authCreateHeadline), findsOneWidget);

      await tester.enterText(
        find.byKey(const Key('auth-confirm-password')),
        'password1',
      );
      await tester.tap(find.byKey(const Key('auth-submit')));
      await tester.pumpAndSettle();

      expect(find.text('THE GAP'), findsOneWidget);
    },
  );

  testWidgets('social buttons explain that providers are not wired yet', (
    tester,
  ) async {
    _largeScreen(tester);
    await pumpKichtaApp(tester, location: AppRoutes.signIn);

    expect(find.text(AppStrings.continueWithApple), findsOneWidget);
    expect(find.text(AppStrings.continueWithGoogle), findsOneWidget);
    expect(find.text(AppStrings.continueWithFacebook), findsOneWidget);

    await tester.ensureVisible(find.byKey(const Key('auth-apple')));
    await tester.tap(find.byKey(const Key('auth-apple')));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.socialSignInUnavailable), findsOneWidget);
    expect(find.text('THE GAP'), findsNothing);
  });
}
