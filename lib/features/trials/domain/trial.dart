import '../../../core/utils/id_generator.dart';
import '../../../core/utils/money_format.dart';

enum TrialStatus { active, endingSoon, expired, cancelled }

class Trial {
  const Trial({
    required this.id,
    required this.subscriptionName,
    required this.amountAfterTrial,
    required this.currency,
    required this.trialEndDate,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trial.create({
    required String subscriptionName,
    required double amountAfterTrial,
    required DateTime trialEndDate,
    String? id,
    String currency = MoneyFormat.defaultCurrencyCode,
    TrialStatus status = TrialStatus.active,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    final now = DateTime.now().toUtc();
    return Trial(
      id: id ?? IdGenerator.next(),
      subscriptionName: subscriptionName,
      amountAfterTrial: amountAfterTrial,
      currency: currency,
      trialEndDate: trialEndDate,
      status: status,
      createdAt: createdAt ?? now,
      updatedAt: updatedAt ?? now,
    );
  }

  final String id;
  final String subscriptionName;
  final double amountAfterTrial;
  final String currency;
  final DateTime trialEndDate;
  final TrialStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  Trial copyWith({
    String? subscriptionName,
    double? amountAfterTrial,
    String? currency,
    DateTime? trialEndDate,
    TrialStatus? status,
    DateTime? updatedAt,
  }) {
    return Trial(
      id: id,
      subscriptionName: subscriptionName ?? this.subscriptionName,
      amountAfterTrial: amountAfterTrial ?? this.amountAfterTrial,
      currency: currency ?? this.currency,
      trialEndDate: trialEndDate ?? this.trialEndDate,
      status: status ?? this.status,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
