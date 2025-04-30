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

  static bool isEmailCompanyValid(String companyEmail) {
    return emailRegex.hasMatch(companyEmail);
  }

  static bool isPasswordValid(String password) {
    return passwordRegex.hasMatch(password);
  }

  static bool isValid(String email, String password, String companyEmail) {
    return isEmailValid(email) &&
        isPasswordValid(password) &&
        isEmailCompanyValid(companyEmail);
  }
}
