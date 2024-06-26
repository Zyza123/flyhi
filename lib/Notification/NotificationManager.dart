import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationManager {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<void> initNotification() async {
    AndroidInitializationSettings initializationSettingsAndroid =
    const AndroidInitializationSettings('ic_noti');

    DarwinInitializationSettings initializationSettingsIOS =
    const DarwinInitializationSettings(requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true, );

    InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings);
  }

  notificationDetails(){
    return const NotificationDetails(
      android: AndroidNotificationDetails('channelId 2', 'ChannelName',
      importance: Importance.max,
      priority: Priority.max),
      iOS: DarwinNotificationDetails(presentAlert: true,
      presentBadge: true,
      presentSound: true,
      )
    );
  }

  Future showNotification({
    int id = 0, String? title, String? body, String? payLoad
}) async {
    return flutterLocalNotificationsPlugin.show(id, title, body, await notificationDetails());
  }

  Future<void> scheduleNotification({
    int? id,
    String? title,
    String? body,
    String? payLoad,
    required DateTime scheduledNotificationDateTime,
  }) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        id!,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.wallClockTime,
      );
    } catch (e) {
      print('Error scheduling notification: $e');
    }
  }
}