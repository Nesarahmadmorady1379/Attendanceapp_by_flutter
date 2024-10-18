import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart';
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:attendanceapp/Moldels/Dalyattendancemodle.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class TakeAttendancePage extends StatefulWidget {
  final Attendance attendance;

  const TakeAttendancePage({Key? key, required this.attendance}) : super(key: key);

  @override
  _TakeAttendancePageState createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
  DateTime? currentDate;
  List<Dalyattendancemodle> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    students = await dbHelper.getStudentsByAttendanceId(widget.attendance.id!);
    setState(() {});
  }

  void _saveAttendance() async {
    if (currentDate == null) {
      currentDate = DateTime.now();
    }

    DatabaseHelper dbHelper = DatabaseHelper();
    for (var student in students) {
      student.isPresent = student.isPresent; // Mark attendance based on checkbox
      await dbHelper.insertStudent(student, widget.attendance.id!);
    }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Attendance saved')));
    Navigator.pop(context);
  }

  void _pickCurrentDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        currentDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.attendance.department} - ${widget.attendance.semester} - ${widget.attendance.subject}'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickCurrentDate,
            child: Text(currentDate == null ? 'Select Date' : DateFormat('yyyy-MM-dd').format(currentDate!)),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(students[index].name),
                  subtitle: Text('ID: ${students[index].studentId}'),
                  trailing: Checkbox(
                    value: students[index].isPresent,
                    onChanged: (value) {
                      setState(() {
                        students[index].isPresent = value ?? false;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (currentDate != null) {
                _saveAttendance();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please select a date first')));
              }
            },
            child: Text('Save Attendance'),
          ),
        ],
      ),
    );
  }
}
