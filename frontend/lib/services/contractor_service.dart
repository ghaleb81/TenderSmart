import 'dart:convert'; // مكتبة لتحويل البيانات من/إلى JSON
import 'dart:developer'; // مكتبة لتسجيل السجلات (Logs)
import 'package:http/http.dart' as http; // مكتبة لإجراء طلبات HTTP
import 'package:tendersmart/models/Bid.dart'; // استدعاء موديل العروض
import 'package:tendersmart/models/contractor.dart'; // استدعاء موديل المقاول
import 'package:tendersmart/services/token_storage.dart'; // استدعاء خدمة تخزين التوكن

class ContractorService {
  static final ip = TokenStorage.getIp();
  static Future<Contractor?> getContractorInfo() async {
    final userrId = await TokenStorage.getUserrId();
    final token = await TokenStorage.getToken();

    // بناء الرابط باستخدام IP والمستخدم ID
    final url = Uri.parse('http://$ip:8000/api/contractor/show/$userrId');

    // إرسال طلب GET إلى السيرفر مع التوكن في الرؤوس
    final response = await http.get(
      Uri.parse('http://$ip:8000/api/contractor/show/$userrId'),
      headers: {'Authorization': 'Bearer $token'},
    );

    // تسجيل الرد القادم من السيرفر
    log('Response body: ${response.body}');

    // إذا نجح الطلب ورجع حالة 200
    if (response.statusCode == 200) {
      // تحويل الرد من JSON إلى كائن Map
      final data = json.decode(response.body);

      // استخراج البيانات الخاصة بالمقاول من المفتاح "The Detail of Contractor:"
      final contractorData = data["The Detail of Contractor:"];

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
      // إذا كانت حالة 404: لم توجد معلومات
      return null;
    } else {
      // أي حالة أخرى تعتبر فشل
      throw Exception('فشل في جلب بيانات المقاول');
    }
  }

  /// 🟩 دالة لجلب جميع عروض المقاول من السيرفر
  static Future<List<Bid>> fetchContractorBids() async {
    // جلب التوكن
    final token = await TokenStorage.getToken();

    // بناء الرابط للـ API
    final url = Uri.parse('http://$ip:8000/api/contractor/bids');

    // إرسال طلب GET مع التوكن
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    // إذا نجح الطلب
    if (response.statusCode == 200) {
      // تحويل الرد من JSON إلى كائن Map
      final Map<String, dynamic> json = jsonDecode(response.body);

      // استخراج قائمة العروض من المفتاح 'bids'
      final List<dynamic> body = json['bids'] ?? [];

      // تحويل كل عرض إلى كائن Bid وإرجاع القائمة
      return body.map((json) => Bid.fromJson(json)).toList();
    } else {
      // في حال الفشل، إرجاع خطأ
      throw Exception('فشل في تحميل عروض المقاول');
    }
  }

  /// 🟩 دالة لحفظ بيانات المقاول في السيرفر
  static Future<bool> saveContractorInfo(Contractor contractor) async {
    // جلب التوكن
    final token = await TokenStorage.getToken();
    log('$token');
    // بناء رابط API
    final url = Uri.parse('http://$ip:8000/api/contractor/store');

    // إرسال طلب POST لحفظ البيانات مع التوكن وبيانات المقاول بصيغة JSON
    final response = await http.post(
      // Uri.parse('http://$ip:8000/api/contractor/store'),
      url,
      headers: {
        'Content-Type': 'application/json', // تحديد نوع البيانات JSON
        'Authorization': 'Bearer $token', // إضافة التوكن
      },

      body: json.encode(
        contractor.toJsonCont(),
      ), // تحويل بيانات المقاول إلى JSON
    );

    // تسجيل الرد القادم من السيرفر
    log("Response body: ${response.body}");
    log("Status code: ${response.statusCode}");

    // إذا كان الرد حالة نجاح 200
    if (response.statusCode == 200) {
      try {
        // محاولة تحويل الرد من JSON إلى Map (اختياري)
        final data = jsonDecode(response.body);
        log("Decoded JSON: $data");
      } catch (e) {
        // في حال فشل فك JSON، تسجيل السبب
        log("الرد ليس بصيغة JSON: $e");
      }
      return true; // تم الحفظ بنجاح
    } else {
      log("فشل في حفظ بيانات المقاول");
      return false; // لم يتم الحفظ
    }
  }
}

// import 'dart:convert';
// import 'dart:developer';
// import 'package:http/http.dart' as http;
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/models/contractor.dart';
// import 'package:tendersmart/services/token_storage.dart';

// class ContractorService {
//   static final ip = TokenStorage.getIp();
//   static Future<Contractor?> getContractorInfo() async {
//     final userrId = await TokenStorage.getUserrId();
//     final token = await TokenStorage.getToken();

//     final url = Uri.parse('http://$ip:8000/api/contractor/show/$userrId');
//     final response = await http.get(
//       url,
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     log('Response body: ${response.body}');

//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);

