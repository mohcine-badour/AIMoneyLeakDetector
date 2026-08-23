import 'package:flutter/material.dart';

import '../../../core/brand/brand_registry.dart';
import 'subscription.dart';

/// Structured service used to add a subscription and match receipt text.
class CatalogService {
  const CatalogService({
    required this.slug,
    required this.name,
    required this.category,
    required this.website,
    this.billing = const [BillingCycle.monthly, BillingCycle.yearly],
    this.aliases = const [],
    this.popularCountries = const ['US', 'CA', 'UK', 'AU'],
  });

  final String slug;
  final String name;
  final BrandCategory category;
  final String website;
  final List<BillingCycle> billing;
  final List<String> aliases;
  final List<String> popularCountries;

  Iterable<String> get matchKeys sync* {
    yield name;
    yield slug;
    yield* aliases;
    final host = Uri.tryParse(website)?.host.replaceFirst(RegExp(r'^www\.'), '');
    if (host != null && host.isNotEmpty) {
      yield host;
    }
  }
}

/// V1 catalog of ~150 services. Search this list; do not dump it in the UI.
abstract final class SubscriptionCatalog {
  static const popularSlugs = [
    'netflix',
    'spotify',
    'amazonprime',
    'youtube',
    'icloud',
    'openai',
    'disneyplus',
    'googledrive',
  ];

  static final List<CatalogService> all = [
    ..._streaming,
    ..._music,
    ..._storage,
    ..._productivity,
    ..._ai,
    ..._gaming,
    ..._news,
    ..._fitness,
    ..._security,
    ..._shopping,
    ..._finance,
    ..._other,
  ];

  static final Map<String, CatalogService> bySlug = {
    for (final service in all) service.slug: service,
  };

  static List<CatalogService> get popular {
    return [
      for (final slug in popularSlugs)
        if (bySlug[slug] != null) bySlug[slug]!,
    ];
  }

  static List<CatalogService> search(String query) {
    final raw = query.trim().toLowerCase();
    if (raw.isEmpty) {
      return const [];
    }
    final compact = _compact(raw);
    final results = all.where((service) {
      if (service.name.toLowerCase().contains(raw)) {
        return true;
      }
      if (_compact(service.slug).contains(compact)) {
        return true;
      }
      if (service.category.label.toLowerCase().contains(raw)) {
        return true;
      }
      return service.aliases.any(
        (alias) =>
            alias.toLowerCase().contains(raw) ||
            _compact(alias).contains(compact),
      );
    }).toList();
    results.sort((a, b) {
      final aName = a.name.toLowerCase();
      final bName = b.name.toLowerCase();
      final aRank = aName.startsWith(raw)
          ? 0
          : _compact(a.name).startsWith(compact)
          ? 1
          : 2;
      final bRank = bName.startsWith(raw)
          ? 0
          : _compact(b.name).startsWith(compact)
          ? 1
          : 2;
      if (aRank != bRank) {
        return aRank - bRank;
      }
      return aName.compareTo(bName);
    });
    return results;
  }

  static CatalogService? match(String text) {
    final lower = text.toLowerCase();
    final compact = _compact(text);
    CatalogService? best;
    var bestScore = 0;
    for (final service in all) {
      for (final key in service.matchKeys) {
        final phrase = key.trim();
        if (phrase.isEmpty) {
          continue;
        }
        final compactKey = _compact(phrase);
        if (compactKey.length < 3) {
          continue;
        }
        final hit = compactKey.length <= 4
            ? _wordBoundary(lower, phrase.toLowerCase())
            : compact.contains(compactKey) ||
                  _wordBoundary(lower, phrase.toLowerCase());
        if (!hit) {
          continue;
        }
        if (compactKey.length > bestScore) {
          best = service;
          bestScore = compactKey.length;
        }
      }
    }
    return best;
  }

  static String slugFor({required String name, String? merchant}) {
    final matched = match('$name ${merchant ?? ''}');
    if (matched != null) {
      return matched.slug;
    }
    return BrandRegistry.slugFor(name: name, merchant: merchant);
  }

  static Brand? brandForSlug(String slug) {
    final service = bySlug[slug] ?? match(slug);
    if (service != null) {
      return brandFor(service);
    }
    return BrandRegistry.getBrand(slug);
  }

