import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart';

const uuid = Uuid();
final dateFormat = DateFormat.yMd();

enum StateOfTender { opened, closed }

class Tender {
  final String id;
  final String title;
  final String descripe;
  final String location;
  final int implementationPeriod; //عدد ايام التنفيذ
  final int numberOfTechnicalConditions; //عدد القيود الفنية
  final DateTime registrationDeadline; //اخر موعد للتسجيل
  final StateOfTender stateOfTender; //حالة المناقصة
  final DateTime expectedStartTime; //الوقت المتوقع للبدء
  final double budget; //الميزانية

  Tender({
    required this.title,
    required this.descripe,
    required this.location,
    required this.implementationPeriod,
    required this.numberOfTechnicalConditions,
    required this.registrationDeadline,
    required this.stateOfTender,
    required this.expectedStartTime,
    required this.budget,
  }) : id = uuid.v4();
}
