import 'dart:convert';

import 'package:attendanceapp/Screens/AttendanceFolder/Add_Attendance_Screen.dart';
import 'package:attendanceapp/Screens/AttendanceFolder/Take_Attendance_Screen.dart';
import 'package:attendanceapp/Screens/AttendanceFolder/View_Attendance_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendancepage extends StatefulWidget {
  @override
  _AttendanceOverviewPageState createState() => _AttendanceOverviewPageState();
}

class _AttendanceOverviewPageState extends State<Attendancepage> {
  List<Map<String, String>> attendances = []; // Store attendance records

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

  void _loadAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      try {
        List<String>? attendanceList = prefs.getStringList('attendances');
        if (attendanceList != null) {
          attendances = attendanceList.map((e) {
            try {
              // Try to decode the JSON string
              return Map<String, String>.from(jsonDecode(e));
            } catch (error) {
              print('Error decoding attendance record: $e');
              return <String, String>{}; // Return an empty map on error
            }
          }).toList();
        } else {
          attendances = [];
        }
      } catch (error) {
        print('Error loading attendance data: $error');
        attendances = []; // Fallback to an empty list on error
      }
    });
  }

  void _saveAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> attendanceList =
        attendances.map((e) => jsonEncode(e)).toList();
    prefs.setStringList('attendances', attendanceList);
  }

  void _deleteAttendance(int index) {
    setState(() {
      attendances.removeAt(index);
      _saveAttendances();
    });
  }

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
                  // Handle "Take Attendance"
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            TakeAttendancePage(attendance: attendances[index])),
                  );
                },
                child: Text('Take Attendance'),
              ),
              ElevatedButton(
                onPressed: () {
                  // Handle "View Attendance"
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ViewAttendancePage(attendance: attendances[index])),
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
      appBar: AppBar(title: Text('Attendance Overview')),
      body: ListView.builder(
        itemCount: attendances.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Row(
              children: [
                Text(attendances[index]['department']!),
                SizedBox(width: 10),
                Text(attendances[index]['semester']!),
              ],
            ),
            subtitle: Text(attendances[index]['subject']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(attendances[index]['startDate']!),
                SizedBox(width: 10),
                Text(attendances[index]['endDate']!),
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
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAttendancePage()));
        },
      ),
    );
  }
}