  static Brand brandFor(CatalogService service) {
    final existing = BrandRegistry.getBrand(service.slug);
    if (existing != null) {
      return Brand(
        slug: existing.slug,
        displayName: service.name,
        tileBg: existing.tileBg,
        iconColor: existing.iconColor,
        category: service.category,
      );
    }
    return Brand(
      slug: service.slug,
      displayName: service.name,
      tileBg: _tileColor(service.category),
      iconColor: const Color(0xFFFFFFFF),
      category: service.category,
    );
  }

  static String _compact(String value) {
    return value.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '');
  }

  static bool _wordBoundary(String haystack, String needle) {
    if (needle.isEmpty) {
      return false;
    }
    return RegExp(
      '(^|[^a-z0-9])${RegExp.escape(needle)}([^a-z0-9]|\$)',
    ).hasMatch(haystack);
  }

  static Color _tileColor(BrandCategory category) {
    return switch (category) {
      BrandCategory.entertainment => const Color(0xFFE24A4A),
      BrandCategory.music => const Color(0xFF1DB954),
      BrandCategory.productivity => const Color(0xFF5B5FC7),
      BrandCategory.storage => const Color(0xFF3B82F6),
      BrandCategory.ai => const Color(0xFF10A37F),
      BrandCategory.news => const Color(0xFF111111),
      BrandCategory.fitness => const Color(0xFFFC5200),
      BrandCategory.gaming => const Color(0xFF5865F2),
      BrandCategory.developer => const Color(0xFF181717),
      BrandCategory.security => const Color(0xFF1A73E8),
      BrandCategory.shopping => const Color(0xFFFF9900),
      BrandCategory.finance => const Color(0xFF0F766E),
      BrandCategory.other => const Color(0xFF6B7280),
    };
  }
}

const _e = BrandCategory.entertainment;
const _m = BrandCategory.music;
const _s = BrandCategory.storage;
const _p = BrandCategory.productivity;
const _a = BrandCategory.ai;
const _g = BrandCategory.gaming;
const _n = BrandCategory.news;
const _f = BrandCategory.fitness;
const _sec = BrandCategory.security;
const _shop = BrandCategory.shopping;
const _fin = BrandCategory.finance;
const _o = BrandCategory.other;
const _dev = BrandCategory.developer;

CatalogService _c(
  String slug,
  String name,
  BrandCategory category,
  String website, {
  List<String> aliases = const [],
}) {
  return CatalogService(
    slug: slug,
    name: name,
    category: category,
    website: website,
    aliases: aliases,
  );
}

final _streaming = [
  _c('netflix', 'Netflix', _e, 'https://www.netflix.com', aliases: [
    'netflix.com',
    'NETFLIX.COM',
    'NETFLIX.COM/AMSTERDAM',
    'Netflix.com',
    'NFLX',
  ]),
  _c('disneyplus', 'Disney+', _e, 'https://www.disneyplus.com', aliases: [
    'disney+',
    'disney plus',
    'disneyplus.com',
    'DISNEYPLUS.COM',
  ]),
  _c('hulu', 'Hulu', _e, 'https://www.hulu.com', aliases: [
    'hulu.com',
    'HULU.COM',
  ]),
  _c('hbo', 'Max', _e, 'https://www.max.com', aliases: [
    'hbo',
    'hbo max',
    'hbomax',
    'max.com',
    'play.hbomax.com',
  ]),
  _c(
    'amazonprimevideo',
    'Amazon Prime Video',
    _e,
    'https://www.primevideo.com',
    aliases: [
      'prime video',
      'amazon prime video',
      'primevideo',
      'primevideo.com',
    ],
  ),
  _c('paramountplus', 'Paramount+', _e, 'https://www.paramountplus.com', aliases: [
    'paramount',
    'paramount+',
    'paramount plus',
    'paramountplus.com',
  ]),
  _c('peacock', 'Peacock', _e, 'https://www.peacocktv.com', aliases: [
    'peacocktv',
    'peacocktv.com',
  ]),
  _c('appletvplus', 'Apple TV+', _e, 'https://tv.apple.com', aliases: [
    'apple tv+',
    'apple tv plus',
    'apple tv',
    'tv.apple.com',
  ]),
  _c('youtube', 'YouTube Premium', _e, 'https://www.youtube.com/premium', aliases: [
    'youtube premium',
    'youtube.com',
    'youtubepremium',
    'google youtube',
  ]),
  _c('youtubetv', 'YouTube TV', _e, 'https://tv.youtube.com', aliases: [
    'youtube tv',
    'youtubetv.com',
  ]),
  _c('crunchyroll', 'Crunchyroll', _e, 'https://www.crunchyroll.com', aliases: [
    'crunchyroll.com',
  ]),
  _c('mubi', 'MUBI', _e, 'https://mubi.com', aliases: ['mubi.com']),
  _c('starz', 'STARZ', _e, 'https://www.starz.com', aliases: ['starz.com']),
  _c('amcplus', 'AMC+', _e, 'https://www.amcplus.com', aliases: [
    'amc+',
    'amc plus',
    'amcplus.com',
  ]),
  _c('discoveryplus', 'Discovery+', _e, 'https://www.discoveryplus.com', aliases: [
    'discovery+',
    'discovery plus',
    'discoveryplus.com',
  ]),
  _c('britbox', 'BritBox', _e, 'https://www.britbox.com', aliases: [
    'britbox.com',
  ]),
  _c('dazn', 'DAZN', _e, 'https://www.dazn.com', aliases: ['dazn.com']),
  _c('espnplus', 'ESPN+', _e, 'https://plus.espn.com', aliases: [
    'espn+',
    'espn plus',
    'plus.espn.com',
  ]),
  _c('fubo', 'Fubo', _e, 'https://www.fubo.tv', aliases: [
    'fubo.tv',
    'fubotv',
  ]),
  _c('slingtv', 'Sling TV', _e, 'https://www.sling.com', aliases: [
    'sling',
    'sling.com',
  ]),
];

