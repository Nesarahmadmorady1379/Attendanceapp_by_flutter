import 'dart:convert';

<<<<<<< HEAD
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

=======
import 'package:attendanceapp/Screens/AttendanceFolder/Add_Attendance_Screen.dart';
import 'package:attendanceapp/Screens/AttendanceFolder/Take_Attendance_Screen.dart';
import 'package:attendanceapp/Screens/AttendanceFolder/View_Attendance_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Attendancepage extends StatefulWidget {
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
  @override
  _AttendanceOverviewPageState createState() => _AttendanceOverviewPageState();
}

class _AttendanceOverviewPageState extends State<Attendancepage> {
<<<<<<< HEAD
  List<Map<String, dynamic>> attendances = [];
=======
  List<Map<String, String>> attendances = []; // Store attendance records
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7

  @override
  void initState() {
    super.initState();
    _loadAttendances();
  }

<<<<<<< HEAD
  // Load attendance data from SharedPreferences
=======
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
  void _loadAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      try {
<<<<<<< HEAD
        String? attendanceString =
            prefs.getString('attendance_${widget.departmentName}');
        if (attendanceString != null) {
          List<dynamic> attendanceList = json.decode(attendanceString);
          attendances =
              attendanceList.map((e) => Map<String, dynamic>.from(e)).toList();
=======
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
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
        } else {
          attendances = [];
        }
      } catch (error) {
        print('Error loading attendance data: $error');
        attendances = []; // Fallback to an empty list on error
      }
    });
  }

<<<<<<< HEAD
  // Save updated attendance data back to SharedPreferences
  void _saveAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedData = jsonEncode(attendances);
    prefs.setString('attendance_${widget.departmentName}', encodedData);
  }

  // Delete an attendance record
=======
  void _saveAttendances() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> attendanceList =
        attendances.map((e) => jsonEncode(e)).toList();
    prefs.setStringList('attendances', attendanceList);
  }

>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
  void _deleteAttendance(int index) {
    setState(() {
      attendances.removeAt(index);
      _saveAttendances();
    });
  }

<<<<<<< HEAD
  // Show options for each attendance (Take/View Attendance)
=======
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
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
<<<<<<< HEAD
=======
                  // Handle "Take Attendance"
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
<<<<<<< HEAD
                      builder: (context) => TakeAttendancePage(
                        attendance: attendances[index], // Passing dynamic map
                      ),
                    ),
=======
                        builder: (context) =>
                            TakeAttendancePage(attendance: attendances[index])),
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
                  );
                },
                child: Text('Take Attendance'),
              ),
              ElevatedButton(
                onPressed: () {
<<<<<<< HEAD
=======
                  // Handle "View Attendance"
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
                  Navigator.of(context).pop();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
<<<<<<< HEAD
                      builder: (context) => ViewAttendancePage(
                        attendance: attendances[index], // Passing dynamic map
                      ),
                    ),
=======
                        builder: (context) =>
                            ViewAttendancePage(attendance: attendances[index])),
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
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
<<<<<<< HEAD
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
=======
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
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
<<<<<<< HEAD
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
=======
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddAttendancePage()));
>>>>>>> a34608d4e0bcdf2b87e2711bc3f26299c9a4fda7
        },
      ),
    );
  }
}
