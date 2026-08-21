import '../domain/subscribe_advisor.dart';
import '../domain/subscribe_advice_validator.dart';
import '../domain/subscribe_impact.dart';

class ValidatedSubscribeAdvisor implements SubscribeAdvisor {
  const ValidatedSubscribeAdvisor(this._backend);

  final SubscribeAdviceBackend _backend;

  @override
  Future<SubscribeAdvice> advise(SubscribeImpact impact) async {
    final json = await _backend.advise(impact);
    return SubscribeAdvice(
      impact: impact,
      recommendation: SubscribeAdviceValidator.parse(
        json: json,
        impact: impact,
      ),
    );
  }
}
