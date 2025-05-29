import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'auth_service.dart';

class ContractorService {
  static Future<Contractor?> getContractorInfo() async {
    final contractorId = await TokenStorage.getContractorId();
    final token = await TokenStorage.getToken();

    final url = Uri.parse(
      'http://your-api-url.com/api/contractors/$contractorId',
    );
    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Contractor.fromJson(data);
    } else if (response.statusCode == 404) {
      return null; // لا توجد معلومات
    } else {
      throw Exception('فشل في جلب بيانات المقاول');
    }
  }

  static Future<bool> saveContractorInfo(Contractor contractor) async {
    final token = await TokenStorage.getToken(); // جلب التوكن
    final url = Uri.parse('https://your-api-url.com/api/contractor');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode(
        contractor.toJson(),
        // {
        //   "company_name": contractor.companyName,
        //   "commercial_registration_number":
        //       contractor.commercialRegistrationNumber,
        //   "company_email": contractor.companyEmail,
        //   "country_city": contractor.countryCity,
        //   "phone_number": contractor.phoneNumber,
        //   "year_established": contractor.yearEstablished.toIso8601String(),
        //   "projects_last_5_years": contractor.projectsLast5Years,
        //   "quality_certificates": contractor.qualityCertificates,
        //   "public_sector_successful_contracts":
        //       contractor.publicSectorSuccessfulContracts,
        //   "website_url_or_linkedin_profile":
        //       contractor.websiteUrlOrLinkedinProfile,
        //   "company_bio": contractor.companyBio,
        //   "upload_official_documents_amount":
        //       contractor.uploadOfficialDocumentsAmount,
        // }
      ),
    );

    return response.statusCode == 200;
  }
}
