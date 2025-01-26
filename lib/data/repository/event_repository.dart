import 'package:android_intent_plus/android_intent.dart';
import 'package:device_calendar/device_calendar.dart';
import 'package:todo_list_app/utils/helper/timezone_handler.dart';

import '../../utils/helper/permission_handler.dart';
import '../../data/repository/calendar_repository.dart';

class EventRepository {

  static Future<Event?> getEventFromCalendar({
    required DeviceCalendarPlugin deviceCalendarPlugin,
    required String calendarName,
    required String eventId,
  }) async {
    // check permission
    if (!(await PermissionHandler.requestCalendarPermission(
        deviceCalendarPlugin: deviceCalendarPlugin))) {
      throw Exception("Calendar Permission Not Granted!");
    }

    // get calendar id
    final String calendarId = await CalendarRepository.getOrCreateCalendarId(
      calendarName: calendarName,
      deviceCalendarPlugin: deviceCalendarPlugin,
    );

    // retrieve all existing events
    final eventsResult = await deviceCalendarPlugin.retrieveEvents(
      calendarId,
      RetrieveEventsParams(
        eventIds: [eventId],
      ),
    );

    // check retrieved event
    if (!eventsResult.isSuccess || eventsResult.data == null || eventsResult.data!.isEmpty){
      return null;
    }

    return eventsResult.data!.first;
  }

  static Future<String> addOrUpdateEventToCalendar({
    required DeviceCalendarPlugin deviceCalendarPlugin,
    required String calendarId,
    String? eventId,
    required String title,
    String? description,
    required DateTime start,
    required DateTime? end,
  }) async {
    // Check permission
    if (!(await PermissionHandler.requestCalendarPermission(
        deviceCalendarPlugin: deviceCalendarPlugin))) {
      throw Exception("Calendar Permission Not Granted!");
    }

    // Get device timezone
    late final Location location;
    try {
      location = await TimezoneHandler.getDeviceTimezone();
    } catch (e) {
      throw Exception(e.toString());
    }

    // Convert Date Time to Timezone
    final TZDateTime tzStart = TZDateTime.from(start, location);
    final TZDateTime tzEnd = TZDateTime.from(end ?? start, location);

    final Event event = Event(calendarId, eventId: eventId)
      ..title = title
      ..description = description
      ..start = tzStart
      ..end = tzEnd
      ..reminders = [
        Reminder(minutes: 30),
        Reminder(minutes: 10),
        Reminder(minutes: 1),
        Reminder(minutes: 0),
      ];

    final Result<String>? result =
    await deviceCalendarPlugin.createOrUpdateEvent(event);

    if (result == null || !result.isSuccess || result.data == null) {
      throw Exception("Failed to add event to calendar!");
    }

    return result.data!;
  }

  static Future<bool> deleteEventFromCalendar({
    required DeviceCalendarPlugin deviceCalendarPlugin,
    required String calendarId,
    required String? eventId,
  }) async {
    final Result<bool> deleteResult =
    await deviceCalendarPlugin.deleteEvent(calendarId, eventId);

    if (!deleteResult.isSuccess || deleteResult.data == null) {
      throw Exception("Failed to delete event: ${deleteResult.errors}");
    }

    return deleteResult.data ?? false;
  }

  // -- ALARM MANAGER -- //
  static void setAlarm({
    required DateTime eventStartDate,
    required String message,
  }) {
    final AndroidIntent intent =
    AndroidIntent(action: 'android.intent.action.SET_ALARM', arguments: {
      'android.intent.extra.alarm.HOUR': eventStartDate.hour,
      'android.intent.extra.alarm.MINUTES': eventStartDate.minute,
      'android.intent.extra.alarm.MESSAGE': message,
    });

    intent.launch().catchError((_) {
      throw Exception(
          "There seems to be something wrong when setting the alarm");
    });
  }
  //
  // void openDefaultAlarmApp() {
  //   final AndroidIntent intent = AndroidIntent(
  //     action: 'android.intent.action.SHOW_ALARMS',
  //   );
  //
  //   intent.launch().catchError((_) {
  //     throw Exception(
  //         "Tidak dapat membuka aplikasi alarm bawaan. Periksa apakah aplikasi alarm tersedia di perangkat.");
  //   });
  // }

}
