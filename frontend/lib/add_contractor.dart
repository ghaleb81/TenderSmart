import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/auth_service.dart';
import 'package:tendersmart/services/contractor_service.dart';
// import 'package:tendersmart/screens/contractor_information.dart';

final _companyNameController = TextEditingController();
final _commercialRegistrationNumberController = TextEditingController();
final _companyEmailController = TextEditingController();
final _countryCityController = TextEditingController();
final _phoneNumberController = TextEditingController();
final _yearEstablishedController = TextEditingController();
final _projectsLast5YearsController = TextEditingController();
final _qualityCertificatesController = TextEditingController();
final _publicSectorSuccessfulContractsController = TextEditingController();
final _websiteUrlLinkedinProfileController = TextEditingController();
final _companyBioController = TextEditingController();
final _uploadOfficialDocumentsAmountController = TextEditingController();

class AddContractor extends StatefulWidget {
  AddContractor({super.key, this.addContractor});
  void Function(Contractor contractor)? addContractor;

  @override
  State<AddContractor> createState() => _AddContractorState();
}

class _AddContractorState extends State<AddContractor> {
  void _saveContractor() async {
    try {
      if (_companyNameController.text.isEmpty ||
          _commercialRegistrationNumberController.text.isEmpty ||
          _companyEmailController.text.isEmpty) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('يرجى تعبئة جميع الحقول')));
        return;
      }

      final contractor = Contractor(
        companyName: _companyNameController.text,
        commercialRegistrationNumber: int.parse(
          _commercialRegistrationNumberController.text,
        ),
        companyEmail: _companyEmailController.text,
        countryCity: _countryCityController.text,
        phoneNumber: _phoneNumberController.text,
        yearEstablished: DateFormat.yMd().parse(
          _yearEstablishedController.text,
        ),
        projectsLast5Years: int.parse(_projectsLast5YearsController.text),
        qualityCertificates: _qualityCertificatesController.text,
        publicSectorSuccessfulContracts:
            _publicSectorSuccessfulContractsController.text,
        websiteUrlOrLinkedinProfile: _websiteUrlLinkedinProfileController.text,
        companyBio: _companyBioController.text,
        uploadOfficialDocumentsAmount:
            _uploadOfficialDocumentsAmountController.text,
        email: '', // غير ضروري هنا، مسجل مسبقاً
        password: '', // غير ضروري هنا، مسجل مسبقاً
      );

      bool success = await ContractorService.saveContractorInfo(contractor);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حفظ بيانات المقاول بنجاح')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل في حفظ البيانات')));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ: ${e.toString()}')));
    }
  }

  // try {
  //   final contractor = Contractor(
  //     companyName: _companyNameController.text,
  //     commercialRegistrationNumber: int.parse(
  //       _commercialRegistrationNumberController.text,
  //     ),
  //     companyEmail: _companyEmailController.text,
  //     countryCity: _countryCityController.text,
  //     phoneNumber: _phoneNumberController.text,
  //     yearEstablished: DateFormat.yMd().parse(
  //       _yearEstablishedController.text,
  //     ),
  //     projectsLast5Years: int.parse(_projectsLast5YearsController.text),
  //     qualityCertificates: _qualityCertificatesController.text,
  //     publicSectorSuccessfulContracts:
  //         _publicSectorSuccessfulContractsController.text,
  //     websiteUrlOrLinkedinProfile: _websiteUrlLinkedinProfileController.text,
  //     companyBio: _companyBioController.text,
  //     uploadOfficialDocumentsAmount:
  //         _uploadOfficialDocumentsAmountController.text,
  //     email: '', // ستحصل على البريد من المستخدم المسجل حالياً
  //     password: '', // لن يتم حفظها هنا عادةً
  //   );

  //   final success = await AuthService_Login.sendContractorData(contractor);

  //   if (success) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => Text('data'),
  //         //  AddBid()
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('فشل في حفظ بيانات المقاول')));
  //   }
  // } catch (e) {
  //   ScaffoldMessenger.of(
  //     context,
  //   ).showSnackBar(SnackBar(content: Text('خطأ: ${e.toString()}')));
  // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اهلاً بك'), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text(': اسم الشركة')),
              controller: _companyNameController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': رقم السجل التجاري/الترخيص'),
              ),
              controller: _commercialRegistrationNumberController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': البريد الإلكتروني للشركة'),
              ),
              controller: _companyEmailController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': الدولة/المدينة')),
              controller: _countryCityController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': رقم الهاتف')),
              controller: _phoneNumberController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': سنة تأسيس الشركة')),
              controller: _yearEstablishedController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': عدد المشاريع المنفذة آخر 5 سنوات'),
              ),
              controller: _projectsLast5YearsController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': شهادات الجودة')),
              controller: _qualityCertificatesController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': العقود الناجحة للقطاع العام'),
              ),
              controller: _publicSectorSuccessfulContractsController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': Website url/linkedin Profile'),
              ),
              controller: _websiteUrlLinkedinProfileController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': وصف الشركة')),
              controller: _companyBioController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': تحميل الوثائق الرسمية'),
              ),
              controller: _uploadOfficialDocumentsAmountController,
              maxLength: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
                  ),
                  onPressed: _saveContractor,
                  child: Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:tendersmart/models/contractor.dart';
