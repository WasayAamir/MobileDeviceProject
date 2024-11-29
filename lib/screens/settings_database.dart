import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

//class to handle the database for saving settings
class SettingsDatabase {

  static final SettingsDatabase _instance = SettingsDatabase._internal();

  // Reference to the SQLite database
  static Database? _database;

  SettingsDatabase._internal();

  // Factory constructor that returns the  instance
  factory SettingsDatabase() => _instance;

  // Getter method to retrieve the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Method to initialize the SQLite database
  Future<Database> _initDatabase() async {
    // Get the directory path to store the database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'settings.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // This creates a table called settings to store key-value pairs
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

  // Saves the users theme if they set it to dark or light mode
  Future<void> saveThemePreference(String theme) async {
    final db = await database;
    await db.insert(
      'settings',
      {'key': 'theme', 'value': theme},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Method to get the user's saved theme preference from the database
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
