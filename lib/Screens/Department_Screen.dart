import 'package:attendanceapp/Databasehelpers/Departmenthelper.dart';
import 'package:attendanceapp/Moldels/Deartnebtmodel.dart';
import 'package:attendanceapp/Screens/AttendanceFolder/Attendance_Screen.dart';
import 'package:attendanceapp/Screens/Subjects_Screen.dart';
import 'package:attendanceapp/Screens/studentFolder/Students_Screen.dart';
import 'package:flutter/material.dart';

class Departmentpage extends StatefulWidget {
  final String departmentName;

  const Departmentpage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _DepartmentpageState createState() => _DepartmentpageState();
}

class _DepartmentpageState extends State<Departmentpage> {
  Department? department; // Initialize as null instead of using 'late'
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    fetchDepartment();
  }

  // Fetch department details from SQLite by name
  void fetchDepartment() async {
    Department? fetchedDepartment =
        await dbHelper.getDepartmentByName(widget.departmentName);
    setState(() {
      department = fetchedDepartment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departmentName} Department'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 80),
              const Text(
                'Choose what you want to see',
                style: TextStyle(fontSize: 25),
              ),
              const SizedBox(height: 50),
              if (department != null) ...[
                // Buttons and navigation
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Attendancepage(
                            departmentName: department!.name,
                          ),
                        ),
                      );
                    },
                    child: const Text('Attendance'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentPage(
                            departmentName: department!.name,
                          ),
                        ),
                      );
                    },
                    child: const Text('Students'),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SubjectsPage(
                            departmentName: department!.name,
                          ),
                        ),
                      );
                    },
                    child: const Text('Subjects'),
                  ),
                ),
              ] else
                const CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
