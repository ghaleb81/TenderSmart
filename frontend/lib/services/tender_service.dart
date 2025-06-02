import 'package:http/http.dart' as http;
import 'package:tendersmart/models/Tender.dart';
import 'dart:convert';

class TenderService {
  static Future<List<Tender>> fetchTenders() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/indexApi'),
      // Uri.parse('http://192.168.214.174:8000/api/indexApi'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> body = json['tenders'];
      return body.map((json) => Tender.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }
  // static Future<List<Tender>> fetchTenders() async {
  //   final response = await http.get(
  //     Uri.parse('http://192.168.64.174:8000/api/indexApi'),
  //   );
  //   // print('Response: ${response.body}');
  //   if (response.statusCode == 200) {
  //     // List<dynamic> body = jsonDecode(response.body);
  //     // final Map<String, dynamic> json = jsonDecode(response.body);
  //     final List<dynamic> body = jsonDecode(response.body);
  //     // final List<dynamic> body = json['data'];

  //     return body.map((json) => Tender.fromJson(json)).toList();
  //   } else {
  //     throw Exception('فشل في تحميل البيانات');
  //   }
  // }

  static Future<void> addTenders(Tender tender) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/storeTender'),
      // Uri.parse('http://192.168.214.174:8000/api/storeTender'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        tender.toJson(),
        //   {
        //   'title': tender.title,
        //   'description': tender.descripe,
        //   'location': tender.location,
        //   'execution_duration_days': tender.implementationPeriod,
        //   'technical_requirements_count': tender.numberOfTechnicalConditions,
        //   'submission_deadline': tender.registrationDeadline.toIso8601String(),
        //   'status': tender.stateOfTender.name,
        //   // 'expectedStartTime': tender.expectedStartTime.toIso8601String(),
        //   'estimated_budget': tender.budget,
        // }
      ),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة المناقصة');
    }
    return;
  }

  static Future<void> deleteTenders(String id) async {
    final String baseUrl = 'http://127.0.0.1:8000/api/destroyTender/$id';
    // final String baseUrl = 'http://192.168.214.174:8000/api/destroyTender/$id';
    // final url = "$baseUrl/$tender";
    try {
      final response = await http
          .delete(Uri.parse(baseUrl))
          .timeout(Duration(seconds: 5));
      if (response.statusCode != 200) {
        print('حالة الرد : ${response.statusCode}');
        print('الرد : ${response.body}');
        throw Exception('فشل في حذف المناقصة');
      }
    } catch (e) {
      print('خطأ أثناء حذف المناقصة :$e');
    }
    return;
  }

  static Future<List<Tender>> fetchSavedTenders() async {
    final response = await http.get(
      Uri.parse('http://127.0.0.1:8000/api/saved'),
      // Uri.parse('http://192.168.214.174:8000/api/indexApi'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> body = json['tenders'];
      return body.map((json) => Tender.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }

  static Future<void> saveTenders(Tender tender, String id) async {
    final response = await http.post(
      Uri.parse('http://127.0.0.1:8000/api/$id/save'),
      // Uri.parse('http://192.168.214.174:8000/api/storeTender'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tender.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة المناقصة');
    }
    return;
  }

  static Future<void> cancellationTenders(String id) async {
    final String baseUrl = 'http://127.0.0.1:8000/api/$id/delete';
    // final String baseUrl = 'http://192.168.214.174:8000/api/destroyTender/$id';
    // final url = "$baseUrl/$tender";
    try {
      final response = await http
          .delete(Uri.parse(baseUrl))
          .timeout(Duration(seconds: 5));
      if (response.statusCode != 200) {
        print('حالة الرد : ${response.statusCode}');
        print('الرد : ${response.body}');
        throw Exception('فشل في حذف المناقصة');
      }
    } catch (e) {
      print('خطأ أثناء حذف المناقصة :$e');
    }
    return;
  }
}
