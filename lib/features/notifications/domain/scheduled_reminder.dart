enum ReminderKind { renewal, trialEnding }

class ReminderEvent {
  const ReminderEvent({
    required this.id,
    required this.kind,
    required this.name,
    required this.amount,
    required this.currencyCode,
    required this.eventDate,
  });

  final String id;
  final ReminderKind kind;
  final String name;
  final double amount;
  final String currencyCode;
  final DateTime eventDate;
}

class ScheduledReminder {
  const ScheduledReminder({
    required this.id,
    required this.eventId,
    required this.kind,
    required this.offset,
    required this.fireAt,
    required this.title,
    required this.body,
  });

  final int id;
  final String eventId;
  final ReminderKind kind;
  final Duration offset;
  final DateTime fireAt;
  final String title;
  final String body;
}
