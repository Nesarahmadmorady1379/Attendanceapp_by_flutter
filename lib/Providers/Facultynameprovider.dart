import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Facultynameprovider extends StateNotifier<String> {
  Facultynameprovider() : super('No ') {
    loadFacultyname();
  }

  Future<void> loadFacultyname() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedfacultyname = prefs.getString('facultyName') ?? 'No';
    state = savedfacultyname;
  }

  Future<void> setFacultyname(String newFacultyname) async {
    state = newFacultyname;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('facultyName', newFacultyname);
  }
}

final facultynameprovider =
    StateNotifierProvider<Facultynameprovider, String>((ref) {
  return Facultynameprovider();
});