final _music = [
  _c('spotify', 'Spotify', _m, 'https://www.spotify.com', aliases: [
    'spotify.com',
    'SPOTIFY.COM',
    'SPOTIFY USA',
    'SPOTIFY AB',
    'Spotify USA',
  ]),
  _c('applemusic', 'Apple Music', _m, 'https://music.apple.com', aliases: [
    'apple music',
    'music.apple.com',
    'itunes.apple.com',
  ]),
  _c('youtubemusic', 'YouTube Music', _m, 'https://music.youtube.com', aliases: [
    'youtube music',
    'music.youtube.com',
    'yt music',
  ]),
  _c('amazonmusic', 'Amazon Music', _m, 'https://music.amazon.com', aliases: [
    'amazon music',
    'amazon music unlimited',
    'music.amazon.com',
  ]),
  _c('tidal', 'Tidal', _m, 'https://tidal.com', aliases: ['tidal.com']),
  _c('deezer', 'Deezer', _m, 'https://www.deezer.com', aliases: ['deezer.com']),
  _c('pandora', 'Pandora', _m, 'https://www.pandora.com', aliases: [
    'pandora.com',
  ]),
  _c('soundcloudgo', 'SoundCloud Go+', _m, 'https://soundcloud.com/go', aliases: [
    'soundcloud',
    'soundcloud go',
    'soundcloud.com',
  ]),
  _c('audible', 'Audible', _m, 'https://www.audible.com', aliases: [
    'audible.com',
    'AUDIBLE.COM',
  ]),
  _c('iheartradio', 'iHeartRadio', _m, 'https://www.iheart.com', aliases: [
    'iheart',
    'iheart.com',
  ]),
  _c('siriusxm', 'SiriusXM', _m, 'https://www.siriusxm.com', aliases: [
    'sirius xm',
    'siriusxm.com',
  ]),
  _c('pocketcasts', 'Pocket Casts', _m, 'https://pocketcasts.com', aliases: [
    'pocketcasts.com',
  ]),
  _c('calm', 'Calm', _m, 'https://www.calm.com', aliases: ['calm.com']),
  _c('headspace', 'Headspace', _m, 'https://www.headspace.com', aliases: [
    'headspace.com',
  ]),
];

