import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/paywall/domain/yearly_savings.dart';

void main() {
  test('yearly savings are 44 percent at default prices', () {
    final savings = YearlySavingsMath.compute(
      monthlyPrice: 5.99,
      yearlyPrice: 39.99,
    );
    expect(savings.savedPercent, 44);
    expect(savings.monthlyEquivalent, closeTo(3.3325, 0.0001));
    expect(savings.showBadge, isTrue);
  });

  test('hides the save badge under 10 percent or when yearly costs more', () {
    expect(
      YearlySavingsMath.compute(
        monthlyPrice: 5.99,
        yearlyPrice: 68,
      ).showBadge,
      isFalse,
    );
    expect(
      YearlySavingsMath.compute(
        monthlyPrice: 5.99,
        yearlyPrice: 80,
      ).showBadge,
      isFalse,
    );
  });
}
