import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GeneralSettingScreen extends StatefulWidget {
  @override
  _GeneralSettingScrennState createState() => _GeneralSettingScrennState();
}

class _GeneralSettingScrennState extends State<GeneralSettingScreen> {
  bool isDarkMode = false;
  double fontSize = 14;
  String language = 'English';

  _toggleDarkMode() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isDarkMode = !isDarkMode;
      prefs.setBool('darkMode', isDarkMode);
    });
  }

  _changeFontSize(double value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    fontSize = value;
    await prefs.setDouble('fontSize', fontSize);
    setState(() {});
  }

  _changeLanguage(String newLanguage) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    language = newLanguage;
    await prefs.setString('language', language);
    setState(() {});
  }

  _getCurrentDarkMode() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      bool? temp = pref.getBool("darkMode");
      isDarkMode = temp ?? false;
    });
  }

  _getCurrentFontSize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      double? temp = pref.getDouble("fontSize");
      fontSize = temp ?? 12;
    });
  }

  _getCurrentLangauage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      String? temp = pref.getString("language");
      language = temp ?? language;
    });
  }

  @override
  void initState() {
    _getCurrentDarkMode();
    _getCurrentFontSize();
    _getCurrentLangauage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('General Settings')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            SwitchListTile(
              title: Text('Dark Mode'),
              value: isDarkMode,
              onChanged: (value) async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                isDarkMode = !isDarkMode;
                await prefs.setBool('darkMode', isDarkMode);
                setState(() {
                  print(isDarkMode);
                });
              },
            ),
            ListTile(
              title: Text('Font Size'),
              subtitle: Slider(
                divisions: 3,
                value: fontSize,
                min: 12,
                max: 24,
                onChanged: (value) => _changeFontSize(value),
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
