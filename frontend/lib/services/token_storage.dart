import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenkey = 'token';
  static const _rolekey = 'user_role';
  static const _userrId = 'user_id';
  static const String _ipAddress = '127.0.0.1';
  // static const String _ipAddress = '192.168.43.104';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenkey, token);
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rolekey, role);
  }

  static Future<void> saveUserrId(String userrId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userrId, userrId);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenkey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rolekey);
  }

  static Future<String?> getUserrId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userrId);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenkey);
    await prefs.remove(_rolekey);
    await prefs.remove(_userrId);
  }

  static String getIp() {
    return _ipAddress;
  }
}
