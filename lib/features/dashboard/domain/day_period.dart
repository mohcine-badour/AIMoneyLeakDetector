enum GreetingPeriod { morning, afternoon, evening }

/// Deterministic greeting period. Do not use AI for this.
abstract final class GreetingPeriodResolver {
  static GreetingPeriod from(DateTime now) {
    final hour = now.hour;
    if (hour >= 5 && hour < 12) {
      return GreetingPeriod.morning;
    }
    if (hour >= 12 && hour < 18) {
      return GreetingPeriod.afternoon;
    }
    return GreetingPeriod.evening;
  }
}
