import 'package:attendanceapp/Providers/Fontsizeprovider.dart';
import 'package:attendanceapp/Providers/Theamnotifire.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingScreen extends ConsumerStatefulWidget {
  @override
  _GeneralSettingScrennState createState() => _GeneralSettingScrennState();
}

class _GeneralSettingScrennState extends ConsumerState<GeneralSettingScreen> {
  double fontSize = 14;
  String language = 'English';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    double savedFontSize = prefs.getDouble('fontSize') ?? 14;
    String savedLanguage = prefs.getString('language') ?? 'English';

    setState(() {
      fontSize = savedFontSize;
      language = savedLanguage;
    });
  }

  void _changeFontSize(double value) async {
    // ref.read(fontSizeProvider.notifier).setFontSize(value);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', value);
  }

  void _changeLanguage(String newLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      language = newLanguage;
    });
    await prefs.setString('language', language);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = ref.watch(themeProvider) == ThemeMode.dark;
    double fontSize = ref.watch(fontSizeProvider); // Watch the theme state

    return Scaffold(
      appBar: AppBar(title: Text('General Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkMode, // Use Riverpod state for dark mode
              onChanged: (value) {
                ref
                    .read(themeProvider.notifier)
                    .toggleTheme(); // Toggle theme using provider
              },
            ),
            ListTile(
              title: Text('Font Size'),
              subtitle: Slider(
                divisions: 3,
                value: fontSize,
                min: 12,
                max: 34,
                onChanged: (value) {
                  // Update font size using FontSizeNotifier provider
                  ref.read(fontSizeProvider.notifier).setFontSize(value);
                },
              ),
            ),
            ListTile(
              title: Text('Language'),
              subtitle: DropdownButton<String>(
                value: language,
                items: ['English', 'Spanish', 'French']
                    .map((lang) => DropdownMenuItem(
                          value: lang,
                          child: Text(lang),
                        ))
                    .toList(),
                onChanged: (value) => _changeLanguage(value!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
