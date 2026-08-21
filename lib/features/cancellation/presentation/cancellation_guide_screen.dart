import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../subscriptions/domain/subscription.dart';
import '../../subscriptions/subscriptions_providers.dart';
import '../cancellation_providers.dart';
import '../domain/cancellation_catalog.dart';
import '../domain/cancellation_guide.dart';
import '../domain/cancellation_message.dart';

class CancellationGuideScreen extends ConsumerWidget {
  const CancellationGuideScreen({required this.subscriptionId, super.key});

  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(subscriptionByIdProvider(subscriptionId));

    return async.when(
      loading: () => const AppScaffold(
        title: AppStrings.cancellationGuide,
        body: LoadingState(),
      ),
      error: (error, stackTrace) => AppScaffold(
        title: AppStrings.cancellationGuide,
        body: ErrorState(
          message: AppStrings.errorLoadSubscriptions,
          onRetry: () =>
              ref.invalidate(subscriptionByIdProvider(subscriptionId)),
        ),
      ),
      data: (subscription) {
        if (subscription == null) {
          return AppScaffold(
            title: AppStrings.cancellationGuide,
            body: ErrorState(
              message: AppStrings.subscriptionNotFound,
              retryLabel: AppStrings.backToList,
              onRetry: () => context.go(AppRoutes.subscriptions),
            ),
          );
        }
        final guide = CancellationCatalog.lookup(
          merchant: subscription.merchant,
          name: subscription.name,
        );
        return _CancellationGuideBody(
          subscription: subscription,
          guide: guide,
        );
      },
    );
  }
}

class _CancellationGuideBody extends ConsumerWidget {
  const _CancellationGuideBody({
    required this.subscription,
    required this.guide,
  });

  final Subscription subscription;
  final CancellationGuide guide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return AppScaffold(
      title: AppStrings.cancellationGuide,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(guide.merchantLabel, style: textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.md),
            Text(
              AppStrings.cancellationDidNotHappen,
              style: textTheme.bodyLarge,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _LabeledText(
                    label: AppStrings.cancellationEstimatedTime,
                    value: guide.estimatedTime,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledText(
                    label: AppStrings.cancellationInstructions,
                    value: guide.instructions,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _LabeledText(
                    label: AppStrings.cancellationNotes,
                    value: guide.notes,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            if (guide.canOpenPage) ...[
              AppButton(
                key: const Key('open-cancellation-page'),
                label: AppStrings.openCancellationPage,
                onPressed: () => _openPage(context, ref),
              ),
              const SizedBox(height: AppSpacing.md),
            ],
            if (guide.includeMessage)
              AppButton(
                key: const Key('generate-cancellation-message'),
                label: AppStrings.generateCancellationMessage,
                variant: guide.canOpenPage
                    ? AppButtonVariant.secondary
                    : AppButtonVariant.primary,
                onPressed: () => _showMessage(context),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openPage(BuildContext context, WidgetRef ref) async {
    final uri = guide.officialUrl;
    if (uri == null) {
      return;
    }
    final opened = await ref.read(cancellationLinkOpenerProvider).open(uri);
    if (!context.mounted) {
      return;
    }
    if (!opened) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text(AppStrings.cancellationOpenFailed)),
      );
    }
  }

  Future<void> _showMessage(BuildContext context) {
    final message = CancellationMessage.compose(
      merchant: subscription.merchant,
      subscriptionName: subscription.name,
      nextBillingDate: subscription.nextBillingDate,
    );
    return showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.generateCancellationMessage),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(message),
                const SizedBox(height: AppSpacing.md),
                const Text(AppStrings.cancellationMessageDisclaimer),
              ],
            ),
          ),
          actions: [
            AppButton(
              label: AppStrings.cancel,
              expand: false,
              variant: AppButtonVariant.tertiary,
              onPressed: () => Navigator.of(context).pop(),
            ),
            AppButton(
              key: const Key('copy-cancellation-message'),
              label: AppStrings.copyMessage,
              expand: false,
              onPressed: () async {
                await Clipboard.setData(ClipboardData(text: message));
                if (!context.mounted) {
                  return;
                }
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(AppStrings.cancellationMessageCopied),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _LabeledText extends StatelessWidget {
  const _LabeledText({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: textTheme.labelMedium),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: textTheme.bodyLarge),
      ],
    );
  }
}
