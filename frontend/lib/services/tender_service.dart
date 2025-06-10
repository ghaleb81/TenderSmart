import 'dart:developer';

import 'package:http/http.dart' as http;
import 'package:tendersmart/models/Tender.dart';
import 'dart:convert';
import 'package:tendersmart/services/token_storage.dart';

class TenderService {
  static final ip = TokenStorage.getIp();
  static Future<List<Tender>> fetchTenders() async {
    final response = await http.get(
      Uri.parse('http://$ip:8000/api/indexApi'),
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

  static Future<void> addTenders(Tender tender) async {
    final response = await http.post(
      Uri.parse('http://$ip:8000/api/storeTender'),
      // Uri.parse('http://192.168.214.174:8000/api/storeTender'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(tender.toJson()),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة المناقصة');
    }
    return;
  }

  static Future<void> deleteTenders(String id) async {
    final String baseUrl = 'http://$ip:8000/api/destroyTender/$id';
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
      Uri.parse('http://${ip}:8000/api/saved'),
      // Uri.parse('http://192.168.214.174:8000/api/indexApi'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> body = json['tenders'];
      return body.map((json) => Tender.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل المناقصات المحفوظة');
    }
  }
  // static Future<List<Tender>> fetchSavedTenders() async {
  //   final response = await http.get(Uri.parse('http://$ip:8000/api/saved'));
  //   log('${response.body}');
  //   if (response.statusCode == 200) {
  //     final data = jsonDecode(response.body) as List;
  //     return data.map((e) => Tender.fromJson(e)).toList();
  //   } else {
  //     throw Exception('فشل في تحميل المناقصات المحفوظة');
  //   }
  // }

  static Future<void> saveTenders(Tender tender) async {
    final userId = await TokenStorage.getUserrId();
    final response = await http.post(
      Uri.parse('http://$ip:8000/api/${tender.id}/save'),
      // Uri.parse('http://192.168.214.174:8000/api/storeTender'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          // 'id': tender.id,
          // 'title': tender.title,
          // 'description': tender.descripe,
          // 'location': tender.location,
          // 'execution_duration_days': tender.implementationPeriod,
          // 'technical_requirements_count': tender.numberOfTechnicalConditions,
          // 'submission_deadline': tender.registrationDeadline.toIso8601String(),
          // 'status': tender.stateOfTender.name,
          // // 'expectedStartTime': tender.expectedStartTime.toIso8601String(),
          // 'estimated_budget': tender.budget,
          'tender_id': tender.id.toString(),
          // 'user_id': userId,
        },
        // tender.toJson()
      ),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة المناقصة');
    }
    return;
  }

  static Future<void> cancellationTenders(String id) async {
    final String baseUrl = 'http://$ip:8000/api/$id/delete';
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