// import 'package:tendersmart/services/auth_service.dart';

// final _companyNameController = TextEditingController();
// final _commercialRegistrationNumberController = TextEditingController();
// final _companyEmailController = TextEditingController();
// final _countryCityController = TextEditingController();
// final _phoneNumberController = TextEditingController();
// final _yearEstablishedController = TextEditingController();
// final _projectsLast5YearsController = TextEditingController();
// final _qualityCertificatesController = TextEditingController();
// final _publicSectorSuccessfulContractsController = TextEditingController();
// final _websiteUrlLinkedinProfileController = TextEditingController();
// final _companyBioController = TextEditingController();
// final _uploadOfficialDocumentsAmountController = TextEditingController();

// class AddContractor extends StatefulWidget {
//   AddContractor({super.key, required this.addContractor});
//   void Function(Contractor contractot) addContractor;
//   @override
//   State<AddContractor> createState() => _AddContractorState();
// }

// class _AddContractorState extends State<AddContractor> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('اهلاً بك'), backgroundColor: Colors.blue),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(label: Text(': اسم الشركة')),
//               // onChanged: _saveChangeTitle,
//               controller: _companyNameController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': رقم السجل التجاري/الترخيص'),
//               ),
//               // onChanged: _saveChangeTitle,
//               controller: _commercialRegistrationNumberController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': البريد الإلكتروني للشركة'),
//               ),
//               // onChanged: _saveChangeTitle,
//               controller: _companyEmailController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': الدولة/المدينة')),
//               // onChanged: _saveChangeTitle,
//               controller: _countryCityController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': رقم الهاتف')),
//               // onChanged: _saveChangeTitle,
//               controller: _phoneNumberController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': سنة تأسيس الشركة')),
//               // onChanged: _saveChangeTitle,
//               controller: _yearEstablishedController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': عدد المشاريع المنفذة آخر 5 سنوات'),
//               ),
//               // onChanged: _saveChangeTitle,
//               controller: _projectsLast5YearsController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': شهادات الجودة')),
//               // onChanged: _saveChangeTitle,
//               controller: _qualityCertificatesController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': العقود الناجحة للقطاع العام'),
//               ),
//               // onChanged: _saveChangeTitle,
//               controller: _publicSectorSuccessfulContractsController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': Website url/linkedin Profile'),
//               ),
//               // onChanged: _saveChangeTitle,
//               controller: _websiteUrlLinkedinProfileController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': وصف الشركة')),
//               // onChanged: _saveChangeTitle,
//               controller: _companyBioController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': تحميل الوثائق الرسمية'),
//               ),
//               // onChanged: _saveChangeTitle,
//               controller: _uploadOfficialDocumentsAmountController,
//               maxLength: 50,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
//                   ),
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Cancel'),
//                 ),
//                 SizedBox(width: 5),
//                 ElevatedButton(
//                   style: ButtonStyle(
//                     backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
//                   ),
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder:
//                             (context) => ContractorInformation(
//                               // addContractor: widget.addContractor,
//                             ),
//                       ),
//                     );
//                   },
//                   child: Text('Save'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ContractorInformation extends StatefulWidget {
  ContractorInformation({super.key});
  // void Function(Contractor contractor) addContractor;
  @override
  State<ContractorInformation> createState() => _ContractorInformationState();
}

