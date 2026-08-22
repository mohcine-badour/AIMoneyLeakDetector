import 'package:flutter/widgets.dart';

import '../domain/ad_placement.dart';
import '../domain/ad_service.dart';

/// No-op network. Used when ads are disabled.
class DisabledAdService implements AdService {
  const DisabledAdService();

  @override
  Widget banner({required AdPlacement placement, VoidCallback? onUpgrade}) {
    return const SizedBox.shrink();
  }
}
