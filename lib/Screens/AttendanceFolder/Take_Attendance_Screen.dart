import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TakeAttendancePage extends StatefulWidget {
  final Map<String, dynamic> attendance;

  const TakeAttendancePage({Key? key, required this.attendance})
      : super(key: key);

  @override
  _TakeAttendancePageState createState() => _TakeAttendancePageState();
}

class _TakeAttendancePageState extends State<TakeAttendancePage> {
  DateTime? currentDate;
  List<Map<String, dynamic>> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Load students for the specific attendance record
  void _loadStudents() {
    setState(() {
      // Retrieve students directly from the attendance data
      students = List<Map<String, dynamic>>.from(widget.attendance['students']);

      // Ensure all students have an 'isPresent' field with a boolean value
      for (var student in students) {
        student['isPresent'] =
            student['isPresent'] == true || student['isPresent'] == 'true';
        // This ensures 'true' string and bool true are converted to bool true.
      }
    });
  }

  // Save the updated attendance data (with attendance status)
  void _saveAttendance() async {
    if (currentDate == null) {
      currentDate = DateTime.now();
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> attendanceData = students.map((e) => jsonEncode(e)).toList();
    String formattedDate = DateFormat('yyyy-MM-dd').format(currentDate!);
    String attendanceKey =
        'attendance_${widget.attendance['department']}_${widget.attendance['semester']}_${widget.attendance['subject']}_$formattedDate';

    prefs.setStringList(attendanceKey, attendanceData);

    // Debugging: Immediately retrieve the saved data and print
    List<String>? savedData = prefs.getStringList(attendanceKey);
    if (savedData != null) {
      print('Attendance saved successfully. Data: $savedData');
    } else {
      print('Failed to save attendance.');
    }
  }

  // Function to pick the date for attendance
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
                    value: students[index]['isPresent'] ==
                        true, // Ensure it's a bool
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
              if (currentDate != null) {
                _saveAttendance();
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBar(content: Text('Attendance saved')));
                Navigator.pop(context); // Return to previous page
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please select a date first')));
              }
            },
            child: Text('Save Attendance'),
          ),
        ],
      ),
    );
  }
}
