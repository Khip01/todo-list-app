import 'package:device_calendar/device_calendar.dart';

import '../../utils/helper/permission_handler.dart';

class CalendarRepository {

  static Future<String> getOrCreateCalendarId({
    required String calendarName,
    required DeviceCalendarPlugin deviceCalendarPlugin,
  }) async {
    // Check permission
    if (!(await PermissionHandler.requestCalendarPermission(
        deviceCalendarPlugin: deviceCalendarPlugin))) {
      throw Exception("Calendar Permission Not Granted!");
    }

    // Retrieve All Calendar
    final calendarResult = await deviceCalendarPlugin.retrieveCalendars();
    if (!calendarResult.isSuccess && calendarResult.data == null) {
      throw Exception("Failed to retrieve calendars :/");
    }

    // Search Existing calendar
    final List<Calendar> filteredCalendars = calendarResult.data!
        .where(
          (calendar) => calendar.name == calendarName,
    )
        .toList();

    // Calender already exist
    if (filteredCalendars.isNotEmpty && filteredCalendars.first.id == null) {
      throw Exception("Failed to retrieve id with existing calendar");
    } else if (filteredCalendars.isNotEmpty &&
        filteredCalendars.first.id != null) {
      final existingCalendar = filteredCalendars.first;
      return existingCalendar.id!;
    }

    // Create new calendar
    try {
      return await _createNewCalendar(
        calendarName: calendarName,
        deviceCalendarPlugin: deviceCalendarPlugin,
      );
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<String> _createNewCalendar({
    required String calendarName,
    required DeviceCalendarPlugin deviceCalendarPlugin,
  }) async {
    final createResult = await deviceCalendarPlugin.createCalendar(
      calendarName,
      localAccountName: "Local Account",
    );

    if (!createResult.isSuccess || createResult.data == null) {
      throw Exception("Failed when creating a new calendar");
    }

    // Return new Calendar id
    return createResult.data!;
  }

}