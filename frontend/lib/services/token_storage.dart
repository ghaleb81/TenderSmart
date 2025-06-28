import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  static const _tokenkey = 'token';
  static const _rolekey = 'user_role';
  static const _userrId = 'user_id';
  static const _deviceTokenKey = 'device_token'; // ← 🔹 مفتاح جديد
  // static const String _ipAddress = '10.0.2.2';
  // static const String _ipAddress = '192.168.1.107';
  static const String _ipAddress = 'https://637c-169-150-218-56.ngrok-free.app';

  // حفظ توكن الدخول
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
    await prefs.remove(_deviceTokenKey); // ← إزالة device token أيضًا
  }

  static String getIp() {
    return _ipAddress;
  }

  // 🔐 حفظ device token
  static Future<void> saveDeviceToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_deviceTokenKey, token);
  }

  // 🔓 استرجاع device token
  static Future<String?> getDeviceToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_deviceTokenKey);
  }
}
