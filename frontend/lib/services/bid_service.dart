import 'package:http/http.dart' as http;
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'dart:convert';

class TenderService {
  static Future<List<Bid>> fetchBids() async {
    final response = await http.get(
      // Uri.parse('http://192.168.64.174:8000/api/indexApi'),
      Uri.parse('http://127.0.0.1:8000/api/indexApi'),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> body = json['bids'];
      return body.map((json) => Bid.fromJson(json)).toList();
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

  static Future<void> AddBid(Bid bid) async {
    final response = await http.post(
      Uri.parse('http://192.168.64.174:8000/api/bids'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'bid_amount': bid.bidAmount,
        'completion_time': bid.completionTimeExcepted,
        'technical_matched_count': bid.technicalMatchedCount,
      }),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة المناقصة');
    }
    return;
  }

  static Future<void> deleteTenders(String id) async {
    final String baseUrl = 'http://192.168.64.174:8000/api/destroyTender/$id';
    // final url = "$baseUrl/$tender";
    final response = await http.delete(Uri.parse(baseUrl));
    if (response.statusCode != 200) {
      throw Exception('فشل في حذف المناقصة');
    }
    return;
  }
}
