import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../app/theme/app_tokens.dart';
import 'brand_icon_paths.dart';
import 'brand_registry.dart';

class BrandIcon extends StatelessWidget {
  const BrandIcon({
    required this.slug,
    this.size = 34,
    this.fallbackInitial,
    super.key,
  });

  final String slug;
  final double size;
  final String? fallbackInitial;

  static const _pathAliases = {
    'nytimes': 'newyorktimes',
    'amazonprimevideo': 'amazonprime',
    'paramount': 'paramountplus',
  };

  @override
  Widget build(BuildContext context) {
    final tokens = AppTokens.of(context);
    final radius = size * 0.24;
    final brand = BrandRegistry.getBrand(slug);

    if (brand == null) {
      final initial = (fallbackInitial ?? (slug.isEmpty ? '?' : slug[0]))
          .toUpperCase();
      return _Tile(
        size: size,
        radius: radius,
        color: tokens.bgMuted,
        child: Text(
          initial,
          style: TextStyle(
            fontSize: size * 0.4,
            fontWeight: FontWeight.w500,
            color: tokens.textSecondary,
            letterSpacing: -0.3,
            height: 1,
          ),
        ),
      );
    }

    final pathKey = _pathAliases[brand.slug] ?? brand.slug;
    final path = BrandIconPaths.bySlug[pathKey];
    if (path == null) {
      return _Tile(size: size, radius: radius, color: brand.tileBg);
    }

    final iconPx = size * 0.55;
    final fill = brand.iconColor.computeLuminance() < 0.5
        ? '#000000'
        : '#FFFFFF';
    final svg =
        '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" '
        'width="$iconPx" height="$iconPx">'
        '<path fill="$fill" d="$path"/></svg>';

    return _Tile(
      size: size,
      radius: radius,
      color: brand.tileBg,
      child: SvgPicture.string(svg, width: iconPx, height: iconPx),
    );
  }
}

class _Tile extends StatelessWidget {
  const _Tile({
    required this.size,
    required this.radius,
    required this.color,
    this.child,
  });

  final double size;
  final double radius;
  final Color color;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: child,
    );
  }
}
