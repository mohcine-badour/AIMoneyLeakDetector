import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'domain/cancellation_link_opener.dart';

final cancellationLinkOpenerProvider = Provider<CancellationLinkOpener>((ref) {
  return const NoOpCancellationLinkOpener();
});
