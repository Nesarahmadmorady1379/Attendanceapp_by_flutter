import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAttendancePage extends StatefulWidget {
  final Map<String, dynamic> attendance;

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
    String attendanceKeyPrefix =
        'attendance_${widget.attendance['department']}_${widget.attendance['semester']}_${widget.attendance['subject']}';

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
              'id': studentId, // Save the student ID here
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
          } else {
            print('Error: Invalid or null date found for entry: $entry');
          }
        }
      }
    }

    setState(() {
      attendanceData = groupedAttendance.values.toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.attendance['department']} - ${widget.attendance['semester']} - ${widget.attendance['subject']}'),
      ),
      body: attendanceData.isNotEmpty
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black), // Border for the whole table
                  ),
                  child: DataTable(
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black), // Border for the table cells
                    ),
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
                          return DataCell(RichText(
                              text: TextSpan(children: [
                            TextSpan(
                              text: (isPresent ?? false) ? '✓' : 'x',
                              style: TextStyle(
                                color: (isPresent ?? false)
                                    ? Colors.black
                                    : Colors
                                        .red, // Default color for ✓, red for x
                                fontSize: 24, // Adjust font size as needed
                              ),
                            ),
                          ])));
                        }).toList(),
                        DataCell(Text(student['presentDays'].toString())),
                        DataCell(Text(student['absentDays'].toString())),
                      ]);
                    }).toList(),
                  ),
                ),
              ),
            )
          : Center(child: Text('No attendance data available')),
    );
  }
}
