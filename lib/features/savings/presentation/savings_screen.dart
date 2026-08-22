import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../ai_analysis/ai_analysis_providers.dart';
import '../../ai_analysis/domain/money_leak_report.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../../subscriptions/usage_controller.dart';
import '../../trials/trials_providers.dart';
import '../domain/leak_recommendation.dart';
import 'leak_recommendation_card.dart';

class SavingsScreen extends ConsumerWidget {
  const SavingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(moneyLeakReportProvider);

    return AppScaffold(
      title: AppStrings.insightsTitle,
      showTabs: true,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.md,
      ),
      body: async.when(
        loading: () =>
            const LoadingState(message: AppStrings.analysisProcessing),
        error: (error, stackTrace) => ErrorState(
          message: AppStrings.errorLoadAnalysis,
          onRetry: () {
            ref.invalidate(subscriptionsProvider);
            ref.invalidate(trialsProvider);
            ref.invalidate(declaredUsageCountsProvider);
            ref.invalidate(moneyLeakReportProvider);
          },
        ),
        data: (report) => _ReportBody(report: report),
      ),
    );
  }
}

class _ReportBody extends StatelessWidget {
  const _ReportBody({required this.report});

  final MoneyLeakReport report;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final spend = MoneyFormat.format(
      report.monthlySpend,
      currencyCode: report.currencyCode,
    );
    final savings = MoneyFormat.format(
      report.potentialSavings,
      currencyCode: report.currencyCode,
    );

    return ListView(
      children: [
        Text(AppStrings.moneyLeakReportTitle, style: textTheme.headlineMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(AppStrings.analysisReadOnlyNotice, style: textTheme.bodySmall),
        const SizedBox(height: AppSpacing.xl),
        Text(AppStrings.youSpend, style: textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(
          '$spend${AppStrings.compactPerMonth}',
          style: textTheme.displaySmall,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppCard(
          tone: AppCardTone.insight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppStrings.potentialSavingsLabel,
                style: textTheme.labelMedium,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                '$savings${AppStrings.compactPerMonth}',
                style: textTheme.titleLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(AppStrings.weFound, style: textTheme.titleLarge),
        const SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.subscriptionsToReview(
            report.summary.subscriptionsToReview,
          ),
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.possibleOverlaps(report.summary.possibleOverlaps),
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          AppStrings.upcomingExpensiveRenewals(
            report.summary.upcomingExpensiveRenewals,
          ),
          style: textTheme.bodyLarge,
        ),
        const SizedBox(height: AppSpacing.xl),
        if (report.items.isEmpty)
          const EmptyState(
            title: AppStrings.emptyLeaksTitle,
            message: AppStrings.emptyLeaksMessage,
          )
        else
          for (var i = 0; i < report.items.length; i++) ...[
            if (i > 0) const Divider(),
            LeakRecommendationCard(
              recommendation: report.items[i].recommendation,
              explanation: report.items[i].explanation,
              onTap: () => _open(context, report.items[i].recommendation),
            ),
          ],
      ],
    );
  }

  void _open(BuildContext context, LeakRecommendation item) {
    final subscriptionId = item.subscriptionId;
    if (subscriptionId != null) {
      context.push(AppRoutes.subscriptionDetailLocation(subscriptionId));
      return;
    }
    final trialId = item.trialId;
    if (trialId != null) {
      context.push(AppRoutes.trialDetailLocation(trialId));
    }
  }
}
