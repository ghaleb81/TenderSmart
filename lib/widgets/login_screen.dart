import 'package:flutter/material.dart';
import 'package:tendersmart/widgets/add_contractor.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/auth_service.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'package:tendersmart/services/firebase_messaging_service.dart'; // ⬅️ مهم

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Widget state = const Text('LOGIN', style: TextStyle(color: Colors.white));
  bool _obscurePassword = true;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void restate() {
    setState(() {
      state = const Text('LOGIN', style: TextStyle(color: Colors.white));
    });
  }

  void handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى إدخال البريد الإلكتروني وكلمة المرور'),
        ),
      );
      restate();
      return;
    }

    if (!ContractorValidator.isEmailValid(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى إدخال بريد إلكتروني صالح')),
      );
      restate();
      return;
    }

    final result = await AuthService.login(email, password);

    if (result != null) {
      final token = result['token'];
      final role = result['role'];
      final userId = result['user_id'];

      await TokenStorage.saveToken(token);
      await TokenStorage.saveRole(role);
      await TokenStorage.saveUserrId(userId.toString());

      await FirebaseMessagingService().init();

      Navigator.pushReplacementNamed(context, '/tendersScreen');
    } else {
      restate();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('البريد الإلكتروني أو كلمة المرور غير صحيحة'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset('images/image_2.jpg', fit: BoxFit.cover),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(
                  left: 32,
                  right: 32,
                  bottom: MediaQuery.of(context).viewInsets.bottom + 24,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white70,
                        hintText: 'Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          state = const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          );
                        });
                        handleLogin();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyan,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 16,
                        ),
                      ),
                      child: state,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ContractorInformation(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 75,
                          vertical: 16,
                        ),
                      ),
                      child: const Text(
                        'REGISTRATION',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: () async {
                        await AuthService.signInWithGoogle();
                      },
                      icon: const Icon(Icons.account_circle, size: 24),
                      label: const Text('Sign in with Google'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
