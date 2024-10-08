import 'package:flutter/material.dart';

class About_Screen extends StatefulWidget {
  const About_Screen({Key? key}) : super(key: key);

  @override
  _About_ScreenState createState() => _About_ScreenState();
}

class _About_ScreenState extends State<About_Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About app page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(padding: EdgeInsets.all(10)),
    );
  }
}
