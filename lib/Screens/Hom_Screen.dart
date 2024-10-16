import 'package:attendanceapp/Screens/About_Screen.dart';
import 'package:attendanceapp/Screens/Department_Screen.dart';
import 'package:attendanceapp/Screens/settingsFolder/Setting_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  String Facultyname = '';
  List<String> departments = [];
  @override
  void initState() {
    super.initState();
    getFacultyname();
    getDepartments();
  }

//get faculty name method
  void getFacultyname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      Facultyname = prefs.getString('facultyName') ?? '';
    });
  }

  //get department method from shared preferances
  void getDepartments() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      departments = prefs.getStringList('departments') ?? [];
    });
  }

  //save new department by using shared preferences
  void saveDepartment(String department) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      departments.add(department);
      prefs.setStringList('departments', departments);
    });
  }

  //delete department by using shared preferences
  void deleteDepartment(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      departments.removeAt(index);
      prefs.setStringList('departments', departments);
    });
  }

  //edit department by using shared preferences
  void editDepartment(int index, String newName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      departments[index] = newName;
      prefs.setStringList('departments', departments);
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
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Settingpage()));
                            },
                            icon: Icon(
                              color: Colors.blueAccent,
                              Icons.settings,
                              size: 50,
                            )),
                        Text(
                          'settings',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              color: Colors.blueAccent,
                              Icons.share,
                              size: 50,
                            )),
                        Text(
                          'share',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {},
                            icon: Icon(
                              color: Colors.blueAccent,
                              Icons.email,
                              size: 50,
                            )),
                        Text(
                          'email',
                          style: TextStyle(color: Colors.black),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                    width: 80,
                    decoration: BoxDecoration(
                        border: Border.all(width: 2),
                        borderRadius: BorderRadius.circular(15)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => About_Screen()));
                            },
                            icon: Icon(
                              color: Colors.blueAccent,
                              Icons.person,
                              size: 50,
                            )),
                        Text(
                          'about',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '$Facultyname  Faculty',
                  style: TextStyle(fontSize: 23),
                ),
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
                                departmentName: departments[index]),
                          ),
                        );
                      },
                      title: Text(departments[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              showEditDialog(
                                  context, index, departments[index]);
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
