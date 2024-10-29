import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FontSizeNotifier extends StateNotifier<double> {
  FontSizeNotifier() : super(14.0) {
    // Initial font size set to 14.0
    _loadFontSize();
  }

  // Load font size from SharedPreferences
  Future<void> _loadFontSize() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final savedFontSize = prefs.getDouble('fontSize') ?? 14.0;
    state = savedFontSize;
  }

  // Set a new font size and save it to SharedPreferences
  Future<void> setFontSize(double newSize) async {
    state = newSize;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('fontSize', newSize);
  }
}

// Provider for the font size
final fontSizeProvider = StateNotifierProvider<FontSizeNotifier, double>((ref) {
  return FontSizeNotifier();
});
