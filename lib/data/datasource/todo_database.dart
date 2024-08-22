import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list_app/models/todo.dart';

class TodoDatabase {
  // Implement Singleton
  static final TodoDatabase instance = TodoDatabase._internal();

  TodoDatabase._internal();

  factory TodoDatabase() => instance;

  // Open Database
  final String databaseName = "todo.db";

  static Database? _database;

  Future<Database> get getDatabase async {
    if (_database != null) return _database!;

    _database = await _openNewDatabase(databaseName);
    return _database!;
  }

  Future<Database> _openNewDatabase(String filePath) async {
    final String databasePath = await getDatabasesPath();
    final String path = join(databasePath, filePath);

    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreateTable,
      onUpgrade: _onUpgradeTable,
    );
  }

  // Create New Table
  Future<void> _onCreateTable(Database db, int version) async {
    return db.execute("CREATE TABLE "
        "$todoTableName ("
        "${TodoTable.id} ${TodoTable.idType}, "
        "${TodoTable.title} ${TodoTable.titleType}, "
        "${TodoTable.desc} ${TodoTable.descType}, "
        "${TodoTable.check} ${TodoTable.checkType}, "
        "${TodoTable.scheduledTime} ${TodoTable.scheduledTimeType}"
        ")");
  }

  // Update Added New table scheduledTime
  Future<void> _onUpgradeTable(
      Database db, int oldVersion, int newVersion) async {
    if (oldVersion < newVersion) {
      await db.execute(
          'ALTER TABLE $todoTableName ADD COLUMN ${TodoTable.scheduledTime} ${TodoTable.scheduledTimeType}');
    }
  }
}
