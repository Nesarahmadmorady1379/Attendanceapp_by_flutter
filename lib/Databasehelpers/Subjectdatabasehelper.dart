import 'package:attendanceapp/Moldels/Subjectmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// Import the subject model

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'subjects.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute(
          '''
          CREATE TABLE subjects(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            department TEXT,
            name TEXT,
            credit TEXT
          )
          ''',
        );
      },
    );
  }

  // Insert a subject into the database
  Future<int> addSubject(Subject subject) async {
    final db = await database;
    return await db.insert('subjects', subject.toMap());
  }

  // Retrieve subjects for a specific department
  Future<List<Subject>> getSubjects(String department) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'subjects',
      where: 'department = ?',
      whereArgs: [department],
    );

    return List.generate(maps.length, (i) {
      return Subject.fromMap(maps[i]);
    });
  }

  // Update an existing subject
  Future<int> updateSubject(Subject subject) async {
    final db = await database;
    return await db.update(
      'subjects',
      subject.toMap(),
      where: 'id = ?',
      whereArgs: [subject.id],
    );
  }

  // Delete a subject from the database
  Future<int> deleteSubject(int id) async {
    final db = await database;
    return await db.delete(
      'subjects',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
