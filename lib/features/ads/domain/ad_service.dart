import 'package:flutter/widgets.dart';

import 'ad_placement.dart';

/// Ad network port. Implementations must not leak AdMob types into widgets.
abstract class AdService {
  Widget banner({required AdPlacement placement, VoidCallback? onUpgrade});
}
