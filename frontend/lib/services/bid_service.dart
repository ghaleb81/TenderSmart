import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'dart:convert';
import 'package:tendersmart/services/token_storage.dart';
import 'package:http_parser/http_parser.dart';

class BidService {
  static final ip = TokenStorage.getIp();
  static String baseUrl = 'http://$ip:8000'; // عدّله حسب جهازك

  static Future<List<Bid>> fetchBids(int tenderId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$ip/api/bid/show/$tenderId');

    final response = await http.get(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      log(data.toString());

      // تحقق أن المفتاح موجود وأنه List
      final bidsJson = data['the bids'];
      if (bidsJson == null || bidsJson is! List) {
        // إذا لم توجد بيانات أو غير قائمة، أرجع قائمة فارغة
        return [];
      }

      return bidsJson.map((json) => Bid.fromJson(json)).toList();
    } else {
      throw Exception('فشل في جلب العروض (${response.statusCode})');
    }
  }

  // static Future<List<Bid>> fetchBids(int id) async {
  //   final token = await TokenStorage.getToken();
  //   final response = await http.get(
  //     Uri.parse('http://$ip:8000/api/bids/$id/result'),
  //     headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
  //   );

  //   if (response.statusCode == 200) {
  //     final List<dynamic> body = jsonDecode(response.body);
  //     log('$body');
  //     return body.map((json) => Bid.fromJson(json)).toList();
  //   } else {
  //     log('Status Code: ${response.statusCode}');
  //     log('Response Body: ${response.body}');
  //     throw Exception('فشل في تحميل البيانات');
  //   }
  // }

  static Future<List<Bid>> fetchPreviousBids() async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$ip/api/contractor/bids');
    // final url = Uri.parse('http://$ip:8000/api/contractor/bids');

    final response = await http.get(
      url,
      // headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      log('Contractor Data: $body');
      return body.map((json) => Bid.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      throw Exception('لا يوجد لديك حساب مقاول');
    } else {
      throw Exception('فشل في تحميل العروض السابقة');
    }
  }

  static Future<void> chooseWinner(int bidId, int tenderId) async {
    final token = await TokenStorage.getToken();
    final url = Uri.parse('$ip/api/Tender/$tenderId/winner');

    final response = await http.post(
      url,
      headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
      body: jsonEncode({'bid_id': bidId}),
    );

    if (response.statusCode != 200) {
      throw Exception('فشل في اختيار الفائز');
    }
  }
  // static Future<void> addBid(
  //   Bid bid, {
  //   File? technicalFile,
  //   String? technicalFileName,
  // }) async {
  //   final token = await TokenStorage.getToken();
  //   final uri = Uri.parse('$ip/api/bid/store');
  //   // final uri = Uri.parse('http://$ip:8000/api/bid/store');
  //   final request = http.MultipartRequest('POST', uri);

  //   // إعداد التوكن
  //   request.headers['Authorization'] = 'Bearer $token';
  //   request.headers['Accept'] = 'application/json';

  //   // تعبئة الحقول النصية من الـ bid
  //   bid.toJson().forEach((key, value) {
  //     request.fields[key] = value.toString();
  //   });

  //   // إرسال ملف PDF إن وُجد
  //   if (technicalFile != null && technicalFileName != null) {
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'technical_proposal_pdf', // ← يجب أن يتطابق مع اسم الحقل في الباك
  //         technicalFile.path,
  //         filename: technicalFileName,
  //         contentType: MediaType('application', 'pdf'),
  //       ),
  //     );
  //   }

  //   // إرسال الطلب
  //   final response = await request.send();

  //   // التحقق من حالة الاستجابة
  //   if (response.statusCode != 200 && response.statusCode != 201) {
  //     final respStr = await response.stream.bytesToString();
  //     throw Exception('فشل في رفع العرض: $respStr');
  //   }
  // }
  static Future<bool> addBid(
    Bid bid, {
    File? technicalFile,
    String? technicalFileName,
  }) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$ip/api/bid/store');
    final request = http.MultipartRequest('POST', uri)
      ..headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

    // حقول العرض
    bid.toJson().forEach((k, v) => request.fields[k] = v.toString());

    // ملف PDF إن وجد
    if (technicalFile != null && technicalFileName != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'technical_proposal_pdf',
          technicalFile.path,
          filename: technicalFileName,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    }

    // الإرسال
    final streamed = await request.send();
    final respStr = await streamed.stream.bytesToString();
    final status = streamed.statusCode;

    try {
      final body = jsonDecode(respStr);
      final msg = body['message'] ?? '—';

      if (status == 200 || status == 201) {
        log('AddBid success: $msg'); // يظهر للمطوّر
        return true; // يمكنك إعادة true للاستخدام في الواجهة
      } else {
        log('AddBid error: $msg'); // تفاصيل للمطوّر
        return false;
      }
    } catch (e) {
      // لو لم يكن الرد JSON متوقع
      log('AddBid parse error: $e — raw: $respStr');
      return false;
    }
  }
}
