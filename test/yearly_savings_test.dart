import 'package:flutter_test/flutter_test.dart';

import 'package:kichta/features/paywall/domain/yearly_savings.dart';

void main() {
  test('yearly savings are 44 percent at default prices', () {
    final savings = YearlySavingsMath.compute(
      monthlyPrice: 2.99,
      yearlyPrice: 19.99,
    );
    expect(savings.savedPercent, 44);
    expect(savings.monthlyEquivalent, closeTo(1.665833, 0.0001));
    expect(savings.showBadge, isTrue);
  });

  test('hides the save badge under 10 percent or when yearly costs more', () {
    expect(
      YearlySavingsMath.compute(
        monthlyPrice: 2.99,
        yearlyPrice: 34,
      ).showBadge,
      isFalse,
    );
    expect(
      YearlySavingsMath.compute(
        monthlyPrice: 2.99,
        yearlyPrice: 40,
      ).showBadge,
      isFalse,
    );
  });
}
