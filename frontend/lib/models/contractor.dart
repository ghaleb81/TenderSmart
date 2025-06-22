class Contractor {
  final int? id;
  final int? userId; // لربط المقاول بالمستخدم
  final String? companyName;
  final String? commercialRegistrationNumber;
  final String? companyEmail;
  final String? country;
  final String? city;
  final String? phoneNumber;
  final int? yearEstablished; // السنة كرقم
  final int? projectsLast5Years;
  final List<String>? qualityCertificates; // JSON Array
  final String? publicSectorSuccessfulContracts;
  final String? websiteUrl;
  final String? linkedinProfile;
  final String? companyBio;
  final String? officialDocuments; // رابط المستندات
  final String? email; // للتسجيل
  final String? password;
  final String? passwordConfirmation;
  final String? phoneNumberForUser; // للتسجيل
  final String? fullName; // للتسجيل

  Contractor({
    this.id,
    this.userId,
    this.companyName,
    this.commercialRegistrationNumber,
    this.companyEmail,
    this.country,
    this.city,
    this.phoneNumber,
    this.yearEstablished,
    this.projectsLast5Years,
    this.qualityCertificates,
    this.publicSectorSuccessfulContracts,
    this.websiteUrl,
    this.linkedinProfile,
    this.companyBio,
    this.officialDocuments,
    this.email,
    this.password,
    this.passwordConfirmation,
    this.phoneNumberForUser,
    this.fullName,
  });

  factory Contractor.fromJsonCont(Map<String, dynamic> json) {
    return Contractor(
      id: json['id'],
      userId: json['user_id'],
      companyName: json['company_name'],
      commercialRegistrationNumber: json['commercial_registration_number'],
      companyEmail: json['company_email'],
      country: json['country'],
      city: json['city'],
      phoneNumber: json['phone_number'],
      yearEstablished: int.tryParse(json['year_established'].toString()),
      projectsLast5Years: json['projects_last_5_years'],
      qualityCertificates:
          json['quality_certificates'] != null
              ? List<String>.from(json['quality_certificates'])
              : [],
      publicSectorSuccessfulContracts:
          json['public_sector_successful_contracts'],
      websiteUrl: json['website_url'],
      linkedinProfile: json['linkedin_profile'],
      companyBio: json['company_bio'],
      officialDocuments: json['official_documents'],
    );
  }

  factory Contractor.fromJsonRegister(Map<String, dynamic> json) {
    return Contractor(
      email: json['email'] ?? '',
      password: json['password'] ?? '',
      fullName: json['name'] ?? '',
      phoneNumberForUser: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJsonCont() {
    return {
      "user_id": userId,
      "company_name": companyName,
      "commercial_registration_number": commercialRegistrationNumber,
      "company_email": companyEmail,
      "country": country,
      "city": city,
      "phone_number": phoneNumber,
      "year_established": yearEstablished,
      "projects_last_5_years": projectsLast5Years,
      "quality_certificates": qualityCertificates,
      "public_sector_successful_contracts": publicSectorSuccessfulContracts,
      "website_url": websiteUrl,
      "linkedin_profile": linkedinProfile,
      "company_bio": companyBio,
      // "official_documents": officialDocuments,
    };
  }

  Map<String, dynamic> toJsonRegister() {
    return {
      "name": fullName,
      "email": email,
      "password": password,
      "password_confirmation": passwordConfirmation,
      "phone": phoneNumberForUser,
    };
  }
}

// import 'package:intl/intl.dart';

// final dateFormat = DateFormat.yMd();

// class Contractor {
//   final String? fullName;
//   final String? contractorId;
//   final String? companyName;
//   final String? commercialRegistrationNumber;
//   final String? companyEmail;
//   final String? country;
//   final String? city;
//   final String? phoneNumberForCompany;
//   final String? phoneNumberForUser;
//   final DateTime? yearEstablished; //سنة التأسيس
//   final int? projectsLast5Years; //
//   final List<String>? qualityCertificates; //شهادات الجودة
//   final String? publicSectorSuccessfulContracts; //العقود الناجحة للقطاع العام
//   final String? websiteUrl; //عنوان اللينكدان
//   final String? LinkedinProfile; //عنوان اللينكدان
//   final String? companyBio;
//   final String? uploadOfficialDocumentsAmount; //الوثائق المحملة
//   final String? email;
//   final String? password;
//   final String? passwordConfirmation;

//   Contractor({
//     this.fullName,
//     this.contractorId,
//     this.companyName,
//     this.commercialRegistrationNumber,
//     this.companyEmail,
//     this.country,
//     this.city,
//     this.phoneNumberForCompany,
//     this.phoneNumberForUser,

//     this.yearEstablished,
//     this.projectsLast5Years,
//     this.qualityCertificates,
//     this.publicSectorSuccessfulContracts,
//     this.websiteUrl,
//     this.LinkedinProfile,
//     this.companyBio,
//     this.uploadOfficialDocumentsAmount,
//     this.email,
//     this.password,
//     this.passwordConfirmation,
//   });
//   factory Contractor.fromJsonCont(Map<String, dynamic> json) {
//     return Contractor(
//       contractorId: json['user_id']?.toString(),
//       companyName: json['company_name'],
//       commercialRegistrationNumber: json['commercial_registration_number'],
//       companyEmail: json['company_email'],
//       country: json['country'],
//       city: json['city'],
//       phoneNumberForCompany: json['phone_number'],
//       // yearEstablished: DateTime.parse(json['year_established']),
//       yearEstablished: int.tryParse(json['year_established'].toString()),
//       projectsLast5Years: json['projects_last_5_years'],
//       // qualityCertificates: json['quality_certificates'],
//       qualityCertificates:
//           json['quality_certificates'] != null
//               ? List<String>.from(json['quality_certificates'])
//               : [],
//       // qualityCertificates: List<String>.from(json['quality_certificates']),
//       // publicSectorSuccessfulContracts:
//       //     json['public_sector_successful_contracts'],
//       publicSectorSuccessfulContracts: int.tryParse(
//         json['public_sector_successful_contracts'].toString(),
//       ),
//       // websiteUrlOrLinkedinProfile: json['website_url_or_linkedin_profile'],
//       websiteUrl: json['website_url'],
//       LinkedinProfile: json['linkedin_profile'],
//       companyBio: json['company_bio'],
//       // uploadOfficialDocumentsAmount: json['upload_official_documents_amount'],
//     );
//   }
//   factory Contractor.fromJsonRegister(Map<String, dynamic> json) {
//     return Contractor(
//       email: json['email'] ?? '',
//       password: json['password'] ?? '',
//       fullName: json['name'] ?? '',
//       phoneNumberForUser: json['phone'] ?? '',
//     );
//   }

//   Map<String, dynamic> toJsonCont() {
//     return {
//       "company_name": companyName,
//       "commercial_registration_number": commercialRegistrationNumber,
//       "company_email": companyEmail,
//       "country": country,
//       "city": city,
//       "phone_number": phoneNumberForCompany,
//       "year_established": yearEstablished!.year,
//       "projects_last_5_years": projectsLast5Years,
//       "quality_certificates": qualityCertificates,
//       "public_sector_successful_contracts": publicSectorSuccessfulContracts,
//       "website_url_or_linkedin_profile": websiteUrl,
//       "company_bio": companyBio,
//       "upload_official_documents_amount": uploadOfficialDocumentsAmount,
//     };
//   }

//   Map<String, dynamic> toJsonRegister() {
//     return {
//       "name": fullName,
//       "email": email,
//       "password": password,
//       "password_confirmation": passwordConfirmation,
//       "phone": phoneNumberForUser,
//     };
//   }
//   // final RegExp emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
//   // final RegExp passwordRegex = RegExp(
//   //   r'^(?=.*[A-Za-z])(?=.*\d)[A-Za-z\d@$!%*?&]{8,}$',
//   // );

//   // bool isEmailValid() {
//   //   return emailRegex.hasMatch(email);
//   // }

//   // bool isPasswordValid() {
//   //   return passwordRegex.hasMatch(password);
//   // }

//   // bool isValid() {
//   //   return isEmailValid() && isPasswordValid();
//   // }
// }

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
