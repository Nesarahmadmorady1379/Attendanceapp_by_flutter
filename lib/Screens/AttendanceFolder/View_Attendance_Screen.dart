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

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  // Load attendance data from SharedPreferences
  void _loadAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Allow the user to select or pass a specific date here
    String selectedDate = '2024-10-11'; // Example, replace this with date logic
    String attendanceKey =
        'attendance_${widget.attendance['department']}_${widget.attendance['semester']}_${widget.attendance['subject']}_$selectedDate';

    List<String>? attendanceList = prefs.getStringList(attendanceKey);

    if (attendanceList != null) {
      setState(() {
        attendanceData = attendanceList.map((e) {
          return Map<String, dynamic>.from(jsonDecode(e));
        }).toList();
      });
    } else {
      print("No attendance data found for the selected date.");
    }
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
                    // Check if 'students' field exists for each record
                    if (student.containsKey('students')) {
                      // Extract student attendance records
                      List<dynamic> attendanceRecords = student['students']
                          .map((stu) => stu['isPresent'] as bool)
                          .toList();

                      // Calculate present and absent days
                      int presentDays = attendanceRecords
                          .where((status) => status == true)
                          .length;
                      int absentDays = attendanceRecords.length - presentDays;

                      // Build each row of the DataTable
                      return DataRow(cells: [
                        DataCell(Text(student['name'] ?? '')),
                        DataCell(Text(student['id'] ?? '')),
                        ...attendanceRecords
                            .map<DataCell>((isPresent) =>
                                DataCell(Text(isPresent ? '✓' : 'x')))
                            .toList(),
                        DataCell(Text(presentDays.toString())),
                        DataCell(Text(absentDays.toString())),
                      ]);
                    } else {
                      // Handle cases with missing 'students' data
                      return DataRow(cells: [
                        DataCell(Text('No data')),
                        DataCell(Text('No data')),
                        ...dates.map((_) => DataCell(Text('N/A'))).toList(),
                        DataCell(Text('N/A')),
                        DataCell(Text('N/A')),
                      ]);
                    }
                  }).toList(),
                ),
              ),
            )
          : Center(child: Text('No attendance data available')),
    );
  }
}
