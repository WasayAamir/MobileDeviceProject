import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Singleton class to handle the database for saving settings, e.g., theme preferences
class SettingsDatabase {
  // Creating a private instance for singleton pattern
  static final SettingsDatabase _instance = SettingsDatabase._internal();

  // Reference to the SQLite database
  static Database? _database;

  // Private internal constructor
  SettingsDatabase._internal();

  // Factory constructor that returns the singleton instance
  factory SettingsDatabase() => _instance;

  // Getter method to retrieve the database, initializing it if not already initialized
  Future<Database> get database async {
    if (_database != null) return _database!; // If database exists, return it
    _database = await _initDatabase(); // Otherwise, initialize it
    return _database!;
  }

  // Method to initialize the SQLite database
  Future<Database> _initDatabase() async {
    // Get the directory path to store the database
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'settings.db');

    // Open or create the database with specified version and onCreate callback
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create a table called 'settings' to store key-value pairs
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

  // Method to save the user's theme preference (e.g., light or dark mode)
  Future<void> saveThemePreference(String theme) async {
    final db = await database; // Get the database instance
    await db.insert(
      'settings',
      {'key': 'theme', 'value': theme}, // Insert theme preference
      conflictAlgorithm: ConflictAlgorithm.replace, // Replace if the key already exists
    );
  }

  // Method to get the user's saved theme preference from the database
  Future<String?> getThemePreference() async {
    final db = await database; // Get the database instance

    // Query the 'settings' table for the theme preference value
    final result = await db.query(
      'settings',
      columns: ['value'], // Only retrieve the 'value' column
      where: 'key = ?', // Where the 'key' is 'theme'
      whereArgs: ['theme'],
    );

    // If there is a result, return the value; otherwise, return null
    return result.isNotEmpty ? result.first['value'] as String? : null;
  }
}