class _ContractorInformationState extends State<ContractorInformation> {
  // Controllers لتخزين القيم
  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileController = TextEditingController();
  bool isChecked = false;

  @override
  void dispose() {
    // إفراغ الـ Controllers عند إغلاق الصفحة
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void onContinuePressed() {
    final fullName = fullNameController.text;
    final email = emailController.text;
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;
    final mobile = mobileController.text;

    // هنا يمكنك طباعة أو إرسال البيانات إلى الباكند
    print('Full Name: $fullName');
    print('Email: $email');
    print('Password: $password');
    print('Confirm Password: $confirmPassword');
    print('Mobile: $mobile');
    print('Terms Accepted: $isChecked');

    // تنقل إلى شاشة التحقق
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CodeVerificationScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // رأس الصفحة مع صورة
            Image.asset(
              'images/image_1.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Full Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  TextField(
                    controller: mobileController,
                    decoration: const InputDecoration(
                      labelText: 'Mobile No.',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      Checkbox(
                        value: isChecked,
                        onChanged: (v) {
                          setState(() {
                            isChecked = v ?? false;
                          });
                        },
                      ),
                      const Expanded(
                        child: Text('I agree to Terms and Conditions'),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: onContinuePressed,
                    child: const Text('CONTINUE'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// final _emailController = TextEditingController();
// final _passwordController = TextEditingController();
// final _nameController = TextEditingController();
// final _phoneController = TextEditingController();
// void _submit() async {
//   String email = _emailController.text;
//   String password = _passwordController.text;
//   String name = _nameController.text;
//   String phone = _phoneController.text;

//   if (email.isEmpty || password.isEmpty || name.isEmpty || phone.isEmpty) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('يرجى ملء جميع الحقول')));
//     return;
//   }

//   bool success = await AuthService_Login.register(
//     name: name,
//     phone: phone,
//     email: email,
//     password: password,
//   );

//   if (success) {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('تم التسجيل بنجاح')));
//     Navigator.pop(context);
//   } else {
//     ScaffoldMessenger.of(
//       context,
//     ).showSnackBar(SnackBar(content: Text('فشل التسجيل')));
//   }
// }

// @override
// Widget build(BuildContext context) {
//   return Scaffold(
//     body: SingleChildScrollView(
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(colors: [Colors.blue, Colors.indigo]),
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': الإسم', textAlign: TextAlign.center),
//               ),
//               keyboardType: TextInputType.name,
//               controller: _nameController,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(':  رقم الهاتف', textAlign: TextAlign.center),
//               ),
//               keyboardType: TextInputType.phone,
//               controller: _phoneController,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(
//                   ': البريد الإلتروني',
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//               keyboardType: TextInputType.emailAddress,
//               controller: _emailController,
//             ),
//             TextField(
//               textAlign: TextAlign.end,
//               decoration: InputDecoration(label: Text(': كلمة المرور')),
//               // keyboardType: TextInputType.visiblePassword,
//               obscureText: true,
//               controller: _passwordController,
//             ),
//             SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 ElevatedButton(
//                   onPressed: () {
//                     _submit();
//                     // Navigator.pop(context);
//                   },
//                   child: Text('Save'),
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.pop(context);
//                   },
//                   child: Text('Cancel'),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
//}
class CodeVerificationScreen extends StatelessWidget {
  const CodeVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final codeController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Verify Code')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/tender_smart_header.png',
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('Enter the verification code sent to your email'),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Verification Code',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final code = codeController.text;
                print('Verification Code: $code');
              },
              child: const Text('VERIFY Code'),
            ),
          ],
        ),
      ),
    );
  }
}
