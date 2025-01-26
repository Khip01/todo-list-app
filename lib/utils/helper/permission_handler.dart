import 'package:device_calendar/device_calendar.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHandler {

  static Future<bool> requestCalendarPermission({
    required DeviceCalendarPlugin deviceCalendarPlugin,
  }) async {
    final permissionGranted = await deviceCalendarPlugin.requestPermissions();
    return permissionGranted.isSuccess && permissionGranted.data == true;
  }

  static Future<void> requestAlarmPermissions() async {
    //  POST_NOTIFICATIONS permission request (for Android 13+)
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }

    // SCHEDULE_EXACT_ALARM permission request
    if (await Permission.scheduleExactAlarm.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

}