import 'dart:convert'; // مكتبة لتحويل البيانات من/إلى JSON
import 'dart:developer'; // مكتبة لتسجيل السجلات (Logs)
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // مكتبة لإجراء طلبات HTTP
import 'package:tendersmart/models/Bid.dart'; // استدعاء موديل العروض
import 'package:tendersmart/models/contractor.dart'; // استدعاء موديل المقاول
import 'package:tendersmart/services/token_storage.dart'; // استدعاء خدمة تخزين التوكن

class ContractorService {
  static final ip = TokenStorage.getIp();
  static Future<Contractor?> getContractorInfo() async {
    final userrId = await TokenStorage.getUserrId();
    final token = await TokenStorage.getToken();
    // final url = Uri.parse('http://$ip:8000/api/contractor/show/$userrId');

    final response = await http.get(
      Uri.parse('$ip/api/contractor/user/$userrId'),
      // Uri.parse('$ip/api/contractor/show/$userrId'),
      // Uri.parse('http://$ip:8000/api/contractor/show/$userrId'),
      // headers: {'Authorization': 'Bearer $token'},
      headers: {
        'Accept': 'application/json', // مهم جداً!
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    // log('Response body: ${response.body}');

    if (response.statusCode == 200) {
      log(response.body);
      // تحويل الرد من JSON إلى كائن Map
      final data = json.decode(response.body);
      // استخراج البيانات الخاصة بالمقاول من المفتاح "The Detail of Contractor:"
      final contractorData = data["The Detail of Contactor:"];
      log(contractorData);
      // التحقق إذا كانت البيانات موجودة
      if (contractorData != null) {
        log('Contractor Data: $contractorData');

        // تحويل البيانات إلى كائن Contractor وإرجاعه
        return Contractor.fromJsonCont(contractorData);
      } else {
        log('No contractor data found');
        return null; // لم توجد بيانات
      }
    } else if (response.statusCode == 404) {
      log(response.body);
      // إذا كانت حالة 404: لم توجد معلومات
      return null;
    } else {
      log('${response.body}');
      // أي حالة أخرى تعتبر فشل
      throw Exception('فشل في جلب بيانات المقاول');
    }
  }

  // static Future<List<Bid>> fetchContractorBids() async {
  //   final token = await TokenStorage.getToken();
  //   final url = Uri.parse('http://$ip:8000/api/contractor/bids');
  //   final response = await http.get(
  //     url,
  //     // headers: {
  //     //   'Authorization': 'Bearer $token'
  //     //   },
  //     headers: {
  //       'Accept': 'application/json', // مهم جداً!
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     // تحويل الرد من JSON إلى كائن Map
  //     final Map<String, dynamic> json = jsonDecode(response.body);

  //     // استخراج قائمة العروض من المفتاح 'bids'
  //     final List<dynamic> body = json['bid'] ?? [];

  //     // تحويل كل عرض إلى كائن Bid وإرجاع القائمة
  //     return body.map((json) => Bid.fromJson(json)).toList();
  //   } else {
  //     throw Exception('فشل في تحميل عروض المقاول');
  //   }
  // }
  static Future<List<Bid>> fetchContractorBids() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$ip/api/contractor/bids');
    // final url = Uri.parse('http://$ip:8000/api/contractor/bids');
    final response = await http.get(
      url,
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);

      // تحويل كل عنصر إلى كائن Bid
      return body.map((json) => Bid.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل عروض المقاول');
    }
  }

  // static Future<bool> saveContractorInfo(Contractor contractor) async {
  //   final token = await TokenStorage.getToken();
  //   // log('Token : $token');
  //   if (token == null) {
  //     log("لا يوجد توكن. تأكد من تسجيل الدخول أولاً.");
  //     return false;
  //   }
  //   // log("Sending contractor data: ${json.encode(contractor.toJsonCont())}");
  //   final response = await http.post(
  //     Uri.parse('$ip/api/contractor/store'),
  //     // Uri.parse('http://$ip:8000/api/contractor/store'),
  //     // headers: {
  //     //   'Content-Type': 'application/json',
  //     //   'Authorization': 'Bearer $token',
  //     // },
  //     headers: {
  //       'Accept': 'application/json', // مهم جداً!
  //       'Content-Type': 'application/json',
  //       'Authorization': 'Bearer $token',
  //     },
  //     body: json.encode(contractor.toJsonCont()),
  //   );
  //   // log(token);
  //   // log("Response body: ${response.body}");
  //   // log("Status code: ${response.statusCode}");

  //   if (response.statusCode == 200) {
  //     try {
  //       final data = jsonDecode(response.body);
  //       log("تم فك الرد بنجاح: $data");
  //     } catch (e) {
  //       log("الرد ليس JSON: $e");
  //     }
  //     return true;
  //   } else {
  //     log("فشل في حفظ بيانات المقاول");
  //     return false;
  //   }
  // }
  // static Future<bool> saveContractorInfo(Contractor contractor) async {
  //   final ip = TokenStorage.getIp();
  //   final token = await TokenStorage.getToken(); // التوكِن لتوثيق الطلب

  //   try {
  //     final response = await http.post(
  //       Uri.parse('$ip/api/contractor/store'), // عدِّل المسار إذا لزم
  //       headers: {
  //         'Accept': 'application/json',
  //         'Content-Type': 'application/json',
  //         'Authorization': 'Bearer $token', // مهم إذا كان المسار محميًّا
  //       },
  //       body: jsonEncode(contractor.toJsonCont()),
  //     );

  //     // اطبع كل ما قد يساعدك على التشخيص
  //     debugPrint('STATUS: ${response.statusCode}');
  //     debugPrint('BODY  : ${response.body}');

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       return true;
  //     }
  //     return false; // السيرفر أعاد 4xx أو 5xx
  //   } catch (e, st) {
  //     debugPrint('ERROR : $e');
  //     debugPrintStack(stackTrace: st);
  //     return false; // حدث استثناء في الاتصال
  //   }
  // }
  static Future<bool> saveContractorInfo(Contractor contractor) async {
    final ip = TokenStorage.getIp();
    final token = await TokenStorage.getToken();

    try {
      final body = jsonEncode(contractor.toJsonCont());

      debugPrint('SENDING TO: $ip/api/contractor/store');
      debugPrint('HEADERS: Authorization: Bearer $token');
      debugPrint('BODY: $body');

      final response = await http.post(
        Uri.parse('$ip/api/contractor/store'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: body,
      );

      debugPrint('STATUS: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      }

      return false;
    } catch (e, st) {
      debugPrint('ERROR WHILE SENDING CONTRACTOR DATA: $e');
      debugPrintStack(stackTrace: st);
      return false;
    }
  }

  static Future<Contractor?> fetchContractorByUserId(String userId) async {
    final ip = await TokenStorage.getIp(); // أو أي طريقة تجلب بها عنوان السيرفر
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$ip/api/contractor/user/$userId'),
      // Uri.parse('http://$ip:8000/api/contractor/user/$userId'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return Contractor.fromJsonCont(json['contractor']);
    } else {
      print('فشل في جلب بيانات المقاول: ${response.body}');
      return null;
    }
  }

  static Future<List<Contractor>> getContractors() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$ip/api/contractor/index'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      log(response.body);

      final Map<String, dynamic> jsonBody = json.decode(response.body);

      // تأكد من وجود المفتاح "Contractors"
      if (jsonBody.containsKey("Contractors")) {
        final List<dynamic> data = jsonBody["Contractors"];

        return data.map((e) => Contractor.fromJson(e)).toList();
      } else {
        throw Exception("البيانات لا تحتوي على مفتاح Contractors");
      }
    } else {
      log(response.body);
      throw Exception('فشل تحميل الموردين');
    }
  }
}
