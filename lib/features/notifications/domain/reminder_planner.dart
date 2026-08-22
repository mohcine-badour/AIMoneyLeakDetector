import '../../upcoming/domain/payment_reminder_scheduler.dart';
import 'reminder_copy.dart';
import 'scheduled_reminder.dart';

/// Plans local reminder fire times. Do not use AI for this.
///
/// Stored dates are calendar days. The charge/trial-end instant is 09:00
/// in the device's local timezone so 3-day, 24-hour, and 2-hour offsets
/// land on local wall-clock times, including DST.
abstract final class ReminderPlanner {
  static const int eventHour = 9;
  static const int eventMinute = 0;

  static DateTime eventAt(DateTime storedDate) {
    return DateTime(
      storedDate.year,
      storedDate.month,
      storedDate.day,
      eventHour,
      eventMinute,
    );
  }

  static List<ScheduledReminder> plan({
    required List<ReminderEvent> events,
    required DateTime now,
  }) {
    final reminders = <ScheduledReminder>[];
    for (final event in events) {
      final eventTime = eventAt(event.eventDate);
      for (final offset in PaymentReminderOffsets.beforeCharge) {
        final fireAt = eventTime.subtract(offset);
        if (!fireAt.isAfter(now)) {
          continue;
        }
        reminders.add(
          ScheduledReminder(
            id: notificationId(event.id, event.kind, offset),
            eventId: event.id,
            kind: event.kind,
            offset: offset,
            fireAt: fireAt,
            title: ReminderCopy.title(
              kind: event.kind,
              name: event.name,
              offset: offset,
            ),
            body: ReminderCopy.body(
              kind: event.kind,
              amount: event.amount,
              currencyCode: event.currencyCode,
            ),
          ),
        );
      }
    }
    reminders.sort((left, right) => left.fireAt.compareTo(right.fireAt));
    return reminders;
  }

  static bool hasUpcoming({
    required DateTime eventDate,
    required DateTime now,
  }) {
    final eventTime = eventAt(eventDate);
    return PaymentReminderOffsets.beforeCharge.any(
      (offset) => eventTime.subtract(offset).isAfter(now),
    );
  }

  static int notificationId(
    String eventId,
    ReminderKind kind,
    Duration offset,
  ) {
    return Object.hash(kind.index, eventId, offset.inMinutes) & 0x7fffffff;
  }
}
