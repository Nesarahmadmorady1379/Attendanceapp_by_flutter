import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ViewAttendancePage extends StatefulWidget {
  final Map<String, String> attendance; // Pass the selected attendance details

  ViewAttendancePage({required this.attendance});

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

  void _loadAttendanceData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Load attendance data from SharedPreferences based on selected department, semester, subject, and dates
    List<String>? attendanceList = prefs.getStringList(
        'attendance_${widget.attendance['department']}_${widget.attendance['semester']}_${widget.attendance['subject']}');
    if (attendanceList != null) {
      setState(() {
        attendanceData = List<Map<String, dynamic>>.from(
            attendanceList.map((e) => jsonDecode(e)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            '${widget.attendance['department']} - ${widget.attendance['semester']} - ${widget.attendance['subject']}'),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columns: [
            DataColumn(label: Text('Name')),
            DataColumn(label: Text('ID')),
            ...dates
                .map((date) => DataColumn(label: Text(date)))
                .toList(), // Dates as columns
            DataColumn(label: Text('Present Days')),
            DataColumn(label: Text('Absent Days')),
          ],
          rows: attendanceData.map((student) {
            int presentDays =
                student['attendance'].where((status) => status == true).length;
            int absentDays = student['attendance'].length - presentDays;
            return DataRow(cells: [
              DataCell(Text(student['name'])),
              DataCell(Text(student['id'])),
              ...student['attendance']
                  .map<DataCell>(
                      (isPresent) => DataCell(Text(isPresent ? '✓' : '')))
                  .toList(),
              DataCell(Text(presentDays.toString())),
              DataCell(Text(absentDays.toString())),
            ]);
          }).toList(),
        ),
      ),
    );
  }
}
