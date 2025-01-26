import 'package:device_calendar/device_calendar.dart';
import 'package:todo_list_app/data/repository/event_repository.dart';

const String todoTableName = "todo";

// initialise the todo table in the sqflite database
class TodoTable {
  static const String id = "id";
  static const String title = "title";
  static const String desc = "description";
  static const String check = "isChecked";
  static const String eventId = "eventId";
  static const String isUsingAlarm = "isUsingAlarm";

  static const String idType = "TEXT PRIMARY KEY";
  static const String titleType = "TEXT NOT NULL";
  static const String descType = "TEXT NOT NULL";
  static const String checkType = "INTEGER NOT NULL";
  static const String eventIdType = "TEXT";
  static const String isUsingAlarmType = "INTEGER NOT NULL";
}

class Todo {
  final String id;
  final String title;
  final String desc;
  final bool check;
  Event? event; // optional
  final bool isUsingAlarm;

  Todo({
    required this.id,
    required this.title,
    required this.desc,
    required this.check,
    this.event,
    required this.isUsingAlarm,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? desc,
    bool? check,
    Event? event,
    bool? isUsingAlarm,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      check: check ?? this.check,
      event: event ?? this.event,
      isUsingAlarm: isUsingAlarm ?? this.isUsingAlarm,
    );
  }

  static Future<Todo> fromJson({
    required Map<String, dynamic> json,
    required DeviceCalendarPlugin deviceCalendarPlugin,
    required String calendarName,
  }) async {
    Event? event = await EventRepository.getEventFromCalendar(
      deviceCalendarPlugin: deviceCalendarPlugin,
      calendarName: calendarName,
      eventId: json[TodoTable.eventId] as String? ?? "",
    );

    return Todo(
      id: json[TodoTable.id] as String,
      title: json[TodoTable.title] as String,
      desc: json[TodoTable.desc] as String,
      check: json[TodoTable.check] == 1,
      event: event,
      isUsingAlarm: json[TodoTable.isUsingAlarm] == 1,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
        TodoTable.id: id,
        TodoTable.title: title,
        TodoTable.desc: desc,
        TodoTable.check: check ? 1 : 0,
        TodoTable.eventId: event == null ? "" : event!.eventId,
        TodoTable.isUsingAlarm: isUsingAlarm ? 1 : 0,
      };
}

class TodoRequirement {
  final bool titleIsError;
  final bool descIsError;

  TodoRequirement({
    required this.titleIsError,
    required this.descIsError,
  });
}
