import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = 'myDatabase.db';
  static const _databaseVersion = 1;

  static const table = 'myTable';

  static const columnId = 'id';
  static const columnTarefa = 'nome';
  static const columnStatus = 'status';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = await getDatabasesPath();
    final databasePath = join(path, _databaseName);

    return await openDatabase(
      databasePath,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nome TEXT,
        status INTEGER
        )
      ''');


  }

  Future<int> insert(Map<String, dynamic> row) async {
    final db = await database;
    return await db.insert(table, row);
  }

  Future<int> update(Map<String, dynamic> row) async {
    final db = await database;
    final id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> updateStatus(int id, bool concluida) async {
    final db = await database;
    return await db.update(
      table,
      {'status': concluida ? 1 : 0},
      where: '$columnId = ?',
      whereArgs: [id],
    );
  }

  Future<int> delete(int id) async {
    final db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    final db = await database;
    return await db.query(table);
  }

  Future<List<Map<String, dynamic>>> queryById(int id) async {
    final db = await database;
    final result = await db.query(table, where: '$columnId = ?', whereArgs: [id]);

    if (result.isNotEmpty) {
      return result;
    } else {
      return [];
    }
  }
}




