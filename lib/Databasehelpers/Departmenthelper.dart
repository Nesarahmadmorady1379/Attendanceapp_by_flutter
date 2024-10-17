import 'package:attendanceapp/Moldels/Deartnebtmodel.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
// Import the Department model

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
    String path = join(await getDatabasesPath(), 'departments.db');
    return await openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE departments(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT)',
        );
      },
      version: 1,
    );
  }

  // Fetch departments from the database and map them to Department objects
  Future<List<Department>> getDepartments() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('departments');

    return List.generate(maps.length, (i) {
      return Department.fromMap(maps[i]);
    });
  }

  // Insert a new department into the database
  Future<void> insertDepartment(Department department) async {
    final db = await database;
    await db.insert(
      'departments',
      department.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Delete a department from the database
  Future<void> deleteDepartment(int id) async {
    final db = await database;
    await db.delete(
      'departments',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  //fitch departemnt by name
  Future<Department?> getDepartmentByName(String name) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'departments',
      where: 'name = ?',
      whereArgs: [name],
    );

    if (maps.isNotEmpty) {
      return Department.fromMap(maps.first);
    } else {
      return null;
    }
  }

  // Update an existing department in the database
  Future<void> updateDepartment(Department department) async {
    final db = await database;
    await db.update(
      'departments',
      department.toMap(),
      where: 'id = ?',
      whereArgs: [department.id],
    );
  }
}
