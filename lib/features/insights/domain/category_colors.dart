import 'package:flutter/material.dart';

import '../../../core/brand/brand_registry.dart';

/// Mid-tone stops that read in dark and light mode without inversion.
abstract final class CategoryColors {
  static const Map<BrandCategory, Color> values = {
    BrandCategory.productivity: Color(0xFF7F77DD),
    BrandCategory.entertainment: Color(0xFFF0997B),
    BrandCategory.ai: Color(0xFF5DCAA5),
    BrandCategory.music: Color(0xFF97C459),
    BrandCategory.storage: Color(0xFF85B7EB),
    BrandCategory.gaming: Color(0xFFED93B1),
    BrandCategory.developer: Color(0xFFFAC775),
    BrandCategory.news: Color(0xFFF5C4B3),
    BrandCategory.fitness: Color(0xFF9FE1CB),
    BrandCategory.other: Color(0xFFB4B2A9),
  };

  static Color of(BrandCategory category) =>
      values[category] ?? values[BrandCategory.other]!;
}
