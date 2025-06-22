// import 'package:flutter/material.dart';
// import 'package:tendersmart/add_bid.dart';
// import 'package:tendersmart/login_screen.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/models/Tender.dart';
// import 'package:tendersmart/models/contractor.dart';
// import 'package:tendersmart/new_tender.dart';
// import 'package:tendersmart/splash_screen.dart';
// import 'package:tendersmart/tender_details.dart';
// import 'package:tendersmart/tenders.dart';
// import 'package:tendersmart/tenders_list.dart';

// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   Widget? activeScreen;
//   @override
//   void initState() {
//     super.initState();
//     activeScreen = LoginScreen(
//       switchScreenToTenders: switchScreenToTenders,
//       // addContractor: _addContractor,
//     );
//   }

//   void switchScreenToTenders() {
//     setState(() {
//       activeScreen = Tenders(
//         // currentTenders: _currentTenders,
//         // bids: bidContractor,
//         // addBid: _addBid,
//         // addContractor: _addContractor,
//         switchScreenToTenders: switchScreenToTenders,
//         // currentUserRole: currentUserRole,
//       );
//     });
//   }

//   // void switchScreenToTenderDetails() {
//   //   setState(() {
//   //     activeScreen = TenderDetails(
//   //       // tender: _currentTenders[0],
//   //       // bids: bidContractor,
//   //       // addBid: _addBid,
//   //       // currentUserRole: currentUserRole,
//   //     );
//   //   });
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       locale: const Locale('ar'),
//       // supportedLocales: const [Locale('ar', ''), Locale('en', '')],
//       // localizationsDelegates: [
//       //   GlobalMaterialLocalizations.delegate,
//       //   GlobalWidgetsLocalizations.delegate,
//       //   GlobalCupertLocalizations.delegate,

//       // ],
//       title: 'Tender App',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         fontFamily: 'Cairo', // (اختياري لخط عربي أجمل)
//       ),
//       initialRoute: '/',
//       routes: {
//         '/': (context) => SplashScreen(),
//         '/login': (context) => MainScreen(),
//         '/tendersScreen': (context) => TenderListPage(),
//         '/add_Bid': (context) => AddBid(),
//         '/newTender': (context) => NewTender(),
//       },
//       home: Expanded(
//         child: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.indigo, Colors.purpleAccent],
//             ),
//           ),
//           child: activeScreen,
//         ),
//       ),
//     );
//   }
// }
