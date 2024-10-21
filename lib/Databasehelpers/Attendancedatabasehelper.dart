import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:attendanceapp/Moldels/Dalyattendancemodle.dart';
import 'package:attendanceapp/Moldels/Studentmodel.dart';
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
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'attendance.db');
    return await openDatabase(
      path,
      version: 3, // Increment the version for migration
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE attendances('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'department TEXT, '
          'semester TEXT, '
          'subject TEXT, '
          'startDate TEXT, '
          'endDate TEXT, '
          'studentIds TEXT)',
        );
        // Create DailyAttendance table
        await db.execute(
          'CREATE TABLE daily_attendance('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'attendanceId INTEGER, '
          'studentId TEXT, '
          'isPresent INTEGER, ' // 1 for present, 0 for absent
          'date TEXT)',
        );
        // Assuming you also have a students table, uncomment and adjust if needed
        /*
        await db.execute(
          'CREATE TABLE students('
          'studentId TEXT PRIMARY KEY, '
          'name TEXT)',
        );
        */
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 3) {
          await db.execute(
            'CREATE TABLE IF NOT EXISTS daily_attendance('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'attendanceId INTEGER, '
            'studentId TEXT, '
            'isPresent INTEGER, ' // 1 for present, 0 for absent
            'date TEXT)',
          );
        }
      },
    );
  }

  // Attendance table methods

  Future<int> insertAttendance(Attendance attendance) async {
    final db = await database;
    return await db.insert('attendances', attendance.toMap());
  }

  Future<List<Attendance>> getAttendances() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('attendances');

    return List.generate(maps.length, (index) {
      return Attendance.fromMap(maps[index]);
    });
  }

  Future<Attendance> getAttendanceById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'attendances',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return Attendance.fromMap(maps.first);
    } else {
      throw Exception('Attendance not found');
    }
  }

  Future<int> deleteAttendance(int id) async {
    final db = await database;
    return await db.delete(
      'attendances',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // New function to convert student IDs string to a List<String>
  List<String> convertStringToList(String studentIds) {
    return studentIds.split(',').map((id) => id.trim()).toList();
  }

  // New function to convert List<String> to a comma-separated string
  String convertListToString(List<String> studentIds) {
    return studentIds.join(',');
  }

  // DailyAttendance table methods

  Future<int> insertDailyAttendance(DailyAttendance dailyAttendance) async {
    final db = await database;
    return await db.insert('daily_attendance', dailyAttendance.toMap());
  }

  Future<int> updateDailyAttendance(DailyAttendance dailyAttendance) async {
    final db = await database;
    return await db.update(
      'daily_attendance',
      dailyAttendance.toMap(),
      where: 'id = ?',
      whereArgs: [dailyAttendance.id],
    );
  }

  Future<List<DailyAttendance>> getDailyAttendanceByDate(
      int attendanceId, String date) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'daily_attendance',
      where: 'attendanceId = ? AND date = ?',
      whereArgs: [attendanceId, date],
    );

    return List.generate(maps.length, (index) {
      return DailyAttendance.fromMap(maps[index]);
    });
  }

  // New method to get daily attendance by attendance ID
  Future<List<DailyAttendance>> getDailyAttendanceByAttendanceId(
      int attendanceId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'daily_attendance',
      where: 'attendanceId = ?',
      whereArgs: [attendanceId],
    );

    return List.generate(maps.length, (index) {
      return DailyAttendance.fromMap(maps[index]);
    });
  }

  // New method to get student name by student ID
  Future<String> getStudentNameById(String studentId) async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );

    if (maps.isNotEmpty) {
      return maps.first['name']; // Adjust based on your column name
    } else {
      throw Exception('Student not found');
    }
  }

  // Method to get students by attendance ID
  Future<List<Student>> getStudentsByAttendanceId(int attendanceId) async {
    final db = await database;

    // Fetch the attendance record by ID
    final List<Map<String, dynamic>> attendanceResult = await db.query(
      'attendances',
      where: 'id = ?',
      whereArgs: [attendanceId],
    );

    if (attendanceResult.isEmpty) {
      throw Exception('Attendance not found');
    }

    // Extract student IDs from the attendance
    String studentIdsString = attendanceResult.first['studentIds'];
    List<String> studentIds =
        studentIdsString.split(',').map((id) => id.trim()).toList();

    // Fetch the students whose IDs are in the attendance
    final List<Map<String, dynamic>> studentResults = await db.query(
      'students',
      where: 'studentId IN (${List.filled(studentIds.length, '?').join(',')})',
      whereArgs: studentIds,
    );

    if (studentResults.isEmpty) {
      throw Exception('No students found for this attendance');
    }

    // Convert the results to a list of Student objects
    return List.generate(studentResults.length, (index) {
      return Student.fromMap(studentResults[index]);
    });
  }
}