final _storage = [
  _c('icloud', 'iCloud+', _s, 'https://www.icloud.com', aliases: [
    'icloud+',
    'icloud plus',
    'icloud.com',
    'apple icloud',
  ]),
  _c('googledrive', 'Google One', _s, 'https://one.google.com', aliases: [
    'google one',
    'google drive',
    'one.google.com',
    'drive.google.com',
  ]),
  _c('dropbox', 'Dropbox', _s, 'https://www.dropbox.com', aliases: [
    'dropbox.com',
  ]),
  _c('onedrive', 'Microsoft OneDrive', _s, 'https://onedrive.live.com', aliases: [
    'onedrive',
    'one drive',
    'onedrive.live.com',
  ]),
  _c('box', 'Box', _s, 'https://www.box.com', aliases: ['box.com']),
  _c('pcloud', 'pCloud', _s, 'https://www.pcloud.com', aliases: ['pcloud.com']),
  _c('synccom', 'Sync.com', _s, 'https://www.sync.com', aliases: ['sync.com']),
  _c('mega', 'MEGA', _s, 'https://mega.io', aliases: ['mega.nz', 'mega.io']),
  _c('protondrive', 'Proton Drive', _s, 'https://drive.proton.me', aliases: [
    'proton.me/drive',
    'drive.proton.me',
  ]),
  _c('nordlocker', 'NordLocker', _s, 'https://nordlocker.com', aliases: [
    'nordlocker.com',
  ]),
];

final _productivity = [
  _c('microsoft365', 'Microsoft 365', _p, 'https://www.microsoft365.com', aliases: [
    'office 365',
    'microsoft office',
    'office365',
    'microsoft365.com',
  ]),
  _c(
    'googleworkspace',
    'Google Workspace',
    _p,
    'https://workspace.google.com',
    aliases: ['g suite', 'gsuite', 'workspace.google.com'],
  ),
  _c('notion', 'Notion', _p, 'https://www.notion.so', aliases: [
    'notion.so',
    'notion.com',
  ]),
  _c('evernote', 'Evernote', _p, 'https://evernote.com', aliases: [
    'evernote.com',
  ]),
  _c('todoist', 'Todoist', _p, 'https://todoist.com', aliases: ['todoist.com']),
  _c('ticktick', 'TickTick', _p, 'https://ticktick.com', aliases: [
    'ticktick.com',
  ]),
  _c('onepassword', '1Password', _p, 'https://1password.com', aliases: [
    '1password.com',
    '1 password',
  ]),
  _c('bitwarden', 'Bitwarden', _p, 'https://bitwarden.com', aliases: [
    'bitwarden.com',
  ]),
  _c('dashlane', 'Dashlane', _p, 'https://www.dashlane.com', aliases: [
    'dashlane.com',
  ]),
  _c('grammarly', 'Grammarly', _p, 'https://www.grammarly.com', aliases: [
    'grammarly.com',
  ]),
  _c(
    'adobecreativecloud',
    'Adobe Creative Cloud',
    _p,
    'https://www.adobe.com/creativecloud.html',
    aliases: ['adobe', 'creative cloud', 'adobe.cc', 'adobe.com'],
  ),
  _c('adobeacrobat', 'Adobe Acrobat Pro', _p, 'https://www.adobe.com/acrobat.html', aliases: [
    'acrobat pro',
    'adobe acrobat',
  ]),
  _c('canvapro', 'Canva Pro', _p, 'https://www.canva.com/pro', aliases: [
    'canva',
    'canva.com',
  ]),
  _c('figma', 'Figma', _p, 'https://www.figma.com', aliases: ['figma.com']),
  _c('miro', 'Miro', _p, 'https://miro.com', aliases: ['miro.com']),
  _c('slack', 'Slack', _p, 'https://slack.com', aliases: ['slack.com']),
  _c('zoom', 'Zoom', _p, 'https://zoom.us', aliases: ['zoom.us', 'zoom.com']),
  _c('dropboxsign', 'Dropbox Sign', _p, 'https://www.hellosign.com', aliases: [
    'hello sign',
    'hellosign',
    'hellosign.com',
  ]),
  _c('calendly', 'Calendly', _p, 'https://calendly.com', aliases: [
    'calendly.com',
  ]),
  _c('trello', 'Trello Premium', _p, 'https://trello.com', aliases: [
    'trello',
    'trello.com',
  ]),
  _c('asana', 'Asana', _p, 'https://asana.com', aliases: ['asana.com']),
  _c('monday', 'Monday.com', _p, 'https://monday.com', aliases: ['monday.com']),
  _c('clickup', 'ClickUp', _p, 'https://clickup.com', aliases: ['clickup.com']),
  _c('linear', 'Linear', _p, 'https://linear.app', aliases: ['linear.app']),
  _c('jetbrains', 'JetBrains', _p, 'https://www.jetbrains.com', aliases: [
    'jetbrains.com',
  ]),
];

