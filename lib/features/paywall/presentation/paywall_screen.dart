import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/config/app_config.dart';
import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/clock_provider.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../../cancellation/cancellation_providers.dart';
import '../domain/paywall_plan.dart';
import '../domain/paywall_source.dart';
import '../paywall_providers.dart';
import 'paywall_cta.dart';
import 'paywall_feature_list.dart';
import 'paywall_fine_print.dart';
import 'paywall_header.dart';
import 'paywall_hero.dart';
import 'paywall_pricing_card.dart';
import 'paywall_trust_row.dart';

class PaywallScreen extends ConsumerStatefulWidget {
  const PaywallScreen({this.source = PaywallSource.settings, super.key});

  final PaywallSource source;

  @override
  ConsumerState<PaywallScreen> createState() => _PaywallScreenState();
}

class _PaywallScreenState extends ConsumerState<PaywallScreen> {
  var _viewTracked = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      if (ref.read(entitlementProvider).isPro) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(AppStrings.alreadyPro)),
        );
        _leave();
        return;
      }
      if (_viewTracked) {
        return;
      }
      _viewTracked = true;
      ref.read(analyticsProvider).track(
        AnalyticsEvent.paywallViewed,
        properties: {'source': widget.source.query},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final offerings = ref.watch(paywallOfferingsProvider);
    final selected = ref.watch(paywallPlanProvider);
    final action = ref.watch(paywallActionProvider);
    final now = ref.watch(appNowProvider);

    if (ref.watch(entitlementProvider).isPro) {
      return ColoredBox(color: tokens.bgApp, child: const SizedBox.expand());
    }

    return AppScaffold(
      showAppBar: false,
      padding: EdgeInsets.zero,
      body: ColoredBox(
        color: tokens.bgApp,
        child: ListView(
          children: [
            PaywallHeader(
              onDismiss: () {
                ref.read(analyticsProvider).track(
                  AnalyticsEvent.paywallDismissed,
                  properties: {'source': widget.source.query},
                );
                _leave();
              },
            ),
            const PaywallHero(),
            const PaywallFeatureList(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Column(
                children: [
                  PaywallPricingCard(
                    plan: PaywallPlan.yearly,
                    offerings: offerings,
                    selected: selected == PaywallPlan.yearly,
                    onPress: () => _select(PaywallPlan.yearly),
                  ),
                  const SizedBox(height: 8),
                  PaywallPricingCard(
                    plan: PaywallPlan.monthly,
                    offerings: offerings,
                    selected: selected == PaywallPlan.monthly,
                    onPress: () => _select(PaywallPlan.monthly),
                  ),
                ],
              ),
            ),
            PaywallCta(
              plan: selected,
              offerings: offerings,
              purchasing: action.isPurchasing,
              onPressed: action.isBusy ? null : () => _purchase(selected),
            ),
            if (selected == PaywallPlan.yearly && offerings.hasYearlyTrial)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 6, 20, 0),
                child: Text(
                  AppStrings.trialNotChargedToday(
                    AppDateFormat.monthDayShort(
                      now.add(
                        Duration(days: offerings.yearlyIntroTrialDays!),
                      ),
                    ),
                  ),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 10.5, color: tokens.textMuted),
                ),
              ),
            const PaywallTrustRow(),
            PaywallFinePrint(
              restoring: action.isRestoring,
              onRestore: _restore,
              onTerms: () => _openLegal(privacy: false),
              onPrivacy: () => _openLegal(privacy: true),
            ),
          ],
        ),
      ),
    );
  }

  void _select(PaywallPlan plan) {
    ref.read(paywallPlanProvider.notifier).select(plan);
    ref.read(analyticsProvider).track(
      AnalyticsEvent.paywallPlanToggled,
      properties: {'plan': plan.name},
    );
  }

  Future<void> _purchase(PaywallPlan plan) async {
    final unlocked = await ref
        .read(paywallActionProvider.notifier)
        .purchase(plan);
    if (!mounted) {
      return;
    }
    if (unlocked) {
      _leave();
      return;
    }
    final error = ref.read(paywallActionProvider).error;
    if (error != null) {
      await _alert(AppStrings.purchaseFailedTitle, error);
    }
  }

  Future<void> _restore() async {
    final unlocked = await ref.read(paywallActionProvider.notifier).restore();
    if (!mounted) {
      return;
    }
    if (unlocked) {
      await _alert(
        AppStrings.restoreSuccessTitle,
        AppStrings.restoreSuccessMessage,
      );
      if (mounted) {
        _leave();
      }
      return;
    }
    final error = ref.read(paywallActionProvider).error;
    if (error == AppStrings.restoreNone) {
      await _alert(AppStrings.restoreNoneTitle, AppStrings.restoreNone);
      return;
    }
    if (error != null) {
      await _alert(AppStrings.restoreFailedTitle, error);
    }
  }

  Future<void> _openLegal({required bool privacy}) async {
    ref.read(analyticsProvider).track(
      privacy
          ? AnalyticsEvent.paywallPrivacyOpened
          : AnalyticsEvent.paywallTermsOpened,
    );
    final raw = privacy ? AppConfig.privacyPolicyUrl : AppConfig.termsUrl;
    if (raw.isNotEmpty) {
      await ref.read(cancellationLinkOpenerProvider).open(Uri.parse(raw));
      return;
    }
    if (mounted) {
      context.push(AppRoutes.privacyPolicy);
    }
  }

  Future<void> _alert(String title, String message) {
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
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

  void _leave() {
    if (context.canPop()) {
      context.pop();
      return;
    }
    context.go(AppRoutes.dashboard);
  }
}
