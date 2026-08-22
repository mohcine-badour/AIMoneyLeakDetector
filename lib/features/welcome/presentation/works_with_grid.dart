import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_tokens.dart';
import '../../../core/brand/brand_icon.dart';
import '../../../core/constants/app_strings.dart';
import '../../analytics/analytics_providers.dart';
import '../../analytics/domain/analytics_event.dart';
import '../domain/featured_brands.dart';

class WorksWithGrid extends ConsumerWidget {
  const WorksWithGrid({
    super.key,
    this.slugs,
    this.moreCount,
    this.showLabel = true,
    this.center = true,
  });

  final List<String>? slugs;
  final int? moreCount;
  final bool showLabel;
  final bool center;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tokens = AppTokens.of(context);
    final tiles = slugs ?? FeaturedBrands.slugs;
    final extra = moreCount ?? FeaturedBrands.otherCount;
    final columns = tiles.length <= 8 ? 4 : FeaturedBrands.gridColumns;
    final row1 = tiles.take(columns).toList();
    final row2 = tiles.skip(columns).toList();
    final alignment = center
        ? MainAxisAlignment.center
        : MainAxisAlignment.start;

    return Column(
      crossAxisAlignment: center
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      children: [
        if (showLabel)
          Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              AppStrings.worksWith.toUpperCase(),
              textAlign: center ? TextAlign.center : TextAlign.start,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
                color: tokens.textMuted,
              ),
            ),
          ),
        Column(
          children: [
            _Row(slugs: row1, onTap: (slug) => _track(ref, slug), alignment: alignment),
            const SizedBox(height: 8),
            _Row(
              slugs: row2,
              trailingCount: extra,
              onTap: (slug) => _track(ref, slug),
              alignment: alignment,
            ),
          ],
        ),
      ],
    );
  }

  void _track(WidgetRef ref, String slug) {
    ref.read(analyticsProvider).track(
      AnalyticsEvent.featuredBrandTap,
      properties: {'kind': slug},
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.slugs,
    required this.onTap,
    this.trailingCount,
    this.alignment = MainAxisAlignment.center,
  });

  final List<String> slugs;
  final ValueChanged<String> onTap;
  final int? trailingCount;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: alignment,
      children: [
        for (var i = 0; i < slugs.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          GestureDetector(
            key: Key('featured-brand-${slugs[i]}'),
            onTap: () => onTap(slugs[i]),
            child: BrandIcon(slug: slugs[i], size: 40),
          ),
        ],
        if (trailingCount != null && trailingCount! > 0) ...[
          const SizedBox(width: 8),
          MoreBrandsChip(count: trailingCount!),
        ],
      ],
    );
  }
}

class MoreBrandsChip extends StatelessWidget {
  const MoreBrandsChip({required this.count, super.key});

  final int count;

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    const size = 40.0;
    const radius = 10.0;
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        painter: _DashedRRectPainter(
          color: tokens.textPrimary.withValues(alpha: 0.15),
          radius: radius,
        ),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: tokens.bgHover,
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Center(
            child: Text(
              AppStrings.moreBrandsCount(count),
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w500,
                letterSpacing: -0.2,
                color: tokens.textMuted,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  const _DashedRRectPainter({required this.color, required this.radius});

  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0.25, 0.25, size.width - 0.5, size.height - 0.5),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      const dash = 3.0;
      const gap = 2.5;
      while (distance < metric.length) {
        final next = math.min(distance + dash, metric.length);
        canvas.drawPath(metric.extractPath(distance, next), paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.radius != radius;
  }
}
