import 'package:url_launcher/url_launcher.dart';

import '../domain/cancellation_link_opener.dart';

class UrlLauncherLinkOpener implements CancellationLinkOpener {
  const UrlLauncherLinkOpener();

  @override
  Future<bool> open(Uri uri) async {
    if (!await canLaunchUrl(uri)) {
      return false;
    }
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
