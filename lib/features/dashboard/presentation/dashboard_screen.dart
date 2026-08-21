import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../../core/widgets/money_text.dart';
import '../../../core/widgets/section_header.dart';
import '../../subscriptions/presentation/subscription_labels.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../../upcoming/domain/upcoming_payment.dart';
import '../../upcoming/presentation/upcoming_payment_tile.dart';
import '../../upcoming/upcoming_providers.dart';
import '../domain/dashboard_snapshot.dart';
import '../domain/day_period.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clock = ref.watch(appNowProvider);
    ref.watch(upcomingReminderSyncProvider);
    final async = ref.watch(subscriptionsProvider);

    return AppScaffold(
      showAppBar: false,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.page,
      ),
      body: async.when(
        loading: () => const LoadingState(),
        error: (error, stackTrace) => ErrorState(
          message: AppStrings.errorLoadSubscriptions,
          onRetry: () => ref.invalidate(subscriptionsProvider),
        ),
        data: (subscriptions) {
          final snapshot = DashboardCalculator.fromSubscriptions(subscriptions);
          return _DashboardBody(now: clock, snapshot: snapshot);
        },
      ),
    );
  }
}

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({required this.now, required this.snapshot});

  final DateTime now;
  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _GreetingRow(now: now),
          const SizedBox(height: AppSpacing.xl),
          Text(
            AppStrings.yourSubscriptions,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: AppSpacing.md),
          _HeroTotals(snapshot: snapshot),
          const SizedBox(height: AppSpacing.xxl),
          const SectionHeader(title: AppStrings.monthlySpending),
          const SizedBox(height: AppSpacing.md),
          _AmountCard(
            amount: snapshot.monthlyTotal,
            currencyCode: snapshot.currencyCode,
            period: AppStrings.compactPerMonth,
          ),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: AppStrings.annualSpending),
          const SizedBox(height: AppSpacing.md),
          _AmountCard(
            amount: snapshot.annualTotal,
            currencyCode: snapshot.currencyCode,
            period: AppStrings.compactPerYear,
          ),
          const SizedBox(height: AppSpacing.xl),
          SectionHeader(
            title: AppStrings.upcomingPayments,
            actionLabel: AppStrings.viewAll,
            onAction: () => context.push(AppRoutes.upcoming),
          ),
          const SizedBox(height: AppSpacing.md),
          _UpcomingSection(now: now, upcoming: snapshot.upcoming),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: AppStrings.categoryBreakdown),
          const SizedBox(height: AppSpacing.md),
          _CategorySection(snapshot: snapshot),
          const SizedBox(height: AppSpacing.xl),
          const SectionHeader(title: AppStrings.potentialSavings),
          const SizedBox(height: AppSpacing.md),
          const AppCard(
            child: Text(AppStrings.potentialSavingsPlaceholder),
          ),
          if (snapshot.activeCount == 0) ...[
            const SizedBox(height: AppSpacing.xl),
            AppButton(
              label: AppStrings.addSubscriptionTitle,
              onPressed: () => context.push(AppRoutes.addSubscription),
            ),
          ],
        ],
      ),
    );
  }
}

class _GreetingRow extends StatelessWidget {
  const _GreetingRow({required this.now});

  final DateTime now;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            GreetingPeriodResolver.from(now).label,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        IconButton(
          tooltip: AppStrings.subscriptionsTitle,
          onPressed: () => context.push(AppRoutes.subscriptions),
          icon: const Icon(AppIcons.subscriptions),
        ),
      ],
    );
  }
}

class _HeroTotals extends StatelessWidget {
  const _HeroTotals({required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            MoneyFormat.format(
              snapshot.monthlyTotal,
              currencyCode: snapshot.currencyCode,
            ),
            style: textTheme.displaySmall,
          ),
          Text(AppStrings.compactPerMonth, style: textTheme.titleMedium),
          const SizedBox(height: AppSpacing.lg),
          Text(
            MoneyFormat.format(
              snapshot.annualTotal,
              currencyCode: snapshot.currencyCode,
            ),
            style: textTheme.headlineMedium,
          ),
          Text(AppStrings.compactPerYear, style: textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _AmountCard extends StatelessWidget {
  const _AmountCard({
    required this.amount,
    required this.currencyCode,
    required this.period,
  });

  final double amount;
  final String currencyCode;
  final String period;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoneyText(amount: amount, currencyCode: currencyCode),
          const SizedBox(height: AppSpacing.xs),
          Text(period, style: Theme.of(context).textTheme.titleMedium),
        ],
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({required this.now, required this.upcoming});

  final DateTime now;
  final List<UpcomingPayment> upcoming;

  @override
  Widget build(BuildContext context) {
    if (upcoming.isEmpty) {
      return const AppCard(child: Text(AppStrings.noUpcomingPayments));
    }

    return Column(
      children: [
        for (var i = 0; i < upcoming.length; i++) ...[
          if (i > 0) const SizedBox(height: AppSpacing.md),
          UpcomingPaymentTile(now: now, payment: upcoming[i]),
        ],
      ],
    );
  }
}

class _CategorySection extends StatelessWidget {
  const _CategorySection({required this.snapshot});

  final DashboardSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    if (snapshot.categories.isEmpty) {
      return const AppCard(child: Text(AppStrings.emptyCategoryBreakdown));
    }

    final maxAmount = snapshot.categories.first.monthlyAmount;
    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < snapshot.categories.length; i++) ...[
            if (i > 0) const SizedBox(height: AppSpacing.lg),
            _CategoryRow(
              spend: snapshot.categories[i],
              currencyCode: snapshot.currencyCode,
              fraction: maxAmount == 0
                  ? 0
                  : snapshot.categories[i].monthlyAmount / maxAmount,
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.spend,
    required this.currencyCode,
    required this.fraction,
  });

  final CategorySpend spend;
  final String currencyCode;
  final double fraction;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(spend.category.label, style: textTheme.titleSmall),
            ),
            MoneyText(
              amount: spend.monthlyAmount,
              currencyCode: currencyCode,
              compact: true,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.mark,
          child: LinearProgressIndicator(
            value: fraction.clamp(0, 1),
            minHeight: 6,
            backgroundColor: colorScheme.outline.withValues(alpha: 0.24),
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

extension on GreetingPeriod {
  String get label => switch (this) {
        GreetingPeriod.morning => AppStrings.goodMorning,
        GreetingPeriod.afternoon => AppStrings.goodAfternoon,
        GreetingPeriod.evening => AppStrings.goodEvening,
      };
}
