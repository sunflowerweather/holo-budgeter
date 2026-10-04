import 'package:shared_preferences/shared_preferences.dart';

class DataPrefs {


  static Future<void> saveKeyDouble(double amnt, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(key, amnt);
  }

  static Future<double?> loadKeyDouble(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(key) ?? 0.0;
  }

  static Future<void> saveKeyString(String data, String key) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, data);
  }

  static Future<String?> loadKeyString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }




}