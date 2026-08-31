import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseService {
  DatabaseService._();

  static final DatabaseService instance = DatabaseService._();

  static const String _databaseName = 'momentum.db';
  static const int _databaseVersion = 1;

  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _openDatabase();
    return _database!;
  }

  Future<Database> _openDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, _databaseName);

    return openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE users (
            id TEXT PRIMARY KEY,
            email TEXT NOT NULL UNIQUE,
            name TEXT NOT NULL,
            createdAt TEXT NOT NULL,
            updatedAt TEXT
          )
        ''');
      },
    );
  }
}
