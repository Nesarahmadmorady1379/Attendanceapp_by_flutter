import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart';
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Add_Attendance_Screen.dart';
import 'Take_Attendance_Screen.dart';
import 'View_Attendance_Screen.dart';

class AttendancePage extends StatefulWidget {
  final String departmentName;

  const AttendancePage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _AttendanceOverviewPageState createState() => _AttendanceOverviewPageState();
}

class _AttendanceOverviewPageState extends State<AttendancePage> {
  List<Attendance> attendances = [];
  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  // Load attendance data from the database
  void _loadAttendances() async {
    attendances = await dbHelper.getAttendances();
    setState(() {});
  }

  // Delete an attendance record
  void _deleteAttendance(int id) async {
    await dbHelper.deleteAttendance(id);
    _loadAttendances(); // Refresh the list after deletion
  }

  // Show options for each attendance (Take/View Attendance)
  void _showAttendanceOptionsDialog(Attendance attendance) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Attendance Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          TakeAttendancePage(attendance: attendance),
                    ),
                  );
                },
                child: Text('Take Attendance'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ViewAttendancePage(attendance: attendance),
                    ),
                  );
                },
                child: Text('View Attendance'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departmentName} attendances'),
      ),
      body: ListView.builder(
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          var attendance = attendances[index];
          return Card(
            child: ListTile(
              title: Row(
                children: [
                  Text("Subject: ${attendance.subject}"),
                  SizedBox(width: 3),
                ],
              ),
              subtitle: Text("Semester: ${attendance.semester}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Updated to parse the custom date format
                  Text(
                    DateFormat.yMd().format(
                      DateFormat('yyyy-MM-dd').parse(attendance.startDate),
                    ),
                  ),
                  Text(
                    DateFormat.yMd().format(
                      DateFormat('yyyy-MM-dd').parse(attendance.endDate),
                    ),
                  ),

                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAttendance(attendance.id!);
                    },
                  ),
                ],
              ),
              onTap: () {
                _showAttendanceOptionsDialog(attendance);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AddAttendancePage(departmentName: widget.departmentName),
            ),
          ).then((newAttendance) {
            // If a new attendance record is returned, add it to the list
            if (newAttendance != null) {
              setState(() {
                attendances.add(newAttendance);
              });
            }
          });
        },
      ),
    );
  }
}
