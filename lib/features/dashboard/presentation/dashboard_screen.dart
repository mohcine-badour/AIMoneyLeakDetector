import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../paywall/paywall_navigation.dart';
import '../../paywall/paywall_providers.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../domain/home_insight.dart';
import '../domain/spending_summary.dart';
import '../home_scroll.dart';
import 'home_greeting.dart';
import 'home_insight_card.dart';
import 'home_list_sections.dart';
import 'monthly_hero_card.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clock = ref.watch(appNowProvider);
    final async = ref.watch(subscriptionsProvider);
    final tokens = AppTokens.of(context);

    ref.listen(homeScrollToTopProvider, (previous, next) {
      if (previous == next || !_scroll.hasClients) {
        return;
      }
      _scroll.animateTo(
        0,
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOutCubic,
      );
    });

    return AppScaffold(
      showAppBar: false,
      showTabs: true,
      padding: EdgeInsets.zero,
      body: ColoredBox(
        color: tokens.bgApp,
        child: async.when(
          loading: () => const LoadingState(),
          error: (error, stackTrace) => ErrorState(
            message: AppStrings.errorLoadSubscriptions,
            onRetry: () => ref.invalidate(subscriptionsProvider),
          ),
          data: (subscriptions) => _HomeBody(
            controller: _scroll,
            now: clock,
            subscriptions: subscriptions,
            showUnlock: !ref.watch(entitlementProvider).isPro,
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({
    required this.controller,
    required this.now,
    required this.subscriptions,
    required this.showUnlock,
  });

  final ScrollController controller;
  final DateTime now;
  final List<Subscription> subscriptions;
  final bool showUnlock;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summary = SpendingSummaryCalculator.fromSubscriptions(
      subscriptions,
      now: now,
    );
    final split = RenewalWindow.split(subscriptions, now);
    final insight = HomeInsightResolver.fromSubscriptions(
      subscriptions,
      now: now,
    );

    return ListView(
      controller: controller,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        HomeGreeting(now: now, renewalCount: split.soon.length),
        if (showUnlock)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: AppButton(
              key: const Key('dashboard-unlock-pro'),
              label: AppStrings.unlockPro,
              variant: AppButtonVariant.tertiary,
              onPressed: () => context.push(AppRoutes.paywall),
            ),
          ),
        MonthlyHeroCard(summary: summary, now: now),
        if (summary.activeCount == 0)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: AppButton(
              label: AppStrings.addSubscriptionTitle,
              onPressed: () => PaywallNavigation.addSubscription(context, ref),
            ),
          )
        else ...[
          RenewingSoonSection(subscriptions: split.soon, now: now),
          if (insight != null) HomeInsightCard(insight: insight),
          AllSubscriptionsSection(
            subscriptions: split.remaining,
            now: now,
            activeCount: summary.activeCount,
            onSeeAll: () => context.go(AppRoutes.subscriptions),
          ),
        ],
      ],
    );
  }
}
