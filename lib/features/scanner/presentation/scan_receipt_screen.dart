import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_radius.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/loading_state.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../../subscriptions/presentation/subscription_labels.dart';
import '../domain/extracted_receipt.dart';
import '../domain/receipt_image.dart';
import '../scan_flow_controller.dart';

class ScanReceiptScreen extends ConsumerWidget {
  const ScanReceiptScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(analyticsScreenViewProvider(AnalyticsEvent.receiptScanStarted));
    final flow = ref.watch(scanFlowControllerProvider);
    final controller = ref.read(scanFlowControllerProvider.notifier);

    return AppScaffold(
      title: flow.step == ScanFlowStep.extracted
          ? AppStrings.scanExtractedTitle
          : AppStrings.scanReceiptTitle,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: switch (flow.step) {
        ScanFlowStep.source => _SourceStep(
          onCamera: controller.pickFromCamera,
          onGallery: controller.pickFromGallery,
        ),
        ScanFlowStep.preview => _PreviewStep(
          image: flow.image!,
          error: flow.error,
          onUse: controller.usePhoto,
          onRetake: controller.retake,
        ),
        ScanFlowStep.processing => const LoadingState(
          message: AppStrings.scanProcessing,
        ),
        ScanFlowStep.extracted => _ExtractedStep(
          receipt: flow.extracted!,
          isSaving: flow.isSaving,
          onConfirm: () => _confirm(context, controller),
          onRetake: controller.retake,
        ),
      },
    );
  }

  Future<void> _confirm(
    BuildContext context,
    ScanFlowController controller,
  ) async {
    final candidate = controller.candidateFromExtracted();
    if (candidate == null || !context.mounted) {
      return;
    }
    context.push(AppRoutes.beforeYouSubscribe, extra: candidate);
  }
}

class _SourceStep extends StatelessWidget {
  const _SourceStep({required this.onCamera, required this.onGallery});

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(AppStrings.scanSourceMessage, style: textTheme.titleMedium),
        const SizedBox(height: AppSpacing.xl),
        AppCard(
          key: const Key('scan-camera'),
          onTap: onCamera,
          child: Row(
            children: [
              const Icon(AppIcons.camera),
              const SizedBox(width: AppSpacing.md),
              Text(AppStrings.scanUseCamera, style: textTheme.titleSmall),
            ],
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          key: const Key('scan-gallery'),
          onTap: onGallery,
          child: Row(
            children: [
              const Icon(AppIcons.gallery),
              const SizedBox(width: AppSpacing.md),
              Text(AppStrings.scanUseGallery, style: textTheme.titleSmall),
            ],
          ),
        ),
      ],
    );
  }
}

class _PreviewStep extends StatelessWidget {
  const _PreviewStep({
    required this.image,
    required this.onUse,
    required this.onRetake,
    this.error,
  });

  final ReceiptImage image;
  final String? error;
  final VoidCallback onUse;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: AppRadius.card,
            child: ColoredBox(
              color: colorScheme.surface,
              child: Image.memory(image.bytes, fit: BoxFit.contain),
            ),
          ),
        ),
        if (error != null) ...[
          const SizedBox(height: AppSpacing.md),
          Text(
            error!,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: colorScheme.error),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: AppStrings.scanUseThisPhoto, onPressed: onUse),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: AppStrings.scanRetake,
          variant: AppButtonVariant.secondary,
          onPressed: onRetake,
        ),
      ],
    );
  }
}

class _ExtractedStep extends StatelessWidget {
  const _ExtractedStep({
    required this.receipt,
    required this.isSaving,
    required this.onConfirm,
    required this.onRetake,
  });

  final ExtractedReceipt receipt;
  final bool isSaving;
  final VoidCallback onConfirm;
  final VoidCallback onRetake;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            children: [
              _Field(label: AppStrings.fieldMerchant, value: receipt.merchant),
              _Field(
                label: AppStrings.fieldAmount,
                value: MoneyFormat.format(
                  receipt.amount,
                  currencyCode: receipt.currency,
                ),
              ),
              _Field(
                label: AppStrings.scanFieldDate,
                value: AppDateFormat.short(receipt.date),
              ),
              _Field(
                label: AppStrings.scanFieldBilling,
                value: receipt.billingCycle.label,
              ),
              _Field(
                label: AppStrings.scanConfidence,
                value: receipt.confidencePercent,
              ),
            ],
          ),
        ),
        AppButton(
          label: AppStrings.scanConfirm,
          isLoading: isSaving,
          onPressed: onConfirm,
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: AppStrings.scanRetake,
          variant: AppButtonVariant.secondary,
          onPressed: onRetake,
        ),
      ],
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: textTheme.labelMedium),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: textTheme.bodyLarge),
        ],
      ),
    );
  }
}
