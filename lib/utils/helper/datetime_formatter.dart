import 'package:device_calendar/device_calendar.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo_list_app/utils/helper/timezone_handler.dart';

class DateTimeFormatter {
  static final DateFormat _formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm');

  static String formatToString({required dynamic dateTime}) {
    if (dateTime is DateTime) {
      return _formatter.format(dateTime);
    } else if (dateTime is TZDateTime) {
      return _formatter.format(
        DateTime.fromMillisecondsSinceEpoch(dateTime.millisecondsSinceEpoch),
      );
    } else {
      throw ArgumentError(
          'Invalid type. Only DateTime or TZDateTime are supported.');
    }
  }

  static dynamic dateTimeNeutralizer(dynamic dateTime) async {
    if (dateTime is DateTime) {
      return tz.TZDateTime.from(
        dateTime,
        await TimezoneHandler.getDeviceTimezone(),
      );
    } else if (dateTime is TZDateTime) {
      return DateTime.fromMillisecondsSinceEpoch(
        dateTime.millisecondsSinceEpoch,
      );
    }
  }

  static DateTime formatToDateTime({required String dateTimeStr}) {
    return _formatter.parse(dateTimeStr);
  }

  static DateTime dateIsMinTimeAndNullChecker({required DateTime minTime, required String? dateTimeStr}) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) {
      return minTime;
    }

    DateTime parsedDateTime = formatToDateTime(dateTimeStr: dateTimeStr);
    if (parsedDateTime.isBefore(minTime) || parsedDateTime.isAtSameMomentAs(minTime)) {
      return minTime;
    } else {
      return parsedDateTime;
    }
  }
}
