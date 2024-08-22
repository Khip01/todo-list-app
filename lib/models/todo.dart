const String todoTableName = "todo";

// initialise the todo table in the sqflite database
class TodoTable {
  static const String id = "id";
  static const String title = "title";
  static const String desc = "description";
  static const String check = "isChecked";
  static const String scheduledTime = "scheduledTime";

  static const String idType = "TEXT PRIMARY KEY";
  static const String titleType = "TEXT NOT NULL";
  static const String descType = "TEXT NOT NULL";
  static const String checkType = "INTEGER NOT NULL";
  static const String scheduledTimeType = "TEXT";
}

class Todo {
  final String id;
  final String title;
  final String desc;
  final bool check;
  final String? scheduledTime; // optional

  Todo({
    required this.id,
    required this.title,
    required this.desc,
    required this.check,
    this.scheduledTime,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? desc,
    bool? check,
    String? scheduledTime,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      check: check ?? this.check,
      scheduledTime: scheduledTime ?? this.scheduledTime,
    );
  }

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        id: json[TodoTable.id] as String,
        title: json[TodoTable.title] as String,
        desc: json[TodoTable.desc] as String,
        check: json[TodoTable.check] == 1,
        scheduledTime: json[TodoTable.scheduledTime] as String?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        TodoTable.id: id,
        TodoTable.title: title,
        TodoTable.desc: desc,
        TodoTable.check: check ? 1 : 0,
        TodoTable.scheduledTime: scheduledTime,
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
