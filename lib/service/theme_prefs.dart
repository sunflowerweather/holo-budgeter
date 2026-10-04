import 'package:shared_preferences/shared_preferences.dart';

class ThemePrefs {
  static const String _key = "selected_theme_id";

  static Future<void> saveThemeId(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, id);
  }

  static Future<int?> loadThemeId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_key);
  }
}