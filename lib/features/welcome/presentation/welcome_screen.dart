import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../../onboarding/data/onboarding_repository.dart';
import '../welcome_providers.dart';
import 'welcome_cta.dart';
import 'welcome_footer.dart';
import 'welcome_hero.dart';
import 'welcome_trust_row.dart';
import 'works_with_grid.dart';

class WelcomeScreen extends ConsumerStatefulWidget {
  const WelcomeScreen({super.key});

  static const authenticatedFlash = Duration(milliseconds: 800);

  @override
  ConsumerState<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _CenteredHero extends StatelessWidget {
  const _CenteredHero();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                WelcomeHero(),
                WorksWithGrid(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WelcomeScreenState extends ConsumerState<WelcomeScreen> {
  Timer? _flash;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (ref.read(onboardingRepositoryProvider).isCompleted) {
        _flash = Timer(WelcomeScreen.authenticatedFlash, () {
          if (mounted) {
            context.go(AppRoutes.dashboard);
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _flash?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(analyticsScreenViewProvider(AnalyticsEvent.welcomeView));
    final tokens = AppTokens.of(context);
    final padding = MediaQuery.paddingOf(context);
    final action = ref.watch(welcomeActionProvider);
    final dark = Theme.of(context).brightness == Brightness.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: tokens.bgApp,
        body: Column(
          children: [
            SizedBox(height: padding.top),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 28),
                child: _CenteredHero(),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, padding.bottom + 20),
              child: Column(
                children: [
                  const WelcomeTrustRow(),
                  WelcomeCta(
                    pending: action.pending,
                    onPressed: action.pending ? null : _getStarted,
                  ),
                  WelcomeFooter(
                    onTerms: () => _openLegal(privacy: false),
                    onPrivacy: () => _openLegal(privacy: true),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getStarted() async {
    _flash?.cancel();
    if (ref.read(onboardingRepositoryProvider).isCompleted) {
      if (mounted) {
        context.go(AppRoutes.dashboard);
      }
      return;
    }
    final ok = await ref.read(welcomeActionProvider.notifier).startAnonymous();
    if (!mounted) {
      return;
    }
    if (ok) {
      HapticFeedback.mediumImpact();
      context.go(AppRoutes.onboarding);
      return;
    }
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.couldNotContinueTitle),
          content: const Text(AppStrings.couldNotContinueMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(AppStrings.continueLabel),
            ),
          ],
        );
      },
    );
  }

  Future<void> _openLegal({required bool privacy}) async {
    ref.read(analyticsProvider).track(
      privacy ? AnalyticsEvent.privacyPress : AnalyticsEvent.termsPress,
    );
    if (!mounted) {
      return;
    }
    context.push(privacy ? AppRoutes.privacyPolicy : AppRoutes.termsOfUse);
  }
}
