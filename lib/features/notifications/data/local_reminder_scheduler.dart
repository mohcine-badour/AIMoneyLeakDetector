import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../analytics/data/disabled_analytics.dart';
import '../../analytics/domain/analytics.dart';
import '../../analytics/domain/reminder_analytics.dart';
import '../domain/reminder_scheduler.dart';
import '../domain/scheduled_reminder.dart';

class LocalReminderScheduler implements ReminderScheduler {
  LocalReminderScheduler({
    FlutterLocalNotificationsPlugin? plugin,
    Analytics? analytics,
  }) : _plugin = plugin ?? FlutterLocalNotificationsPlugin(),
       _analytics = analytics ?? const DisabledAnalytics();

  static const _channelId = 'billkiller_reminders';
  static const _channelName = 'Reminders';
  static const _channelDescription =
      'Trial ending and subscription renewal reminders';

  final FlutterLocalNotificationsPlugin _plugin;
  final Analytics _analytics;
  var _initialized = false;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }
    await _configureLocalTimezone();
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestAlertPermission: false,
        requestBadgePermission: false,
        requestSoundPermission: false,
      ),
    );
    await _plugin.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: (response) {
        ReminderAnalytics.onPayload(response.payload, _analytics);
      },
    );
    _initialized = true;
  }

  @override
  Future<void> sync(List<ScheduledReminder> reminders) async {
    await initialize();
    await _plugin.cancelAll();
    if (reminders.isEmpty) {
      return;
    }
    final allowed = await requestPermission();
    if (!allowed) {
      return;
    }
    for (final reminder in reminders) {
      await _schedule(reminder);
    }
  }

  Future<void> _schedule(ScheduledReminder reminder) async {
    final scheduled = tz.TZDateTime(
      tz.local,
      reminder.fireAt.year,
      reminder.fireAt.month,
      reminder.fireAt.day,
      reminder.fireAt.hour,
      reminder.fireAt.minute,
    );
    if (!scheduled.isAfter(tz.TZDateTime.now(tz.local))) {
      return;
    }
    try {
      await _plugin.zonedSchedule(
        id: reminder.id,
        title: reminder.title,
        body: reminder.body,
        scheduledDate: scheduled,
        payload: '${reminder.kind.name}:${reminder.eventId}',
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );
    } on Object catch (error) {
      debugPrint('Failed to schedule reminder ${reminder.id}: $error');
    }
  }

  @override
  Future<bool> requestPermission() async {
    await initialize();
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      final notifications =
          await android.requestNotificationsPermission() ?? true;
      await android.requestExactAlarmsPermission();
      return notifications;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          ) ??
          false;
    }
    return true;
  }

  Future<void> _configureLocalTimezone() async {
    tzdata.initializeTimeZones();
    try {
      final info = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(info.identifier));
    } on Object {
      tz.setLocalLocation(tz.UTC);
    }
  }
}
