import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart'
    as attendance_db;
import 'package:attendanceapp/Databasehelpers/Studentdatabasehelper.dart'
    as student_db;
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:attendanceapp/Moldels/Studentmodel.dart';
import 'package:flutter/material.dart';

class TakeAttendancePage extends StatefulWidget {
  final Attendance attendance; // Add this line

  const TakeAttendancePage({Key? key, required this.attendance})
      : super(key: key); // Update constructor

  @override
  _TakeAttendancePageState createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
  final attendanceDbHelper = attendance_db.DatabaseHelper();
  final studentDbHelper = student_db.DatabaseHelper();
  List<Student> studentsForAttendance =
      []; // Changed from attendances to studentsForAttendance

  @override
  void initState() {
    super.initState();
    _loadStudentsForAttendance(); // Load students for the specific attendance
  }

  Future<void> _loadStudentsForAttendance() async {
    studentsForAttendance = await getStudentsForAttendance(
        widget.attendance); // Use widget.attendance
    setState(() {});
  }

  Future<List<Student>> getStudentsForAttendance(Attendance attendance) async {
    List<Student> students = [];

    for (String studentId in attendance.studentIds) {
      Student student = await studentDbHelper.getStudentById(studentId);
      students.add(student);
    }
    return students;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Attendance for ${widget.attendance.subject}'),
      ),
      body: ListView.builder(
        itemCount: studentsForAttendance.length,
        itemBuilder: (context, index) {
          final student = studentsForAttendance[index];
          return Card(
            child: ListTile(
              title: Text(student.name),
              subtitle: Text(
                  'ID: ${student.studentId} | Semester: ${student.semester}'),
            ),
          );
        },
      ),
    );
  }
}
