import 'dart:developer';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http; //لارسال طلبات الى ال api
import 'package:tendersmart/models/contractor.dart';
import 'dart:convert';

import 'package:tendersmart/services/token_storage.dart'; //مكتبة تتيح نحويل البيانات بين json وال map

class AuthService {
  static final ip = TokenStorage.getIp();
  static const _storage = FlutterSecureStorage();
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      // Uri.parse('http://192.168.214.174:8000/api/login'),
      Uri.parse('http://$ip:8000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    log('Response status: ${response.statusCode}');
    log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'token': data['access_token'],
        'role': data['role'],
        'user_id': data['user_id'],
        // ← أو اجلبه من الـ backend لو كان متاحًا
      };
    } else {
      return null;
    }
  }

  static Future<bool> register(Contractor contractor) async {
    // final url = Uri.parse('http://${ip}:8000/api/register');
    // final url = Uri.parse('http://192.168.214.174:8000/api/register');
    // print('IP being used: $ip');
    final response = await http.post(
      Uri.parse('http://$ip:8000/api/bids'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(
        contractor.toJsonRegister(),

        //   {
        // contractor.toJsonRegister(),
        //   "name": contractor.fullName,
        //   "email": contractor.email,
        //   "password": contractor.password,
        //   "password_confirmation": contractor.passwordConfirmation,
        //   "phone": contractor.phoneNumberForUser,
        // }
      ),
    );
    // print('IP being used: $ip');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      log('Register Success, token: $token');
      log('Register status: ${response.statusCode}');
      log('Register response: ${response.body}');

      return true;
    } else {
      log('Register status: ${response.statusCode}');
      log('Register response: ${response.body}');

      log('Error response: ${response.body}');
      return false;
    }
  }

  static Future<void> logout() async {
    final token = await _storage.read(key: 'token');

    if (token == null) return;

    final response = await http.post(
      Uri.parse('http://$ip:8000/api/logout'),
      // Uri.parse('http://192.168.214.174:8000/api/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    log('Logout status: ${response.statusCode}');
    log('Logout response: ${response.body}');

    await _storage.delete(key: 'token'); // ← حذف التوكن
  }
}
