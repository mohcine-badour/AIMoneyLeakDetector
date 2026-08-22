import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../insights_providers.dart';
import '../insights_scroll.dart';
import 'category_breakdown_card.dart';
import 'empty_insights_state.dart';
import 'insight_callout.dart';
import 'insights_header.dart';
import 'spend_hero_card.dart';
import 'timeframe_menu.dart';
import 'top_by_cost_card.dart';

class InsightsScreen extends ConsumerStatefulWidget {
  const InsightsScreen({super.key});

  @override
  ConsumerState<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends ConsumerState<InsightsScreen> {
  final _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(subscriptionsProvider);
    final tokens = AppTokens.of(context);

    ref.listen(insightsScrollToTopProvider, (previous, next) {
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
          data: (subscriptions) {
            final active = subscriptions
                .where((item) => item.status == SubscriptionStatus.active)
                .toList();
            if (active.isEmpty) {
              return const EmptyInsightsState();
            }
            return _InsightsBody(controller: _scroll);
          },
        ),
      ),
    );
  }
}

class _InsightsBody extends ConsumerWidget {
  const _InsightsBody({required this.controller});

  final ScrollController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metrics = ref.watch(spendMetricsProvider);
    final breakdown = ref.watch(categoryBreakdownProvider);
    final topByCost = ref.watch(topByCostProvider);
    final insights = ref.watch(insightListProvider);
    final now = ref.watch(appNowProvider);

    return ListView(
      controller: controller,
      padding: const EdgeInsets.only(bottom: 24),
      children: [
        InsightsHeader(
          onTimeframePress: () async {
            final selected = await showTimeframeMenu(
              context: context,
              current: ref.read(insightsTimeframeProvider),
            );
            if (selected == null) {
              return;
            }
            ref.read(insightsTimeframeProvider.notifier).setTimeframe(selected);
          },
        ),
        SpendHeroCard(metrics: metrics, now: now),
        CategoryBreakdownCard(breakdown: breakdown),
        TopByCostCard(result: topByCost),
        if (insights.isNotEmpty) InsightCallout(insights: insights),
      ],
    );
  }
}
