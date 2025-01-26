import 'package:device_calendar/device_calendar.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/data/datasource/todo_database.dart';

import '../../models/todo.dart';

class TodoRepository {
  // Implement Singleton
  static final TodoRepository instance = TodoRepository._internal();

  TodoRepository._internal();

  factory TodoRepository() => instance;

  // Get Todo List
  Future<List<Todo>> getTodoList({
    required DeviceCalendarPlugin deviceCalendarPlugin,
    required String calendarName,
  }) async {
    final Database database = await TodoDatabase().getDatabase;

    final List<Map<String, dynamic>> todoListJson =
        await database.query(todoTableName);

    final List<Todo> todoList = await Future.wait(
      todoListJson.map((json) async {
        return await Todo.fromJson(
          json: json,
          deviceCalendarPlugin: deviceCalendarPlugin,
          calendarName: calendarName,
        );
      }).toList(),
    );

    return todoList;
  }

  // Get Specific Todo
  Future<Todo> getTodoFromId({
    required int todoId,
    required DeviceCalendarPlugin deviceCalendarPlugin,
    required String calendarName,
  }) async {
    final Database database = await TodoDatabase().getDatabase;

    final Map<String, dynamic> todoJson = (await database.query(
      todoTableName,
      where: "${TodoTable.id} = ?",
      whereArgs: [todoId],
    ))
        .first;

    Todo todoObject = await Todo.fromJson(
      json: todoJson,
      deviceCalendarPlugin: deviceCalendarPlugin,
      calendarName: calendarName,
    );

    return todoObject;
  }

  // Create New Todo
  Future<void> addTodo({required Todo todo}) async {
    final Database database = await TodoDatabase().getDatabase;

    await database.insert(
      todoTableName,
      todo.toJson(),
    );
  }

  // Update Todo
  Future<void> updateTodo({required Todo todo}) async {
    final Database database = await TodoDatabase().getDatabase;

    await database.update(
      todoTableName,
      todo.toJson(),
      where: "${TodoTable.id} = ?",
      whereArgs: [todo.id],
    );
  }

  // Delete Todo
  Future<void> deleteTodo({required int id}) async {
    final Database database = await TodoDatabase().getDatabase;

    await database.delete(
      todoTableName,
      where: "${TodoTable.id} = ?",
      whereArgs: [id],
    );
  }
}
