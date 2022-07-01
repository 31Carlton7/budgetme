/*
BudgetMe iOS & Android App
Copyright (C) 2022 Carlton Aikins

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

import 'dart:math';

import 'package:budgetme/src/repositories/notifications_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  Future<void> showScheduledNotification({int id = 0}) async {
    final notification = NotificationsRepository().budgetMeNotifications[Random().nextInt(7)];

    return _notifications.zonedSchedule(
      id,
      notification.title,
      notification.body,
      _scheduleNotificationTime(Time(15)),
      await _notificationDetails(),
      payload: 'budget.me',
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _scheduleNotificationTime(Time time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time.hour, time.minute, time.second);

    return scheduleDate.isBefore(now) ? scheduleDate.add(Duration(days: 1)) : scheduleDate;
  }

  static Future<void> init({bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@mipmap/ic_launcher');
    final iOS = IOSInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);

    await _notifications.initialize(settings, onSelectNotification: (payload) {
      onNotifications.add(payload);
    });

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future<NotificationDetails> _notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
      ),
      iOS: IOSNotificationDetails(),
    );
  }
}
