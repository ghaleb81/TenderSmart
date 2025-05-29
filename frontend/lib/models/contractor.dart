import 'package:intl/intl.dart';

final dateFormat = DateFormat.yMd();

class Contractor {
  final String companyName;
  final int commercialRegistrationNumber;
  final String companyEmail;
  final String countryCity;
  final String phoneNumber;
  final DateTime yearEstablished; //سنة التأسيس
  final int projectsLast5Years; //
  final String qualityCertificates; //شهادات الجودة
  final String publicSectorSuccessfulContracts; //العقود الناجحة للقطاع العام
  final String websiteUrlOrLinkedinProfile; //عنوان اللينكدان
  final String companyBio;
  final String uploadOfficialDocumentsAmount; //الوثائق المحملة
  final String email;
  final String password;

  Contractor({
    required this.companyName,
    required this.commercialRegistrationNumber,
    required this.companyEmail,
    required this.countryCity,
    required this.phoneNumber,
    required this.yearEstablished,
    required this.projectsLast5Years,
    required this.qualityCertificates,
    required this.publicSectorSuccessfulContracts,
    required this.websiteUrlOrLinkedinProfile,
    required this.companyBio,
    required this.uploadOfficialDocumentsAmount,
    required this.email,
    required this.password,
  });
  factory Contractor.fromJson(Map<String, dynamic> json) {
    return Contractor(
      companyName: json['company_name'],
      commercialRegistrationNumber: json['commercial_registration_number'],
      companyEmail: json['company_email'],
      countryCity: json['country_city'],
      phoneNumber: json['phone_number'],
      yearEstablished: DateTime.parse(json['year_established']),
      projectsLast5Years: json['projects_last_5_years'],
      qualityCertificates: json['quality_certificates'],
      publicSectorSuccessfulContracts:
          json['public_sector_successful_contracts'],
      websiteUrlOrLinkedinProfile: json['website_url_or_linkedin_profile'],
      companyBio: json['company_bio'],
      uploadOfficialDocumentsAmount: json['upload_official_documents_amount'],
      email: json['email'] ?? '',
      password: json['password'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "company_name": companyName,
      "commercial_registration_number": commercialRegistrationNumber,
      "company_email": companyEmail,
      "country_city": countryCity,
      "phone_number": phoneNumber,
      "year_established": yearEstablished.toIso8601String(),
      "projects_last_5_years": projectsLast5Years,
      "quality_certificates": qualityCertificates,
      "public_sector_successful_contracts": publicSectorSuccessfulContracts,
      "website_url_or_linkedin_profile": websiteUrlOrLinkedinProfile,
      "company_bio": companyBio,
      "upload_official_documents_amount": uploadOfficialDocumentsAmount,
      "email": email,
      "password": password,
    };
  }
  // final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  // final RegExp passwordRegex = RegExp(
  //   r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
  // );

  // bool isEmailValid() {
  //   return emailRegex.hasMatch(email);
  // }

  // bool isPasswordValid() {
  //   return passwordRegex.hasMatch(password);
  // }

  // bool isValid() {
  //   return isEmailValid() && isPasswordValid();
  // }
}

class ContractorValidator {
  static final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  static final RegExp passwordRegex = RegExp(
    r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
  );

  static bool isEmailValid(String email) {
    return emailRegex.hasMatch(email);
  }

  // static bool isEmailCompanyValid(String companyEmail) {
  //   return emailRegex.hasMatch(companyEmail);
  // }

  static bool isPasswordValid(String password) {
    return passwordRegex.hasMatch(password);
  }

  static bool isValid(String email, String password) {
    return isEmailValid(email) && isPasswordValid(password);
    // isEmailCompanyValid(companyEmail);
  }
}
