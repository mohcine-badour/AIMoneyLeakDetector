import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../constants/app_radius.dart';
import '../constants/app_spacing.dart';

enum AppCardTone { plain, surface, insight }

class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.onTap,
    this.selected = false,
    this.tone = AppCardTone.surface,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    super.key,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool selected;
  final AppCardTone tone;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final content = Padding(padding: padding, child: child);
    final Color? fill = switch (tone) {
      AppCardTone.plain => null,
      AppCardTone.surface => colorScheme.surface,
      AppCardTone.insight =>
        isDark ? AppColors.insightFillDark : AppColors.insightFill,
    };

    final box = DecoratedBox(
      decoration: BoxDecoration(
        color: fill,
        borderRadius: tone == AppCardTone.insight
            ? AppRadius.hero
            : AppRadius.card,
        border: selected
            ? Border.all(color: colorScheme.primary, width: 1.5)
            : null,
      ),
      child: onTap == null
          ? content
          : Material(
              type: MaterialType.transparency,
              child: InkWell(
                onTap: onTap,
                borderRadius: AppRadius.card,
                child: content,
              ),
            ),
    );

    if (tone == AppCardTone.plain) {
      return onTap == null
          ? content
          : Material(
              type: MaterialType.transparency,
              child: InkWell(onTap: onTap, child: content),
            );
    }
    return box;
  }
}
