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
import '../../../core/widgets/error_state.dart';
import '../../../core/widgets/loading_state.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../../paywall/domain/paywall_source.dart';
import '../../paywall/paywall_navigation.dart';
import '../../paywall/paywall_providers.dart';
import '../add_subscription_controller.dart';
import '../domain/subscription.dart';
import '../domain/subscription_brand.dart';
import '../subscriptions_providers.dart';
import 'billing_cycle_sheet.dart';
import 'category_sheet.dart';
import 'popular_apps_scroller.dart';
import 'subscription_labels.dart';

class AddSubscriptionScreen extends ConsumerStatefulWidget {
  const AddSubscriptionScreen({this.subscriptionId, super.key});

  final String? subscriptionId;

  @override
  ConsumerState<AddSubscriptionScreen> createState() =>
      _AddSubscriptionScreenState();
}

class _AddSubscriptionScreenState extends ConsumerState<AddSubscriptionScreen> {
  final _nameController = TextEditingController();
  final _merchantController = TextEditingController();
  final _amountController = TextEditingController();
  var _hydrated = false;
  String? _selectedBrandSlug;

  bool get _isEditing => widget.subscriptionId != null;

  @override
  void dispose() {
    _nameController.dispose();
    _merchantController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _hydrate(Subscription subscription) {
    if (_hydrated) {
      return;
    }
    _nameController.text = subscription.name;
    _merchantController.text = subscription.merchant;
    _amountController.text = subscription.amount.toStringAsFixed(2);
    ref.read(addSubscriptionControllerProvider.notifier).hydrate(subscription);
    setState(() => _hydrated = true);
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final form = ref.watch(addSubscriptionControllerProvider);
    final controller = ref.read(addSubscriptionControllerProvider.notifier);

    if (_isEditing && !_hydrated) {
      final async = ref.watch(subscriptionByIdProvider(widget.subscriptionId!));
      return async.when(
        loading: () => AppScaffold(
          title: AppStrings.editSubscriptionTitle,
          body: const LoadingState(),
        ),
        error: (error, stackTrace) => AppScaffold(
          title: AppStrings.editSubscriptionTitle,
          body: ErrorState(
            message: AppStrings.errorLoadSubscriptions,
            onRetry: () => ref.invalidate(
              subscriptionByIdProvider(widget.subscriptionId!),
            ),
          ),
        ),
        data: (subscription) {
          if (subscription == null) {
            return AppScaffold(
              title: AppStrings.editSubscriptionTitle,
              body: ErrorState(
                message: AppStrings.subscriptionNotFound,
                retryLabel: AppStrings.backToList,
                onRetry: () => context.go(AppRoutes.subscriptions),
              ),
            );
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _hydrate(subscription);
            }
          });
          return const AppScaffold(
            title: AppStrings.editSubscriptionTitle,
            body: LoadingState(),
          );
        },
      );
    }

