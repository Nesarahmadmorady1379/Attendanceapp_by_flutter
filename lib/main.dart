import 'package:attendanceapp/Screens/Hom_Screen.dart';
import 'package:attendanceapp/Screens/Splash_Screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();

  // Get the stored values or set defaults
  bool isDarkMode = prefs.getBool('darkMode') ?? false;
  double fontSize = prefs.getDouble('fontSize') ?? 14;

  runApp(MyApp(isDarkMode: isDarkMode, fontSize: fontSize));
}

class MyApp extends StatelessWidget {
  final bool isDarkMode;
  final double fontSize;

  const MyApp({Key? key, required this.isDarkMode, required this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode ? ThemeData.dark() : ThemeData.light(),
      routes: {
        '/': (context) => splashscreen(),
        '/home': (context) => Homepage(),
      },
    );
  }
}
