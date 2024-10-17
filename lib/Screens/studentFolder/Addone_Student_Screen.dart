import 'package:attendanceapp/Databasehelpers/Studentdatabasehelper.dart';
import 'package:attendanceapp/Moldels/Studentmodel.dart';
import 'package:flutter/material.dart';

class AddoneStudentPage extends StatefulWidget {
  final String departmentName;

  const AddoneStudentPage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _AddoneStudentPageState createState() => _AddoneStudentPageState();
}

class _AddoneStudentPageState extends State<AddoneStudentPage> {
  TextEditingController studentNameController = TextEditingController();
  TextEditingController studentIdController = TextEditingController();
  String? selectedSemester;
  List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];

  // Add a new student and save it to SQLite
  void _addStudent() async {
    if (studentNameController.text.isNotEmpty &&
        studentIdController.text.isNotEmpty &&
        selectedSemester != null) {
      Student newStudent = Student(
        name: studentNameController.text,
        studentId: studentIdController.text,
        semester: selectedSemester!,
        department: widget.departmentName,
      );
      await DatabaseHelper().insertStudent(newStudent);
      Navigator.pop(context, true); // Navigate back to StudentPage
    }
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
            TextField(
              controller: studentNameController,
              decoration: InputDecoration(
                label: Text('Student Name'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: studentIdController,
              decoration: InputDecoration(
                label: Text('Student ID'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
            ),
            SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: selectedSemester,
              decoration: InputDecoration(
                labelText: 'Select Semester',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
              ),
              items: semesters.map((String semester) {
                return DropdownMenuItem<String>(
                  value: semester,
                  child: Text(semester),
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedSemester = newValue;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addStudent,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
