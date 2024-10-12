import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAttendancePage extends StatefulWidget {
  @override
  _AddAttendancePageState createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  String? selectedDepartment;
  String? selectedSemester;
  String? selectedSubject;
  DateTime? startDate;
  DateTime? endDate;

  List<String> departments = []; // Load from SharedPreferences
  List<String> semesters = []; // Load from SharedPreferences
  List<String> subjects = []; // Load from SharedPreferences
  List<Map<String, String>> students = []; // Filtered students

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      departments = prefs.getStringList('departments') ?? [];
      semesters = prefs.getStringList('semesters') ?? [];
      // Ensure that the decoded data is correctly cast to String
      subjects = prefs
              .getStringList('subjects')
              ?.map((e) =>
                  (jsonDecode(e) as Map<String, dynamic>)['name'] as String)
              .toList() ??
          [];
    });
  }

  void _pickStartDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        startDate = date;
      });
    }
  }

  void _pickEndDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) {
      setState(() {
        endDate = date;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Attendance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              value: selectedDepartment,
              hint: Text('Select Department'),
              items: departments.map((dept) {
                return DropdownMenuItem(value: dept, child: Text(dept));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedDepartment = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedSemester,
              hint: Text('Select Semester'),
              items: semesters.map((sem) {
                return DropdownMenuItem(value: sem, child: Text(sem));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value;
                });
              },
            ),
            DropdownButtonFormField<String>(
              value: selectedSubject,
              hint: Text('Select Subject'),
              items: subjects.map((subj) {
                return DropdownMenuItem(value: subj, child: Text(subj));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),
            ElevatedButton(
              onPressed: _pickStartDate,
              child: Text(startDate == null
                  ? 'Select Start Date'
                  : startDate!.toString()),
            ),
            ElevatedButton(
              onPressed: _pickEndDate,
              child: Text(
                  endDate == null ? 'Select End Date' : endDate!.toString()),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Save the attendance record
              },
              child: Text('Save Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
