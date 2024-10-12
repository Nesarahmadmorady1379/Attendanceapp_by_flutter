import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddoneStudentPage extends StatefulWidget {
  final String departmentName;

  const AddoneStudentPage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _AddStudentPageState createState() => _AddStudentPageState();
}

class _AddStudentPageState extends State<AddoneStudentPage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  TextEditingController studentSemesterController = TextEditingController();

  // Add a new student and save it to SharedPreferences
  void _addStudent(String name, String id, String semester) async {
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

    students.add({'name': name, 'id': id, 'semester': semester});
    prefs.setString('students_${widget.departmentName}', json.encode(students));
    Navigator.pop(context, true); // Navigate back to StudentPage
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add One Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                  _addStudent(studentNameController.text,
                      studentIdController.text, studentSemesterController.text);
                }
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
