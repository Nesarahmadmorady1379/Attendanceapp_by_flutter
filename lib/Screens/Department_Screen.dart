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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departmentName} Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(children: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Attendancepage()));
              },
              child: Container(
                height: 200,
                width: 300,
                color: Colors.blueGrey,
                child: Center(child: Text('Attendance')),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Addingstudentpage()));
                },
                child: Text('Students')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => SubjectsPage()));
                },
                child: Text('Subjects'))
          ]),
        ),
      ),
    );
  }
}
