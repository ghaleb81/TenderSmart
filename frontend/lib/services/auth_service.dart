import 'package:http/http.dart' as http; //لارسال طلبات الى ال api
import 'dart:convert'; //مكتبة تتيح نحويل البيانات بين json وال map

class AuthService {
  static const baseUrl =
      'http://yourdomain.com/api'; //رابط السيرفر على اللارافيل

  static Future<Map<String, dynamic>?> login(
    String email,
    String password,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      //رد السيرفر بنجاح
      final data = json.decode(
        response.body,
      ); //يحول نص الرد الى كائن map باستخدام json
      return {'token': data['token'], 'role': data['user']['role']};
    } else {
      return null;
    }
  }

  // static Future<void> logout(String token) async {
  //   await http.post(
  //     Uri.parse('$baseUrl/logout'),
  //     headers: {'Authorization': 'Bearer $token'},
  //   );
  // }

  // static Future<bool> register(
  //   String name,
  //   String email,
  //   String password,
  // ) async {
  //   final response = await http.post(
  //     Uri.parse('$baseUrl/register'),
  //     body: {
  //       'name': name,
  //       'email': email,
  //       'password': password,
  //       'password_confirmation': password,
  //     },
  //   );

  //   return response.statusCode == 201;
  // }
}
