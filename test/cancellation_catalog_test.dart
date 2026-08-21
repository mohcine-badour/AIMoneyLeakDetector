import 'package:flutter_test/flutter_test.dart';

import 'package:billkiller_ai/features/cancellation/domain/cancellation_catalog.dart';
import 'package:billkiller_ai/features/cancellation/domain/cancellation_message.dart';

void main() {
  test('looks up Netflix by merchant and keeps an official cancel URL', () {
    final guide = CancellationCatalog.lookup(
      merchant: 'Netflix',
      name: 'Netflix Premium',
    );

    expect(guide.merchantLabel, 'Netflix');
    expect(guide.canOpenPage, isTrue);
    expect(
      guide.officialUrl,
      Uri.parse('https://www.netflix.com/cancelplan'),
    );
    expect(guide.includeMessage, isTrue);
    expect(guide.notes.toLowerCase(), contains('does not cancel'));
  });

  test('unknown merchants do not get an invented URL', () {
    final guide = CancellationCatalog.lookup(
      merchant: 'Local Gym',
      name: 'Gym membership',
    );

    expect(guide.canOpenPage, isFalse);
    expect(guide.officialUrl, isNull);
    expect(guide.includeMessage, isTrue);
    expect(guide.instructions.toLowerCase(), contains('cannot cancel'));
  });

  test('builds a deterministic cancellation message', () {
    final message = CancellationMessage.compose(
      merchant: 'Netflix',
      subscriptionName: 'Netflix Premium',
      nextBillingDate: DateTime.utc(2026, 9, 21),
    );

    expect(
      message,
      'Please cancel my Netflix subscription (Netflix Premium). I do not want to be billed again after Sep 21, 2026.',
    );
  });
}
