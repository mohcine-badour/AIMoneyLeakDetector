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
import '../add_subscription_controller.dart';
import '../domain/subscription.dart';
import 'subscription_labels.dart';

class AddSubscriptionScreen extends ConsumerStatefulWidget {
  const AddSubscriptionScreen({super.key});

  @override
  ConsumerState<AddSubscriptionScreen> createState() =>
      _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends ConsumerState<AddSubscriptionScreen> {
  final _nameController = TextEditingController();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final form = ref.watch(addSubscriptionControllerProvider);
    final controller = ref.read(addSubscriptionControllerProvider.notifier);

    return AppScaffold(
      title: AppStrings.addSubscriptionTitle,
      padding: const EdgeInsets.all(AppSpacing.page),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
          AppTextField(
            key: const Key('subscription-name'),
            label: AppStrings.fieldName,
            controller: _nameController,
            textInputAction: TextInputAction.next,
            errorText: form.errors.name,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            key: const Key('subscription-merchant'),
            label: AppStrings.fieldMerchant,
            hint: AppStrings.fieldMerchantHint,
            controller: _merchantController,
            textInputAction: TextInputAction.next,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppTextField(
            key: const Key('subscription-amount'),
            label: AppStrings.fieldAmount,
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(
              decimal: true,
            ),
            textInputAction: TextInputAction.done,
            errorText: form.errors.amount,
          ),
          const SizedBox(height: AppSpacing.lg),
          _SelectField(
            key: const Key('subscription-currency'),
            label: AppStrings.fieldCurrency,
            value: form.currency,
            onTap: () => _pickCurrency(controller),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SelectField(
            key: const Key('subscription-cycle'),
            label: AppStrings.fieldBillingCycle,
            value: form.billingCycle?.label,
            errorText: form.errors.billingCycle,
            onTap: () => _pickBillingCycle(controller),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SelectField(
            key: const Key('subscription-date'),
            label: AppStrings.fieldNextBillingDate,
            value: form.nextBillingDate == null
                ? null
                : AppDateFormat.short(form.nextBillingDate!),
            errorText: form.errors.nextBillingDate,
            onTap: () => _pickDate(),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SelectField(
            key: const Key('subscription-category'),
            label: AppStrings.fieldCategory,
            value: form.category?.label,
            errorText: form.errors.category,
            onTap: () => _pickCategory(controller),
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton(
            label: AppStrings.save,
            isLoading: form.isSaving,
            onPressed: () => _save(controller),
          ),
        ],
        ),
      ),
    );
  }

  Future<void> _save(AddSubscriptionController controller) async {
    final saved = await controller.submit(
      name: _nameController.text,
      merchant: _merchantController.text,
      amount: _amountController.text,
    );
    if (!saved || !mounted) {
      return;
    }
    context.go(AppRoutes.subscriptions);
  }

  Future<void> _pickDate() async {
    final current = ref.read(addSubscriptionControllerProvider).nextBillingDate;
    final selected = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime(2018),
      lastDate: DateTime(2100),
    );
    if (selected != null) {
      ref
          .read(addSubscriptionControllerProvider.notifier)
          .setNextBillingDate(selected);
    }
  }

  Future<void> _pickCurrency(AddSubscriptionController controller) async {
    final selected = await _pickItem(
      title: AppStrings.fieldCurrency,
      options: MoneyFormat.supportedCurrencyCodes.toList(),
      labelFor: (code) => code,
    );
    if (selected != null) {
      controller.setCurrency(selected);
    }
  }

  Future<void> _pickBillingCycle(AddSubscriptionController controller) async {
    final selected = await _pickItem(
      title: AppStrings.fieldBillingCycle,
      options: BillingCycle.values,
      labelFor: (cycle) => cycle.label,
    );
    if (selected != null) {
      controller.setBillingCycle(selected);
    }
  }

  Future<void> _pickCategory(AddSubscriptionController controller) async {
    final selected = await _pickItem(
      title: AppStrings.fieldCategory,
      options: SubscriptionCategory.values,
      labelFor: (category) => category.label,
    );
    if (selected != null) {
      controller.setCategory(selected);
    }
  }

  Future<T?> _pickItem<T>({
    required String title,
    required List<T> options,
    required String Function(T) labelFor,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.page),
            children: [
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: AppSpacing.lg),
              for (final option in options) ...[
                AppCard(
                  onTap: () => Navigator.of(context).pop(option),
                  child: Text(
                    labelFor(option),
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
