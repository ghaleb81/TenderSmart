import 'package:tendersmart/mainScreen.dart';
import 'package:flutter/material.dart';
import 'splash_screen.dart';

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
        '/': (context) => SplashScreen(),
        '/login': (context) => MainScreen(),
      },
    );
  }
}
