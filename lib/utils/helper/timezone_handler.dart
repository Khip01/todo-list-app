import 'package:device_calendar/device_calendar.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class TimezoneHandler {

  static Future<Location> getDeviceTimezone() async {
    tz.initializeTimeZones();
    String timezone = 'ETC/UTC'; // Default Timezone
    try{
      timezone = await FlutterTimezone.getLocalTimezone();
    } catch (e) {
      throw Exception("There's a problem when trying to get a Local Timezone");
    }
    return tz.getLocation(timezone);
  }

}