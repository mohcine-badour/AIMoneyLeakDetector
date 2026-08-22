import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/merchant_mark.dart';
import '../../paywall/paywall_navigation.dart';
import '../../trials/domain/trial.dart';
import '../../trials/domain/trial_countdown.dart';
import '../../trials/presentation/trial_labels.dart';

class HomeTrialsSection extends ConsumerWidget {
  const HomeTrialsSection({required this.trials, required this.now, super.key});

  final List<Trial> trials;
  final DateTime now;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final live = [
      for (final trial in trials)
        if (_isLive(trial)) trial,
    ].take(3).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.trialsTitle,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: tokens.textPrimary,
                  ),
                ),
              ),
              InkWell(
                key: const Key('open-trials'),
                onTap: () => context.push(AppRoutes.trials),
                child: Text(
                  AppStrings.viewAll,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: tokens.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: tokens.bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: tokens.border, width: 0.5),
          ),
          child: live.isEmpty
              ? InkWell(
                  onTap: () => PaywallNavigation.addTrial(context, ref),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Text(
                      AppStrings.trackAFreeTrial,
                      style: TextStyle(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w500,
                        color: tokens.textPrimary,
                      ),
                    ),
                  ),
                )
              : Column(
                  children: [
                    for (var i = 0; i < live.length; i++) ...[
                      if (i > 0)
                        Divider(
                          height: 0.5,
                          thickness: 0.5,
                          color: tokens.border,
                        ),
                      _HomeTrialRow(trial: live[i], now: now),
                    ],
                  ],
                ),
        ),
      ],
    );
  }

  bool _isLive(Trial trial) {
    final status = TrialCountdown.displayStatus(
      stored: trial.status,
      trialEndDate: trial.trialEndDate,
      now: now,
    );
    return status == TrialStatus.active || status == TrialStatus.endingSoon;
  }
}

class _HomeTrialRow extends StatelessWidget {
  const _HomeTrialRow({required this.trial, required this.now});

  final Trial trial;
  final DateTime now;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return InkWell(
      onTap: () => context.push(AppRoutes.trialDetailLocation(trial.id)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            MerchantMark(name: trial.subscriptionName, size: 34),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    trial.subscriptionName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      color: tokens.textPrimary,
                      letterSpacing: -0.1,
                    ),
                  ),
                  Text(
                    TrialLabels.remaining(trial: trial, now: now),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: tokens.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
