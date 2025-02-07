import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/calculation_log.dart';
import 'persistence.dart';

class SqlLiteController implements Persistence {
  static final SqlLiteController _instance = SqlLiteController._internal();
  factory SqlLiteController() => _instance;
  SqlLiteController._internal();

  Database? _db;

  @override
  Future<void> init() async {
    if (_db != null) return;

    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'calculation_log.db');

    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE CalculationLog (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            expression TEXT,
            result TEXT,
            timestamp TEXT
          )
        ''');
      },
    );
  }
  Future<void> clearData() async {
    if (_db == null) {
      throw Exception('Database not initialized. Call init() first.');
    }
    await _db!.delete('CalculationLog');
  }



  Future<CalculationLog?> getLastEntry() async {
    if (_db == null) {
      throw Exception('Database not initialized. Call init() first.');
    }

    final List<Map<String, dynamic>> result = await _db!.query(
      'CalculationLog',
      orderBy: 'id DESC',
      limit: 1,
    );

    if (result.isEmpty) return null;

    return CalculationLog(
      result.first['expression'],
      result.first['result'],
    )..timestamp = result.first['timestamp'];
  }



  @override
  Future<void> saveData(CalculationLog data) async {
    if (_db == null) {
      throw Exception('Database not initialized. Call init() first.');
    }

    // Ensure only one save per input by checking for an identical expression
    final existing = await _db!.query(
      'CalculationLog',
      where: 'expression = ? AND result = ?',
      whereArgs: [data.expression, data.result],
    );

    if (existing.isNotEmpty) return; // Prevent duplicate saves

    await _db!.insert(
      'CalculationLog',
      {
        'expression': data.expression,
        'result': data.result,
        'timestamp': data.timestamp,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }



  @override
  Future<List<CalculationLog>> getAllData() async {
    if (_db == null) {
      throw Exception('Database not initialized. Call init() first.');
    }

    final List<Map<String, dynamic>> result =
    await _db!.query('CalculationLog');

    return List.generate(result.length, (i) {
      return CalculationLog(
        result[i]['expression'],
        result[i]['result'],
      )..timestamp = result[i]['timestamp'];
    });
  }
}
