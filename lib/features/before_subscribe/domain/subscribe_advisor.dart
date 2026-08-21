import 'subscribe_impact.dart';

class SubscribeAdvice {
  const SubscribeAdvice({
    required this.impact,
    required this.recommendation,
  });

  final SubscribeImpact impact;
  final String recommendation;
}

/// Port for before-you-subscribe advice. Implementations must not embed AI keys.
abstract class SubscribeAdviceBackend {
  Future<Map<String, dynamic>> advise(SubscribeImpact impact);
}

abstract class SubscribeAdvisor {
  Future<SubscribeAdvice> advise(SubscribeImpact impact);
}
