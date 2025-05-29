import 'package:flutter/material.dart';
import 'package:tendersmart/add_contractor.dart';
import 'package:tendersmart/services/auth_service.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'package:tendersmart/tenders.dart';

// class Loginscreen extends StatelessWidget {
//   const Loginscreen(this.switchScreenToNewTender, {super.key});

//   final Function() switchScreenToNewTender;

//   @override
//   Widget build(BuildContext context) {

class LoginScreen extends StatefulWidget {
  LoginScreen({
    super.key,
    required this.switchScreenToTenders,
    required this.addContractor,
  });
  // LoginScreen(this.switchScreenToNewTender, {Key? key}) : super(key: key);
  final Function() switchScreenToTenders;
  void Function(Contractor contractor) addContractor;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور')),
      );
      return;
    }
    if (!ContractorValidator.isEmailValid(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى إدخال بريد الإلكتروني صالح ')),
      );
      return;
    }
    final result = await AuthService_Login.login(email, password);

    if (result != null) {
      widget.switchScreenToTenders();
      final token = result['token'];
      final role = result['role'];
      await TokenStorage.saveToken(token);
      await TokenStorage.saveRole(role);
      if ((TokenStorage.getRole()) == 'contractor') {
        final contractorId = result['contractor_id'];
        await TokenStorage.saveRole(contractorId);
        print('تم تسجيل الدخول، contractor Id: $contractorId');
      }
      print('تم تسجيل الدخول، التوكن: $token');
      print('تم تسجيل الدخول، role: $role');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        // SnackBar(content: Text('فشل تسجيل الدخول')),
        SnackBar(content: Text('البريد الإلكتروني أو كلمة المرور غير صحيحة')),
      );
    }
  }

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
                controller: emailController,
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
                controller: passwordController,
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
                  onPressed: () {
                    // handleLogin();
                    widget.switchScreenToTenders();
                    // async {
                    // final email = emailController.text.trim();
                    // final password = passwordController.text.trim();
                    // if (email.isEmpty || password.isEmpty) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text(
                    //         'يرجى إدخال البريد الإلكتروني وكلمة المرور',
                    //       ),
                    //     ),
                    //   );
                    //   return;
                    // }
                    // if (!ContractorValidator.isEmailValid(email)) {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     SnackBar(
                    //       content: Text('يرجى إدخال بريد الإلكتروني صالح '),
                    //     ),
                    //   );
                    //   return;
                    // }
                    // final result = await AuthService_Login.login(
                    //   email,
                    //   password,
                    // );

                    // if (result != null) {
                    //   widget.switchScreenToTenders();
                    //   final token = result['token'];
                    //   final role = result['role'];
                    //   await TokenStorage.saveToken(token);
                    //   await TokenStorage.saveRole(role);
                    //   if ((TokenStorage.getRole()) == 'contractor') {
                    //     final contractorId = result['contractor_id'];
                    //     await TokenStorage.saveRole(contractorId);
                    //     print('تم تسجيل الدخول، contractor Id: $contractorId');
                    //   }
                    //   print('تم تسجيل الدخول، التوكن: $token');
                    //   print('تم تسجيل الدخول، role: $role');
                    // } else {
                    //   ScaffoldMessenger.of(context).showSnackBar(
                    //     // SnackBar(content: Text('فشل تسجيل الدخول')),
                    //     SnackBar(
                    //       content: Text(
                    //         'البريد الإلكتروني أو كلمة المرور غير صحيحة',
                    //       ),
                    //     ),
                    //   );
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.black,
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ContractorInformation(),
                          //  AddContractor(
                          //   addContractor: widget.addContractor,
                          // ),
                        ),
                      );
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
 // async {
                    //   final email = emailController.text.trim();
                    //   final password = passwordController.text.trim();

                    //   if (email.isEmpty || password.isEmpty) {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       SnackBar(
                    //         content: Text(
                    //           'يرجى إدخال البريد الإلكتروني وكلمة المرور',
                    //         ),
                    //       ),
                    //     );
                    //     return;
                    //   }

                    //   final result = await AuthService_Login.login(
                    //     email,
                    //     password,
                    //   ); // أو AuthService_Login حسب ما عندك فعليًا

                    //   if (result != null) {
                    //     final token = result['token'];
                    //     final role = result['role'];

                    //     await TokenStorage.saveToken(token);
                    //     await TokenStorage.saveRole(role);

                    // بعد نجاح تسجيل الدخول ننتقل لصفحة Tenders
                    // widget.switchScreenToTenders();
                  

                  //     print('تم تسجيل الدخول، التوكن: $token');
                  //   } else {
                  //     ScaffoldMessenger.of(context).showSnackBar(
                  //       SnackBar(content: Text('فشل تسجيل الدخول')),
                  //     );
                  //   }
                  // },