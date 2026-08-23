import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../ads/domain/ad_placement.dart';
import '../../ads/presentation/ad_banner_slot.dart';
import '../../paywall/paywall_navigation.dart';
import '../trials_providers.dart';
import 'trial_list_card.dart';

class TrialsListScreen extends ConsumerWidget {
  const TrialsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final visible = ref.watch(visibleTrialsProvider);
    final now = ref.watch(appNowProvider);

    return AppScaffold(
      title: AppStrings.trialsTitle,
      actions: [
        IconButton(
          onPressed: () => PaywallNavigation.addTrial(context, ref),
          tooltip: AppStrings.addTrialTitle,
          icon: const Icon(AppIcons.add),
        ),
      ],
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.page,
        AppSpacing.sm,
        AppSpacing.page,
        AppSpacing.page,
      ),
      bottomBanner: AdBannerSlot(
        placement: AdPlacement.trials,
        visible: visible.asData?.value.isNotEmpty ?? false,
      ),
      body: visible.when(
        loading: () => const LoadingState(),
        error: (error, stackTrace) => ErrorState(
          message: AppStrings.errorLoadTrials,
          onRetry: () => ref.invalidate(trialsProvider),
        ),
        data: (items) {
          if (items.isEmpty) {
            return EmptyState(
              title: AppStrings.emptyTrialsTitle,
              message: AppStrings.emptyTrialsMessage,
              actionLabel: AppStrings.addTrialTitle,
              onAction: () => PaywallNavigation.addTrial(context, ref),
            );
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (context, index) => const Divider(),
            itemBuilder: (context, index) {
              final trial = items[index];
              return TrialListCard(
                trial: trial,
                now: now,
                onTap: () =>
                    context.push(AppRoutes.trialDetailLocation(trial.id)),
              );
            },
          );
        },
      ),
    );
  }
}
