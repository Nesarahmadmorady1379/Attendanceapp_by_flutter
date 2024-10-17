import 'package:attendanceapp/Databasehelpers/Departmenthelper.dart';
import 'package:attendanceapp/Moldels/Deartnebtmodel.dart';
import 'package:attendanceapp/Screens/Department_Screen.dart';
import 'package:flutter/material.dart';
// Import the Department model

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String Facultyname = '';
  List<Department> departments = [];
  DatabaseHelper dbHelper = DatabaseHelper(); // Instantiate the DatabaseHelper

  @override
  void initState() {
    super.initState();
    getFacultyname();
    getDepartments();
  }

  void getFacultyname() async {
    // Use SharedPreferences or keep it as is for faculty name.
  }

  // Get departments from SQLite
  void getDepartments() async {
    List<Department> fetchedDepartments = await dbHelper.getDepartments();
    setState(() {
      departments = fetchedDepartments;
    });
  }

  // Save new department in SQLite
  void saveDepartment(String departmentName) async {
    Department department = Department(name: departmentName);
    await dbHelper.insertDepartment(department);
    setState(() {
      departments.add(department);
    });
  }

  // Delete department in SQLite
  void deleteDepartment(int index) async {
    Department department = departments[index];
    await dbHelper.deleteDepartment(department.id!);
    setState(() {
      departments.removeAt(index);
    });
  }

  // Edit department in SQLite
  void editDepartment(int index, String newName) async {
    Department department = departments[index];
    department.name = newName;
    await dbHelper.updateDepartment(department);
    setState(() {
      departments[index] = department;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Home page',
            style: TextStyle(
              fontSize: 26,
              color: Colors.black,
            )),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Your existing button layout...
                ],
              ),
            ),
            SizedBox(height: 15),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text('$Facultyname  Faculty',
                    style: TextStyle(fontSize: 23)),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: departments.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Departmentpage(
                                departmentName: departments[index].name),
                          ),
                        );
                      },
                      title: Text(departments[index].name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showEditDialog(
                                  context, index, departments[index].name);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              deleteDepartment(index);
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showAddDepartmentDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void showAddDepartmentDialog(BuildContext context) {
    TextEditingController departmentController = TextEditingController();
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Department'),
          content: TextField(
            controller: departmentController,
            decoration: InputDecoration(
                label: Text('Enter department name'),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20)))),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (departmentController.text.isNotEmpty) {
                  saveDepartment(departmentController.text);
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

  void showEditDialog(BuildContext context, int index, String currentName) {
    TextEditingController departmentController =
        TextEditingController(text: currentName);
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Department'),
          content: TextField(
            controller: departmentController,
            decoration: InputDecoration(hintText: 'Enter department name'),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                if (departmentController.text.isNotEmpty) {
                  editDepartment(index, departmentController.text);
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