final _ai = [
  _c('openai', 'ChatGPT Plus', _a, 'https://chatgpt.com', aliases: [
    'chatgpt',
    'chatgpt plus',
    'chat.openai.com',
    'openai.com',
    'chatgpt.com',
  ]),
  _c('chatgptpro', 'ChatGPT Pro', _a, 'https://chatgpt.com', aliases: [
    'chatgpt pro',
    'openai pro',
  ]),
  _c('claude', 'Claude Pro', _a, 'https://claude.ai', aliases: [
    'claude',
    'anthropic',
    'claude.ai',
  ]),
  _c('gemini', 'Gemini Advanced', _a, 'https://gemini.google.com', aliases: [
    'gemini',
    'bard',
    'gemini.google.com',
  ]),
  _c('perplexity', 'Perplexity Pro', _a, 'https://www.perplexity.ai', aliases: [
    'perplexity',
    'perplexity.ai',
  ]),
  _c('copilot', 'Microsoft Copilot Pro', _a, 'https://copilot.microsoft.com', aliases: [
    'copilot pro',
    'microsoft copilot',
    'copilot.microsoft.com',
  ]),
  _c('grok', 'Grok', _a, 'https://grok.x.ai', aliases: ['x.ai', 'grok.x.ai']),
  _c('midjourney', 'Midjourney', _a, 'https://www.midjourney.com', aliases: [
    'midjourney.com',
  ]),
  _c('runway', 'Runway', _a, 'https://runwayml.com', aliases: ['runwayml.com']),
  _c('cursor', 'Cursor', _a, 'https://cursor.com', aliases: [
    'cursor.com',
    'cursor.sh',
  ]),
  _c('githubcopilot', 'GitHub Copilot', _a, 'https://github.com/features/copilot', aliases: [
    'copilot.github.com',
  ]),
  _c('elevenlabs', 'ElevenLabs', _a, 'https://elevenlabs.io', aliases: [
    'elevenlabs.io',
  ]),
  _c('jasper', 'Jasper', _a, 'https://www.jasper.ai', aliases: ['jasper.ai']),
  _c('grammarlypro', 'Grammarly Pro', _a, 'https://www.grammarly.com', aliases: [
    'grammarly premium',
  ]),
  _c('characterai', 'Character.AI', _a, 'https://character.ai', aliases: [
    'character ai',
    'character.ai',
  ]),
  _c('poe', 'Poe', _a, 'https://poe.com', aliases: ['poe.com']),
];

final _gaming = [
  _c('xboxgamepass', 'Xbox Game Pass', _g, 'https://www.xbox.com/game-pass', aliases: [
    'game pass',
    'xbox.com',
  ]),
  _c(
    'playstationplus',
    'PlayStation Plus',
    _g,
    'https://www.playstation.com/ps-plus',
    aliases: ['ps plus', 'playstation plus', 'playstation'],
  ),
  _c(
    'nintendoswitchonline',
    'Nintendo Switch Online',
    _g,
    'https://www.nintendo.com/switch/online-service',
    aliases: ['nintendo online', 'nintendo switch online'],
  ),
  _c('eaplay', 'EA Play', _g, 'https://www.ea.com/ea-play', aliases: [
    'ea play',
    'ea.com',
  ]),
  _c('ubisoftplus', 'Ubisoft+', _g, 'https://www.ubisoft.com/ubisoftplus', aliases: [
    'ubisoft+',
    'ubisoft plus',
  ]),
  _c('geforcenow', 'GeForce NOW', _g, 'https://www.nvidia.com/geforce-now', aliases: [
    'geforce now',
    'nvidia geforce',
  ]),
  _c('applearcade', 'Apple Arcade', _g, 'https://www.apple.com/apple-arcade', aliases: [
    'apple arcade',
  ]),
  _c('googleplaypass', 'Google Play Pass', _g, 'https://play.google.com/pass', aliases: [
    'play pass',
  ]),
  _c('robloxpremium', 'Roblox Premium', _g, 'https://www.roblox.com/premium', aliases: [
    'roblox',
    'roblox.com',
  ]),
  _c('minecraftrealms', 'Minecraft Realms', _g, 'https://www.minecraft.net/realms', aliases: [
    'minecraft',
    'minecraft.net',
  ]),
  _c('discord', 'Discord Nitro', _g, 'https://discord.com/nitro', aliases: [
    'discord',
    'discord.com',
    'discord nitro',
  ]),
  _c('twitch', 'Twitch Turbo', _g, 'https://www.twitch.tv/turbo', aliases: [
    'twitch',
    'twitch.tv',
    'twitch turbo',
  ]),
];

