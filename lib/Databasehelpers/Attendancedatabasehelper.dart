import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:attendanceapp/Moldels/Dalyattendancemodle.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() {
    return _instance;
  }

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'attendance.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE attendances(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        department TEXT,
        semester TEXT,
        subject TEXT,
        startDate TEXT,
        endDate TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE Dalyattendancemodle(
        id INTEGER PRIMARY KEY ,
        name TEXT,
        studentId TEXT,
        isPresent INTEGER,
        attendanceId INTEGER,
        FOREIGN KEY (attendanceId) REFERENCES attendances(id) ON DELETE CASCADE
      )
    ''');
  }

  // Attendance CRUD operations
  Future<int> insertAttendance(Attendance attendance) async {
    final db = await database;
    return await db.insert('attendances', attendance.toMap());
  }

  Future<List<Attendance>> getAttendances() async {
    final db = await database;
    var result = await db.query('attendances');
    return result.map((e) => Attendance.fromMap(e)).toList();
  }

  Future<int> deleteAttendance(int id) async {
    final db = await database;
    return await db.delete('attendances', where: 'id = ?', whereArgs: [id]);
  }

  // Student CRUD operations
  Future<int> insertStudent(
      Dalyattendancemodle student, int attendanceId) async {
    final db = await database;
    var studentData = student.toMap();
    studentData['attendanceId'] = attendanceId;
    return await db.insert('Dalyattendancemodle', studentData);
  }

  Future<List<Dalyattendancemodle>> getStudentsByAttendanceId(
      int attendanceId) async {
    final db = await database;
    var result = await db.query('Dalyattendancemodle',
        where: 'attendanceId = ?', whereArgs: [attendanceId]);
    return result.map((e) => Dalyattendancemodle.fromMap(e)).toList();
  }

  Future<int> deleteStudentsByAttendanceId(int attendanceId) async {
    final db = await database;
    return await db.delete('Dalyattendancemodle',
        where: 'attendanceId = ?', whereArgs: [attendanceId]);
  }
}
