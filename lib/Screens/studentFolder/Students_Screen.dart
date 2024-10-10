import 'package:flutter/material.dart';

class Addingstudentpage extends StatefulWidget {
  const Addingstudentpage({Key? key}) : super(key: key);

  @override
  _AddingstudentpageState createState() => _AddingstudentpageState();
}

class _AddingstudentpageState extends State<Addingstudentpage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Adding students'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(),
    );
  }
}
