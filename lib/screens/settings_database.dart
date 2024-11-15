import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SettingsDatabase {
  static final SettingsDatabase _instance = SettingsDatabase._internal();
  static Database? _database;

  SettingsDatabase._internal();

  factory SettingsDatabase() => _instance;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'settings.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE settings (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            key TEXT UNIQUE,
            value TEXT
          )
        ''');
      },
    );
  }

  Future<void> saveThemePreference(String theme) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': 'theme', 'value': theme},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getThemePreference() async {
    final db = await database;
    final result = await db.query(
      'settings',
      columns: ['value'],
      where: 'key = ?',
      whereArgs: ['theme'],
    );
    return result.isNotEmpty ? result.first['value'] as String? : null;
  }
}
