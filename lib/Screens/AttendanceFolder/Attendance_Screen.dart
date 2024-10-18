import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart';
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'add_attendance_screen.dart';
import 'take_attendance_screen.dart';
import 'view_attendance_screen.dart';


class AttendancePage extends StatefulWidget {
  final String departmentName;

  const AttendancePage({Key? key, required this.departmentName}) : super(key: key);

  @override
  _AttendancePageState createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  List<Attendance> attendances = [];

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  // Load attendance data from the database
  void _loadAttendances() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    attendances = await dbHelper.getAttendancesByDepartment(widget.departmentName);
    setState(() {});
  }

  // Delete an attendance record
  void _deleteAttendance(int index) async {
    await DatabaseHelper().deleteAttendance(attendances[index].id!);
    setState(() {
      attendances.removeAt(index);
    });
  }

  // Show options for each attendance (Take/View Attendance)
  void _showAttendanceOptionsDialog(int index) {
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
                      builder: (context) => TakeAttendancePage(
                        attendance: attendances[index],
                      ),
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
                      builder: (context) => ViewAttendancePage(
                        attendance: attendances[index],
                      ),
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
        title: Text('${widget.departmentName} Attendances'),
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
                  Text(
                    DateFormat.yMd().format(DateTime.parse(attendance.startDate)),
                  ),
                  SizedBox(width: 10),
                  Text(
                    DateFormat.yMd().format(DateTime.parse(attendance.endDate)),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteAttendance(index);
                    },
                  ),
                ],
              ),
              onTap: () {
                _showAttendanceOptionsDialog(index);
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
              builder: (context) => AddAttendancePage(
                departmentName: widget.departmentName,
              ),
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
