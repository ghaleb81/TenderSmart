// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:tendersmart/models/ReportSummary.dart';

// class ReportService {
//   final String baseUrl;
//   final String token;

//   ReportService({required this.baseUrl, required this.token});

//   Future<ReportSummary> fetchReportSummary() async {
//     final response = await http.get(
//       Uri.parse('$baseUrl/report/summary'),
//       headers: {'Authorization': 'Bearer $token'},
//     );

//     if (response.statusCode == 200) {
//       final jsonData = json.decode(response.body);
//       return ReportSummary.fromJson(jsonData);
//     } else {
//       throw Exception('فشل تحميل تقارير الملخص');
//     }
//   }
// }
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tendersmart/services/token_storage.dart';

import 'dart:convert';
import 'dart:developer';

class ReportService {
  static final ip = TokenStorage.getIp();

  static Future<Map<String, dynamic>> getSummaryReport() async {
    final token = await TokenStorage.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$ip/api/report/summary'),
      headers: headers,
    );
    return _handleJsonResponse(response);
  }

  static Future<Map<String, dynamic>> getContractorPerformance() async {
    final token = await TokenStorage.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$ip/api/report/performance'),
      headers: headers,
    );
    return _handleJsonResponse(response);
  }

  static Future<List<dynamic>> getAllTenders() async {
    final token = await TokenStorage.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$ip/api/Tender/index'),
      headers: headers,
    );
    return _handleJsonResponse(response);
  }

  static Future<List<dynamic>> getOpenedTenders() async {
    final token = await TokenStorage.getToken();
    final headers = {
      'Authorization': 'Bearer $token',
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    final response = await http.get(
      Uri.parse('$ip/api/Tender/opened'),
      headers: headers,
    );
    return _handleJsonResponse(response);
  }

  // static Future<List<dynamic>> getAllBids() async {
  //   final token = await TokenStorage.getToken();
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //   };

  //   final response = await http.get(
  //     Uri.parse('$ip/api/bid/index'),
  //     headers: headers,
  //   );
  //   return _handleJsonResponse(response);
  // }

  // static Future<Map<String, dynamic>> getBidById(int id) async {
  //   final token = await TokenStorage.getToken();
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //   };

  //   final response = await http.get(
  //     Uri.parse('$ip/api/bid/show/$id'),
  //     headers: headers,
  //   );
  //   return _handleJsonResponse(response);
  // }

  // static Future<Map<String, dynamic>> getBidResult(int bidId) async {
  //   final token = await TokenStorage.getToken();
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //   };

  //   final response = await http.get(
  //     Uri.parse('$ip/api/bids/$bidId/result'),
  //     headers: headers,
  //   );
  //   return _handleJsonResponse(response);
  // }

  // static Future<List<dynamic>> getAllContractors() async {
  //   final token = await TokenStorage.getToken();
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //   };

  //   final response = await http.get(
  //     Uri.parse('$ip/api/contractor/show'),
  //     headers: headers,
  //   );
  //   return _handleJsonResponse(response);
  // }

  // static Future<Map<String, dynamic>> getContractorByUserId(int userId) async {
  //   final token = await TokenStorage.getToken();
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //   };

  //   final response = await http.get(
  //     Uri.parse('$ip/api/contractor/user/$userId'),
  //     headers: headers,
  //   );
  //   return _handleJsonResponse(response);
  // }

  // static Future<List<dynamic>> getPreviousBidsForContractor() async {
  //   final token = await TokenStorage.getToken();
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Accept': 'application/json',
  //     'Content-Type': 'application/json',
  //   };

  //   final response = await http.get(
  //     Uri.parse('$ip/api/contractor/bids'),
  //     headers: headers,
  //   );
  //   return _handleJsonResponse(response);
  // }

  static dynamic _handleJsonResponse(http.Response response) {
    log('Response (${response.statusCode}): ${response.body}');
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
        'فشل الاتصال بالخادم: ${response.statusCode}\n${response.body}',
      );
    }
  }
}
