import '../../../core/utils/app_date_format.dart';

/// Deterministic cancellation message. Do not use AI for this.
abstract final class CancellationMessage {
  static String compose({
    required String merchant,
    required String subscriptionName,
    required DateTime nextBillingDate,
  }) {
    final who = merchant.trim().isEmpty ? subscriptionName.trim() : merchant.trim();
    final date = AppDateFormat.short(nextBillingDate);
    return 'Please cancel my $who subscription ($subscriptionName). '
        'I do not want to be billed again after $date.';
  }
}
