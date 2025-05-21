import 'package:flutter/material.dart';
import 'package:tendersmart/login_screen.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/tender_details.dart';
import 'package:tendersmart/tenders.dart';

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
      // expectedStartTime: DateTime(2025, 12, 4),
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
      // expectedStartTime: DateTime(2025, 23, 4),
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
      // expectedStartTime: DateTime(2025, 23, 4),
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
      // expectedStartTime: DateTime(2025, 23, 4),
      budget: 3333333,
    ),
  ];
  final List<Bid> bidContractor = [
    Bid(bidAmount: 3222, completionTimeExcepted: 2, technicalMatchedCount: 5),
    Bid(bidAmount: 444, completionTimeExcepted: 3, technicalMatchedCount: 3),
    Bid(bidAmount: 111, completionTimeExcepted: 4, technicalMatchedCount: 9),
  ];
  final List<Contractor> contractorList = [
    Contractor(
      companyName: 'It Company',
      commercialRegistrationNumber: 4,
      companyEmail: 'ghalebmarwa@gmail.com',
      countryCity: 'Damas',
      phoneNumber: '0992824259',
      yearEstablished: DateTime(2010),
      projectsLast5Years: 9,
      qualityCertificates: 'qualityCertificates',
      publicSectorSuccessfulContracts: 'publicSectorSuccessfulContracts',
      websiteUrlOrLinkedinProfile: 'websiteUrlOrLinkedinProfile',
      companyBio: 'companyBio',
      uploadOfficialDocumentsAmount: 'uploadOfficialDocumentsAmount',
      email: 'email',
      password: 'password',
    ),
    Contractor(
      companyName: 'QR Company',
      commercialRegistrationNumber: 2,
      companyEmail: 'eyadalkhateb@gmail.com',
      countryCity: 'EAU',
      phoneNumber: '22333',
      yearEstablished: DateTime(2010),
      projectsLast5Years: 9,
      qualityCertificates: 'qualityCertificates',
      publicSectorSuccessfulContracts: 'publicSectorSuccessfulContracts',
      websiteUrlOrLinkedinProfile: 'websiteUrlOrLinkedinProfile',
      companyBio: 'companyBio',
      uploadOfficialDocumentsAmount: 'uploadOfficialDocumentsAmount',
      email: 'email',
      password: 'password',
    ),
    Contractor(
      companyName: 'MCQ Company',
      commercialRegistrationNumber: 5,
      companyEmail: 'marwa@gmail.com',
      countryCity: 'Syria',
      phoneNumber: '32323111',
      yearEstablished: DateTime(2010),
      projectsLast5Years: 3,
      qualityCertificates: 'qualityCertificates',
      publicSectorSuccessfulContracts: 'publicSectorSuccessfulContracts',
      websiteUrlOrLinkedinProfile: 'websiteUrlOrLinkedinProfile',
      companyBio: 'companyBio',
      uploadOfficialDocumentsAmount: 'uploadOfficialDocumentsAmount',
      email: 'email',
      password: 'password',
    ),
  ];
  String currentUserRole = 'admin';
  void _addBid(Bid bid) {
    setState(() {
      bidContractor.add(bid);
    });
  }

  void _addContractor(Contractor contractor) {
    setState(() {
      contractorList.add(contractor);
    });
  }

  @override
  void initState() {
    super.initState();
    activeScreen = LoginScreen(
      switchScreenToTenders: switchScreenToTenders,
      addContractor: _addContractor,
    );
  }

  void switchScreenToTenders() {
    setState(() {
      activeScreen = Tenders(
        currentTenders: _currentTenders,
        bids: bidContractor,
        addBid: _addBid,
        addContractor: _addContractor,
        switchScreenToTenders: switchScreenToTenders,
        currentUserRole: currentUserRole,
      );
    });
  }

  void switchScreenToTenderDetails() {
    setState(() {
      activeScreen = TenderDetails(
        tender: _currentTenders[0],
        bids: bidContractor,
        addBid: _addBid,
        currentUserRole: currentUserRole,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.purpleAccent],
          ),
        ),
        child: activeScreen,
      ),
    );
  }
}
