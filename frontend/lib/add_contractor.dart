import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/auth_service.dart';
import 'package:tendersmart/services/contractor_service.dart';
import 'package:tendersmart/services/token_storage.dart';

class AddContractor extends StatefulWidget {
  AddContractor({super.key, this.tender});
  Tender? tender;

  @override
  State<AddContractor> createState() => _AddContractorState();
}

class _AddContractorState extends State<AddContractor> {
  final userId = TokenStorage.getUserrId();
  final _formKey = GlobalKey<FormState>();
  bool isSaving = false;

  final List<String> qualityCertificatesOptions = [
    'ISO 9001',
    'ISO 14001',
    'ISO 45001',
    'OHSAS 18001',
    'Other',
  ];
  List<String> selectedQualityCertificates = [];

  final _companyNameController = TextEditingController();
  final _commercialRegistrationNumberController = TextEditingController();
  final _companyEmailController = TextEditingController();
  final _countryController = TextEditingController();
  final _cityController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _yearEstablishedController = TextEditingController();
  final _projectsLast5YearsController = TextEditingController();
  final _publicSectorSuccessfulContractsController = TextEditingController();
  final _websiteUrlController = TextEditingController();
  final _linkedinProfileController = TextEditingController();
  final _companyBioController = TextEditingController();
  // final _uploadOfficialDocumentsAmountController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _companyNameController.dispose();
    _commercialRegistrationNumberController.dispose();
    _companyEmailController.dispose();
    _countryController.dispose();
    _cityController.dispose();
    _phoneNumberController.dispose();
    _yearEstablishedController.dispose();
    _projectsLast5YearsController.dispose();
    _publicSectorSuccessfulContractsController.dispose();
    _websiteUrlController.dispose();
    _linkedinProfileController.dispose();
    _companyBioController.dispose();
    // _uploadOfficialDocumentsAmountController.dispose();
  }

  void _saveContractor() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تعبئة جميع الحقول الإلزامية بشكل صحيح')),
      );
      return;
    }

    setState(() {
      isSaving = true;
    });

    try {
      final userId = int.tryParse(await TokenStorage.getUserrId() ?? '');
      final contractor = Contractor(
        companyName: _companyNameController.text.trim(),
        commercialRegistrationNumber:
            _commercialRegistrationNumberController.text.trim(),
        companyEmail: _companyEmailController.text.trim(),
        country: _countryController.text.trim(),
        city: _cityController.text.trim(),
        phoneNumber: _phoneNumberController.text.trim(),
        yearEstablished: int.tryParse(_yearEstablishedController.text.trim()),
        projectsLast5Years: int.tryParse(
          _projectsLast5YearsController.text.trim(),
        ),
        qualityCertificates: selectedQualityCertificates,
        publicSectorSuccessfulContracts:
            _publicSectorSuccessfulContractsController.text.trim(),
        websiteUrl: _websiteUrlController.text.trim(),
        linkedinProfile: _linkedinProfileController.text.trim(),
        companyBio: _companyBioController.text.trim(),
        userId: userId,
      );
      // log('$userId');
      // print(
      //   selectedQualityCertificates.runtimeType,
      // ); // يجب أن تطبع: List<String>

      // log('${contractor.toJsonCont()}');

      bool success = await ContractorService.saveContractorInfo(contractor);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حفظ البيانات بنجاح')));
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AddBid(tender: widget.tender),
          ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل في حفظ البيانات')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('خطأ أثناء الحفظ: ${e.toString()}')),
      );
    } finally {
      setState(() {
        isSaving = false;
      });
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اهلاً بك'), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_companyNameController, 'اسم الشركة', true),
              _buildTextField(
                _commercialRegistrationNumberController,
                'رقم السجل التجاري/الترخيص',
                true,
              ),
              _buildTextField(
                _companyEmailController,
                'البريد الإلكتروني',
                true,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(_countryController, 'الدولة', false),
              _buildTextField(_cityController, 'المدينة', false),
              _buildTextField(
                _phoneNumberController,
                'رقم الهاتف',
                false,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                _yearEstablishedController,
                'سنة التأسيس',
                false,
                keyboardType: TextInputType.number,
              ),
              _buildTextField(
                _projectsLast5YearsController,
                'عدد المشاريع آخر 5 سنوات',
                false,
                keyboardType: TextInputType.number,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                  child: Text(
                    ': شهادات الجودة',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Wrap(
                spacing: 8,
                children:
                    qualityCertificatesOptions.map((certificate) {
                      bool isSelected = selectedQualityCertificates.contains(
                        certificate,
                      );
                      IconData icon = Icons.check;
                      switch (certificate) {
                        case 'ISO 9001':
                          icon = Icons.verified;
                          break;
                        case 'ISO 14001':
                          icon = Icons.eco;
                          break;
                        case 'ISO 45001':
                          icon = Icons.security;
                          break;
                        case 'OHSAS 18001':
                          icon = Icons.health_and_safety;
                          break;
                        case 'Other':
                          icon = Icons.more_horiz;
                          break;
                      }
                      return ChoiceChip(
                        label: Text(certificate),
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                        ),
                        selected: isSelected,
                        avatar: Icon(
                          icon,
                          color: isSelected ? Colors.white : Colors.grey,
                          size: 20,
                        ),
                        selectedColor: Colors.deepPurpleAccent,
                        backgroundColor: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        onSelected: (selected) {
                          setState(() {
                            if (isSelected) {
                              selectedQualityCertificates.remove(certificate);
                            } else {
                              selectedQualityCertificates.add(certificate);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              SizedBox(height: 12),
              _buildTextField(
                _publicSectorSuccessfulContractsController,
                'العقود الناجحة للقطاع العام',
                false,
              ),
              _buildTextField(
                _websiteUrlController,
                'Website URL',
                false,
                keyboardType: TextInputType.url,
              ),
              _buildTextField(
                _linkedinProfileController,
                'LinkedIn Profile',
                false,
              ),
              _buildTextField(
                _companyBioController,
                'وصف الشركة',
                false,
                maxLines: 3,
              ),
              // _buildTextField(
              //   _uploadOfficialDocumentsAmountController,
              //   'تحميل الوثائق الرسمية',
              //   false,
              // ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                    onPressed: () => Navigator.pop(context),
                    child: Text('إلغاء'),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[300],
                    ),
                    onPressed: isSaving ? null : _saveContractor,
                    child:
                        isSaving
                            ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : Text('حفظ'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool isRequired, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: 50,
        decoration: _buildInputDecoration(label),
        validator: (value) {
          if (isRequired && (value == null || value.trim().isEmpty)) {
            return 'هذا الحقل مطلوب';
          }
          return null;
        },
      ),
    );
  }
}

// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:tendersmart/models/contractor.dart';
// import 'package:tendersmart/services/auth_service.dart';
// import 'package:tendersmart/services/contractor_service.dart';

// final _companyNameController = TextEditingController();
// final _commercialRegistrationNumberController = TextEditingController();
// final _companyEmailController = TextEditingController();
// // final _countryCityController = TextEditingController();
// final _countryController = TextEditingController();
// final _cityController = TextEditingController();

// final _phoneNumberController = TextEditingController();
// final _yearEstablishedController = TextEditingController();
// final _projectsLast5YearsController = TextEditingController();
// // final _qualityCertificatesController = TextEditingController();
// final _publicSectorSuccessfulContractsController = TextEditingController();
// final _websiteUrlController = TextEditingController();
// final _linkedinProfileController = TextEditingController();
// final _companyBioController = TextEditingController();
// final _uploadOfficialDocumentsAmountController = TextEditingController();

// class AddContractor extends StatefulWidget {
//   const AddContractor({
//     super.key,
//     // this.addContractor
//   });
//   // void Function(Contractor contractor)? addContractor;

//   @override
//   State<AddContractor> createState() => _AddContractorState();
// }

// class _AddContractorState extends State<AddContractor> {
//   bool isSaving = false;

//   // قائمة الشهادات المتاحة
//   final List<String> qualityCertificatesOptions = [
//     'ISO 9001',
//     'ISO 14001',
//     'ISO 45001',
//     'OHSAS 18001',
//     'Other',
//   ];

//   // مصفوفة لتخزين الشهادات التي يختارها المستخدم
//   List<String> selectedQualityCertificates = [];
//   @override
//   void dispose() {
//     _companyNameController.dispose();
//     _commercialRegistrationNumberController.dispose();
//     _companyEmailController.dispose();
//     _countryController.dispose();
//     _cityController.dispose();
//     _phoneNumberController.dispose();
//     _yearEstablishedController.dispose();
//     _projectsLast5YearsController.dispose();
//     _publicSectorSuccessfulContractsController.dispose();
//     _websiteUrlController.dispose();
//     _linkedinProfileController.dispose();
//     _companyBioController.dispose();
//     _uploadOfficialDocumentsAmountController.dispose();
//     super.dispose();
//   }

//   void _saveContractor() async {
//     if (_companyNameController.text.isEmpty ||
//         _commercialRegistrationNumberController.text.isEmpty ||
//         _companyEmailController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❗️ يرجى تعبئة جميع الحقول الإلزامية')),
//       );
//       return;
//     }

//     setState(() {
//       isSaving = true;
//     });

//     try {
//       final contractor = Contractor(
//         companyName: _companyNameController.text,
//         commercialRegistrationNumber:
//             _commercialRegistrationNumberController.text,
//         companyEmail: _companyEmailController.text,
//         country: _countryController.text,
//         city: _cityController.text,
//         phoneNumber: _phoneNumberController.text,
//         yearEstablished: int.tryParse(_yearEstablishedController.text),
//         projectsLast5Years: int.tryParse(_projectsLast5YearsController.text),
//         qualityCertificates: selectedQualityCertificates,
//         publicSectorSuccessfulContracts:
//             _publicSectorSuccessfulContractsController.text,
//         websiteUrl: _websiteUrlController.text,
//         linkedinProfile: _linkedinProfileController.text,
//         companyBio: _companyBioController.text,
//       );

//       bool success = await ContractorService.saveContractorInfo(contractor);

//       if (success) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('✅ تم حفظ البيانات بنجاح')));
//         Navigator.pushReplacementNamed(context, '/contractorProfile');
//       } else {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('❌ فشل في حفظ البيانات')));
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('❌ حدث خطأ أثناء الحفظ: ${e.toString()}')),
//       );
//     } finally {
//       setState(() {
//         isSaving = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('اهلاً بك'), backgroundColor: Colors.blue),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(label: Text(': اسم الشركة')),
//               controller: _companyNameController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': رقم السجل التجاري/الترخيص'),
//               ),
//               controller: _commercialRegistrationNumberController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': البريد الإلكتروني للشركة'),
//               ),
//               controller: _companyEmailController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': الدولة')),
//               controller: _countryController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': المدينة')),
//               controller: _cityController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': رقم الهاتف')),
//               controller: _phoneNumberController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': سنة تأسيس الشركة')),
//               controller: _yearEstablishedController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': عدد المشاريع المنفذة آخر 5 سنوات'),
//               ),
//               controller: _projectsLast5YearsController,
//               maxLength: 50,
//             ),
//             // TextField(
//             //   readOnly: true,
//             //   decoration: InputDecoration(label: Text(': شهادات الجودة')),
//             //   controller: TextEditingController(
//             //     text: selectedQualityCertificates.join(', '),
//             //   ),
//             //   onTap: () {
//             //     _showQualityCertificatesDialog();
//             //   },
//             // ),
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Padding(
//                 padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
//                 child: Text(
//                   ': شهادات الجودة',
//                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//             Wrap(
//               spacing: 8,
//               children:
//                   qualityCertificatesOptions.map((certificate) {
//                     bool isSelected = selectedQualityCertificates.contains(
//                       certificate,
//                     );

//                     // 🟢 حدد الأيقونة لكل شهادة
//                     IconData icon;
//                     switch (certificate) {
//                       case 'ISO 9001':
//                         icon = Icons.verified;
//                         break;
//                       case 'ISO 14001':
//                         icon = Icons.eco;
//                         break;
//                       case 'ISO 45001':
//                         icon = Icons.security;
//                         break;
//                       case 'OHSAS 18001':
//                         icon = Icons.health_and_safety;
//                         break;
//                       case 'Other':
//                         icon = Icons.more_horiz;
//                         break;
//                       default:
//                         icon = Icons.check;
//                     }

//                     return ChoiceChip(
//                       label: Text(certificate),
//                       labelStyle: TextStyle(
//                         color: isSelected ? Colors.white : Colors.black,
//                       ),
//                       selected: isSelected,
//                       avatar: Icon(
//                         icon,
//                         color: isSelected ? Colors.white : Colors.grey,
//                         size: 20,
//                       ),
//                       selectedColor:
//                           Colors.deepPurpleAccent, // لون أرجواني جميل
//                       backgroundColor:
//                           Colors.grey[200], // لون خلفية لطيف قبل التحديد
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(20), // زوايا دائرية
//                       ),
//                       onSelected: (selected) {
//                         setState(() {
//                           if (isSelected) {
//                             selectedQualityCertificates.remove(certificate);
//                           } else {
//                             selectedQualityCertificates.add(certificate);
//                           }
//                         });
//                       },
//                     );
//                   }).toList(),
//             ),
//             SizedBox(height: 12),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': العقود الناجحة للقطاع العام'),
//               ),
//               controller: _publicSectorSuccessfulContractsController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': Website url')),
//               controller: _websiteUrlController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(':linkedin Profile')),
//               controller: _linkedinProfileController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(label: Text(': وصف الشركة')),
//               controller: _companyBioController,
//               maxLength: 50,
//             ),
//             TextField(
//               decoration: InputDecoration(
//                 label: Text(': تحميل الوثائق الرسمية'),
//               ),
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
//                   onPressed: isSaving ? null : _saveContractor,
//                   child:
//                       isSaving
//                           ? CircularProgressIndicator(color: Colors.white)
//                           : Text('Save'),
//                 ),

//                 // ElevatedButton(
//                 //   style: ButtonStyle(
//                 //     backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
//                 //   ),
//                 //   onPressed: _saveContractor,
//                 //   child: Text('Save'),
//                 // ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ContractorInformation extends StatefulWidget {
  const ContractorInformation({super.key});

  @override
  State<ContractorInformation> createState() => _ContractorInformationState();
}

class _ContractorInformationState extends State<ContractorInformation> {
  final _formKey = GlobalKey<FormState>();

  final fullNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final mobileController = TextEditingController();
  bool isChecked = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    fullNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    mobileController.dispose();
    super.dispose();
  }

  void onContinuePressed() async {
    if (_formKey.currentState!.validate()) {
      final fullName = fullNameController.text;
      final email = emailController.text;
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final mobile = mobileController.text;

      log('Full Name: $fullName');
      log('Email: $email');
      log('Password: $password');
      log('Confirm Password: $confirmPassword');
      log('Mobile: $mobile');
      log('Terms Accepted: $isChecked');
      // await AuthService_Login.register(contractor)
      final register = Contractor(
        email: email.toString(),
        password: password.toString(),
        passwordConfirmation: confirmPassword.toString(),
        fullName: fullName.toString(),
        phoneNumberForUser: mobile.toString(),
      );
      log(register.toString());
      log('toJsonRegister: ${register.toJsonRegister()}');
      try {
        await AuthService.register(register);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تمت الإضافة بنجاح')));
        // Navigator.pop(context);
        // tendersFuture;
        // tendersFuture = TenderService.fetchTenders();
        // setState(() {
        //   tendersFuture; //= TenderService.fetchTenders();
        // });
      } catch (e, stackTrace) {
        log('خطأ في الاضافة : $e');
        log('Stack trace : $stackTrace');
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل في الإضافة :$e')));
      }
      Navigator.pop(context);
      // هنا التنقل لشاشة التحقق أو إرسال البيانات للباكند
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (_) =>
      // const CodeVerificationScreen()
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image.asset(
            //   'images/image_1.jpg',
            //   width: double.infinity,
            //   fit: BoxFit.cover,
            // ),
            Image.asset(
              'images/image_1.jpg',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email ID',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
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
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: 'Confirm Password',
                        border: const OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your password';
                        }
                        if (value != passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 15),
                    TextFormField(
                      controller: mobileController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Mobile No.',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your mobile number';
                        }
                        return null;
                      },
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
                    if (!isChecked)
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'You must accept terms and conditions',
                          style: TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: isChecked ? onContinuePressed : null,
                      child: const Text('CONTINUE'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
              'images/image_2.jpg',
              // width: 20,
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
                log('Verification Code: $code');
              },
              child: const Text('VERIFY Code'),
            ),
          ],
        ),
      ),
    );
  }
}
