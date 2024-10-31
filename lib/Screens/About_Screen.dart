import 'package:attendanceapp/Providers/Fontsizeprovider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class About_Screen extends ConsumerStatefulWidget {
  const About_Screen({Key? key}) : super(key: key);

  @override
  _About_ScreenState createState() => _About_ScreenState();
}

class _About_ScreenState extends ConsumerState<About_Screen> {
  @override
  Widget build(BuildContext context) {
    double Fontsize = ref.watch(fontSizeProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('About page'),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListView(
            children: [
              CircleAvatar(
                maxRadius: 100,
                backgroundColor: Colors
                    .transparent, // Optional: Set background color to transparent or any color
                child: ClipOval(
                  child: Image.asset(
                    'image/nsh1.jpg',
                    fit: BoxFit
                        .cover, // Ensures the image covers the circular area properly
                    width:
                        200, // Adjust these values based on the image size and CircleAvatar radius
                    height: 200,
                  ),
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text('Developer'),
              ),
              SizedBox(
                height: 3,
              ),
              Center(
                child: Text('Contect number : 0790 457 286'),
              ),
              SizedBox(
                height: 5,
              ),
              Center(
                child: Text('Email: nasarahmedmo12345@gmail.com'),
              ),
              SizedBox(
                height: 5,
              ),
              Column(
                crossAxisAlignment:
                    CrossAxisAlignment.center, // Centers the texts
                children: [
                  Text(
                    '''This app was developed by Nesarahmad "Morady", a graduate from 
      the Computer Science Faculty of Herat University, who learned Flutter 
      during an internship program at the WASSA organization, supported by 
      UNHCR and other donors. Special thanks to them for their support.''',
                    textAlign: TextAlign.justify, // Justifies the text
                    style: TextStyle(fontSize: Fontsize),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Center(
                    child: Text('Application'),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      '''This is an Attendance Management System developed for universities 
      and can be used in all faculties. It allows adding students not only 
      by typing them manually but also by importing CSV files. The app 
      provides a view page that shows a real attendance list, where absentees 
      have a cross mark in their cell and attendees have a checkmark. It also 
      counts the days students were absent or present and displays them in the 
      last two columns.''',
                      textAlign: TextAlign.justify, // Justifies the text
                      style: TextStyle(fontSize: Fontsize)),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
