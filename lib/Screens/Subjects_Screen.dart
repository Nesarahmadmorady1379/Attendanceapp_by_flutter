import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectsPage extends StatefulWidget {
  final String departmentName; // Added to hold the department name

  const SubjectsPage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<Map<String, String>> subjects = [];

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  // Load subjects from SharedPreferences for the specific department
  void _loadSubjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? subjectsString =
        prefs.getString('subjects_${widget.departmentName}');

    if (subjectsString != null) {
      try {
        List<dynamic> decodedList = json.decode(subjectsString);
        setState(() {
          subjects = decodedList.map<Map<String, String>>((item) {
            return Map<String, String>.from(item);
          }).toList();
        });
      } catch (e) {
        print('Error loading subjects: $e');
        setState(() {
          subjects = []; // Reset subjects to an empty list if there's an error
        });
      }
    }
  }

  // Save subjects to SharedPreferences for the specific department
  void _saveSubjects() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Save the subjects list after encoding it into JSON
    prefs.setString('subjects_${widget.departmentName}', json.encode(subjects));
  }

  // Adding a subject to the list
  void _addSubject(String name, String credit) {
    setState(() {
      subjects.add({'name': name, 'credit': credit});
      _saveSubjects(); // Save to SharedPreferences after adding
    });
  }

  // Editing a subject in the list
  void _editSubject(int index, String name, String credit) {
    setState(() {
      subjects[index] = {'name': name, 'credit': credit};
      _saveSubjects(); // Save to SharedPreferences after editing
    });
  }

  // Deleting a subject from the list
  void _deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
      _saveSubjects(); // Save to SharedPreferences after deleting
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departmentName} Subjects'),
        backgroundColor: Colors.blueAccent,
      ),
      body: ListView.builder(
        itemCount: subjects.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(subjects[index]['name']!),
              subtitle: Text('Credit: ${subjects[index]['credit']}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteSubject(index);
                },
              ),
              onTap: () {
                _showEditSubjectDialog(context, index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          _showAddSubjectDialog(context);
        },
      ),
    );
  }

  // Dialog for adding a new subject
  void _showAddSubjectDialog(BuildContext context) {
    TextEditingController subjectNameController = TextEditingController();
    TextEditingController subjectCreditController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectNameController,
                decoration: InputDecoration(hintText: 'Subject Name'),
              ),
              TextField(
                controller: subjectCreditController,
                decoration: InputDecoration(hintText: 'Subject Credit'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (subjectNameController.text.isNotEmpty &&
                    subjectCreditController.text.isNotEmpty) {
                  _addSubject(
                      subjectNameController.text, subjectCreditController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Dialog for editing an existing subject
  void _showEditSubjectDialog(BuildContext context, int index) {
    TextEditingController subjectNameController =
        TextEditingController(text: subjects[index]['name']);
    TextEditingController subjectCreditController =
        TextEditingController(text: subjects[index]['credit']);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Subject'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: subjectNameController,
                decoration: InputDecoration(hintText: 'Subject Name'),
              ),
              TextField(
                controller: subjectCreditController,
                decoration: InputDecoration(hintText: 'Subject Credit'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (subjectNameController.text.isNotEmpty &&
                    subjectCreditController.text.isNotEmpty) {
                  _editSubject(index, subjectNameController.text,
                      subjectCreditController.text);
                  Navigator.of(context).pop();
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
