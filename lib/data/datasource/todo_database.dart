import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/utils/constants.dart';

class TodoDatabase {
  // Implement Singleton
  static final TodoDatabase instance = TodoDatabase._internal();

  TodoDatabase._internal();

  factory TodoDatabase() => instance;

  // Open Database
  final String databaseName = Constants.SQFLITE_DATABASE_NAME;

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
      version: 5,
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
        "${TodoTable.eventId} ${TodoTable.eventIdType}"
        ")");
  }

  // Update Added New table column eventId (migrating)
  Future<void> _onUpgradeTable(Database db, int oldVersion, int newVersion) async {
    if (oldVersion >= newVersion) {
      return;
    }
    // rename old table to temp_name
    await db.execute('ALTER TABLE $todoTableName RENAME TO ${todoTableName}_temp');

    // create new table with the updated structure
    db.execute("CREATE TABLE "
        "$todoTableName ("
        "${TodoTable.id} ${TodoTable.idType}, "
        "${TodoTable.title} ${TodoTable.titleType}, "
        "${TodoTable.desc} ${TodoTable.descType}, "
        "${TodoTable.check} ${TodoTable.checkType}, "
        "${TodoTable.eventId} ${TodoTable.eventIdType}"
        ")");

    // copy data from temp tabel to new table
    await db.execute("""
      INSERT INTO $todoTableName (
        ${TodoTable.id},
        ${TodoTable.title},
        ${TodoTable.desc},
        ${TodoTable.check}
      )
      SELECT 
        ${todoTableName}_temp.${TodoTable.id},
        ${todoTableName}_temp.${TodoTable.title},
        ${todoTableName}_temp.${TodoTable.desc},
        ${todoTableName}_temp.${TodoTable.check}
      FROM ${todoTableName}_temp;
    """);

    // drop the temp table
    await db.execute("DROP TABLE ${todoTableName}_temp");

  }
}
