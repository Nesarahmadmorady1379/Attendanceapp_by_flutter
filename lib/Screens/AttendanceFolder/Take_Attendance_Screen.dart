import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakeAttendancePage extends StatefulWidget {
  final Map<String, String> attendance; // Pass selected attendance details

  TakeAttendancePage({required this.attendance});

  @override
  _TakeAttendancePageState createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
  DateTime? currentDate;
  List<Map<String, dynamic>> students =
      []; // Sample student data with present/absent status

  @override
  void initState() {
    super.initState();
    _loadStudents(); // Load students related to the selected department/semester
  }

  void _loadStudents() async {
    // Load student data from SharedPreferences or another source
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      students = List<Map<String, dynamic>>.from(prefs
              .getStringList('students')
              ?.map((e) => Map<String, dynamic>.from(jsonDecode(e))) ??
          []);
    });
  }

  void _saveAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> attendanceData = students.map((e) => jsonEncode(e)).toList();
    prefs.setStringList(
        'attendance_${widget.attendance['department']}_${widget.attendance['semester']}_${widget.attendance['subject']}_$currentDate',
        attendanceData);
  }

  void _pickCurrentDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        currentDate = date;
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
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _pickCurrentDate,
            child: Text(
                currentDate == null ? 'Select Date' : currentDate!.toString()),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(students[index]['name']),
                  subtitle: Text('ID: ${students[index]['id']}'),
                  trailing: Checkbox(
                    value: students[index]['isPresent'],
                    onChanged: (value) {
                      setState(() {
                        students[index]['isPresent'] = value;
                      });
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            onPressed: () {
              _saveAttendance();
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text('Attendance saved')));
              Navigator.pop(context); // Return to previous page
            },
            child: Text('Save Attendance'),
          ),
        ],
      ),
    );
  }
}
