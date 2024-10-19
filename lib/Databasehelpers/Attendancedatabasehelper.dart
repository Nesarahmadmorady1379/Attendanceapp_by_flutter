import 'package:attendanceapp/Moldels/Attendancemodel.dart';
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
      version: 1,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE attendances('
          'id INTEGER PRIMARY KEY AUTOINCREMENT, '
          'department TEXT, '
          'semester TEXT, '
          'subject TEXT, '
          'startDate TEXT, '
          'endDate TEXT, '
          'studentIds TEXT)',
        );
      },
    );
  }

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

  // New method to delete attendance by ID
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
}
