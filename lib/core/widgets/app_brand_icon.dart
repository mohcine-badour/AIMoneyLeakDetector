import 'package:flutter/material.dart';

/// App mark used on Welcome, Sign in, and About.
class AppBrandIcon extends StatelessWidget {
  const AppBrandIcon({this.size = 76, super.key});

  final double size;

  static const assetPath = 'assets/brand/app_icon.png';

  @override
  Widget build(BuildContext context) {
    final radius = (size * 0.24).roundToDouble();
    return SizedBox(
      width: size,
      height: size,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius),
          boxShadow: [
            BoxShadow(
              color: const Color(0x99000000),
              offset: Offset(0, size * 0.105),
              blurRadius: size * 0.42,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: Image.asset(
            assetPath,
            width: size,
            height: size,
            fit: BoxFit.cover,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
