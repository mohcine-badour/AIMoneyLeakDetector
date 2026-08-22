import 'package:flutter/material.dart';

import '../../welcome/presentation/works_with_grid.dart';
import '../domain/onboarding_pages.dart';

class OnboardingHeroBrandGrid extends StatelessWidget {
  const OnboardingHeroBrandGrid({required this.payload, super.key});

  final HeroBrandGridPayload payload;

  @override
  Widget build(BuildContext context) {
    return WorksWithGrid(
      slugs: payload.featuredSlugs,
      moreCount: payload.moreCount,
      showLabel: false,
      center: false,
    );
  }
}
