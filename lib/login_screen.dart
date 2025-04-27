import 'package:flutter/material.dart';
import 'package:tendersmart/tenders.dart';

// class Loginscreen extends StatelessWidget {
//   const Loginscreen(this.switchScreenToNewTender, {super.key});

//   final Function() switchScreenToNewTender;

//   @override
//   Widget build(BuildContext context) {

class LoginScreen extends StatelessWidget {
  LoginScreen(this.switchScreenToNewTender, {Key? key}) : super(key: key);
  final Function() switchScreenToNewTender;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'أهلاً بك!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                  // color: Colors.teal[700],
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                decoration: InputDecoration(
                  labelText: 'البريد الإلكتروني',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // ضع هنا ما يحدث عند النقر على "نسيت كلمة المرور؟"
                  },
                  child: const Text('نسيت كلمة المرور؟'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: switchScreenToNewTender,

                  // ضع هنا منطق تسجيل الدخول
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
                    // backgroundColor: Colors.teal[700],
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('ليس لديك حساب؟'),
                  TextButton(
                    onPressed: () {
                      // الانتقال إلى صفحة التسجيل
                    },
                    child: const Text('سجّل الآن'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
    // return Center(
    //   child: Column(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     children: [
    //       ElevatedButton(
    //         onPressed: switchScreenToNewTender,
    //         child: const Text('Welcome in TenderSmart'),
    //       ),
    //     ],
    //   ),
    // );
  // }
// }

// import 'package:flutter/material.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final emailController = TextEditingController();
//     final passwordController = TextEditingController();

//     return Scaffold(
//       backgroundColor: Colors.grey.shade100,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "مرحباً بك",
//                 style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 "سجل الدخول للمتابعة",
//                 style: TextStyle(fontSize: 18, color: Colors.black54),
//               ),
//               const SizedBox(height: 40),
//               Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(16),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black12,
//                       blurRadius: 10,
//                       spreadRadius: 5,
//                     ),
//                   ],
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(24.0),
//                   child: Column(
//                     children: [
//                       TextField(
//                         controller: emailController,
//                         decoration: const InputDecoration(
//                           labelText: 'البريد الإلكتروني',
//                           prefixIcon: Icon(Icons.email_outlined),
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       TextField(
//                         controller: passwordController,
//                         obscureText: true,
//                         decoration: const InputDecoration(
//                           labelText: 'كلمة المرور',
//                           prefixIcon: Icon(Icons.lock_outline),
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       const SizedBox(height: 30),
//                       ElevatedButton(
//                         onPressed: () {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(
//                               content: Text('تم تسجيل الدخول بنجاح'),
//                             ),
//                           );
//                         },
//                         style: ElevatedButton.styleFrom(
//                           minimumSize: const Size.fromHeight(50),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: const Text(
//                           'تسجيل الدخول',
//                           style: TextStyle(fontSize: 18),
//                         ),
//                       ),
//                       const SizedBox(height: 15),
//                       TextButton(
//                         onPressed: () {
//                           // انتقال لصفحة تسجيل المورد لاحقًا
//                         },
//                         child: const Text('ليس لديك حساب؟ سجل كمورد'),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
