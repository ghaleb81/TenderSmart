import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tendersmart/main.dart';
// import 'start_screen.dart'; // تأكد من إنشاء هذه الصفحة

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/loginScreen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(
          'images/image_1.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     Timer(Duration(seconds: 3), () {
//       print('Navigating to login screen...');
//       Navigator.pushReplacementNamed(context, '/loginScreen');
//       // Navigator.pushReplacement(
//       //   context,
//       //   MaterialPageRoute(
//       //     builder:
//       //         (context) => Stack(
//       //           children: [Image.asset('images/image_1.jpg'), MainScreen()],
//       //         ),
//       //   ),
//       // );
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(
//         child: Image.asset(
//           'images/image_1.jpg', // ضع اسم الصورة التي رفعتها هنا
//           fit: BoxFit.cover,
//           width: double.infinity,
//           height: double.infinity,
//         ),
//       ),
//     );
//   }
// }
// import 'package:flutter/material.dart';
// import 'package:tendersmart/login_screen.dart';
// import 'package:tendersmart/mainScreen.dart';
// import 'login_screen.dart'; // تأكد أنك أضفتها

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);

//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _controller;
//   late Animation<double> _animation;

//   @override
//   void initState() {
//     super.initState();
//     _controller = AnimationController(
//       duration: const Duration(seconds: 2),
//       vsync: this,
//     )..forward();
//     _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

//     Future.delayed(const Duration(seconds: 3), () {
//       Navigator.of(context).pushReplacement(
//         PageRouteBuilder(
//           pageBuilder: (context, animation, secondaryAnimation) => MainScreen(),
//           // LoginScreen(),
//           transitionsBuilder: (context, animation, secondaryAnimation, child) {
//             var begin = const Offset(0.0, 1.0);
//             var end = Offset.zero;
//             var curve = Curves.ease;

//             var tween = Tween(
//               begin: begin,
//               end: end,
//             ).chain(CurveTween(curve: curve));
//             var offsetAnimation = animation.drive(tween);

//             return SlideTransition(position: offsetAnimation, child: child);
//           },
//         ),
//       );
//     });
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blueAccent,
//       body: FadeTransition(
//         opacity: _animation,
//         child: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(
//                 Icons.mark_email_read_rounded,
//                 size: 100,
//                 color: Colors.white,
//               ),
//               const SizedBox(height: 20),
//               Text(
//                 'منصة المناقصات الذكية',
//                 style: TextStyle(
//                   fontSize: 28,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                   letterSpacing: 1.5,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
