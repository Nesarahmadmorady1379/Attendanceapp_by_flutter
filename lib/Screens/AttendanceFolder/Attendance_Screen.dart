import 'package:flutter/material.dart';

class Attendancepage extends StatefulWidget {
  const Attendancepage({Key? key}) : super(key: key);

  @override
  _AttendancepageState createState() => _AttendancepageState();
}

class _AttendancepageState extends State<Attendancepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(),
    );
  }
}
