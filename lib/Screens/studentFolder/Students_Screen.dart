import 'dart:io'; // For file handling

import 'package:attendanceapp/Databasehelpers/Studentdatabasehelper.dart';
import 'package:attendanceapp/Moldels/Studentmodel.dart';
import 'package:csv/csv.dart'; // For CSV parsing
import 'package:file_picker/file_picker.dart'; // For file picking
import 'package:flutter/material.dart';

import 'Addingmutiplestuden.dart';
import 'Addone_Student_Screen.dart';

class StudentPage extends StatefulWidget {
  final String departmentName;

  const StudentPage({Key? key, required this.departmentName}) : super(key: key);

  @override
  _StudentPageState createState() => _StudentPageState();
}

class _StudentPageState extends State<StudentPage> {
  List<Student> students = [];

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  // Load students from SQLite for the specific department
  void _loadStudents() async {
    List<Student> loadedStudents =
        await DatabaseHelper().getStudentsByDepartment(widget.departmentName);
    setState(() {
      students = loadedStudents;
    });
  }

  // Delete a student from the database and the list
  void _deleteStudent(int index) async {
    await DatabaseHelper().deleteStudent(students[index].id!); // Delete from DB
    setState(() {
      students.removeAt(index); // Remove from UI list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departmentName} Students'),
      ),
      body: students.isEmpty
          ? Center(child: Text('No students added yet'))
          : ListView.builder(
              itemCount: students.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Card(
                    child: ListTile(
                      title: Text('Name: ${students[index].name}'),
                      subtitle: Text(
                        'ID: ${students[index].studentId} | Semester: ${students[index].semester}',
                      ),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteStudent(index);
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddStudentOptions(context);
        },
      ),
    );
  }

  // Display options dialog for adding students
  void _showAddStudentOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Student'),
          content: Text('Choose how you want to add students:'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddoneStudentPage(
                        departmentName: widget.departmentName),
                  ),
                );
                if (result == true) {
                  _loadStudents(); // Reload the student list after returning
                }
              },
              child: Text('Add One Student'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close the dialog
                bool? result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddMultipleStudentsPage(
                        departmentName: widget.departmentName),
                  ),
                );
                if (result == true) {
                  _loadStudents(); // Reload the student list after returning
                }
              },
              child: Text('Add Multiple Students'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _importFromCSV(); // Call the CSV import function
              },
              child: Text('Import from CSV'),
            ),
          ],
        );
      },
    );
  }

  // Function to import students from a CSV file
  Future<void> _importFromCSV() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['csv'], // Limit to CSV files
    );

    if (result != null && result.files.single.path != null) {
      File file = File(result.files.single.path!);
      String fileContent = await file.readAsString();
      List<List<dynamic>> csvTable =
          const CsvToListConverter().convert(fileContent);

      // Assuming CSV format: First column for student name, second for student ID, third for semester
      List<Student> newStudents = [];
      for (var row in csvTable) {
        if (row.length >= 3) {
          // Ensure 3 columns are present
          String studentName = row[0].toString();
          String studentId = row[1].toString();
          String semester = row[2].toString();
          Student student = Student(
            name: studentName,
            studentId: studentId,
            semester: semester,
            department: widget.departmentName,
          );
          newStudents.add(student);
        }
      }

      // Insert new students into SQLite and reload the list
      for (var student in newStudents) {
        await DatabaseHelper().insertStudent(student);
      }

      setState(() {
        _loadStudents(); // Reload student list after inserting
      });
    }
  }
}
