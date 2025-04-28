import 'package:tendersmart/login_screen.dart';
import 'package:tendersmart/mainScreen.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/mainScreen.dart';
import 'package:tendersmart/tenders.dart';
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
