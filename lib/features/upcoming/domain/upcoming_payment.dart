class UpcomingPayment {
  const UpcomingPayment({
    required this.subscriptionId,
    required this.name,
    required this.amount,
    required this.currencyCode,
    required this.billingDate,
  });

  final String subscriptionId;
  final String name;
  final double amount;
  final String currencyCode;
  final DateTime billingDate;
}
