import 'package:attendanceapp/Databasehelpers/Studentdatabasehelper.dart';
import 'package:attendanceapp/Moldels/Studentmodel.dart';
import 'package:flutter/material.dart';

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

  // Variable to hold the selected semester
  String? selectedSemester;

  // List of semesters
  List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];

  List<Map<String, String>> newStudents = [];

  // Add a student to the temporary list
  void _addStudentLocally(String name, String id, String semester) {
    setState(() {
      newStudents.add({'name': name, 'id': id, 'semester': semester});
    });
    studentNameController.clear();
    studentIdController.clear();
    selectedSemester = null; // Reset the dropdown after adding a student
  }

  // Save all students to SQLite
  void _saveAllStudents() async {
    // Loop through the list of new students and insert each one into SQLite
    for (var student in newStudents) {
      Student newStudent = Student(
        name: student['name']!,
        studentId: student['id']!,
        semester: student['semester']!,
        department: widget.departmentName,
      );
      await DatabaseHelper().insertStudent(newStudent); // Insert into SQLite
    }

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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: studentNameController,
                decoration: InputDecoration(
                  label: Text('Student Name'),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                controller: studentIdController,
                decoration: InputDecoration(
                    label: Text('Student ID'),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: DropdownButtonFormField<String>(
                value: selectedSemester,
                decoration: InputDecoration(
                  labelText:
                      'Select Semester', // This behaves like a floating label
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
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (studentNameController.text.isNotEmpty &&
                    studentIdController.text.isNotEmpty &&
                    selectedSemester != null) {
                  _addStudentLocally(studentNameController.text,
                      studentIdController.text, selectedSemester!);
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
