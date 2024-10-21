import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart'
    as attendance_db;
import 'package:attendanceapp/Databasehelpers/Studentdatabasehelper.dart'
    as student_db;
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:attendanceapp/Moldels/Dalyattendancemodle.dart';
import 'package:attendanceapp/Moldels/Studentmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TakeAttendancePage extends StatefulWidget {
  final Attendance attendance;

  const TakeAttendancePage({Key? key, required this.attendance})
      : super(key: key);

  @override
  _TakeAttendancePageState createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
  final attendanceDbHelper = attendance_db.DatabaseHelper();
  final studentDbHelper = student_db.DatabaseHelper();
  List<Student> studentsForAttendance = [];
  String currentDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  Map<String, bool> attendanceStatus =
      {}; // Keep track of attendance for each student

  @override
  void initState() {
    super.initState();
    _loadStudentsForAttendance();
  }

  Future<void> _loadStudentsForAttendance() async {
    // Safeguard to ensure that attendance studentIds are valid
    if (widget.attendance.studentIds.isNotEmpty) {
      studentsForAttendance = await getStudentsForAttendance(widget.attendance);
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No students associated with this attendance.")),
      );
    }
  }

  Future<List<Student>> getStudentsForAttendance(Attendance attendance) async {
    List<Student> students = [];
    for (String studentId in attendance.studentIds) {
      try {
        Student student = await studentDbHelper.getStudentById(studentId);
        students.add(student);
      } catch (e) {
        print("Error fetching student with ID $studentId: $e");
        // Optionally handle the error (e.g., show a message)
      }
    }
    return students;
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        currentDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveAttendance() async {
    // Check if the selected date is today's date
    if (currentDate != DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please choose the current date.")),
      );
      return; // Exit the function if the date is not today's date
    }

    // Ensure attendanceId is not null
    if (widget.attendance.id == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Attendance ID is null!")),
      );
      return;
    }

    // Save attendance for each student
    for (var student in studentsForAttendance) {
      if (student.studentId == null) {
        print("Student ID is null for a student!"); // Debugging line
        continue; // Skip if student ID is null
      }

      DailyAttendance dailyAttendance = DailyAttendance(
        attendanceId: widget.attendance.id!, // Ensure this is not null
        studentId: student.studentId,
        isPresent: attendanceStatus[student.studentId] ?? false,
        date: currentDate,
      );

      // Debugging: Print the attendance record being saved
      print(
          'Saving attendance for Student ID: ${student.studentId}, Present: ${dailyAttendance.isPresent}, Date: ${dailyAttendance.date}');

      await attendanceDbHelper.insertDailyAttendance(dailyAttendance);
    }

    // Fetch and print saved records for verification
    List<DailyAttendance> savedAttendance = await attendanceDbHelper
        .getDailyAttendanceByDate(widget.attendance.id!, currentDate);
    for (var record in savedAttendance) {
      print(
          'Saved Attendance - Student ID: ${record.studentId}, Present: ${record.isPresent}, Date: ${record.date}');
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Attendance Saved")),
    );
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Take Attendance for ${widget.attendance.subject}'),
      ),
      body: Column(
        children: [
          // Date Picker Button
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () => _pickDate(context),
              child: Text('Pick Attendance Date'),
            ),
          ),
          Text('Selected Date: $currentDate'),

          Expanded(
            child: ListView.builder(
              itemCount: studentsForAttendance.length,
              itemBuilder: (context, index) {
                final student = studentsForAttendance[index];
                return Card(
                  child: ListTile(
                    title: Text(student.name),
                    subtitle: Text(
                      'ID: ${student.studentId} | Semester: ${student.semester}',
                    ),
                    trailing: Checkbox(
                      value: attendanceStatus[student.studentId] ?? false,
                      onChanged: (bool? value) {
                        setState(() {
                          attendanceStatus[student.studentId] = value ?? false;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveAttendance,
              child: Text('Save Attendance'),
            ),
          ),
        ],
      ),
    );
  }
}
