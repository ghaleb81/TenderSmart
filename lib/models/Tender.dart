import 'package:intl/intl.dart';
import 'package:tendersmart/services/token_storage.dart';

final dateFormat = DateFormat.yMd();

enum StateOfTender { opened, closed, progress }

final ip = TokenStorage.getIp();

class Tender {
  final String? id;
  final String title;
  final String descripe;
  final String location;
  final int implementationPeriod;
  final int numberOfTechnicalConditions;
  final DateTime registrationDeadline;
  final StateOfTender stateOfTender;
  final double budget;
  final String? technicalFileUrl;
  final int? manualWinnerBidId;

  Tender({
    this.id,
    required this.title,
    required this.descripe,
    required this.location,
    required this.implementationPeriod,
    required this.numberOfTechnicalConditions,
    required this.registrationDeadline,
    required this.stateOfTender,
    required this.budget,
    this.technicalFileUrl,
    this.manualWinnerBidId,
  });

  factory Tender.fromJson(Map<String, dynamic> json) {
    final String? filePath = json['attached_file'];
    final String? generatedUrl =
        filePath != null
            ? '$ip/storage/$filePath'
            // ? '$ip/$filePath'
            // ? 'http://0792-185-184-195-146.ngrok-free.app/storage/$filePath'
            : null;

    return Tender(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      descripe: json['description'] ?? '',
      location: json['location'] ?? '',
      implementationPeriod: json['execution_duration_days'] ?? 0,
      numberOfTechnicalConditions: json['technical_requirements_count'] ?? 0,
      registrationDeadline: DateFormat(
        "yyyy-MM-dd",
      ).parse(json['submission_deadline']),
      stateOfTender: parseStateOfTender(json['status']),
      budget: double.tryParse(json['estimated_budget'].toString()) ?? 0.0,
      technicalFileUrl: generatedUrl,
      manualWinnerBidId: json['manual_winner_bid_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': descripe,
      'location': location,
      'execution_duration_days': implementationPeriod,
      'technical_requirements_count': numberOfTechnicalConditions,
      'submission_deadline': registrationDeadline.toIso8601String(),
      'status': stateOfTender.name,
      'estimated_budget': budget,
    };
  }
}

StateOfTender parseStateOfTender(String value) {
  switch (value) {
    case 'opened':
      return StateOfTender.opened;
    case 'closed':
      return StateOfTender.closed;
    case 'progress':
      return StateOfTender.progress;
    default:
      throw Exception('Unknown state: $value');
  }
}

// // import 'dart:convert';
// // import 'dart:typed_data';
// // import 'package:flutter/material.dart';
// import 'package:tendersmart/services/token_storage.dart';
// import 'package:uuid/uuid.dart';
// import 'package:intl/intl.dart';

// const uuid = Uuid();
// final dateFormat = DateFormat.yMd();
// getIp() async {
//   final ip = await TokenStorage.getIp();
//   return ip;
// }

// enum StateOfTender { opened, closed, progress }

// class Tender {
//   final String? id;
//   final String title;
//   final String descripe;
//   final String location;
//   final int implementationPeriod;
//   final int numberOfTechnicalConditions;
//   final DateTime registrationDeadline;
//   final StateOfTender stateOfTender;
//   final double budget;
//   final String? technicalFileUrl;
//   // بدل File
//   // final Uint8List? technicalFileBytes;
//   // final String? technicalFileName;

//   Tender({
//     this.id,
//     required this.title,
//     required this.descripe,
//     required this.location,
//     required this.implementationPeriod,
//     required this.numberOfTechnicalConditions,
//     required this.registrationDeadline,
//     required this.stateOfTender,
//     required this.budget,
//     // this.technicalFileBytes,
//     // this.technicalFileName,
//     this.technicalFileUrl,
//   });

//   factory Tender.fromJson(Map<String, dynamic> json) {
//     // إذا الملف يأتي Base64:
//     // Uint8List? fileBytes;
//     // if (json['technical_file_base64'] != null) {
//     //   fileBytes = base64Decode(json['technical_file_base64']);
//     // }

//     return Tender(
//       id: json['id']?.toString(),
//       title: json['title'] ?? '',
//       descripe: json['description'] ?? '',
//       location: json['location'] ?? '',
//       implementationPeriod: json['execution_duration_days'] ?? 0,
//       numberOfTechnicalConditions: json['technical_requirements_count'] ?? 0,
//       registrationDeadline: DateFormat(
//         "yyyy-MM-dd",
//       ).parse(json['submission_deadline']),
//       stateOfTender: parseStateOfTender(json['status']),
//       budget: double.tryParse(json['estimated_budget'].toString()) ?? 0.0,
//       // technicalFileBytes: fileBytes,
//       // technicalFileName: json['technical_file_name'],
//       // technicalFileUrl:
//       //     json['attached_file'] != null
//       //         ? 'http://${getIp()}:8000/api/indexApi/${json['attached_file']}' // حسب رابط الباكند
//       //         : null,
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'title': title,
//       'description': descripe,
//       'location': location,
//       'execution_duration_days': implementationPeriod,
//       'technical_requirements_count': numberOfTechnicalConditions,
//       'submission_deadline': registrationDeadline.toIso8601String(),
//       'status': stateOfTender.name,
//       'estimated_budget': budget,
//     };
//   }
// }

// StateOfTender parseStateOfTender(String value) {
//   switch (value) {
//     case 'opened':
//       return StateOfTender.opened;
//     case 'closed':
//       return StateOfTender.closed;
//     case 'progress':
//       return StateOfTender.progress;
//     default:
//       throw Exception('Unknown state: $value');
//   }
// }

// // import 'dart:io';
// // import 'package:flutter/material.dart';
// // import 'package:uuid/uuid.dart';
// // import 'package:intl/intl.dart';

// // const uuid = Uuid();
// // final dateFormat = DateFormat.yMd();

// // enum StateOfTender { opened, closed, progress }

// // class Tender {
// //   final String? id;
// //   final String title;
// //   final String descripe;
// //   final String location;
// //   final int implementationPeriod; //عدد ايام التنفيذ
// //   final int numberOfTechnicalConditions; //عدد القيود الفنية
// //   final DateTime registrationDeadline; //اخر موعد للتسجيل
// //   final StateOfTender stateOfTender; //حالة المناقصة
// //   // final String? technicalFileUrl;

// //   // final DateTime expectedStartTime; //الوقت المتوقع للبدء
// //   final double budget; //الميزانية
// //   final File? technicalFile;

// //   Tender({
// //     this.id,
// //     required this.title,
// //     required this.descripe,
// //     required this.location,
// //     required this.implementationPeriod,
// //     required this.numberOfTechnicalConditions,
// //     required this.registrationDeadline,
// //     required this.stateOfTender,
// //     // required this.expectedStartTime,
// //     required this.budget,
// //     // this.technicalFileUrl,
// //     this.technicalFile,
// //   });
// //   // : id = uuid.v4();
// //   factory Tender.fromJson(Map<String, dynamic> json) {
// //     return Tender(
// //       id: json['id']?.toString(),
// //       title: json['title'] ?? '',
// //       descripe: json['description'] ?? '',
// //       location: json['location'] ?? '',
// //       implementationPeriod: json['execution_duration_days'] ?? '',
// //       numberOfTechnicalConditions: json['technical_requirements_count'] ?? '',
// //       registrationDeadline: DateFormat(
// //         "yyyy-MM-dd",
// //       ).parse(json['submission_deadline']),
// //       stateOfTender: parseStateOfTender(json['status']),
// //       // expectedStartTime: DateFormat(
// //       //   "yyyy-MM-dd HH:mm:ss",
// //       // ).parse(json['expectedStartTime']),
// //       budget: double.tryParse(json['estimated_budget'].toString()) ?? 0.0,
// //     );
// //   }
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'title': title,
// //       'description': descripe,
// //       'location': location,
// //       'execution_duration_days': implementationPeriod,
// //       'technical_requirements_count': numberOfTechnicalConditions,
// //       'submission_deadline': registrationDeadline.toIso8601String(),
// //       'status': stateOfTender.name,
// //       // 'expectedStartTime': tender.expectedStartTime.toIso8601String(),
// //       'estimated_budget': budget,
// //     };
// //   }
// // }

// // StateOfTender parseStateOfTender(String value) {
// //   switch (value) {
// //     case 'opened':
// //       return StateOfTender.opened;
// //     case 'closed':
// //       return StateOfTender.closed;
// //     default:
// //       throw Exception('Unknown state : $value');
// //   }
// // }
