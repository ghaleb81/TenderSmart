import 'package:firebase_core/firebase_core.dart';
import 'package:tendersmart/widgets/add_bid.dart';
import 'package:flutter/material.dart';
import 'package:tendersmart/widgets/login_screen.dart';
import 'package:tendersmart/widgets/new_tender.dart';
import 'package:tendersmart/widgets/tenders_list.dart';
import 'widgets/splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeDateFormatting('ar');

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
        '/loginScreen': (context) => LoginScreen(),
        '/tendersScreen': (context) => TenderListPage(),
        '/add_Bid': (context) => AddBid(),
        '/newTender': (context) => NewTender(),
      },
    );
  }
}
