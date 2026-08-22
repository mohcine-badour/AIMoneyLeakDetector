import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../app/theme/app_tokens.dart';
import '../analytics/analytics_providers.dart';
import '../analytics/domain/analytics_event.dart';
import '../paywall/domain/paywall_source.dart';
import 'domain/onboarding_pages.dart';
import 'onboarding_controller.dart';
import 'presentation/onboarding_cta.dart';
import 'presentation/onboarding_header.dart';
import 'presentation/onboarding_page.dart';
import 'presentation/onboarding_swipe_hint.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  late final PageController _pager;
  var _programmatic = false;
  var _started = false;

  @override
  void initState() {
    super.initState();
    _pager = PageController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _started) {
        return;
      }
      _started = true;
      ref.read(onboardingControllerProvider.notifier).trackPageView();
    });
  }

  @override
  void dispose() {
    _pager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(analyticsScreenViewProvider(AnalyticsEvent.onboardingStarted));
    final tokens = AppTokens.of(context);
    final flow = ref.watch(onboardingControllerProvider);
    final padding = MediaQuery.paddingOf(context);
    final dark = Theme.of(context).brightness == Brightness.dark;

    ref.listen<OnboardingFlowState>(onboardingControllerProvider, (
      previous,
      next,
    ) {
      if (previous?.index == next.index) {
        return;
      }
      if (!_pager.hasClients) {
        return;
      }
      if (_pager.page?.round() == next.index) {
        return;
      }
      _programmatic = true;
      _pager.animateToPage(
        next.index,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (didPop) {
            return;
          }
          if (flow.isFirst) {
            context.go(AppRoutes.launch);
          } else {
            ref.read(onboardingControllerProvider.notifier).goToPrevious();
          }
        },
        child: Scaffold(
          backgroundColor: tokens.bgApp,
          body: Column(
            children: [
              SizedBox(height: padding.top),
              OnboardingHeader(
                currentIndex: flow.index,
                totalPages: flow.total,
                onBack: flow.isFirst
                    ? null
                    : () => ref
                          .read(onboardingControllerProvider.notifier)
                          .goToPrevious(),
                onSkip: () => _complete(OnboardingCompleteVia.skip),
                onPillPress: (index) => ref
                    .read(onboardingControllerProvider.notifier)
                    .goToPage(index),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pager,
                  itemCount: OnboardingPages.all.length,
                  onPageChanged: (index) {
                    if (_programmatic) {
                      _programmatic = false;
                      return;
                    }
                    ref
                        .read(onboardingControllerProvider.notifier)
                        .syncFromUserScroll(index);
                  },
                  itemBuilder: (context, index) {
                    final page = OnboardingPages.all[index];
                    return OnboardingPageView(
                      page: page,
                      heroShown: flow.shownHeroes.contains(page.id),
                      onHeroShown: () => ref
                          .read(onboardingControllerProvider.notifier)
                          .markHeroShown(page.id),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 24, padding.bottom + 20),
                child: Column(
                  children: [
                    OnboardingCta(
                      label: flow.page.ctaLabel,
                      icon: flow.page.ctaIcon,
                      onPressed: () {
                        if (flow.isLast) {
                          _complete(OnboardingCompleteVia.ctaFinal);
                          return;
                        }
                        ref
                            .read(onboardingControllerProvider.notifier)
                            .goToNext();
                      },
                    ),
                    if (!flow.isLast) const OnboardingSwipeHint(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _complete(OnboardingCompleteVia via) async {
    await ref.read(onboardingControllerProvider.notifier).complete(via);
    if (!mounted) {
      return;
    }
    context.go(AppRoutes.paywallLocation(source: PaywallSource.onboarding));
  }
}
