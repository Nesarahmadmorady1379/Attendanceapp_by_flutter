import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'attendance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE attendances (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            department TEXT,
            semester TEXT,
            subject TEXT,
            startDate TEXT,
            endDate TEXT,
            students TEXT
          )
        ''');
      },
    );
  }

  Future<void> addAttendance(Attendance attendance) async {
    final db = await database;
    await db.insert('attendances', attendance.toMap());
  }

  Future<List<Attendance>> getAttendances(String department) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('attendances', where: 'department = ?', whereArgs: [department]);

    return List.generate(maps.length, (i) {
      return Attendance.fromMap(maps[i]);
    });
  }

  Future<void> deleteAttendance(int id) async {
    final db = await database;
    await db.delete('attendances', where: 'id = ?', whereArgs: [id]);
  }
}
