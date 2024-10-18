import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart';
import 'package:attendanceapp/Moldels/Dalyattendancemodle.dart';
import 'package:flutter/material.dart';


class AddAttendancePage extends StatefulWidget {
  final int attendanceId; // Add attendance ID to link students

  const AddAttendancePage({Key? key, required this.attendanceId, required String departmentName}) : super(key: key);

  @override
  _AddAttendancePagePageState createState() => _AddAttendancePagePageState();
}

class _AddAttendancePagePageState extends State<AddAttendancePage> {
  final List<Dalyattendancemodle> students = [];
  final TextEditingController nameController = TextEditingController();
  final TextEditingController idController = TextEditingController();

  void _addStudent() {
    final String name = nameController.text.trim();
    final String studentId = idController.text.trim();

    if (name.isNotEmpty && studentId.isNotEmpty) {
      Dalyattendancemodle newStudent = Dalyattendancemodle(name: name, studentId: studentId, isPresent: false);
      setState(() {
        students.add(newStudent);
        nameController.clear();
        idController.clear();
      });
    }
  }

  void _saveStudents() async {
    DatabaseHelper dbHelper = DatabaseHelper();
    for (var student in students) {
      await dbHelper.insertStudent(student, widget.attendanceId);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Students added successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Students'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Student Name'),
            ),
            TextField(
              controller: idController,
              decoration: InputDecoration(labelText: 'Student ID'),
              keyboardType: TextInputType.number,
            ),
            ElevatedButton(
              onPressed: _addStudent,
              child: Text('Add Student'),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(students[index].name),
                    subtitle: Text('ID: ${students[index].studentId}'),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _saveStudents,
              child: Text('Save Students'),
            ),
          ],
        ),
      ),
    );
  }
}
