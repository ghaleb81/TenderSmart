import 'dart:developer';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/token_storage.dart';

class AuthService {
  static const _storage = FlutterSecureStorage();
  static final ip = TokenStorage.getIp();
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    try {
      final response = await http.post(
        Uri.parse('$ip/api/login'), // غيّره حسب الحاجة
        // Uri.parse('http://192.168.1.107:8000/api/login'), // غيّره حسب الحاجة
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'email': email, 'password': password}),
      );

      log('Login Response status: ${response.statusCode}');
      log('Login Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return {
          'token': data['access_token'],
          'role': data['role'],
          'user_id': data['user_id'],
        };
      } else {
        return null;
      }
    } catch (e) {
      log('Login Request failed: $e');
      return null;
    }
  }

  static Future<bool> register(Contractor contractor) async {
    final ip = TokenStorage.getIp();

    if (ip == null || ip.isEmpty) {
      log('Register Error: IP address is null or empty');
      return false;
    }

    try {
      final response = await http.post(
        Uri.parse('$ip/api/register'),
        // Uri.parse('http://$ip:8000/api/register'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(contractor.toJsonRegister()),
      );

      log('Register Response status: ${response.statusCode}');
      log('Register Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['access_token'];
        log('Register Success, token: $token');
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log('Register Request failed: $e');
      return false;
    }
  }

  static Future<void> logout() async {
    final ip = TokenStorage.getIp();

    if (ip == null || ip.isEmpty) {
      log('Logout Error: IP address is null or empty');
      return;
    }

    final token = await _storage.read(key: 'token');
    if (token == null) {
      log('Logout Error: No token found');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('$ip/api/logout'),
        // Uri.parse('http://$ip:8000/api/logout'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log('Logout Response status: ${response.statusCode}');
      log('Logout Response body: ${response.body}');

      await _storage.delete(key: 'token');
    } catch (e) {
      log('Logout Request failed: $e');
    }
  }
}
