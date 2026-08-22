import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/constants/app_icons.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_text_field.dart';
import '../domain/subscription.dart';
import '../domain/subscription_list_filter.dart';
import '../subscriptions_providers.dart';
import 'subscription_list_row.dart';

class SearchOverlay extends ConsumerStatefulWidget {
  const SearchOverlay({required this.subscriptions, super.key});

  final List<Subscription> subscriptions;

  @override
  ConsumerState<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends ConsumerState<SearchOverlay> {
  late final TextEditingController _controller;
  Timer? _debounce;
  late List<String> _recent;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: ref.read(subscriptionListQueryProvider).search,
    );
    _recent = ref.read(subscriptionListQueryProvider.notifier).recentSearches();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 150), () {
      ref.read(subscriptionListQueryProvider.notifier).setSearch(value);
      if (value.trim().isNotEmpty) {
        ref.read(subscriptionListQueryProvider.notifier).rememberSearch(value);
      }
    });
  }

  void _close({required bool clear}) {
    if (clear) {
      ref.read(subscriptionListQueryProvider.notifier).setSearch('');
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final query = ref.watch(subscriptionListQueryProvider);
    final results = SubscriptionListFilter.apply(widget.subscriptions, query);
    final search = query.search.trim();

    return Scaffold(
      backgroundColor: tokens.bgApp,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => _close(clear: true),
                    icon: Icon(AppIcons.close, color: tokens.textSecondary),
                  ),
                  Expanded(
                    child: AppTextField(
                      key: const Key('subscriptions-search'),
                      label: AppStrings.searchSubscriptions,
                      controller: _controller,
                      prefixIcon: AppIcons.search,
                      autofocus: true,
                      onChanged: _onChanged,
                    ),
                  ),
                  TextButton(
                    onPressed: () => _close(clear: true),
                    child: Text(
                      AppStrings.cancel,
                      style: TextStyle(color: tokens.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: search.isEmpty
                  ? _RecentSearches(
                      recent: _recent,
                      onTap: (value) {
                        _controller.text = value;
                        _controller.selection = TextSelection.collapsed(
                          offset: value.length,
                        );
                        ref
                            .read(subscriptionListQueryProvider.notifier)
                            .setSearch(value);
                      },
                    )
                  : results.isEmpty
                  ? _NoMatches(tokens: tokens)
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          decoration: BoxDecoration(
                            color: tokens.bgCard,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: tokens.border,
                              width: 0.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              for (var i = 0; i < results.length; i++)
                                SubscriptionListRow(
                                  subscription: results[i],
                                  isLast: i == results.length - 1,
                                ),
                            ],
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

class _RecentSearches extends StatelessWidget {
  const _RecentSearches({required this.recent, required this.onTap});

  final List<String> recent;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    if (recent.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.recentSearches,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: tokens.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final item in recent)
                ActionChip(
                  label: Text(item),
                  onPressed: () => onTap(item),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NoMatches extends StatelessWidget {
  const _NoMatches({required this.tokens});

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
