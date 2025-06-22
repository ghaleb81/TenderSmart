import 'package:firebase_core/firebase_core.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:tendersmart/new_tender.dart';
import 'package:tendersmart/services/firebase_messaging_service.dart';
import 'package:tendersmart/tenders_list.dart';
import 'splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ar'); // هذا مهم لدعم التاريخ باللغة العربية
  //  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessagingService().init(); // إشعارات FCM
  runApp(const TenderApp());
}

class TenderApp extends StatelessWidget {
  const TenderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: const Locale('ar'),
      title: 'Tender App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue, fontFamily: 'Cairo'),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(),
        '/loginScreen': (context) => LoginScreen(), // بدون تمرير دوال
        '/tendersScreen': (context) => TenderListPage(), // كذلك هنا
        '/add_Bid': (context) => AddBid(),
        '/newTender': (context) => NewTender(),
      },
    );
  }
}

// void main() {
//   runApp(const MainScreen());
// }

// class TenderApp extends StatelessWidget {
//   const TenderApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MainScreen;
//     // MaterialApp(

//     // );
//   }
// }
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key});

//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }

// class _MainScreenState extends State<MainScreen> {
//   Widget? activeScreen;
//   // @override
//   // void initState() {
//   //   super.initState();
//   //   activeScreen = LoginScreen(
//   //     switchScreenToTenders: switchScreenToTenders,
//   //     // addContractor: _addContractor,
//   //   );
//   // }

//   void switchScreenToTenders() {
//     setState(() {
//       activeScreen = TenderListPage();
//       // Tenders(
//       //   // currentTenders: _currentTenders,
//       //   // bids: bidContractor,
//       //   // addBid: _addBid,
//       //   // addContractor: _addContractor,
//       //   switchScreenToTenders: switchScreenToTenders,
//       //   // currentUserRole: currentUserRole,
//       // );
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
//         '/loginScreen':
//             (context) =>
//                 LoginScreen(switchScreenToTenders: switchScreenToTenders),
//         '/login': (context) => MainScreen(),
//         '/tendersScreen':
//             (context) =>
//                 TenderListPage(switchScreenToTenders: switchScreenToTenders),
//         '/add_Bid': (context) => AddBid(),
//         '/newTender': (context) => NewTender(),
//         // '/tenders':
//         //     (context) => Tenders(switchScreenToTenders: switchScreenToTenders),
//       },
//       // home: Expanded(
//       //   child: Container(
//       //     decoration: BoxDecoration(
//       //       gradient: LinearGradient(
//       //         colors: [Colors.indigo, Colors.purpleAccent],
//       //       ),
//       //     ),
//       //     child: activeScreen,
//       //   ),
//       // ),
//     );
//   }
// }
