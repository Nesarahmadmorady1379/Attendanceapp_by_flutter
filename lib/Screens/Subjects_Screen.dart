import 'package:flutter/material.dart';

class SubjectsPage extends StatefulWidget {
  const SubjectsPage({Key? key}) : super(key: key);

  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<Map<String, String>> subjects = [];

  // Adding subject to the list
  void _addSubject(String name, String credit) {
    setState(() {
      subjects.add({'name': name, 'credit': credit});
    });
  }

  // Editing subject in the list
  void _editSubject(int index, String name, String credit) {
    setState(() {
      subjects[index] = {'name': name, 'credit': credit};
    });
  }

  // Deleting subject from the list
  void _deleteSubject(int index) {
    setState(() {
      subjects.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subjects Page'),
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
              // When the ListTile is tapped, open the dialog to edit the subject
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
