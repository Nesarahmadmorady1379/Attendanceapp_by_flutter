import 'package:attendanceapp/Providers/Theamnotifire.dart';
import 'package:attendanceapp/Screens/Hom_Screen.dart';
import 'package:attendanceapp/Screens/Splash_Screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      title: 'Attendance App',
      theme: ThemeData.light(), // Light theme
      darkTheme: ThemeData.dark(), // Dark theme
      themeMode: themeMode, // Use theme mode from provider
      routes: {
        '/': (context) => splashscreen(),
        '/home': (context) => Homepage(),
      }, // Your home page
    );
  }
}
