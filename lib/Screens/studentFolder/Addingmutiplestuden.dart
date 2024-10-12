import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddMultipleStudentsPage extends StatefulWidget {
  final String departmentName;

  const AddMultipleStudentsPage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _AddMultipleStudentsPageState createState() =>
      _AddMultipleStudentsPageState();
}

class _AddMultipleStudentsPageState extends State<AddMultipleStudentsPage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController studentSemesterController = TextEditingController();
  List<Map<String, String>> newStudents = [];

  // Add a student to the temporary list
  void _addStudentLocally(String name, String id, String semester) {
    setState(() {
      newStudents.add({'name': name, 'id': id, 'semester': semester});
    });
    studentNameController.clear();
    studentIdController.clear();
    studentSemesterController.clear();
  }

  // Save all students to SharedPreferences
  void _saveAllStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? studentsString =
        prefs.getString('students_${widget.departmentName}');
    List<Map<String, String>> students = [];

    if (studentsString != null) {
      List<dynamic> decodedList = json.decode(studentsString);
      students = decodedList.map<Map<String, String>>((item) {
        return Map<String, String>.from(item);
      }).toList();
    }

    students.addAll(newStudents);
    prefs.setString('students_${widget.departmentName}', json.encode(students));
    Navigator.pop(context, true); // Navigate back to StudentPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Multiple Students'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            Card(
              child: TextField(
                controller: studentNameController,
                decoration: InputDecoration(hintText: 'Student Name'),
              ),
            ),
            Card(
              child: TextField(
                controller: studentIdController,
                decoration: InputDecoration(hintText: 'Student ID'),
              ),
            ),
            Card(
              child: TextField(
                controller: studentSemesterController,
                decoration: InputDecoration(hintText: 'Student Semester'),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (studentNameController.text.isNotEmpty &&
                    studentIdController.text.isNotEmpty &&
                    studentSemesterController.text.isNotEmpty) {
                  _addStudentLocally(studentNameController.text,
                      studentIdController.text, studentSemesterController.text);
                }
              },
              child: Text('Add Another'),
            ),
            SizedBox(height: 10),
            Text('Temporary Added Students:'),
            for (var student in newStudents)
              Card(
                child: ListTile(
                  title: Text(student['name']!),
                  subtitle: Text(student['id']!),
                ),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAllStudents,
              child: Text('Save All'),
            ),
          ],
        ),
      ),
    );
  }
}
