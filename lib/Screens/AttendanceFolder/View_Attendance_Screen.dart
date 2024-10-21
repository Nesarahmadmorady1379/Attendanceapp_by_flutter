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
    _loadAttendanceData(); // Load attendance data when the page initializes
  }

  // Load attendance data from the database
  void _loadAttendanceData() async {
    final attendanceDbHelper = DatabaseHelper();

    // Fetch attendance records based on the attendance ID
    List<DailyAttendance> attendanceRecords = await attendanceDbHelper
        .getDailyAttendanceByAttendanceId(widget.attendance.id!);

    print("Attendance Records: $attendanceRecords"); // Log fetched records

    // Initialize a set to store unique student IDs
    Set<String> uniqueStudentIds = {};

    // Iterate over the fetched attendance records to group attendance by student
    for (var record in attendanceRecords) {
      String studentId = record.studentId;

      // Add unique student IDs to the set
      uniqueStudentIds.add(studentId);

      // Initialize student data if not already present in the groupedAttendance map
      if (!groupedAttendance.containsKey(studentId)) {
        groupedAttendance[studentId] = {
          'name': record.studentName.isNotEmpty
              ? record.studentName
              : 'Unknown', // Use student name if available
          'id': studentId,
          'attendance': {},
          'presentDays': 0,
          'absentDays': 0,
        };
      }

      // Update attendance data for the student for the specific date
      groupedAttendance[studentId]!['attendance'][record.date] =
          record.isPresent;

      // Count present and absent days for each student
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

    // Update the state to refresh the UI with the loaded attendance data
    setState(() {
      attendanceData = groupedAttendance.values.toList();
    });

    // Log attendance data after state update
    print("Attendance Data: $attendanceData");
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
                  DataColumn(label: Text('Name')), // Column for student names
                  DataColumn(label: Text('ID')), // Column for student IDs
                  ...dates
                      .map((date) => DataColumn(label: Text(date)))
                      .toList(), // Columns for attendance dates
                  DataColumn(
                      label: Text('Present Days')), // Column for present days
                  DataColumn(
                      label: Text('Absent Days')), // Column for absent days
                ],
                rows: attendanceData.map((student) {
                  return DataRow(cells: [
                    DataCell(Text(
                        student['name'] ?? 'Unknown')), // Show student name
                    DataCell(Text(student['id'] ?? '')), // Show student ID
                    ...dates.map<DataCell>((date) {
                      bool? isPresent = student['attendance'][date];
                      return DataCell(
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                // text: isPresent == true
                                //     ? '✓'
                                //     : 'x', // First symbol
                                style: TextStyle(
                                  color: isPresent == true
                                      ? Colors.black
                                      : Colors
                                          .red, // Black if present, red if absent
                                  fontSize:
                                      18, // Optional: Adjust the font size
                                ),
                              ),
                              TextSpan(
                                text: isPresent == false
                                    ? ' x'
                                    : ' ✓', // Second symbol (opposite color)
                                style: TextStyle(
                                  color: isPresent == false
                                      ? Colors.red
                                      : Colors
                                          .black, // Red if present, black if absent
                                  fontSize:
                                      18, // Optional: Adjust the font size
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                      // Mark absent
                    }).toList(),
                    DataCell(Text(
                        student['presentDays'].toString())), // Present days
                    DataCell(
                        Text(student['absentDays'].toString())), // Absent days
                  ]);
                }).toList(),
              ),
            )
          : Center(child: Text('No attendance data available')),
    );
  }
}
