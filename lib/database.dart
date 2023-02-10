import 'package:countup/tasks.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TasksDatabase {
  static final TasksDatabase instance = TasksDatabase._init();
  static Database? _database;

  TasksDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB("tasks.db");
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const textType = 'TEXT NOT NULL';
    const listType = 'LIST(TEXT NOT NULL)';
    await db.execute('''
    CREATE TABLE $tableTasks (
    ${TaskFields.title} $textType,
    ${TaskFields.times} $listType
    )
    ''');
  }

  Future<Task> create(Task task) async {
    final db = await instance.database;
    final id = await db.insert(tableTasks, task.toJSON());
    return task.copy(id: id);
  }

  Future<Task> readNote(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTasks,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Task.fromJSON(maps.first);
    } else {
      throw Exception("ID $id not found.");
    }
  }

  Future<List<Task>> readAllTasks() async {
    final db = await instance.database;
    final result = await db.query(tableTasks);
    return result.map((json) => Task.fromJSON(json)).toList();
  }

  Future<int> update(Task task) async {
    final db = await instance.database;
    return db.update(
        tableTasks,
        task.toJSON(),
        where: "${TaskFields.id} = ?",
        whereArgs: [task.id]
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
        tableTasks,
        where: "${TaskFields.id} = ?",
        whereArgs: [id]
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
