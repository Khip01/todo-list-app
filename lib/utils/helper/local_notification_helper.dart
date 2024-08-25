import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as timezone_latest;
import 'package:timezone/timezone.dart' as timezone;

class LocalNotificationHelper {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // init FlutterLocalNotification
  static Future<void> initLocalNotification() async {
    // init local timezone
    timezone_latest.initializeTimeZones();
    // init notification
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsIos =
        DarwinInitializationSettings(
      onDidReceiveLocalNotification: (id, title, body, payload) {},
    );
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIos,
    );
    _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {
        // // Get Todo id
        // final int? id = details.id;
        // if (id == null || id.toString().isEmpty) return;
        //
        // // Get Todo by id
        // Todo todo = await TodoRepository().getTodoFromId(id: id);
        //
        // // Update Check Todo
        // await TodoRepository().updateTodo(todo: todo.copyWith(check: true));
      },
    );
  }

  static Future<void> getLocalNotificationPermission() async {
    // for Android 13+ Permission Handler
    // if (await Permission.notification.isDenied) { // can be customized
    //   await Permission.notification.request();
    // }
    // for Android 13+ Permission Handler
    if (await isNotificationPermissionGranted()) {
      return;
    }

    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();

    // for IOS
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // Get Condition Notification Permission
  static Future<bool> isNotificationPermissionGranted() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  // Show Scheduled Notification
  static Future<void> showScheduledNotification({
    required String id,
    required String title,
    required String body,
    required timezone.TZDateTime tzDateScheduled,
  }) async {
    final AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      id, // channel id
      title, // channel name
      channelDescription: body,
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    final DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails(
      sound: 'default',
      badgeNumber: null,
      subtitle: body,
      threadIdentifier: 'todo_list_thread',
      categoryIdentifier: 'todo_list_category',
    );
    final NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: iosNotificationDetails,
    );
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      int.parse(id),
      title,
      body,
      tzDateScheduled,
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time
    );
  }

  // Update Scheduled Notification
  static Future<void> updateScheduledNotification({
    required String id,
    required String title,
    required String body,
    required timezone.TZDateTime tzDateScheduled,
  }) async {
    // Close Specific Notification
    closeSpecificNotification(id: int.parse(id));
    // Show/Add Notification with new
    showScheduledNotification(
      id: id,
      title: title,
      body: body,
      tzDateScheduled: tzDateScheduled,
    );
  }

  // close specific notification
  static Future<void> closeSpecificNotification({
    required int id,
  }) async {
    _flutterLocalNotificationsPlugin.cancel(id);
  }
}
