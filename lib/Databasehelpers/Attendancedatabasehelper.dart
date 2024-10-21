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
      version: 2, // Increment the version number
      onCreate: (db, version) async {
        // Create Attendances table
        await db.execute('''
          CREATE TABLE attendances(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            department TEXT,
            semester TEXT,
            subject TEXT,
            startDate TEXT,
            endDate TEXT,
            studentIds TEXT
          )
        ''');

        // Create DailyAttendance table
        await db.execute('''
          CREATE TABLE daily_attendance(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            attendanceId INTEGER,
            studentId TEXT,
            studentName TEXT,  // Added studentName column
            isPresent INTEGER,
            date TEXT
          )
        ''');

        // Create Students table
        await db.execute('''
          CREATE TABLE students(
            studentId TEXT PRIMARY KEY,
            name TEXT,
            department TEXT,
            semester TEXT
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          // Add studentName column to daily_attendance table
          await db.execute(
              'ALTER TABLE daily_attendance ADD COLUMN studentName TEXT');
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

  // Convert student IDs string to a List<String>
  List<String> convertStringToList(String studentIds) {
    return studentIds.split(',').map((id) => id.trim()).toList();
  }

  // Convert List<String> to a comma-separated string
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

  // Get student name by student ID
  Future<String> getStudentNameById(String studentId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'students',
      where: 'studentId = ?',
      whereArgs: [studentId],
    );

    if (maps.isNotEmpty) {
      return maps.first['name'];
    } else {
      return 'Unknown'; // Return 'Unknown' if student is not found
    }
  }

  // Get students based on attendance ID
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

    // Extract student IDs from the attendance record
    String studentIdsString = attendanceResult.first['studentIds'];
    List<String> studentIds = convertStringToList(studentIdsString);

    // Fetch the students whose IDs are in the attendance
    final List<Map<String, dynamic>> studentResults = await db.query(
      'students',
      where: 'studentId IN (${List.filled(studentIds.length, '?').join(',')})',
      whereArgs: studentIds,
    );

    return List.generate(studentResults.length, (index) {
      return Student.fromMap(studentResults[index]);
    });
  }

  // Get daily attendance records along with student names
  Future<List<Map<String, dynamic>>> getDailyAttendanceWithNamesByAttendanceId(
      int attendanceId) async {
    final db = await database;

    // Join daily_attendance with students to get student names
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT d.id, d.attendanceId, d.studentId, d.studentName, d.isPresent, d.date, s.name
      FROM daily_attendance d
      JOIN students s ON d.studentId = s.studentId
      WHERE d.attendanceId = ?
    ''', [attendanceId]);

    return maps;
  }
}
