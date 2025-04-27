import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tendersmart/login_screen.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/new_tender.dart';
import 'package:tendersmart/tender_details.dart';
import 'package:tendersmart/tenders.dart';
import 'package:tendersmart/tenders_list.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Widget? activeScreen;
  final List<Tender> _currentTenders = [
    Tender(
      title: 'إدارة مقصف كلية الهندسة المعلوماتية',
      descripe:
          'كلية المعلوماتية التابعة لجامعة الشام الخاصة بحاجة لاستثمار للمقصف بداخلها وادارة خدمة الطلاب على مدار دوام الكلية من الساعة 8 صباحاً حتى 3 عصراً',
      location: 'ريف دمشق_التل',
      implementationPeriod: 15,
      numberOfTechnicalConditions: 3,
      registrationDeadline: DateTime(2025, 23, 4),
      stateOfTender: StateOfTender.opened,
      expectedStartTime: DateTime(2025, 12, 4),
      budget: 400000.33,
    ),
    Tender(
      title: 'إدارة المركز الطبي في جامعة الشام الخاصة',
      descripe:
          'جامعة الشام الخاصة بحاجة لاستثمار للمركز الطبي بداخلها وادارة خدمة المرضى على مدار دوام الكلية من الساعة 8 صباحاً حتى 4 عصراً',
      location: 'ريف دمشق_التل',
      implementationPeriod: 20,
      numberOfTechnicalConditions: 7,
      registrationDeadline: DateTime(2025, 23, 4),
      stateOfTender: StateOfTender.opened,
      expectedStartTime: DateTime(2025, 23, 4),
      budget: 33333.222,
    ),
    Tender(
      title: 'إدارة مكتبة في كلية الطب البشري',
      descripe: 'descripe',
      location: 'ريف دمشق_التل',
      implementationPeriod: 10,
      numberOfTechnicalConditions: 9,
      registrationDeadline: DateTime(2025, 23, 4),
      stateOfTender: StateOfTender.opened,
      expectedStartTime: DateTime(2025, 23, 4),
      budget: 2220022,
    ),
    Tender(
      title: 'توريد مستلزمات طبية لكلية طب الأسنان',
      descripe: 'descripe',
      location: 'دمشق_المزرعة',
      implementationPeriod: 28,
      numberOfTechnicalConditions: 5,
      registrationDeadline: DateTime(2025, 23, 4),
      stateOfTender: StateOfTender.opened,
      expectedStartTime: DateTime(2025, 23, 4),
      budget: 3333333,
    ),
  ];
  // void onDeleteTender(Tender tender) {
  //   setState(() {
  //     _currentTenders.remove(tender);
  //   });
  // }

  // @override
  // void setState() {

  //   TenderListPage(
  //     onDeleteTender: onDeleteTender,
  //     tenders: _currentTenders,
  //     showTenderDetails: switchScreenToTenderDetails,
  //   );
  // }

  @override
  void initState() {
    super.initState();
    activeScreen = LoginScreen(switchScreenToTenders);
  }

  void switchScreenToTenders() {
    setState(() {
      activeScreen = Tenders(
        switchScreenToTenders: switchScreenToTenderDetails,
        currentTenders: _currentTenders,
        // switchScreenToTender: switchScreenToTenders,
        // onDeleteTender: onDeleteTender,
      );
    });
  }

  void switchScreenToTenderDetails() {
    setState(() {
      activeScreen = TenderDetails(
        switchScreenToTenders: switchScreenToTenders,
        // tenders: _currentTenders,
        tender: _currentTenders[0],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.indigo, Colors.purpleAccent, // Colors.blue],
            ],
          ),
        ),
        child: activeScreen,
      ),
    );
  }
}
