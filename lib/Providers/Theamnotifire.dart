import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.light) {
    _loadTheme();
  }

  // Load theme mode from SharedPreferences
  Future<void> _loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDarkMode = prefs.getBool('darkMode') ?? false;
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // Toggle and save theme mode
  Future<void> toggleTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final isDarkMode = state == ThemeMode.light;
    state = isDarkMode ? ThemeMode.dark : ThemeMode.light;
    await prefs.setBool('darkMode', isDarkMode);
  }
}

// StateNotifierProvider exposes the ThemeNotifier
final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});
