import 'package:attendanceapp/Databasehelpers/Attendancedatabasehelper.dart'
    as attendance_db;
import 'package:attendanceapp/Databasehelpers/Studentdatabasehelper.dart'
    as student_db;
import 'package:attendanceapp/Databasehelpers/Subjectdatabasehelper.dart'
    as subject_db;
import 'package:attendanceapp/Moldels/Attendancemodel.dart';
import 'package:attendanceapp/Moldels/Studentmodel.dart';
import 'package:attendanceapp/Moldels/Subjectmodel.dart';
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
  final _formKey = GlobalKey<FormState>();
  final attendanceDbHelper = attendance_db.DatabaseHelper();
  final subjectDbHelper = subject_db.DatabaseHelper();
  final studentDbHelper = student_db.DatabaseHelper();

  String? selectedSubject;
  String selectedSemester = '';
  String startDate = '';
  String endDate = '';
  List<String> semesters = ['1', '2', '3', '4', '5', '6', '7', '8'];
  List<Subject> subjects = [];
  List<Student> students = [];
  List<Student> filteredStudents = [];
  List<String> selectedStudentIds = []; // Track selected student IDs

  @override
  void initState() {
    super.initState();
    _loadSubjects();
    _loadStudents();
  }

  void _loadSubjects() async {
    List<Subject> loadedSubjects =
        await subjectDbHelper.getSubjects(widget.departmentName);
    setState(() {
      subjects = loadedSubjects;
    });
  }

  void _loadStudents() async {
    List<Student> loadedStudents =
        await studentDbHelper.getStudentsByDepartment(widget.departmentName);
    setState(() {
      students = loadedStudents;
      filteredStudents = loadedStudents; // Initialize filtered students
    });
  }

  void _filterStudentsBySemester() {
    filteredStudents = students
        .where((student) => student.semester == selectedSemester)
        .toList();
    setState(() {});
  }

  Future<void> _pickStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        startDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Attendance'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Subject Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Subject'),
                value: selectedSubject,
                items: subjects.isNotEmpty
                    ? subjects.map((subject) {
                        return DropdownMenuItem<String>(
                          value: subject.name,
                          child: Text(subject.name),
                        );
                      }).toList()
                    : null,
                onChanged: (value) {
                  setState(() {
                    selectedSubject = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a subject' : null,
              ),

              // Semester Dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(labelText: 'Select Semester'),
                value: selectedSemester.isNotEmpty ? selectedSemester : null,
                items: semesters.map((String semester) {
                  return DropdownMenuItem<String>(
                    value: semester,
                    child: Text(' $semester'),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSemester = value!;
                    _filterStudentsBySemester();
                  });
                },
                validator: (value) =>
                    value == null ? 'Please select a semester' : null,
              ),

              // Date Pickers
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'Start Date'),
                onTap: () => _pickStartDate(context),
                controller: TextEditingController(text: startDate),
                validator: (value) =>
                    value!.isEmpty ? 'Please select a start date' : null,
              ),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'End Date'),
                onTap: () => _pickEndDate(context),
                controller: TextEditingController(text: endDate),
                validator: (value) =>
                    value!.isEmpty ? 'Please select an end date' : null,
              ),

              // List of students
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                      child: Card(
                        child: ListTile(
                          title: Text('Name: ${student.name}'),
                          subtitle: Text(
                            'ID: ${student.studentId} | Semester: ${student.semester}',
                          ),
                          trailing: Checkbox(
                            value:
                                selectedStudentIds.contains(student.studentId),
                            onChanged: (bool? value) {
                              setState(() {
                                if (value == true) {
                                  selectedStudentIds.add(student.studentId);
                                } else {
                                  selectedStudentIds.remove(student.studentId);
                                }
                              });
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 20),

              // Save Attendance Button
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Attendance attendance = Attendance(
                      department: widget.departmentName,
                      semester: selectedSemester,
                      subject: selectedSubject!,
                      startDate: startDate,
                      endDate: endDate,
                      studentIds:
                          selectedStudentIds, // Save selected student IDs
                    );

                    await attendanceDbHelper.insertAttendance(attendance);
                    Navigator.pop(context, attendance);
                  }
                },
                child: Text('Save Attendance'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
