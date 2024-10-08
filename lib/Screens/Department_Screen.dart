import 'package:flutter/material.dart';

class Departmentpage extends StatefulWidget {
  const Departmentpage({Key? key}) : super(key: key);

  @override
  _DepartmentpageState createState() => _DepartmentpageState();
}

class _DepartmentpageState extends State<Departmentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Department page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(),
    );
  }
}
