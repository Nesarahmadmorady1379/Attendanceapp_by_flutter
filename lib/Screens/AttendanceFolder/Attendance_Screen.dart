import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Add_Attendance_Screen.dart';
import 'Take_Attendance_Screen.dart';
import 'View_Attendance_Screen.dart';

class Attendancepage extends StatefulWidget {
  final String departmentName;

  const Attendancepage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _AttendanceOverviewPageState createState() => _AttendanceOverviewPageState();
}

class _AttendanceOverviewPageState extends State<Attendancepage> {
  List<Map<String, dynamic>> attendances = [];

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  // Load attendance data from SharedPreferences
  void _loadAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      try {
        String? attendanceString =
            prefs.getString('attendance_${widget.departmentName}');
        if (attendanceString != null) {
          List<dynamic> attendanceList = json.decode(attendanceString);
          attendances =
              attendanceList.map((e) => Map<String, dynamic>.from(e)).toList();
        } else {
          attendances = [];
        }
      } catch (error) {
        print('Error loading attendance data: $error');
        attendances = []; // Fallback to an empty list on error
      }
    });
  }

  // Save updated attendance data back to SharedPreferences
  void _saveAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(attendances);
    prefs.setString('attendance_${widget.departmentName}', encodedData);
  }

  // Delete an attendance record
  void _deleteAttendance(int index) {
    setState(() {
      attendances.removeAt(index);
      _saveAttendances();
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
                        attendance: attendances[index], // Passing dynamic map
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
                        attendance: attendances[index], // Passing dynamic map
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
                  Text("Subject: ${attendance['subject']}"),
                  SizedBox(width: 3),
                ],
              ),
              subtitle: Text("Semester: ${attendance['semester']}"),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Format the start and end dates using the intl package
                  Text(
                    DateFormat.yMd()
                        .format(DateTime.parse(attendance['startDate'])),
                  ),
                  SizedBox(width: 10),
                  Text(
                    DateFormat.yMd()
                        .format(DateTime.parse(attendance['endDate'])),
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
          // Navigate to the AddAttendancePage and wait for the result
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
                _saveAttendances();
              });
            }
          });
        },
      ),
    );
  }
}
