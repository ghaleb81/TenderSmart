import 'dart:convert'; // مكتبة لتحويل البيانات من/إلى JSON
import 'dart:developer'; // مكتبة لتسجيل السجلات (Logs)
import 'package:http/http.dart' as http; // مكتبة لإجراء طلبات HTTP
import 'package:tendersmart/models/Bid.dart'; // استدعاء موديل العروض
import 'package:tendersmart/models/contractor.dart'; // استدعاء موديل المقاول
import 'package:tendersmart/services/token_storage.dart'; // استدعاء خدمة تخزين التوكن

class ContractorService {
  static final ip = TokenStorage.getIp();
  static Future<Contractor?> getContractorInfo(int id) async {
    // final userrId = await TokenStorage.getUserrId();
    final token = await TokenStorage.getToken();
    // final url = Uri.parse('http://$ip:8000/api/contractor/show/$userrId');

    final response = await http.get(
      Uri.parse('$ip/api/contractor/show/$id'),
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
      // تحويل الرد من JSON إلى كائن Map
      final data = json.decode(response.body);
      // استخراج البيانات الخاصة بالمقاول من المفتاح "The Detail of Contractor:"
      final contractorData = data["The Detail of Contactor:"];

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

  static Future<bool> saveContractorInfo(Contractor contractor) async {
    final token = await TokenStorage.getToken();
    // log('Token : $token');
    if (token == null) {
      log("لا يوجد توكن. تأكد من تسجيل الدخول أولاً.");
      return false;
    }
    // log("Sending contractor data: ${json.encode(contractor.toJsonCont())}");
    final response = await http.post(
      Uri.parse('$ip/api/contractor/store'),
      // Uri.parse('http://$ip:8000/api/contractor/store'),
      // headers: {
      //   'Content-Type': 'application/json',
      //   'Authorization': 'Bearer $token',
      // },
      headers: {
        'Accept': 'application/json', // مهم جداً!
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(contractor.toJsonCont()),
    );
    // log(token);
    // log("Response body: ${response.body}");
    // log("Status code: ${response.statusCode}");

    if (response.statusCode == 200) {
      try {
        final data = jsonDecode(response.body);
        log("تم فك الرد بنجاح: $data");
      } catch (e) {
        log("الرد ليس JSON: $e");
      }
      return true;
    } else {
      log("فشل في حفظ بيانات المقاول");
      return false;
    }
  }
}
