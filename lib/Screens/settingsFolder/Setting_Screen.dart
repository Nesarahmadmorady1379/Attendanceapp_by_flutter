import 'package:attendanceapp/Screens/settingsFolder/General_Setting_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Settingpage extends StatefulWidget {
  const Settingpage({Key? key}) : super(key: key);

  @override
  _SettingpageState createState() => _SettingpageState();
}

class _SettingpageState extends State<Settingpage> {
  TextEditingController f_namecontrolar = TextEditingController();
  TextEditingController f_locationcontrolar = TextEditingController();
  TextEditingController t_namecontrolar = TextEditingController();
  TextEditingController t_lastnamecontrolar = TextEditingController();
  TextEditingController t_jobcontrolar = TextEditingController();
  TextEditingController t_ScienceRankingcontrolar = TextEditingController();
//init state method
  @override
  void initState() {
    super.initState();
    load_Faculty_information();
    Load_Teacher_Information();
  }

  //save method for faculty information
  void save_Faculty_information() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = f_namecontrolar.text;
    String location = f_locationcontrolar.text;
    if (name.isEmpty || location.isEmpty) {
      showError_dialog('All the fields are required');
    } else {
      await prefs.setString('facultyName', f_namecontrolar.text);
      await prefs.setString('facultyLocation', f_locationcontrolar.text);
      f_namecontrolar.clear();
      f_locationcontrolar.clear();
    }
  }

//Save method for teacher information
  void Save_Teacher_information() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = t_namecontrolar.text;
    String lastname = t_lastnamecontrolar.text;
    String job = t_jobcontrolar.text;
    String sienceranking = t_ScienceRankingcontrolar.text;
    if (name.isEmpty ||
        lastname.isEmpty ||
        job.isEmpty ||
        sienceranking.isEmpty) {
      showError_dialog('All fields are required');
    } else {
      await prefs.setString('teacherName', t_namecontrolar.text);
      await prefs.setString('teacherLastName', t_lastnamecontrolar.text);
      await prefs.setString('teacherJob', t_jobcontrolar.text);
      await prefs.setString('teacherRanking', t_ScienceRankingcontrolar.text);
      t_namecontrolar.clear();
      t_lastnamecontrolar.clear();
      t_jobcontrolar.clear();
      t_ScienceRankingcontrolar.clear();
    }
  }

//load faculty information
  void load_Faculty_information() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      f_namecontrolar.text = prefs.getString('facultyName') ?? '';
      f_locationcontrolar.text = prefs.getString('facultyLocation') ?? '';
    });
  }

//load teacher information
  void Load_Teacher_Information() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      t_namecontrolar.text = prefs.getString('teacherName') ?? '';
      t_lastnamecontrolar.text = prefs.getString('teacherLastName') ?? '';
      t_jobcontrolar.text = prefs.getString('teacherJob') ?? '';
      t_ScienceRankingcontrolar.text = prefs.getString('teacherRanking') ?? '';
    });
  }

// error dialog method for textfields
  void showError_dialog(String messege) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(messege),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK')),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ListView(
          children: [
            //faculty information
            Card(
              child: Center(
                child: Text('Faculty information'),
              ),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: f_namecontrolar,
              decoration: InputDecoration(label: Text('Enter faculty name')),
            ),
            SizedBox(
              height: 5,
            ),
            TextField(
              controller: f_locationcontrolar,
              decoration:
                  InputDecoration(label: Text('Enter faculty location')),
            ),
            ElevatedButton(
                onPressed: () {
                  save_Faculty_information();
                },
                child: Text('Save faculty information')),
            SizedBox(
              height: 10,
            ),
            //Teacher information
            Card(
              child: Center(
                child: Text('Teacher infromation'),
              ),
            ),
            TextField(
              controller: t_namecontrolar,
              decoration: InputDecoration(label: Text('Enter teacher name')),
            ),
            TextField(
              controller: t_lastnamecontrolar,
              decoration:
                  InputDecoration(label: Text('Enter teacher last name')),
            ),
            TextField(
              controller: t_jobcontrolar,
              decoration: InputDecoration(label: Text('Enter teacher job')),
            ),
            TextField(
              controller: t_ScienceRankingcontrolar,
              decoration:
                  InputDecoration(label: Text('Enter teacher science ranking')),
            ),
            ElevatedButton(
                onPressed: () {
                  Save_Teacher_information();
                },
                child: Text('Save teacher information')),
            SizedBox(
              height: 20,
            ),
            //botton to navigat to general settings
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => GeneralSettingScreen()));
                },
                child: Text('General settings')),
          ],
        ),
      ),
    );
  }
}
