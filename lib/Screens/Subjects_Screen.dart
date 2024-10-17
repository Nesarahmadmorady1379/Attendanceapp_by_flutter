import 'package:attendanceapp/Databasehelpers/Subjectdatabasehelper.dart';
import 'package:attendanceapp/Moldels/Subjectmodel.dart';
import 'package:flutter/material.dart';

class SubjectsPage extends StatefulWidget {
  final String departmentName;

  const SubjectsPage({Key? key, required this.departmentName})
      : super(key: key);

  @override
  _SubjectsPageState createState() => _SubjectsPageState();
}

class _SubjectsPageState extends State<SubjectsPage> {
  List<Subject> subjects = [];
  final DatabaseHelper dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadSubjects();
  }

  // Load subjects from SQLite for the specific department
  void _loadSubjects() async {
    List<Subject> loadedSubjects =
        await dbHelper.getSubjects(widget.departmentName);
    setState(() {
      subjects = loadedSubjects;
    });
  }

  // Save subject to SQLite
  void _addSubject(String name, String credit) async {
    Subject newSubject =
        Subject(department: widget.departmentName, name: name, credit: credit);
    await dbHelper.addSubject(newSubject);
    _loadSubjects(); // Reload subjects after adding
  }

  // Update subject in SQLite
  void _editSubject(int id, String name, String credit) async {
    Subject updatedSubject = Subject(
        id: id, department: widget.departmentName, name: name, credit: credit);
    await dbHelper.updateSubject(updatedSubject);
    _loadSubjects(); // Reload subjects after editing
  }

  // Delete subject from SQLite
  void _deleteSubject(int id) async {
    await dbHelper.deleteSubject(id);
    _loadSubjects(); // Reload subjects after deleting
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
              title: Text(subjects[index].name),
              subtitle: Text('Credit: ${subjects[index].credit}'),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  _deleteSubject(subjects[index].id!);
                },
              ),
              onTap: () {
                _showEditSubjectDialog(context, subjects[index].id!,
                    subjects[index].name, subjects[index].credit);
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
  void _showEditSubjectDialog(
      BuildContext context, int id, String name, String credit) {
    TextEditingController subjectNameController =
        TextEditingController(text: name);
    TextEditingController subjectCreditController =
        TextEditingController(text: credit);

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
                  _editSubject(id, subjectNameController.text,
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
