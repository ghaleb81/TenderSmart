import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenkey = 'token';
  static const _rolekey = 'user_role';
  static const _contractorId = 'contractor_id';

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenkey, token);
  }

  static Future<void> saveRole(String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_rolekey, role);
  }

  static Future<void> saveContractorId(String contractorId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contractorId, contractorId);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenkey);
  }

  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_rolekey);
  }

  static Future<String?> getContractorId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_contractorId);
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenkey);
    await prefs.remove(_rolekey);
    await prefs.remove(_contractorId);
  }
}