//       // البيانات موجودة تحت المفتاح الصحيح
//       final contractorData = data["The Detail of Contractor:"];
//       if (contractorData != null) {
//         log('Contractor Data: $contractorData');
//         return Contractor.fromJsonCont(contractorData);
//       } else {
//         log('No contractor data found');
//         return null;
//       }
//     } else if (response.statusCode == 404) {
//       return null; // لا توجد معلومات
//     } else {
//       throw Exception('فشل في جلب بيانات المقاول');
//     }
//   }

//   // static Future<Contractor?> getContractorInfo() async {
//   //   final userrId = await TokenStorage.getUserrId();
//   //   final token = await TokenStorage.getToken();

//   //   final url = Uri.parse('http://$ip:8000/api/contractor/show/$userrId');
//   //   final response = await http.get(
//   //     // Uri.parse('http://$ip:8000/api/contractor/show/$userrId'),
//   //     url,
//   //     headers: {'Authorization': 'Bearer $token'},
//   //   );
//   //   log(response.body);
//   //   // log(userrId!);
//   //   if (response.statusCode == 200) {
//   //     final data = json.decode(response.body);
//   //     log(data);
//   //     return Contractor.fromJsonCont(data);
//   //   } else if (response.statusCode == 404) {
//   //     return null; // لا توجد معلومات
//   //   } else {
//   //     throw Exception('فشل في جلب بيانات المقاول');
//   //   }
//   // }

//   static Future<List<Bid>> fetchContractorBids() async {
//     final response = await http.get(
//       Uri.parse('http://$ip:8000/api/contractor/bids'),
//     );
//     if (response.statusCode == 200) {
//       final Map<String, dynamic> json = jsonDecode(response.body);
//       final List<dynamic> body = json['bids'] ?? [];
//       return body.map((json) => Bid.fromJson(json)).toList();
//     } else {
//       throw Exception('فشل في تحميل البيانات');
//     }
//   }
//   // static Future<List<Bid>> getContractorBids() async {
//   //   // final contractorId = await TokenStorage.getContractorId();
//   //   final token = await TokenStorage.getToken();

//   //   final url = Uri.parse('http://$ip:8000/api/contractor/bids');
//   //   final response = await http.get(
//   //     url,
//   //     headers: {'Authorization': 'Bearer $token'},
//   //   );

//   //   if (response.statusCode == 200) {
//   //     final data = json.decode(response.body);
//   //     return Bid.fromJson(data);
//   //   } else if (response.statusCode == 404) {
//   //     return null; // لا توجد معلومات
//   //   } else {
//   //     throw Exception('فشل في جلب بيانات المقاول');
//   //   }
//   // }
//   static Future<bool> saveContractorInfo(Contractor contractor) async {
//     final token = await TokenStorage.getToken();
//     final url = Uri.parse('https://$ip:8000/api/contractor/store');

//     final response = await http.post(
//       url,
//       headers: {
//         'Content-Type': 'application/json',
//         'Authorization': 'Bearer $token',
//       },
//       body: json.encode(contractor.toJsonCont()),
//     );

//     log("Response body: ${response.body}");
//     log("Status code: ${response.statusCode}");

//     // فقط حاول فك الرد إذا كان السيرفر أعاد حالة نجاح 200
//     if (response.statusCode == 200) {
//       try {
//         final data = jsonDecode(response.body);
//         log("Decoded JSON: $data");
//       } catch (e) {
//         log("الرد ليس بصيغة JSON: $e");
//       }
//       return true;
//     } else {
//       log("فشل في حفظ بيانات المقاول");
//       return false;
//     }
//   }

//   // static Future<bool> saveContractorInfo(Contractor contractor) async {
//   //   final token = await TokenStorage.getToken(); // جلب التوكن
//   //   final url = Uri.parse('http://$ip:8000/api/contractor/store');

//   //   final response = await http.post(
//   //     url,
//   //     headers: {
//   //       'Content-Type': 'application/json',
//   //       'Authorization': 'Bearer $token',
//   //     },

//   //     body: json.encode(
//   //       contractor.toJson(),
//   //       // {
//   //       //   "company_name": contractor.companyName,
//   //       //   "commercial_registration_number":
//   //       //       contractor.commercialRegistrationNumber,
//   //       //   "company_email": contractor.companyEmail,
//   //       //   "country_city": contractor.countryCity,
//   //       //   "phone_number": contractor.phoneNumber,
//   //       //   "year_established": contractor.yearEstablished.toIso8601String(),
//   //       //   "projects_last_5_years": contractor.projectsLast5Years,
//   //       //   "quality_certificates": contractor.qualityCertificates,
//   //       //   "public_sector_successful_contracts":
//   //       //       contractor.publicSectorSuccessfulContracts,
//   //       //   "website_url_or_linkedin_profile":
//   //       //       contractor.websiteUrlOrLinkedinProfile,
//   //       //   "company_bio": contractor.companyBio,
//   //       //   "upload_official_documents_amount":
//   //       //       contractor.uploadOfficialDocumentsAmount,
//   //       // }
//   //     ),
//   //   );
//   //   print("Response body: ${response.body}");
//   //   print("Status code: ${response.statusCode}");
//   //   print(jsonDecode(response.body));

//   //   return response.statusCode == 200;
//   // }
// }
