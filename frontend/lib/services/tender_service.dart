import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/token_storage.dart';

import 'dart:convert';

class TenderService {
  static final ip = TokenStorage.getIp();

  static Future<List<Tender>> fetchTenders() async {
    final token = await TokenStorage.getToken();
    final response = await http.get(
      // Uri.parse('http://$ip:8000/api/Tender/index'),
      Uri.parse('$ip/api/Tender/index'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> body = json['tenders']['data'];
      return body.map((json) => Tender.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }

  // static Future<void> addTender(Tender tender) async {
  //   final token = await TokenStorage.getToken();
  //   final uri = Uri.parse('http://$ip:8000/api/storeTender');
  //   final request = http.MultipartRequest('POST', uri);

  //   request.headers['Authorization'] = 'Bearer $token';

  //   // أضف الحقول النصية
  //   tender.toJson().forEach((key, value) {
  //     request.fields[key] = value.toString();
  //   });

  //   // أضف الملف إذا موجود
  //   if (tender.technicalFile != null) {
  //     final file = tender.technicalFile!;
  //     final mimeType = 'application/pdf'; // لأننا نستقبل PDF فقط

  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'attached_file', // اسم الحقل كما في الباكند (راجع اسم الحقل في الـ migration)
  //         file.path,
  //         contentType: MediaType('application', 'pdf'),
  //       ),
  //     );
  //   }

  //   // إرسال الطلب
  //   final response = await request.send();

  //   if (response.statusCode == 201 || response.statusCode == 200) {
  //     print('تم رفع المناقصة بنجاح');
  //   } else {
  //     final respStr = await response.stream.bytesToString();
  //     print('فشل في رفع المناقصة: ${response.statusCode}');
  //     print('الرد: $respStr');
  //     throw Exception('فشل في رفع المناقصة');
  //   }
  // }
  // static Future<void> addTender(
  //   Tender tender, {
  //   Uint8List? technicalFileBytes,
  //   String? technicalFileName,
  // }) async {
  //   final token = await TokenStorage.getToken();
  //   final uri = Uri.parse('http://$ip:8000/api/Tender/store');
  //   final request = http.MultipartRequest('POST', uri);

  //   request.headers['Authorization'] = 'Bearer $token';
  //   request.headers['Accept'] = 'application/json';
  //   tender.toJson().forEach((key, value) {
  //     request.fields[key] = value.toString();
  //   });

  //   if (technicalFileBytes != null && technicalFileName != null) {
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'attached_file',
  //         technicalFileBytes,
  //         filename: technicalFileName,
  //         contentType: MediaType('application', 'pdf'),
  //       ),
  //     );
  //   }

  //   final response = await request.send();
  //   if (response.statusCode != 200 && response.statusCode != 201) {
  //     final respStr = await response.stream.bytesToString();
  //     throw Exception('فشل في رفع المناقصة: $respStr');
  //   }
  // }

  // static Future<void> updateTender(
  //   Tender tender, {
  //   Uint8List? technicalFileBytes,
  //   String? technicalFileName,
  // }) async {
  //   final token = await TokenStorage.getToken();
  //   final uri = Uri.parse('http://$ip:8000/api/Tender/update/${tender.id}');
  //   final request =
  //       http.MultipartRequest('POST', uri)
  //         ..headers['Authorization'] = 'Bearer $token'
  //         ..fields['_method'] = 'PUT'; // Laravel spoof

  //   // حقول النموذج
  //   tender.toJson().forEach((k, v) => request.fields[k] = v.toString());

  //   // ملف PDF اختياري
  //   if (technicalFileBytes != null && technicalFileName != null) {
  //     request.files.add(
  //       http.MultipartFile.fromBytes(
  //         'attached_file', // ← نفس الـ key الذي يستقبله الباك‑إند
  //         technicalFileBytes,
  //         filename: technicalFileName,
  //         contentType: MediaType('application', 'pdf'),
  //       ),
  //     );
  //   }

  //   // إرسال الطلب
  //   final response = await request.send();
  //   if (response.statusCode != 200) {
  //     final body = await response.stream.bytesToString();
  //     throw Exception('فشل في تعديل المناقصة: $body');
  //   }
  // }
  static Future<void> addTender(
    Tender tender, {
    File? technicalFile,
    String? technicalFileName,
  }) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$ip/api/Tender/store');
    // final uri = Uri.parse('http://$ip:8000/api/Tender/store');
    final request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token';
    request.headers['Accept'] = 'application/json';

    // تعبئة الحقول النصية
    tender.toJson().forEach((key, value) {
      request.fields[key] = value.toString();
    });

    // إرفاق الملف إذا وُجد
    if (technicalFile != null && technicalFileName != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'attached_file',
          technicalFile.path,
          filename: technicalFileName,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    }

    final response = await request.send();
    if (response.statusCode != 200 && response.statusCode != 201) {
      final respStr = await response.stream.bytesToString();
      throw Exception('فشل في رفع المناقصة: $respStr');
    }
  }

  static Future<void> updateTender(
    Tender tender, {
    File? technicalFile,
    String? technicalFileName,
  }) async {
    final token = await TokenStorage.getToken();
    final uri = Uri.parse('$ip/api/Tender/update/${tender.id}');
    // final uri = Uri.parse('http://$ip:8000/api/Tender/update/${tender.id}');
    final request =
        http.MultipartRequest('POST', uri)
          ..headers['Authorization'] = 'Bearer $token'
          ..fields['_method'] = 'PUT';

    tender.toJson().forEach((key, value) {
      request.fields[key] = value.toString();
    });

    if (technicalFile != null && technicalFileName != null) {
      request.files.add(
        await http.MultipartFile.fromPath(
          'attached_file',
          technicalFile.path,
          filename: technicalFileName,
          contentType: MediaType('application', 'pdf'),
        ),
      );
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      final respStr = await response.stream.bytesToString();
      throw Exception('فشل في تعديل المناقصة: $respStr');
    }
  }

  // static Future<void> addTender(Tender tender) async {
  //   final response = await http.post(
  //     Uri.parse('http://$ip:8000/api/storeTender'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: json.encode(tender.toJson()),
  //   );
  //   if (response.statusCode != 201) {
  //     throw Exception('فشل في إضافة المناقصة');
  //   }
  //   return;
  // }

  static Future<void> deleteTender(String id) async {
    final String baseUrl = '$ip/api/Tender/destroy/$id';
    // final String baseUrl = 'http://$ip:8000/api/Tender/destroy/$id';
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
    final token = await TokenStorage.getToken();
    final response = await http.get(
      Uri.parse('$ip/api/Tender/saved'),
      // Uri.parse('http://${ip}:8000/api/Tender/saved'),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = jsonDecode(response.body);
      return body.map((json) => Tender.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل المناقصات المحفوظة');
    }
  }

  static Future<void> saveTenders(Tender tender) async {
    final userId = await TokenStorage.getUserrId();
    final token = await TokenStorage.getToken();

    final response = await http.post(
      Uri.parse('$ip/api/Tender/${tender.id}/save'),
      // Uri.parse('http://$ip:8000/api/Tender/${tender.id}/save'),
      headers: {
        'Accept': 'application/json', // مهم جداً!
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'tender_id': tender.id, 'user_id': userId}),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل في حفظ المناقصة');
    }
    return;
  }

  static Future<void> cancellationTenders(String id) async {
    final token = await TokenStorage.getToken();
    final String url = '$ip/api/Tender/$id/delete';
    // final String url = 'http://$ip:8000/api/Tender/$id/delete';

    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers: {
              'Accept': 'application/json',
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          )
          .timeout(Duration(seconds: 5));

      if (response.statusCode != 200) {
        print('حالة الرد : ${response.statusCode}');
        print('الرد : ${response.body}');
        throw Exception('فشل في حذف المناقصة');
      }
    } catch (e) {
      print('خطأ أثناء حذف المناقصة : $e');
    }
  }
}
