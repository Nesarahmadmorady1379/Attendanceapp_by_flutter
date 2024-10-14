import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAttendancePage extends StatefulWidget {
  final String departmentName;

  const AddAttendancePage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _AddAttendancePageState createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  String? selectedSemester;
  String? selectedSubject;
  DateTime? startDate;
  DateTime? endDate;
  List<Map<String, dynamic>> filteredStudents = [];

  final List<String> semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3'
  ]; // Example semesters
  final List<String> subjects = [
    'Math',
    'Physics',
    'Chemistry'
  ]; // Example subjects

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedSemester,
              items: semesters.map((String semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text(semester),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value;
                });
              },
              decoration: InputDecoration(labelText: 'Select Semester'),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedSubject,
              items: subjects.map((String subject) {
                return DropdownMenuItem<String>(
                  value: subject,
                  child: Text(subject),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
              decoration: InputDecoration(labelText: 'Select Subject'),
            ),
            SizedBox(height: 16),
            ListTile(
              title: Text('Select Start Date'),
              subtitle: Text(startDate != null
                  ? DateFormat.yMMMd().format(startDate!)
                  : 'No date selected'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    startDate = pickedDate;
                  });
                }
              },
            ),
            ListTile(
              title: Text('Select End Date'),
              subtitle: Text(endDate != null
                  ? DateFormat.yMMMd().format(endDate!)
                  : 'No date selected'),
              onTap: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: endDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (pickedDate != null) {
                  setState(() {
                    endDate = pickedDate;
                  });
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedSemester != null &&
                    selectedSubject != null &&
                    startDate != null &&
                    endDate != null) {
                  _saveAttendance();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please fill all fields')),
                  );
                }
              },
              child: Text('Save Attendance'),
            ),
          ],
        ),
      ),
    );
  }

  void _saveAttendance() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key =
        'attendance_${widget.departmentName}'; // department-specific key

    // Get existing attendance data if any
    String? existingAttendanceString = prefs.getString(key);
    List<dynamic> existingAttendance = existingAttendanceString != null
        ? json.decode(existingAttendanceString)
        : [];

    // Create new attendance record
    Map<String, dynamic> newAttendance = {
      'department': widget.departmentName,
      'semester': selectedSemester,
      'subject': selectedSubject,
      'students': filteredStudents, // Assuming you have a way to add students
      'startDate': startDate!.toIso8601String(),
      'endDate': endDate!.toIso8601String(),
    };

    // Add new attendance record to existing records
    existingAttendance.add(newAttendance);

    // Save updated attendance back to SharedPreferences
    prefs.setString(key, json.encode(existingAttendance));

    // Navigate back with the new attendance record
    Navigator.pop(
        context, newAttendance); // Return the newly created attendance
  }
}