    return AppScaffold(
      title: _isEditing
          ? AppStrings.editSubscriptionTitle
          : AppStrings.addSubscriptionTitle,
      padding: EdgeInsets.zero,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (!_isEditing) ...[
                    Text(
                      AppStrings.emptySubscriptionsMessage,
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
                  ],
                  AppFilledField(
                    fieldKey: const Key('subscription-name'),
                    label: AppStrings.fieldName,
                    controller: _nameController,
                    errorText: form.errors.name,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  AppFilledField(
                    fieldKey: const Key('subscription-merchant'),
                    label: AppStrings.fieldMerchant,
                    hint: AppStrings.fieldMerchantHint,
                    controller: _merchantController,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 14),
                  AppFilledField(
                    fieldKey: const Key('subscription-amount'),
                    label: AppStrings.fieldAmount,
                    hint: '0.00',
                    controller: _amountController,
                    errorText: form.errors.amount,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    textInputAction: TextInputAction.done,
                    suffix: AppCurrencyChip(
                      key: const Key('subscription-currency'),
                      value:
                          '${MoneyFormat.symbolFor(form.currency)}  ${form.currency}',
                      onTap: () => _pickCurrency(form.currency),
                    ),
                  ),
                  const SizedBox(height: 14),
                  AppPickerField(
                    fieldKey: const Key('subscription-cycle'),
                    label: AppStrings.fieldBillingCycle,
                    value: form.billingCycle?.label,
                    icon: AppIcons.subscriptions,
                    errorText: form.errors.billingCycle,
                    onTap: () => _pickBillingCycle(form.billingCycle),
                  ),
                  if (form.billingCycle == BillingCycle.weekly) ...[
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Text(
                        AppStrings.weeklyTypicalWarning,
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.35,
                          color: tokens.warningText,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 14),
                  AppPickerField(
                    fieldKey: const Key('subscription-date'),
                    label: AppStrings.fieldNextBillingDate,
                    value: form.nextBillingDate == null
                        ? null
                        : AppDateFormat.short(form.nextBillingDate!),
                    placeholder: AppStrings.chooseDate,
                    icon: AppIcons.upcoming,
                    errorText: form.errors.nextBillingDate,
                    onTap: () => _pickDate(),
                  ),
                  const SizedBox(height: 14),
                  AppPickerField(
                    fieldKey: const Key('subscription-category'),
                    label: AppStrings.fieldCategory,
                    value: form.category?.label,
                    icon: AppIcons.apps,
                    errorText: form.errors.category,
                    onTap: () => _pickCategory(form.category),
                  ),
                  if (!_isEditing) ...[
                    const SizedBox(height: 20),
                    _ScanReceiptRow(
                      onTap: () => PaywallNavigation.scanReceipt(context, ref),
                    ),
                  ],
                ],
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: AppAccentButton(
                key: Key(
                  _isEditing ? 'save-subscription' : 'review-before-adding',
                ),
                label: _isEditing
                    ? AppStrings.save
                    : AppStrings.reviewBeforeAdding,
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
    _merchantController.text = brand.displayName;
    ref
        .read(addSubscriptionControllerProvider.notifier)
        .setCategory(SubscriptionBrand.storedCategory(brand.category));
    ref
        .read(analyticsProvider)
        .track(
          AnalyticsEvent.featuredBrandTap,
          properties: {'kind': brand.slug},
        );
    setState(() => _selectedBrandSlug = brand.slug);
  }

  Future<void> _save(AddSubscriptionController controller) async {
    if (_isEditing) {
      final saved = await controller.submit(
        name: _nameController.text,
        merchant: _merchantController.text,
        amount: _amountController.text,
      );
      if (!saved || !mounted) {
        return;
      }
      context.go(AppRoutes.subscriptionDetailLocation(widget.subscriptionId!));
      return;
    }

    final candidate = controller.review(
      name: _nameController.text,
      merchant: _merchantController.text,
      amount: _amountController.text,
    );
    if (candidate == null || !mounted) {
      return;
    }
    if (!ref.read(featureAccessProvider).canAddSubscription) {
      context.push(
        AppRoutes.paywallLocation(source: PaywallSource.unlimitedGate),
      );
      return;
    }
    context.push(AppRoutes.beforeYouSubscribe, extra: candidate);
  }

  Future<void> _pickDate() async {
    HapticFeedback.selectionClick();
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

  Future<void> _pickCurrency(String current) async {
    HapticFeedback.selectionClick();
    final selected = await showCurrencySheet(
      context: context,
      current: current,
    );
    if (selected != null) {
      ref
          .read(addSubscriptionControllerProvider.notifier)
          .setCurrency(selected);
    }
  }

  Future<void> _pickBillingCycle(BillingCycle? current) async {
    HapticFeedback.selectionClick();
    final selected = await showBillingCycleSheet(
      context: context,
      current: current,
    );
    if (selected != null) {
      ref
          .read(addSubscriptionControllerProvider.notifier)
          .setBillingCycle(selected);
    }
  }

  Future<void> _pickCategory(SubscriptionCategory? current) async {
    HapticFeedback.selectionClick();
    final selected = await showCategorySheet(
      context: context,
      current: current,
    );
    if (selected != null) {
      ref
          .read(addSubscriptionControllerProvider.notifier)
          .setCategory(selected);
    }
  }
}

class _ScanReceiptRow extends StatelessWidget {
  const _ScanReceiptRow({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return InkWell(
      key: const Key('scan-receipt'),
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Icon(AppIcons.scan, size: 18, color: tokens.textMuted),
            const SizedBox(width: 10),
            Text(
              AppStrings.entryScanReceipt,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: tokens.textSecondary,
              ),
            ),
            const Spacer(),
            Icon(AppIcons.chevronRight, size: 16, color: tokens.textMuted),
          ],
        ),
      ),
    );
  }
}
