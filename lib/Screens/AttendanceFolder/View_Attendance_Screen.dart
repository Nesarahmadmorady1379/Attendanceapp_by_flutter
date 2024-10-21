import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart';
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:attendanceapp/Moldels/Dalyattendancemodle.dart';
import 'package:flutter/material.dart';

class ViewAttendancePage extends StatefulWidget {
  final Attendance attendance;

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
    _loadAttendanceData(); // Call your method here
  }

  // Load attendance data from the database
  void _loadAttendanceData() async {
    final attendanceDbHelper = DatabaseHelper(); // Create instance directly

    // Fetch the attendance records based on attendance ID
    List<DailyAttendance> attendanceRecords = await attendanceDbHelper
        .getDailyAttendanceByAttendanceId(widget.attendance.id!);

    // Iterate over the fetched attendance records
    for (var record in attendanceRecords) {
      String studentId = record.studentId;

      // Initialize student data if not already present
      if (!groupedAttendance.containsKey(studentId)) {
        groupedAttendance[studentId] = {
          'name': '', // Placeholder for student name
          'id': studentId,
          'attendance': {},
          'presentDays': 0,
          'absentDays': 0,
        };
      }

      // Update attendance data for the student
      groupedAttendance[studentId]!['attendance'][record.date] =
          record.isPresent;

      if (record.isPresent) {
        groupedAttendance[studentId]!['presentDays']++;
      } else {
        groupedAttendance[studentId]!['absentDays']++;
      }

      // Add the date to the dates list if it doesn't exist already
      if (!dates.contains(record.date)) {
        dates.add(record.date);
      }
    }

    // Retrieve student names using their IDs and update the groupedAttendance map
    for (var studentId in groupedAttendance.keys) {
      // Fetch student names by ID
      String studentName =
          await attendanceDbHelper.getStudentNameById(studentId);
      groupedAttendance[studentId]!['name'] = studentName;
    }

    // Update the state with grouped attendance data
    setState(() {
      attendanceData = groupedAttendance.values.toList();
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
