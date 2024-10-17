import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart';
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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

  List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  List<String> subjects = [];
  List<Map<String, String>> allStudents = [];
  List<Map<String, String>> filteredStudents = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // Load data for subjects and students
  void _loadData() async {
    // Replace with your method to load subjects and students from sqflite
    // For demonstration, you can initialize subjects and students here.
    // Example:
    setState(() {
      subjects = ['Math', 'Physics', 'Chemistry']; // Sample subjects
      allStudents = [
        {'name': 'John Doe', 'id': '123', 'semester': '1'},
        {'name': 'Jane Smith', 'id': '124', 'semester': '1'}
      ]; // Sample students
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

  // Save attendance for the filtered students to SQLite
  void _saveAttendance() async {
    if (selectedSemester == null ||
        selectedSubject == null ||
        startDate == null ||
        endDate == null) {
      // If any required field is missing, show an error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('All fields (semester, subject, dates) are required'),
        ),
      );
      return;
    }

    // Create new attendance record
    Attendance newAttendance = Attendance(
      department: widget.departmentName,
      semester: selectedSemester!,
      subject: selectedSubject!,
      startDate: startDate!,
      endDate: endDate!,
      students: filteredStudents
          .map((student) => student['name']!)
          .toList(), // Convert names to list
    );

    // Save attendance in the database
    await DatabaseHelper().addAttendance(newAttendance);

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
              decoration: InputDecoration(
                labelText: 'Select Semester',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
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
              decoration: InputDecoration(
                labelText: 'Select Subject',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              items: subjects.map((subj) {
                return DropdownMenuItem(value: subj, child: Text(subj));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedSubject = value;
                });
              },
            ),
            SizedBox(height: 10),

            // Date pickers for start and end date
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _pickStartDate,
                  child: Text(startDate == null
                      ? 'Select Start Date'
                      : DateFormat('yyyy-MM-dd').format(startDate!)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _pickEndDate,
                  child: Text(endDate == null
                      ? 'Select End Date'
                      : DateFormat('yyyy-MM-dd').format(endDate!)),
                ),
              ],
            ),
            SizedBox(height: 20),

            // List of filtered students
            Expanded(
              child: ListView.builder(
                itemCount: filteredStudents.length,
                itemBuilder: (context, index) {
                  var student = filteredStudents[index];
                  return CheckboxListTile(
                    title: Text(student['name']!),
                    value: true, // You can manage checked state as needed
                    onChanged: (bool? value) {
                      // Handle check/uncheck here if needed
                    },
                  );
                },
              ),
            ),

            // Save button
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
