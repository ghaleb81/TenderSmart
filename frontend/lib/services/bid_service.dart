import 'package:http/http.dart' as http;
import 'package:tendersmart/models/Bid.dart';
import 'dart:convert';
import 'package:tendersmart/services/token_storage.dart';

class BidService {
  static final ip = TokenStorage.getIp();
  static Future<List<Bid>> fetchBids() async {
    final response = await http.get(Uri.parse('http://$ip:8000/api/bids'));
    if (response.statusCode == 200) {
      final Map<String, dynamic> json = jsonDecode(response.body);
      final List<dynamic> body = json['bids'] ?? [];
      return body.map((json) => Bid.fromJson(json)).toList();
    } else {
      throw Exception('فشل في تحميل البيانات');
    }
  }

  // static Future<List<Bid>> fetchBids() async {
  //   final response = await http.get(
  //     Uri.parse('http://${ip}:8000/api/indexApi'),
  //   );
  //   if (response.statusCode == 200) {
  //     final Map<String, dynamic> json = jsonDecode(response.body);
  //     final List<dynamic> body = json['bids'];
  //     return body.map((json) => Bid.fromJson(json)).toList();
  //   } else {
  //     throw Exception('فشل في تحميل البيانات');
  //   }
  // }

  // static Future<bool> addBid({
  //   required double bidAmount,
  //   required int completionTime,
  //   required int technicalMatched,
  //   File? technicalProposalPdf,
  //   // required String token,
  // }) async {
  //   var url = Uri.parse('http://192.168.214.174:8000/api/storeApi');

  //   var request =
  //       http.MultipartRequest('POST', url)
  //         // ..headers['Authorization'] = 'Bearer $token'
  //         ..fields['bid_amount'] = bidAmount.toString()
  //         ..fields['completion_time_excepted'] = completionTime.toString()
  //         ..fields['technical_matched_count'] = technicalMatched.toString();

  //   if (technicalProposalPdf != null) {
  //     final mimeType =
  //         lookupMimeType(technicalProposalPdf.path) ?? 'application/pdf';
  //     request.files.add(
  //       await http.MultipartFile.fromPath(
  //         'technical_proposal_pdf',
  //         technicalProposalPdf.path,
  //         contentType: MediaType.parse(mimeType),
  //       ),
  //     );
  //   }

  //   final streamedResponse = await request.send();
  //   final response = await http.Response.fromStream(streamedResponse);

  //   print(response.body);

  //   return response.statusCode == 201;
  // }
  // static Future<bool> addBid(Bid bid) async {
  //   var url = Uri.parse('http://192.168.214.174:8000/api/storeApi');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode(bid.toJson()),
  //     );

  //     print('Status code: ${response.statusCode}');
  //     print('Response body: ${response.body}');

  //     return response.statusCode == 201;
  //   } catch (e) {
  //     print('حدث خطأ أثناء إضافة العرض: $e');
  //     return false;
  //   }
  // }
  static Future<void> addBid(Bid bid) async {
    final token = await TokenStorage.getToken();
    final response = await http.post(
      Uri.parse('http://$ip:8000/api/bid/store'),
      // headers: {'Content-Type': 'application/json'},
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(bid.toJson()),

      // json.encode({
      //   'contractor_id': bid.contractorId,
      //   'tender_id': bid.tenderId,
      //   'bid_amount': bid.bidAmount,
      //   'completion_time': bid.completionTimeExcepted,
      //   'technical_matched_count': bid.technicalMatchedCount,
      // }),
    );
    if (response.statusCode != 201) {
      throw Exception('فشل في إضافة العرض');
    }
    return;
  }
}
