import 'package:intl/intl.dart';

class DateTimeFormatter {
  static final DateFormat _formatter = DateFormat('EEEE, dd MMMM yyyy HH:mm');

  static String formatToString({required DateTime dateTime}) {
    return _formatter.format(dateTime);
  }

  static DateTime formatToDateTime({required String dateTimeStr}) {
    return _formatter.parse(dateTimeStr);
  }

  static DateTime dateIsTodayAndNullChecker ({required String? dateTimeStr}) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return DateTime.now();
    
    DateTime parsedDateTime = formatToDateTime(dateTimeStr: dateTimeStr);
    if(parsedDateTime.isBefore(DateTime.now()) || parsedDateTime.isAtSameMomentAs(DateTime.now())){
      return DateTime.now();
    } else {
      return parsedDateTime;
    }
  }
}
