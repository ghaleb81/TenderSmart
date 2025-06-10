import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final dateFormat = DateFormat.yMd();

enum StateOfTender { opened, closed, progress }

class Tender {
  final String? id;
  final String title;
  final String descripe;
  final String location;
  final int implementationPeriod; //عدد ايام التنفيذ
  final int numberOfTechnicalConditions; //عدد القيود الفنية
  final DateTime registrationDeadline; //اخر موعد للتسجيل
  final StateOfTender stateOfTender; //حالة المناقصة
  // final DateTime expectedStartTime; //الوقت المتوقع للبدء
  final double budget; //الميزانية

  Tender({
    this.id,
    required this.title,
    required this.descripe,
    required this.location,
    required this.implementationPeriod,
    required this.numberOfTechnicalConditions,
    required this.registrationDeadline,
    required this.stateOfTender,
    // required this.expectedStartTime,
    required this.budget,
  });
  // : id = uuid.v4();
  factory Tender.fromJson(Map<String, dynamic> json) {
    return Tender(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      descripe: json['description'] ?? '',
      location: json['location'] ?? '',
      implementationPeriod: json['execution_duration_days'] ?? '',
      numberOfTechnicalConditions: json['technical_requirements_count'] ?? '',
      registrationDeadline: DateFormat(
        "yyyy-MM-dd",
      ).parse(json['submission_deadline']),
      stateOfTender: parseStateOfTender(json['status']),
      // expectedStartTime: DateFormat(
      //   "yyyy-MM-dd HH:mm:ss",
      // ).parse(json['expectedStartTime']),
      budget: double.tryParse(json['estimated_budget'].toString()) ?? 0.0,
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
      // 'expectedStartTime': tender.expectedStartTime.toIso8601String(),
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
    default:
      throw Exception('Unknown state : $value');
  }
}
