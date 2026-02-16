import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/task.dart';

class DatabaseHelper {

  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {

    if (_database != null) return _database!;

    _database = await _initDB('tasks.db');

    return _database!;

  }

  Future<Database> _initDB(String filePath) async {

    final dbPath = await getDatabasesPath();

    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2, // Increment version
      onCreate: _createDB,
      onUpgrade: _upgradeDB, // Handle migration
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE tasks(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  title TEXT,
  description TEXT,
  isCompleted INTEGER,
  deadline TEXT
)
''');
  }

  // Migration logic
  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await db.execute('ALTER TABLE tasks ADD COLUMN deadline TEXT');
    }
  }

  // INSERT
  Future<int> insertTask(Task task) async {

    final db = await instance.database;

    return await db.insert('tasks', task.toMap());

  }

  // READ
  Future<List<Task>> getTasks() async {

    final db = await instance.database;

    final result = await db.query('tasks');

    return result.map((map) => Task.fromMap(map)).toList();

  }

  // DELETE
  Future<int> deleteTask(int id) async {

    final db = await instance.database;

    return await db.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );

  }

  Future<int> updateTask(Task task) async {
    final db = await instance.database ;
    return await db.update(
        'tasks',
        task.toMap(),
        where: 'id = ? ',
       whereArgs: [task.id],
    );
  }



}
