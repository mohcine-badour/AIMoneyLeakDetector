import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/brand/brand_registry.dart';
import '../../../core/constants/app_strings.dart';
import '../domain/popular_apps.dart';

class PopularAppsScroller extends StatelessWidget {
  const PopularAppsScroller({
    required this.selectedSlug,
    required this.onSelected,
    super.key,
  });

  final String? selectedSlug;
  final ValueChanged<Brand> onSelected;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.mostPopular,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w500,
            color: tokens.textSecondary,
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 78,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: PopularApps.slugs.length,
            separatorBuilder: (context, index) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final slug = PopularApps.slugs[index];
              final brand = BrandRegistry.getBrand(slug);
              if (brand == null) {
                return const SizedBox.shrink();
              }
              final selected = selectedSlug == slug;
              return _PopularAppTile(
                brand: brand,
                selected: selected,
                onTap: () {
                  HapticFeedback.selectionClick();
                  onSelected(brand);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _PopularAppTile extends StatelessWidget {
  const _PopularAppTile({
    required this.brand,
    required this.selected,
    required this.onTap,
  });

  final Brand brand;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    return GestureDetector(
      key: Key('popular-app-${brand.slug}'),
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 58,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: selected ? tokens.textPrimary : tokens.borderStrong,
                  width: selected ? 1.5 : 0.5,
                ),
              ),
              child: BrandIcon(slug: brand.slug, size: 40),
            ),
            const SizedBox(height: 6),
            Text(
              PopularApps.tileLabel(brand),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
                color: selected ? tokens.textPrimary : tokens.textMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
