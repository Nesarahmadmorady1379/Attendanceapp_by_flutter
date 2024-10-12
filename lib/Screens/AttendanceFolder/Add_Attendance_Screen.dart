import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddAttendancePage extends StatefulWidget {
  final String departmentName; // New parameter for department name

  const AddAttendancePage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _AddAttendancePageState createState() => _AddAttendancePageState();
}

class _AddAttendancePageState extends State<AddAttendancePage> {
  String? selectedDepartment;
  String? selectedSemester;
  String? selectedSubject;
  DateTime? startDate;
  DateTime? endDate;

  List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  List<String> subjects = [];
  List<Map<String, String>> allStudents = [];
  List<Map<String, String>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load department, subjects, and students from SharedPreferences
  void _loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      selectedDepartment =
          widget.departmentName; // Use the passed department name

      // Load subjects for the specific department
      String? subjectsString = prefs.getString('subjects_$selectedDepartment');
      if (subjectsString != null) {
        List<dynamic> decodedList = json.decode(subjectsString);
        subjects = decodedList.map<String>((item) {
          return item['name'];
        }).toList();
      }

      // Load students for the specific department
      String? studentsString = prefs.getString('students_$selectedDepartment');
      if (studentsString != null) {
        List<dynamic> decodedList = json.decode(studentsString);
        allStudents = decodedList.map<Map<String, String>>((item) {
          return Map<String, String>.from(item);
        }).toList();
      }
    });
  }

  // Filter students based on selected semester
  void _filterStudents() {
    setState(() {
      filteredStudents = allStudents.where((student) {
        return student['semester'] == selectedSemester;
      }).toList();
    });
  }

  // Save attendance for the filtered students to SharedPreferences
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
      'students': filteredStudents,
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

  // Function to pick start date
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

  // Function to pick end date
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
      appBar: AppBar(
        title: Text('Add Attendance for ${widget.departmentName}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for semester selection
            DropdownButtonFormField<String>(
              value: selectedSemester,
              hint: Text('Select Semester'),
              items: semesters.map((sem) {
                return DropdownMenuItem(value: sem, child: Text(sem));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSemester = value;
                  _filterStudents(); // Filter students when semester changes
                });
              },
            ),
            SizedBox(height: 10),

            // Dropdown for subject selection
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
            SizedBox(
              height: 5,
            ),
            // Date pickers for start and end date
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickStartDate,
                    child: Text(startDate == null
                        ? 'Select Start Date'
                        : DateFormat('yyyy-MM-dd')
                            .format(startDate!)), // Format the date here
                  ),
                ),
                SizedBox(width: 2),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _pickEndDate,
                    child: Text(endDate == null
                        ? 'Select End Date'
                        : DateFormat('yyyy-MM-dd').format(endDate!)),
                  ),
                ),
              ],
            ),

            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  var student = filteredStudents[index];
                  return ListTile(
                    title: Text(student['name']!),
                    subtitle: Text('ID: ${student['id']}'),
                  );
                },
              ),
            ),

            // Save attendance button
            ElevatedButton(
              onPressed: _saveAttendance,
              child: Text('Save Attendance'),
            ),
          ],
        ),
      ),
    );
  }
}
