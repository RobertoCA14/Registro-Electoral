import 'package:sqflite/sqflite.dart';
import 'event.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('events.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE events (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        date TEXT NOT NULL,
        description TEXT NOT NULL,
        imagePath TEXT,
        audioPath TEXT
      )
    ''');
  }

  Future<List<Event>> getEvents() async {
    final db = await instance.database;
    final events = await db.query('events', orderBy: 'date DESC');
    return events.map((json) => Event.fromJson(json)).toList();
  }

  Future<void> insertEvent(Event event) async {
    final db = await instance.database;
    await db.insert(
      'events',
      event.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> close() async {
    final db = await instance.database;
    db.close();
  }
}