import 'dart:convert';

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
  List<Dalyattendancemodle> students = [];
  List<String> dates = [];
  Map<String, Map<String, dynamic>> groupedAttendance = {};

  @override
  void initState() {
    super.initState();
    _loadAttendanceData();
  }

  // Load attendance data from the database
  void _loadAttendanceData() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    students = await dbHelper.getStudentsByAttendanceId(widget.attendance.id!);

    for (var student in students) {
      // Assume attendance data is stored in the format: { 'date': isPresent }
      List<AttendanceRecord> attendanceRecords =
          await dbHelper.getAttendanceRecordsByStudentId(student.studentId);

      for (var record in attendanceRecords) {
        String date = record.date;
        if (!groupedAttendance.containsKey(student.studentId)) {
          groupedAttendance[student.studentId] = {
            'name': student.name,
            'id': student.studentId,
            'attendance': {},
            'presentDays': 0,
            'absentDays': 0,
          };
        }

        groupedAttendance[student.studentId]!['attendance'][date] =
            record.isPresent;

        if (record.isPresent) {
          groupedAttendance[student.studentId]!['presentDays']++;
        } else {
          groupedAttendance[student.studentId]!['absentDays']++;
        }

        if (!dates.contains(date)) {
          dates.add(date);
        }
      }
    }

    setState(() {
      // Convert the map to a list for the DataTable
      students = groupedAttendance.values
          .map((e) => Dalyattendancemodle.fromMap(e))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.attendance.department} - ${widget.attendance.semester} - ${widget.attendance.subject}'),
      ),
      body: students.isNotEmpty
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
                    rows: students.map((student) {
                      return DataRow(cells: [
                        DataCell(Text(student.name)),
                        DataCell(Text(student.studentId)),
                        ...dates.map<DataCell>((date) {
                          bool? isPresent =
                              Dalyattendancemodle.attendance[date];
                          return DataCell(
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: (isPresent) ? '✓' : 'x',
                                    style: TextStyle(
                                      color: (isPresent)
                                          ? Colors.black
                                          : Colors.red,
                                      fontSize: 24,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                        DataCell(
                            Text(Dalyattendancemodle.presentDays.toString())),
                        DataCell(
                            Text(Dalyattendancemodle.absentDays.toString())),
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
