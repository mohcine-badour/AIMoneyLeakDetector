import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_form_field.dart';
import '../../../core/widgets/app_scaffold.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../../paywall/paywall_navigation.dart';
import '../domain/subscription_catalog.dart';

class AddSubscriptionCatalogScreen extends ConsumerStatefulWidget {
  const AddSubscriptionCatalogScreen({super.key});

  @override
  ConsumerState<AddSubscriptionCatalogScreen> createState() =>
      _AddSubscriptionCatalogScreenState();
}

class _AddSubscriptionCatalogScreenState
    extends ConsumerState<AddSubscriptionCatalogScreen> {
  final _searchController = TextEditingController();
  var _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final searching = _query.trim().isNotEmpty;
    final services = searching
        ? SubscriptionCatalog.search(_query)
        : SubscriptionCatalog.popular;

    return AppScaffold(
      title: AppStrings.addSubscriptionTitle,
      padding: EdgeInsets.zero,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: AppTextField(
              key: const Key('catalog-search'),
              label: AppStrings.searchAllSubscriptions,
              controller: _searchController,
              prefixIcon: AppIcons.search,
              textInputAction: TextInputAction.search,
              autocorrect: false,
              enableSuggestions: false,
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          if (!searching)
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
              child: Text(
                AppStrings.catalogPopular,
                style: TextStyle(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                  color: tokens.textSecondary,
                ),
              ),
            ),
          Expanded(
            child: services.isEmpty
                ? _NoCatalogMatches(tokens: tokens)
                : ListView.separated(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                    itemCount: services.length,
                    separatorBuilder: (context, index) =>
                        Divider(height: 1, color: tokens.border),
                    itemBuilder: (context, index) {
                      final service = services[index];
                      return _CatalogServiceRow(
                        service: service,
                        brand: SubscriptionCatalog.brandFor(service),
                        onTap: () => _openService(service),
                      );
                    },
                  ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: Column(
                children: [
                  _ScanReceiptRow(
                    onTap: () => PaywallNavigation.scanReceipt(context, ref),
                  ),
                  const SizedBox(height: 10),
                  AppAccentButton(
                    key: const Key('add-custom-subscription'),
                    label: AppStrings.addCustomSubscription,
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      context.push(AppRoutes.addCustomSubscription);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openService(CatalogService service) {
    HapticFeedback.selectionClick();
    ref
        .read(analyticsProvider)
        .track(
          AnalyticsEvent.featuredBrandTap,
          properties: {'kind': service.slug},
        );
    context.push(AppRoutes.addSubscriptionBrand(service.slug));
  }
}

class _CatalogServiceRow extends StatelessWidget {
  const _CatalogServiceRow({
    required this.service,
    required this.brand,
    required this.onTap,
  });

  final CatalogService service;
  final Brand brand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: Key('catalog-app-${service.slug}'),
        onTap: onTap,
        child: SizedBox(
          height: 64,
          child: Row(
            children: [
              BrandIcon(slug: brand.slug, brand: brand, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      service.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        letterSpacing: -0.2,
                        color: tokens.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      service.category.label,
                      style: TextStyle(
                        fontSize: 12,
                        color: tokens.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(AppIcons.chevronRight, size: 16, color: tokens.textMuted),
            ],
          ),
        ),
      ),
    );
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

class _NoCatalogMatches extends StatelessWidget {
  const _NoCatalogMatches({required this.tokens});

  final AppTokens tokens;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 48),
      child: Column(
        children: [
          Text(
            AppStrings.noSearchMatchesTitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: tokens.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            AppStrings.noSearchMatchesMessage,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tokens.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