final _news = [
  _c('nytimes', 'The New York Times', _n, 'https://www.nytimes.com', aliases: [
    'new york times',
    'ny times',
    'nyt',
    'nytimes.com',
  ]),
  _c(
    'washingtonpost',
    'The Washington Post',
    _n,
    'https://www.washingtonpost.com',
    aliases: ['washington post', 'wapo', 'washingtonpost.com'],
  ),
  _c(
    'wsj',
    'The Wall Street Journal',
    _n,
    'https://www.wsj.com',
    aliases: ['wall street journal', 'wsj.com'],
  ),
  _c('financialtimes', 'Financial Times', _n, 'https://www.ft.com', aliases: [
    'ft.com',
  ]),
  _c('economist', 'The Economist', _n, 'https://www.economist.com', aliases: [
    'economist.com',
  ]),
  _c('bloomberg', 'Bloomberg', _n, 'https://www.bloomberg.com', aliases: [
    'bloomberg.com',
  ]),
  _c('atlantic', 'The Atlantic', _n, 'https://www.theatlantic.com', aliases: [
    'theatlantic.com',
  ]),
  _c('newyorker', 'The New Yorker', _n, 'https://www.newyorker.com', aliases: [
    'newyorker.com',
  ]),
  _c('medium', 'Medium', _n, 'https://medium.com', aliases: ['medium.com']),
  _c('substack', 'Substack', _n, 'https://substack.com', aliases: [
    'substack.com',
  ]),
  _c('kindleunlimited', 'Kindle Unlimited', _n, 'https://www.amazon.com/kindle-dbs/hz/bookshelf', aliases: [
    'kindle',
  ]),
  _c('scribd', 'Scribd', _n, 'https://www.scribd.com', aliases: ['scribd.com']),
  _c('readly', 'Readly', _n, 'https://www.readly.com', aliases: ['readly.com']),
];

final _fitness = [
  _c('applefitness', 'Apple Fitness+', _f, 'https://www.apple.com/apple-fitness-plus', aliases: [
    'fitness+',
    'apple fitness',
  ]),
  _c('peloton', 'Peloton', _f, 'https://www.onepeloton.com', aliases: [
    'onepeloton.com',
    'peloton.com',
  ]),
  _c('strava', 'Strava', _f, 'https://www.strava.com', aliases: ['strava.com']),
  _c('fitbit', 'Fitbit Premium', _f, 'https://www.fitbit.com/premium', aliases: [
    'fitbit',
    'fitbit.com',
  ]),
  _c(
    'niketraining',
    'Nike Training Club',
    _f,
    'https://www.nike.com/ntc-app',
    aliases: ['nike training', 'ntc'],
  ),
  _c('myfitnesspal', 'MyFitnessPal', _f, 'https://www.myfitnesspal.com', aliases: [
    'myfitnesspal.com',
  ]),
  _c('freeletics', 'Freeletics', _f, 'https://www.freeletics.com', aliases: [
    'freeletics.com',
  ]),
  _c('betterme', 'BetterMe', _f, 'https://betterme.world', aliases: [
    'betterme.world',
  ]),
  _c('noom', 'Noom', _f, 'https://www.noom.com', aliases: ['noom.com']),
  _c('ww', 'WW', _f, 'https://www.weightwatchers.com', aliases: [
    'weight watchers',
    'weightwatchers',
  ]),
  _c('whoop', 'WHOOP', _f, 'https://www.whoop.com', aliases: ['whoop.com']),
  _c('oura', 'Oura Membership', _f, 'https://ouraring.com', aliases: [
    'oura',
    'oura ring',
    'ouraring.com',
  ]),
  _c('alltrails', 'AllTrails+', _f, 'https://www.alltrails.com', aliases: [
    'alltrails',
    'alltrails.com',
  ]),
  _c('komoot', 'Komoot Premium', _f, 'https://www.komoot.com', aliases: [
    'komoot',
    'komoot.com',
  ]),
];

