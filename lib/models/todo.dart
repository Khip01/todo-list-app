const String todoTableName = "todo";

// initialise the todo table in the sqflite database
class TodoTable {
  static const String id = "id";
  static const String title = "title";
  static const String desc = "description";
  static const String check = "isChecked";

  static const String idType = "TEXT PRIMARY KEY";
  static const String titleType = "TEXT NOT NULL";
  static const String descType = "TEXT NOT NULL";
  static const String checkType = "INTEGER NOT NULL";
}

class Todo {
  final String id;
  final String title;
  final String desc;
  final bool check;

  Todo({
    required this.id,
    required this.title,
    required this.desc,
    required this.check,
  });

  Todo copyWith({
    String? id,
    String? title,
    String? desc,
    bool? check,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      check: check ?? this.check,
    );
  }

  static Todo fromJson(Map<String, dynamic> json) => Todo(
        id: json[TodoTable.id] as String,
        title: json[TodoTable.title] as String,
        desc: json[TodoTable.desc] as String,
        check: json[TodoTable.check] == 1,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
    TodoTable.id : id,
    TodoTable.title : title,
    TodoTable.desc : desc,
    TodoTable.check : check ? 1 : 0,
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
