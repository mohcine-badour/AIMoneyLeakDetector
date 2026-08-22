import 'package:flutter/material.dart';

enum BrandCategory {
  entertainment,
  music,
  productivity,
  storage,
  ai,
  news,
  fitness,
  gaming,
  developer,
  other,
}

extension BrandCategoryLabel on BrandCategory {
  String get label => switch (this) {
    BrandCategory.entertainment => 'Entertainment',
    BrandCategory.music => 'Music',
    BrandCategory.productivity => 'Productivity',
    BrandCategory.storage => 'Storage',
    BrandCategory.ai => 'AI',
    BrandCategory.news => 'News',
    BrandCategory.fitness => 'Fitness',
    BrandCategory.gaming => 'Gaming',
    BrandCategory.developer => 'Developer',
    BrandCategory.other => 'Other',
  };
}

class Brand {
  const Brand({
    required this.slug,
    required this.displayName,
    required this.tileBg,
    required this.iconColor,
    required this.category,
  });

  final String slug;
  final String displayName;
  final Color tileBg;
  final Color iconColor;
  final BrandCategory category;
}

/// Authentic brand tiles. Colors do not invert in dark mode.
abstract final class BrandRegistry {
  static const Map<String, Brand> bySlug = {
    'netflix': Brand(
      slug: 'netflix',
      displayName: 'Netflix',
      tileBg: Color(0xFFE50914),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'spotify': Brand(
      slug: 'spotify',
      displayName: 'Spotify',
      tileBg: Color(0xFF1DB954),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.music,
    ),
    'openai': Brand(
      slug: 'openai',
      displayName: 'ChatGPT Plus',
      tileBg: Color(0xFF10A37F),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.ai,
    ),
    'icloud': Brand(
      slug: 'icloud',
      displayName: 'iCloud+',
      tileBg: Color(0xFF007AFF),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.storage,
    ),
    'youtube': Brand(
      slug: 'youtube',
      displayName: 'YouTube Premium',
      tileBg: Color(0xFFFF0000),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'adobecreativecloud': Brand(
      slug: 'adobecreativecloud',
      displayName: 'Adobe Creative Cloud',
      tileBg: Color(0xFFFA0F00),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.productivity,
    ),
    'notion': Brand(
      slug: 'notion',
      displayName: 'Notion',
      tileBg: Color(0xFF000000),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.productivity,
    ),
    'figma': Brand(
      slug: 'figma',
      displayName: 'Figma',
      tileBg: Color(0xFF0ACF83),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.productivity,
    ),
    'disneyplus': Brand(
      slug: 'disneyplus',
      displayName: 'Disney+',
      tileBg: Color(0xFF113CCF),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'hbo': Brand(
      slug: 'hbo',
      displayName: 'HBO Max',
      tileBg: Color(0xFFB535F6),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'amazonprimevideo': Brand(
      slug: 'amazonprimevideo',
      displayName: 'Prime Video',
      tileBg: Color(0xFF00A8E1),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'applemusic': Brand(
      slug: 'applemusic',
      displayName: 'Apple Music',
      tileBg: Color(0xFFFA243C),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.music,
    ),
    'dropbox': Brand(
      slug: 'dropbox',
      displayName: 'Dropbox',
      tileBg: Color(0xFF0061FF),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.storage,
    ),
    'googledrive': Brand(
      slug: 'googledrive',
      displayName: 'Google One',
      tileBg: Color(0xFF4285F4),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.storage,
    ),
    'linear': Brand(
      slug: 'linear',
      displayName: 'Linear',
      tileBg: Color(0xFF5E6AD2),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.productivity,
    ),
    'github': Brand(
      slug: 'github',
      displayName: 'GitHub',
      tileBg: Color(0xFF181717),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.developer,
    ),
    'discord': Brand(
      slug: 'discord',
      displayName: 'Discord Nitro',
      tileBg: Color(0xFF5865F2),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'slack': Brand(
      slug: 'slack',
      displayName: 'Slack',
      tileBg: Color(0xFF4A154B),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.productivity,
    ),
    'patreon': Brand(
      slug: 'patreon',
      displayName: 'Patreon',
      tileBg: Color(0xFFFF424D),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.other,
    ),
    'substack': Brand(
      slug: 'substack',
      displayName: 'Substack',
      tileBg: Color(0xFFFF6719),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.news,
    ),
    'nytimes': Brand(
      slug: 'nytimes',
      displayName: 'The New York Times',
      tileBg: Color(0xFF000000),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.news,
    ),
    'twitch': Brand(
      slug: 'twitch',
      displayName: 'Twitch',
      tileBg: Color(0xFF9146FF),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'hulu': Brand(
      slug: 'hulu',
      displayName: 'Hulu',
      tileBg: Color(0xFF1CE783),
      iconColor: Color(0xFF000000),
      category: BrandCategory.entertainment,
    ),
    'paramount': Brand(
      slug: 'paramountplus',
      displayName: 'Paramount+',
      tileBg: Color(0xFF0064FF),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'audible': Brand(
      slug: 'audible',
      displayName: 'Audible',
      tileBg: Color(0xFFF8991C),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.entertainment,
    ),
    'strava': Brand(
      slug: 'strava',
      displayName: 'Strava',
      tileBg: Color(0xFFFC5200),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.fitness,
    ),
    'peloton': Brand(
      slug: 'peloton',
      displayName: 'Peloton',
      tileBg: Color(0xFF181A1D),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.fitness,
    ),
    'headspace': Brand(
      slug: 'headspace',
      displayName: 'Headspace',
      tileBg: Color(0xFFF47D31),
      iconColor: Color(0xFFFFFFFF),
      category: BrandCategory.fitness,
    ),
  };

  static const Map<String, String> _aliases = {
    'adobe': 'adobecreativecloud',
    'chatgpt': 'openai',
    'gpt': 'openai',
    'prime': 'amazonprimevideo',
    'prime video': 'amazonprimevideo',
    'amazon prime': 'amazonprimevideo',
    'google one': 'googledrive',
    'icloud+': 'icloud',
    'apple music': 'applemusic',
    'disney+': 'disneyplus',
    'disney plus': 'disneyplus',
    'hbo max': 'hbo',
    'max': 'hbo',
    'paramount+': 'paramount',
    'new york times': 'nytimes',
    'ny times': 'nytimes',
    'creative cloud': 'adobecreativecloud',
  };

  static Brand? getBrand(String slug) {
    final key = slug.trim().toLowerCase();
    return bySlug[key] ?? bySlug[_aliases[key] ?? ''];
  }

  static String slugFor({required String name, String? merchant}) {
    final haystack = '${name.trim()} ${merchant ?? ''}'.toLowerCase();
    for (final entry in _aliases.entries) {
      if (haystack.contains(entry.key)) {
        return entry.value;
      }
    }
    for (final brand in bySlug.values) {
      final display = brand.displayName.toLowerCase();
      if (haystack.contains(brand.slug) || haystack.contains(display)) {
        return brand.slug;
      }
    }
    return name.trim().toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }
}