final _security = [
  _c('nordvpn', 'NordVPN', _sec, 'https://nordvpn.com', aliases: [
    'nord vpn',
    'nordvpn.com',
  ]),
  _c('expressvpn', 'ExpressVPN', _sec, 'https://www.expressvpn.com', aliases: [
    'express vpn',
    'expressvpn.com',
  ]),
  _c('surfshark', 'Surfshark', _sec, 'https://surfshark.com', aliases: [
    'surfshark.com',
  ]),
  _c('protonvpn', 'Proton VPN', _sec, 'https://protonvpn.com', aliases: [
    'protonvpn.com',
  ]),
  _c('cyberghost', 'CyberGhost', _sec, 'https://www.cyberghostvpn.com', aliases: [
    'cyberghostvpn.com',
  ]),
  _c(
    'pia',
    'Private Internet Access',
    _sec,
    'https://www.privateinternetaccess.com',
    aliases: ['privateinternetaccess.com'],
  ),
  _c('malwarebytes', 'Malwarebytes', _sec, 'https://www.malwarebytes.com', aliases: [
    'malwarebytes.com',
  ]),
  _c('mcafee', 'McAfee', _sec, 'https://www.mcafee.com', aliases: ['mcafee.com']),
  _c('norton', 'Norton', _sec, 'https://us.norton.com', aliases: [
    'norton.com',
    'norton 360',
  ]),
  _c('bitdefender', 'Bitdefender', _sec, 'https://www.bitdefender.com', aliases: [
    'bitdefender.com',
  ]),
];

final _shopping = [
  _c('amazonprime', 'Amazon Prime', _shop, 'https://www.amazon.com/prime', aliases: [
    'amazon prime',
    'prime membership',
    'amazon.com/prime',
  ]),
  _c('walmartplus', 'Walmart+', _shop, 'https://www.walmart.com/plus', aliases: [
    'walmart+',
    'walmart plus',
  ]),
  _c('costco', 'Costco Membership', _shop, 'https://www.costco.com', aliases: [
    'costco',
    'costco.com',
  ]),
  _c('samsclub', "Sam's Club", _shop, 'https://www.samsclub.com', aliases: [
    'sams club',
    'samsclub.com',
  ]),
  _c('instacart', 'Instacart+', _shop, 'https://www.instacart.com/plus', aliases: [
    'instacart',
    'instacart.com',
  ]),
  _c('doordash', 'DoorDash DashPass', _shop, 'https://www.doordash.com/dashpass', aliases: [
    'doordash',
    'dashpass',
    'doordash.com',
  ]),
  _c('uberone', 'Uber One', _shop, 'https://www.uber.com/uber-one', aliases: [
    'uber one',
    'uber.com',
  ]),
  _c('walmartinhome', 'Walmart InHome', _shop, 'https://www.walmart.com/inhome', aliases: [
    'walmart inhome',
  ]),
  _c('bestbuyplus', 'Best Buy Plus', _shop, 'https://www.bestbuy.com/plus', aliases: [
    'best buy',
    'bestbuy.com',
  ]),
];

final _finance = [
  _c('experian', 'Experian', _fin, 'https://www.experian.com', aliases: [
    'experian.com',
  ]),
  _c('creditkarma', 'Credit Karma', _fin, 'https://www.creditkarma.com', aliases: [
    'creditkarma.com',
  ]),
  _c('rocketmoney', 'Rocket Money', _fin, 'https://www.rocketmoney.com', aliases: [
    'truebill',
    'rocketmoney.com',
  ]),
  _c('quicken', 'Quicken', _fin, 'https://www.quicken.com', aliases: [
    'quicken.com',
  ]),
  _c('ynab', 'YNAB', _fin, 'https://www.ynab.com', aliases: [
    'you need a budget',
    'ynab.com',
  ]),
  _c('monarch', 'Monarch Money', _fin, 'https://www.monarchmoney.com', aliases: [
    'monarchmoney.com',
  ]),
  _c('copilotmoney', 'Copilot Money', _fin, 'https://www.copilot.money', aliases: [
    'copilot.money',
  ]),
  _c('tradingview', 'TradingView', _fin, 'https://www.tradingview.com', aliases: [
    'tradingview.com',
  ]),
  _c('seekingalpha', 'Seeking Alpha', _fin, 'https://seekingalpha.com', aliases: [
    'seekingalpha.com',
  ]),
  _c('morningstar', 'Morningstar', _fin, 'https://www.morningstar.com', aliases: [
    'morningstar.com',
  ]),
];

final _other = [
  _c('patreon', 'Patreon', _o, 'https://www.patreon.com', aliases: [
    'patreon.com',
  ]),
  _c('github', 'GitHub', _dev, 'https://github.com', aliases: ['github.com']),
];
