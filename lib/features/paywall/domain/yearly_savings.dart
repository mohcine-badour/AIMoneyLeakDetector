class YearlySavings {
  const YearlySavings({
    required this.savedAmount,
    required this.savedPercent,
    required this.monthlyEquivalent,
  });

  final double savedAmount;
  final int savedPercent;
  final double monthlyEquivalent;

  bool get showBadge => savedPercent >= 10 && savedAmount > 0;
}

abstract final class YearlySavingsMath {
  static YearlySavings compute({
    required double monthlyPrice,
    required double yearlyPrice,
  }) {
    final twelveMonthCost = monthlyPrice * 12;
    final savedAmount = twelveMonthCost - yearlyPrice;
    final savedPercent = twelveMonthCost > 0
        ? ((savedAmount / twelveMonthCost) * 100).round()
        : 0;
    return YearlySavings(
      savedAmount: savedAmount,
      savedPercent: savedPercent,
      monthlyEquivalent: yearlyPrice / 12,
    );
  }
}
