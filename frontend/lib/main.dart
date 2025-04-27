// import 'dart:developer';
import 'package:tendersmart/login_screen.dart';
import 'package:tendersmart/mainScreen.dart';
import 'package:tendersmart/models/Tender.dart';

// import 'package:flutter/material.dart';
import 'package:tendersmart/mainScreen.dart';
import 'package:tendersmart/tenders.dart';

// void main() {
//   runApp(const MainApp());
// }

// // class AddBid extends StatefulWidget {
// //   const AddBid({super.key});

// //   @override
// //   State<AddBid> createState() => _AddBidState();
// // }

// // class _AddBidState extends State<AddBid> {
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold();
// //   }
// // }

// class MainApp extends StatefulWidget {
//   const MainApp({super.key});

//   @override
//   State<MainApp> createState() => _MainAppState();
// }

// class _MainAppState extends State<MainApp> {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Tender Smart',
//       home: MainScreen(),
//     );
//   }
// }

// import 'package:flutter/material.dart';

// void main() => runApp(MyApp());

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'قائمة المناقصات',
//       home: MainScreen(),
//       // home: Scaffold(
//       //   appBar: AppBar(
//       //     centerTitle: true,
//       //     backgroundColor: Colors.blue,
//       //     title: const Text('Tender Smart'),
//       //     // leading: Icon(Icons.add),//leading هي الاشياء التي اريد عرضها قبل العنوان من جهة اليسار
//       //     actions: [
//       //       Text('إضافة مناقصة'),
//       //       //Icon(Icons.add),
//       //       IconButton(
//       //         onPressed: () {
//       //           // log(_currentTenders.length.toString());
//       //           //showModalBottomSheet(context: context, builder:(ctx)=>)
//       //           // showModalBottomSheet(
//       //           //   context: context,
//       //           //   // builder: (ctx) => NewExpense(onAddExpense: _addExpense),
//       //           // );
//       //         },
//       //         icon: Icon(Icons.add),
//       //       ),
//       //     ],
//       //   ),
//       //   body: MainScreen(),
//       // ),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// // class Tender {
// //   final String title;
// //   final String number;
// //   final String requester;
// //   final String closingDate;

// //   Tender({
// //     required this.title,
// //     required this.number,
// //     required this.requester,
// //     required this.closingDate,
// //   });
// // }

// // class TenderListPage extends StatelessWidget {
// //   // final List<Tender> tenders = [
// //   //   Tender(
// //   //     title: "توريد معدات طبية",
// //   //     descripe: "MN-2025-001",
// //   //     location: "وزارة الصحة",
// //   //     budget: 3,
// //   //     implementationPeriod: 3,
// //   //     numberOfTechnicalConditions: 3,
// //   //   ),
// //   //   Tender(
// //   //     title: "مشروع صيانة طرق",
// //   //     descripe: "MN-2025-002",
// //   //     location: "وزارة النقل",
// //   //     budget: 3,
// //   //     implementationPeriod: 3,
// //   //     numberOfTechnicalConditions: 3,
// //   //   ),
// //   //   Tender(
// //   //     title: "إنشاء مبنى حكومي",
// //   //     descripe: "MN-2025-003",
// //   //     location: "وزارة الأشغال",
// //   //     budget: 3,
// //   //     implementationPeriod: 3,
// //   //     numberOfTechnicalConditions: 3,
// //   //   ),
// //   //   Tender(
// //   //     title: "تطوير نظام معلومات",
// //   //     descripe: "MN-2025-004",
// //   //     location: "وزارة الاتصالات",
// //   //     budget: 3,
// //   //     implementationPeriod: 3,
// //   //     numberOfTechnicalConditions: 3,
// //   //   ),
// //   //   Tender(
// //   //     title: "شراء مواد قرطاسية",
// //   //     descripe: "MN-2025-005",
// //   //     location: "وزارة التعليم",
// //   //     budget: 3,
// //   //     implementationPeriod: 3,
// //   //     numberOfTechnicalConditions: 3,
// //   //   ),
// //   // ];

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: Text('المناقصات الحالية')),
// //       body: ListView.builder(
// //         itemCount: tenders.length,
// //         itemBuilder: (context, index) {
// //           final tender = tenders[index];
// //           return Card(
// //             margin: EdgeInsets.all(10),
// //             elevation: 4,
// //             shape: RoundedRectangleBorder(
// //               borderRadius: BorderRadius.circular(12),
// //             ),
// //             child: Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 children: [
// //                   Text(
// //                     tender.title,
// //                     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                   ),
// //                   SizedBox(height: 8),
// //                   Text("رقم المناقصة: ${tender.descripe}"),
// //                   Text("الجهة الطالبة: ${tender.location}"),
// //                   Text("تاريخ الإغلاق: ${tender.numberOfTechnicalConditions}"),
// //                 ],
// //               ),
// //             ),
// //           );
// //         },
// //       ),
// //     );
// //   }
// // }

import 'package:flutter/material.dart';
import 'splash_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(const TenderApp());
}

class TenderApp extends StatelessWidget {
  const TenderApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      // supportedLocales: const [Locale('ar', ''), Locale('en', '')],
      // localizationsDelegates: [
      //   GlobalMaterialLocalizations.delegate,
      //   GlobalWidgetsLocalizations.delegate,
      //   GlobalCupertLocalizations.delegate,

      // ],
      title: 'Tender App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Cairo', // (اختياري لخط عربي أجمل)
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => MainScreen(),
      },
    );
  }
}
