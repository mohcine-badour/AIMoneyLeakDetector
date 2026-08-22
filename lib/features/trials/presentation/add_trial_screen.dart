import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/app_date_format.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/app_form_field.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/currency_sheet.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../../subscriptions/presentation/popular_apps_scroller.dart';
import '../add_trial_controller.dart';

class AddTrialScreen extends ConsumerStatefulWidget {
  const AddTrialScreen({super.key});

  @override
  ConsumerState<AddTrialScreen> createState() => _AddTrialScreenState();
}

class _AddTrialScreenState extends ConsumerState<AddTrialScreen> {
  final _nameController = TextEditingController();
  final _amountController = TextEditingController();
  String? _selectedBrandSlug;

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final form = ref.watch(addTrialControllerProvider);
    final controller = ref.read(addTrialControllerProvider.notifier);

    return AppScaffold(
      title: AppStrings.addTrialTitle,
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppStrings.emptyTrialsMessage,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.35,
                      color: tokens.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 20),
                  PopularAppsScroller(
                    selectedSlug: _selectedBrandSlug,
                    onSelected: _selectBrand,
                  ),
                  const SizedBox(height: 20),
                  AppFilledField(
                    fieldKey: const Key('trial-name'),
                    label: AppStrings.fieldName,
                    hint: AppStrings.trialNameHint,
                    controller: _nameController,
                    errorText: form.errors.subscriptionName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  AppFilledField(
                    fieldKey: const Key('trial-amount'),
                    label: AppStrings.fieldAmountAfterTrial,
                    hint: '0.00',
                    controller: _amountController,
                    errorText: form.errors.amountAfterTrial,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    suffix: AppCurrencyChip(
                      key: const Key('trial-currency'),
                      value:
                          '${MoneyFormat.symbolFor(form.currency)}  ${form.currency}',
                      onTap: () => _pickCurrency(form.currency),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppPickerField(
                    fieldKey: const Key('trial-date'),
                    label: AppStrings.fieldTrialEndDate,
                    value: form.trialEndDate == null
                        ? null
                        : AppDateFormat.short(form.trialEndDate!),
                    placeholder: AppStrings.chooseDate,
                    icon: AppIcons.upcoming,
                    errorText: form.errors.trialEndDate,
                    onTap: _pickDate,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: AppAccentButton(
                label: AppStrings.save,
                pending: form.isSaving,
                onPressed: form.isSaving ? null : () => _save(controller),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _selectBrand(Brand brand) {
    _nameController.text = brand.displayName;
    ref
        .read(analyticsProvider)
        .track(
          AnalyticsEvent.featuredBrandTap,
          properties: {'kind': brand.slug},
        );
    setState(() => _selectedBrandSlug = brand.slug);
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
    HapticFeedback.selectionClick();
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

  Future<void> _pickCurrency(String current) async {
    HapticFeedback.selectionClick();
    final selected = await showCurrencySheet(
      context: context,
      current: current,
    );
    if (selected != null) {
      ref.read(addTrialControllerProvider.notifier).setCurrency(selected);
    }
  }
}
