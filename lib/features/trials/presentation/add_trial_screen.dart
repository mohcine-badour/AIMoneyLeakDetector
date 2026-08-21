import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../add_trial_controller.dart';

class AddTrialScreen extends ConsumerStatefulWidget {
  const AddTrialScreen({super.key});

  @override
  ConsumerState<AddTrialScreen> createState() => _AddTrialScreenState();
}

class _AddTrialScreenState extends ConsumerState<AddTrialScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(addTrialControllerProvider);
    final controller = ref.read(addTrialControllerProvider.notifier);

    return AppScaffold(
      title: AppStrings.addTrialTitle,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: ListView(
        children: [
          AppTextField(
            key: const Key('trial-name'),
            label: AppStrings.fieldName,
            controller: _nameController,
            errorText: form.errors.subscriptionName,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            key: const Key('trial-amount'),
            label: AppStrings.fieldAmountAfterTrial,
            controller: _amountController,
            errorText: form.errors.amountAfterTrial,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            textInputAction: TextInputAction.done,
          ),
          const SizedBox(height: AppSpacing.lg),
          _SelectField(
            key: const Key('trial-currency'),
            label: AppStrings.fieldCurrency,
            value: form.currency,
            onTap: () => _pickCurrency(controller),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SelectField(
            key: const Key('trial-date'),
            label: AppStrings.fieldTrialEndDate,
            value: form.trialEndDate == null
                ? null
                : AppDateFormat.short(form.trialEndDate!),
            errorText: form.errors.trialEndDate,
            onTap: _pickDate,
          ),
          const SizedBox(height: AppSpacing.xxl),
          AppButton(
            label: AppStrings.save,
            isLoading: form.isSaving,
            onPressed: () => _save(controller),
          ),
        ],
      ),
    );
  }

  Future<void> _save(AddTrialController controller) async {
    final saved = await controller.submit(
      subscriptionName: _nameController.text,
      amountAfterTrial: _amountController.text,
    );
    if (!saved || !mounted) {
      return;
    }
    context.go(AppRoutes.trials);
  }

  Future<void> _pickDate() async {
    final current = ref.read(addTrialControllerProvider).trialEndDate;
    final selected = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      ref.read(addTrialControllerProvider.notifier).setTrialEndDate(selected);
    }
  }

  Future<void> _pickCurrency(AddTrialController controller) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.page),
            children: [
              Text(
                AppStrings.fieldCurrency,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: AppSpacing.lg),
              for (final code in MoneyFormat.supportedCurrencyCodes) ...[
                AppCard(
                  onTap: () => Navigator.of(context).pop(code),
                  child: Text(
                    code,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
              ],
            ],
          ),
        );
      },
    );
    if (selected != null) {
      controller.setCurrency(selected);
    }
  }
}

class _SelectField extends StatelessWidget {
  const _SelectField({
    required this.label,
    required this.onTap,
    this.value,
    this.errorText,
    super.key,
  });

  final String label;
  final String? value;
  final String? errorText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: textTheme.labelMedium),
        const SizedBox(height: AppSpacing.sm),
        AppCard(
          onTap: onTap,
          child: Text(
            value ?? AppStrings.select,
            style: textTheme.bodyLarge?.copyWith(
              color: value == null ? colorScheme.onSurfaceVariant : null,
            ),
          ),
        ),
        if (errorText != null) ...[
          const SizedBox(height: AppSpacing.xs),
          Text(
            errorText!,
            style: textTheme.bodySmall?.copyWith(color: colorScheme.error),
          ),
        ],
      ],
    );
  }
}
