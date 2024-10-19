import 'dart:convert';

import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// Make sure to import your Attendance model

class ViewAttendancePage extends StatefulWidget {
  final Attendance attendance; // Change to Attendance

  const ViewAttendancePage({Key? key, required this.attendance})
      : super(key: key);

  @override
  _ViewAttendancePageState createState() => _ViewAttendancePageState();
}

class _ViewAttendancePageState extends State<ViewAttendancePage> {
  List<Map<String, dynamic>> attendanceData = [];
  List<String> dates = [];
  Map<String, Map<String, dynamic>> groupedAttendance = {};

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  // Load attendance data from SharedPreferences
  void _loadAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Use the properties of the Attendance object
    String attendanceKeyPrefix =
        'attendance_${widget.attendance.department}_${widget.attendance.semester}_${widget.attendance.subject}';

    Set<String> allKeys = prefs.getKeys();
    List<String> attendanceKeys =
        allKeys.where((key) => key.startsWith(attendanceKeyPrefix)).toList();

    for (String key in attendanceKeys) {
      List<String>? storedData = prefs.getStringList(key);

      if (storedData != null) {
        for (String jsonString in storedData) {
          Map<String, dynamic> entry = jsonDecode(jsonString);
          String studentId = entry['id'];

          if (!groupedAttendance.containsKey(studentId)) {
            groupedAttendance[studentId] = {
              'name': entry['name'],
              'id': studentId,
              'attendance': {},
              'presentDays': 0,
              'absentDays': 0
            };
          }

          String? date = entry['date'];
          if (date != null && date is String) {
            groupedAttendance[studentId]!['attendance'][date] =
                entry['isPresent'];

            if (entry['isPresent'] == true) {
              groupedAttendance[studentId]!['presentDays']++;
            } else {
              groupedAttendance[studentId]!['absentDays']++;
            }

            if (!dates.contains(date)) {
              dates.add(date);
            }
          }
        }
      }
    }

    setState(() {
      attendanceData =
          groupedAttendance.values.toList(); // Ensure this line is included
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.attendance.department} - ${widget.attendance.semester} - ${widget.attendance.subject}'),
      ),
      body: attendanceData.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('ID')),
                  ...dates
                      .map((date) => DataColumn(label: Text(date)))
                      .toList(),
                  DataColumn(label: Text('Present Days')),
                  DataColumn(label: Text('Absent Days')),
                ],
                rows: attendanceData.map((student) {
                  return DataRow(cells: [
                    DataCell(Text(student['name'] ?? '')),
                    DataCell(Text(student['id'] ?? '')),
                    ...dates.map<DataCell>((date) {
                      bool? isPresent = student['attendance'][date];
                      return DataCell(Text(isPresent == true ? '✓' : 'x'));
                    }).toList(),
                    DataCell(Text(student['presentDays'].toString())),
                    DataCell(Text(student['absentDays'].toString())),
                  ]);
                }).toList(),
              ),
            )
          : Center(child: Text('No attendance data available')),
    );
  }
}
