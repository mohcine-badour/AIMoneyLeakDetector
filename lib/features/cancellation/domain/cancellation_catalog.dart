import 'cancellation_guide.dart';

/// Static official-help catalog. Do not invent URLs for unknown merchants.
abstract final class CancellationCatalog {
  static CancellationGuide lookup({
    required String merchant,
    required String name,
  }) {
    final keys = [_normalize(merchant), _normalize(name)];
    for (final key in keys) {
      final hit = _guides[key];
      if (hit != null) {
        return hit;
      }
    }
    for (final entry in _guides.entries) {
      for (final key in keys) {
        if (key.startsWith('${entry.key} ')) {
          return entry.value;
        }
      }
    }
    return generic(merchant);
  }

  static CancellationGuide generic(String merchant) {
    final label = merchant.trim().isEmpty ? 'This merchant' : merchant.trim();
    return CancellationGuide(
      merchantLabel: label,
      instructions:
          'BillKiller cannot cancel this merchant for you. Open their account or billing page, or contact their support, and cancel there.',
      estimatedTime: 'Varies by merchant',
      notes:
          'There is no official cancellation link on file for this merchant. Removing the subscription in BillKiller only updates this app.',
      includeMessage: true,
    );
  }

  static String _normalize(String raw) {
    return raw.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
  }

  static final Map<String, CancellationGuide> _guides = {
    'netflix': CancellationGuide(
      merchantLabel: 'Netflix',
      officialUrl: Uri.parse('https://www.netflix.com/cancelplan'),
      instructions:
          'Open the Netflix cancellation page, sign in, and follow the on-screen steps to finish cancelling.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel Netflix for you. You must finish on the Netflix site.',
    ),
    'spotify': CancellationGuide(
      merchantLabel: 'Spotify',
      officialUrl: Uri.parse('https://www.spotify.com/account/subscription/'),
      instructions:
          'Open your Spotify subscription page, sign in, and choose the option to cancel Premium.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel Spotify for you. You must finish on the Spotify site.',
    ),
    'hulu': CancellationGuide(
      merchantLabel: 'Hulu',
      officialUrl: Uri.parse(
        'https://help.hulu.com/s/article/manage-subscription',
      ),
      instructions:
          'Open Hulu account help, sign in, and follow the steps to cancel your subscription.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel Hulu for you. You must finish on Hulu.',
    ),
    'adobe': CancellationGuide(
      merchantLabel: 'Adobe',
      officialUrl: Uri.parse('https://account.adobe.com/plans'),
      instructions:
          'Open your Adobe plans page, sign in, and follow the steps to cancel the plan.',
      estimatedTime: 'About 10 minutes',
      notes:
          'BillKiller does not cancel Adobe for you. Adobe may keep access until the paid period ends.',
    ),
    'youtube': CancellationGuide(
      merchantLabel: 'YouTube',
      officialUrl: Uri.parse(
        'https://support.google.com/youtube/answer/6308511',
      ),
      instructions:
          'Open YouTube membership help and follow the steps for the store where you subscribed (YouTube, Google Play, Apple, or another billing partner).',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel YouTube for you. Cancel in the same store that billed you.',
    ),
    'youtube premium': CancellationGuide(
      merchantLabel: 'YouTube Premium',
      officialUrl: Uri.parse(
        'https://support.google.com/youtube/answer/6308511',
      ),
      instructions:
          'Open YouTube membership help and follow the steps for the store where you subscribed.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel YouTube Premium for you. Cancel in the same store that billed you.',
    ),
    'chatgpt': CancellationGuide(
      merchantLabel: 'ChatGPT',
      officialUrl: Uri.parse(
        'https://help.openai.com/en/articles/7232945-how-to-cancel-your-chatgpt-plus-subscription',
      ),
      instructions:
          'Open the OpenAI cancel-help article, sign in to ChatGPT, and follow the steps to cancel Plus or Pro.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel ChatGPT for you. You must finish in your OpenAI account.',
    ),
    'openai': CancellationGuide(
      merchantLabel: 'OpenAI',
      officialUrl: Uri.parse(
        'https://help.openai.com/en/articles/7232945-how-to-cancel-your-chatgpt-plus-subscription',
      ),
      instructions:
          'Open the OpenAI cancel-help article, sign in, and follow the steps to cancel the paid plan.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel OpenAI for you. You must finish in your OpenAI account.',
    ),
    'disney+': CancellationGuide(
      merchantLabel: 'Disney+',
      officialUrl: Uri.parse(
        'https://help.disneyplus.com/article/disneyplus-cancel-subscription',
      ),
      instructions:
          'Open Disney+ cancel help, sign in, and follow the steps to cancel.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel Disney+ for you. You must finish on Disney+.',
    ),
    'disney plus': CancellationGuide(
      merchantLabel: 'Disney+',
      officialUrl: Uri.parse(
        'https://help.disneyplus.com/article/disneyplus-cancel-subscription',
      ),
      instructions:
          'Open Disney+ cancel help, sign in, and follow the steps to cancel.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel Disney+ for you. You must finish on Disney+.',
    ),
    'amazon': CancellationGuide(
      merchantLabel: 'Amazon',
      officialUrl: Uri.parse('https://www.amazon.com/gp/primecentral'),
      instructions:
          'Open Amazon Prime Central, sign in, and follow the steps to cancel Prime if that is the subscription you want to stop.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel Amazon for you. Confirm you are cancelling the right Amazon membership.',
    ),
    'amazon prime': CancellationGuide(
      merchantLabel: 'Amazon Prime',
      officialUrl: Uri.parse('https://www.amazon.com/gp/primecentral'),
      instructions:
          'Open Amazon Prime Central, sign in, and follow the steps to cancel Prime.',
      estimatedTime: 'About 5 minutes',
      notes:
          'BillKiller does not cancel Amazon Prime for you. You must finish on Amazon.',
    ),
    'apple': CancellationGuide(
      merchantLabel: 'Apple',
      officialUrl: Uri.parse('https://apps.apple.com/account/subscriptions'),
      instructions:
          'Open Apple subscription management, sign in with your Apple ID, and cancel the subscription there.',
      estimatedTime: 'About 3 minutes',
      notes:
          'BillKiller does not cancel Apple subscriptions for you. Cancel in Settings or on the Apple subscriptions page.',
    ),
    'icloud': CancellationGuide(
      merchantLabel: 'iCloud',
      officialUrl: Uri.parse('https://apps.apple.com/account/subscriptions'),
      instructions:
          'Open Apple subscription management and cancel iCloud+ or the related Apple subscription.',
      estimatedTime: 'About 3 minutes',
      notes:
          'BillKiller does not cancel iCloud for you. Cancel with your Apple ID.',
    ),
  };
}
