import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http; //لارسال طلبات الى ال api
import 'dart:convert'; //مكتبة تتيح نحويل البيانات بين json وال map

class AuthService_Login {
  static const _storage = FlutterSecureStorage();
  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      // Uri.parse('http://192.168.214.174:8000/api/login'),
      Uri.parse('http://127.0.0.1:8000/api/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return {
        'token': data['access_token'],
        'role': data['role'],
        'contractorId': data['cotractor_id'],
        // ← أو اجلبه من الـ backend لو كان متاحًا
      };
    } else {
      return null;
    }
  }

  static Future<bool> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final url = Uri.parse('http://127.0.0.1:8000/api/register');
    // final url = Uri.parse('http://192.168.214.174:8000/api/register');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': password, // تأكيد كلمة المرور
        'phone': phone,
      }),
    );

    print('Register status: ${response.statusCode}');
    print('Register response: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final token = data['access_token'];
      print('Register Success, token: $token');
      return true;
    } else {
      return false;
    }
  }

  static Future<void> logout() async {
    final token = await _storage.read(key: 'token');

    if (token == null) return;

    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/logout'),
      // Uri.parse('http://192.168.214.174:8000/api/logout'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    print('Logout status: ${response.statusCode}');
    print('Logout response: ${response.body}');

    await _storage.delete(key: 'token'); // ← حذف التوكن
  }
}
// void handleLogin() async {
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();
//     if (email.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور')),
//       );
//       return;
//     }
//     final result = await AuthService_Login.login(email, password);

//     if (result != null) {
//       final token = result['token'];
//       final role = result['role'];

//       await TokenStorage.saveToken(token);
//       await TokenStorage.saveRole(role);
//       widget.switchScreenToTenders();
//       print('تم تسجيل الدخول، التوكن: $token');
//     } else {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('فشل تسجيل الدخول')));
//     }
//   }
