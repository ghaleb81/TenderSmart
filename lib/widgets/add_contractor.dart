import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tendersmart/widgets/add_bid.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/auth_service.dart';
import 'package:tendersmart/services/contractor_service.dart';
import 'package:tendersmart/services/token_storage.dart';

// class AddContractor extends StatefulWidget {
//   AddContractor({super.key, this.tender});
//   final tender;

//   @override
//   State<AddContractor> createState() => _AddContractorState();
// }

// class _AddContractorState extends State<AddContractor> {
//   final _formKey = GlobalKey<FormState>();
//   bool isSaving = false;

//   final List<String> qualityCertificatesOptions = [
//     'ISO 9001',
//     'ISO 14001',
//     'ISO 45001',
//     'OHSAS 18001',
//     'Other',
//   ];
//   List<String> selectedQualityCertificates = [];

//   final _companyNameController = TextEditingController();
//   final _commercialRegistrationNumberController = TextEditingController();
//   final _companyEmailController = TextEditingController();
//   final _countryController = TextEditingController();
//   final _cityController = TextEditingController();
//   final _phoneNumberController = TextEditingController();
//   final _yearEstablishedController = TextEditingController();
//   final _projectsLast5YearsController = TextEditingController();
//   final _publicSectorSuccessfulContractsController = TextEditingController();
//   final _websiteUrlController = TextEditingController();
//   final _linkedinProfileController = TextEditingController();
//   final _companyBioController = TextEditingController();

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
//     super.dispose();
//   }

//   void _saveContractor() async {
//     if (!_formKey.currentState!.validate()) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('يرجى تعبئة جميع الحقول الإلزامية بشكل صحيح')),
//       );
//       return;
//     }

//     setState(() {
//       isSaving = true;
//     });

//     try {
//       // استدعاء خدمة الحفظ هنا...
//       bool success = true; // مؤقتاً للشرح

//       if (success) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('تم حفظ البيانات بنجاح')));
//         // تنقل لصفحة أخرى إذا أردت
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('فشل في حفظ البيانات، حاول مرة أخرى')),
//         );
//       }
//     } catch (_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء الحفظ، يرجى المحاولة لاحقاً')),
//       );
//     } finally {
//       setState(() {
//         isSaving = false;
//       });
//     }
//   }

//   InputDecoration _buildInputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//       contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//     );
//   }

//   Widget _buildTextField(
//     TextEditingController controller,
//     String label,
//     bool isRequired, {
//     TextInputType keyboardType = TextInputType.text,
//     int maxLines = 1,
//     String? Function(String?)? validator,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: keyboardType,
//         maxLines: maxLines,
//         maxLength: 50,
//         decoration: _buildInputDecoration(label),
//         validator:
//             validator ??
//             (value) {
//               if (isRequired && (value == null || value.trim().isEmpty)) {
//                 return 'هذا الحقل مطلوب';
//               }
//               return null;
//             },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('إضافة بيانات المقاول'),
//         backgroundColor: Colors.blue,
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Form(
//           key: _formKey,
//           child: Column(
//             children: [
//               _buildTextField(_companyNameController, 'اسم الشركة', true),
//               _buildTextField(
//                 _commercialRegistrationNumberController,
//                 'رقم السجل التجاري/الترخيص',
//                 true,
//               ),
//               _buildTextField(
//                 _companyEmailController,
//                 'البريد الإلكتروني',
//                 true,
//                 keyboardType: TextInputType.emailAddress,
//                 validator: (value) {
//                   if (value == null || value.trim().isEmpty) {
//                     return 'هذا الحقل مطلوب';
//                   }
//                   final emailRegex = RegExp(
//                     r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
//                   );
//                   if (!emailRegex.hasMatch(value.trim())) {
//                     return 'الرجاء إدخال بريد إلكتروني صالح';
//                   }
//                   return null;
//                 },
//               ),
//               _buildTextField(_countryController, 'الدولة', false),
//               _buildTextField(_cityController, 'المدينة', false),
//               _buildTextField(
//                 _phoneNumberController,
//                 'رقم الهاتف',
//                 false,
//                 keyboardType: TextInputType.phone,
//                 validator: (value) {
//                   if (value != null && value.trim().isNotEmpty) {
//                     final phoneRegex = RegExp(r'^\+?\d{7,15}$');
//                     if (!phoneRegex.hasMatch(value.trim())) {
//                       return 'الرجاء إدخال رقم هاتف صالح (7 إلى 15 رقم)';
//                     }
//                   }
//                   return null;
//                 },
//               ),
//               _buildTextField(
//                 _yearEstablishedController,
//                 'سنة التأسيس',
//                 false,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value != null && value.trim().isNotEmpty) {
//                     if (int.tryParse(value.trim()) == null) {
//                       return 'الرجاء إدخال رقم صالح';
//                     }
//                   }
//                   return null;
//                 },
//               ),
//               _buildTextField(
//                 _projectsLast5YearsController,
//                 'عدد المشاريع آخر 5 سنوات',
//                 false,
//                 keyboardType: TextInputType.number,
//                 validator: (value) {
//                   if (value != null && value.trim().isNotEmpty) {
//                     if (int.tryParse(value.trim()) == null) {
//                       return 'الرجاء إدخال رقم صالح';
//                     }
//                   }
//                   return null;
//                 },
//               ),
//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Padding(
//                   padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
//                   child: Text(
//                     ': شهادات الجودة',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//               Wrap(
//                 spacing: 8,
//                 children:
//                     qualityCertificatesOptions.map((certificate) {
//                       bool isSelected = selectedQualityCertificates.contains(
//                         certificate,
//                       );
//                       IconData icon = Icons.check;
//                       switch (certificate) {
//                         case 'ISO 9001':
//                           icon = Icons.verified;
//                           break;
//                         case 'ISO 14001':
//                           icon = Icons.eco;
//                           break;
//                         case 'ISO 45001':
//                           icon = Icons.security;
//                           break;
//                         case 'OHSAS 18001':
//                           icon = Icons.health_and_safety;
//                           break;
//                         case 'Other':
//                           icon = Icons.more_horiz;
//                           break;
//                       }
//                       return ChoiceChip(
//                         label: Text(certificate),
//                         labelStyle: TextStyle(
//                           color: isSelected ? Colors.white : Colors.black,
//                         ),
//                         selected: isSelected,
//                         avatar: Icon(
//                           icon,
//                           color: isSelected ? Colors.white : Colors.grey,
//                           size: 20,
//                         ),
//                         selectedColor: Colors.deepPurpleAccent,
//                         backgroundColor: Colors.grey[200],
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(20),
//                         ),
//                         onSelected: (selected) {
//                           setState(() {
//                             if (isSelected) {
//                               selectedQualityCertificates.remove(certificate);
//                             } else {
//                               selectedQualityCertificates.add(certificate);
//                             }
//                           });
//                         },
//                       );
//                     }).toList(),
//               ),
//               SizedBox(height: 12),
//               _buildTextField(
//                 _publicSectorSuccessfulContractsController,
//                 'العقود الناجحة للقطاع العام',
//                 false,
//               ),
//               _buildTextField(
//                 _websiteUrlController,
//                 'Website URL',
//                 false,
//                 keyboardType: TextInputType.url,
//                 validator: (value) {
//                   if (value != null && value.trim().isNotEmpty) {
//                     final urlRegex = RegExp(
//                       r"^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-._~:/?#[\]@!$&'()*+,;=]*)?$",
//                     );
//                     if (!urlRegex.hasMatch(value.trim())) {
//                       return 'الرجاء إدخال رابط صحيح';
//                     }
//                   }
//                   return null;
//                 },
//               ),

//               // _buildTextField(
//               //   _websiteUrlController,
//               //   'Website URL',
//               //   false,
//               //   keyboardType: TextInputType.url,
//               //   validator: (value) {
//               //     if (value != null && value.trim().isNotEmpty) {
//               //       final urlRegex = RegExp(
//               //           r'^(https?:\/\/)?([\w\-]+\.)+[\w\-]+(\/[\w\-._~:/?#[\]@!$&\'()*+,;=]*)?$');
//               //       if (!urlRegex.hasMatch(value.trim())) {
//               //         return 'الرجاء إدخال رابط صحيح';
//               //       }
//               //     }
//               //     return null;
//               //   },
//               // ),
//               _buildTextField(
//                 _linkedinProfileController,
//                 'LinkedIn Profile',
//                 false,
//               ),
//               _buildTextField(
//                 _companyBioController,
//                 'وصف الشركة',
//                 false,
//                 maxLines: 3,
//               ),
//               SizedBox(height: 16),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.grey[300],
//                     ),
//                     onPressed: () => Navigator.pop(context),
//                     child: Text('إلغاء'),
//                   ),
//                   SizedBox(width: 8),
//                   ElevatedButton(
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.blue[300],
//                     ),
//                     onPressed: isSaving ? null : _saveContractor,
//                     child:
//                         isSaving
//                             ? SizedBox(
//                               width: 20,
//                               height: 20,
//                               child: CircularProgressIndicator(
//                                 color: Colors.white,
//                                 strokeWidth: 2,
//                               ),
//                             )
//                             : Text('حفظ'),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

class AddContractor extends StatefulWidget {
  AddContractor({
    super.key,
    this.tender,
    this.existingContractor,
    required this.isEditing,
  });
  final tender;
  final Contractor? existingContractor;
  bool isEditing;

  @override
  State<AddContractor> createState() => _AddContractorState();
}

class _AddContractorState extends State<AddContractor> {
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

  @override
  void initState() {
    super.initState();
    final contractor = widget.existingContractor;
    if (contractor != null) {
      _companyNameController.text = contractor.companyName ?? '';
      _commercialRegistrationNumberController.text =
          contractor.commercialRegistrationNumber ?? '';
      _companyEmailController.text = contractor.companyEmail ?? '';
      _countryController.text = contractor.country ?? '';
      _cityController.text = contractor.city ?? '';
      _phoneNumberController.text = contractor.phoneNumber ?? '';
      _yearEstablishedController.text =
          contractor.yearEstablished?.toString() ?? '';
      _projectsLast5YearsController.text =
          contractor.projectsLast5Years?.toString() ?? '';
      _publicSectorSuccessfulContractsController.text =
          contractor.publicSectorSuccessfulContracts ?? '';
      _websiteUrlController.text = contractor.websiteUrl ?? '';
      _linkedinProfileController.text = contractor.linkedinProfile ?? '';
      _companyBioController.text = contractor.companyBio ?? '';
      selectedQualityCertificates = contractor.qualityCertificates ?? [];
    }
  }

  @override
  void dispose() {
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
    super.dispose();
  }

  // void _saveContractor() async {
  //   if (!_formKey.currentState!.validate()) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('يرجى تعبئة جميع الحقول الإلزامية بشكل صحيح')),
  //     );
  //     return;
  //   }

  //   setState(() => isSaving = true);

  //   final contractor = Contractor(
  //     id: widget.existingContractor?.id,
  //     userId: widget.existingContractor?.userId,
  //     companyName: _companyNameController.text.trim(),
  //     commercialRegistrationNumber:
  //         _commercialRegistrationNumberController.text.trim(),
  //     companyEmail: _companyEmailController.text.trim(),
  //     country: _countryController.text.trim(),
  //     city: _cityController.text.trim(),
  //     phoneNumber: _phoneNumberController.text.trim(),
  //     yearEstablished: int.tryParse(_yearEstablishedController.text.trim()),
  //     projectsLast5Years: int.tryParse(
  //       _projectsLast5YearsController.text.trim(),
  //     ),
  //     publicSectorSuccessfulContracts:
  //         _publicSectorSuccessfulContractsController.text.trim(),
  //     websiteUrl: _websiteUrlController.text.trim(),
  //     linkedinProfile: _linkedinProfileController.text.trim(),
  //     companyBio: _companyBioController.text.trim(),
  //     qualityCertificates: selectedQualityCertificates,
  //   );

  //   try {
  //     // final success = widget.existingContractor == null
  //     final success = await ContractorService.saveContractorInfo(contractor);

  //     // ? await ContractorService.saveContractorInfo(contractor)
  //     // ? await ContractorService.saveContractorInfo(contractor)
  //     // : await ContractorService.updateContractor(contractor);

  //     if (success) {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('تم حفظ البيانات بنجاح')));
  //       Navigator.pop(context);
  //     } else {
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('فشل في حفظ البيانات')));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(
  //       context,
  //     ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الحفظ: $e')));
  //   } finally {
  //     setState(() => isSaving = false);
  //   }
  // }
  void _saveContractor() async {
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('يرجى تعبئة جميع الحقول الإلزامية بشكل صحيح')),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      // ✅ استرجاع userId من التخزين المحلي
      final userId =
          await TokenStorage.getUserrId(); // تأكد أن هذه الدالة موجودة وتُرجع user_id من SharedPreferences

      if (userId == null) {
        throw Exception("معرف المستخدم غير موجود. يرجى تسجيل الدخول مرة أخرى.");
      }

      final contractor = Contractor(
        id: widget.existingContractor?.id,
        userId: int.tryParse(userId) ?? 0, // ✅ الآن مضمونة القيمة
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
        publicSectorSuccessfulContracts:
            _publicSectorSuccessfulContractsController.text.trim(),
        websiteUrl: _websiteUrlController.text.trim(),
        linkedinProfile: _linkedinProfileController.text.trim(),
        companyBio: _companyBioController.text.trim(),
        qualityCertificates: selectedQualityCertificates,
      );

      // ✅ حفظ البيانات
      final success = await ContractorService.saveContractorInfo(contractor);

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('تم حفظ البيانات بنجاح')));
        if (widget.isEditing) {
          setState(() {
            widget.isEditing = !widget.isEditing;
          });
          Navigator.pop(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddBid(contractorId: contractor.id),
            ),
          );
        }
        // Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('فشل في حفظ البيانات')));
      }
    } catch (e) {
      log("خطأ أثناء الحفظ: $e");
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء الحفظ.')));
    } finally {
      setState(() => isSaving = false);
    }
  }

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    bool isRequired, {
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        maxLength: 50,
        decoration: _buildInputDecoration(label),
        validator:
            validator ??
            (value) {
              if (isRequired && (value == null || value.trim().isEmpty)) {
                return 'هذا الحقل مطلوب';
              }
              return null;
            },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Text(
          widget.existingContractor == null
              ? 'إضافة بيانات المقاول'
              : 'تعديل بيانات المقاول',
        ),
        centerTitle: true,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
        // appBar: AppBar(
        //   title: Text(
        //     widget.existingContractor == null
        //         ? 'إضافة بيانات المقاول'
        //         : 'تعديل بيانات المقاول',
        //   ),
        //   backgroundColor: Colors.blue,
      ),
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'هذا الحقل مطلوب';
                  }
                  final emailRegex = RegExp(
                    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                  );
                  if (!emailRegex.hasMatch(value.trim())) {
                    return 'الرجاء إدخال بريد إلكتروني صالح';
                  }
                  return null;
                },
              ),
              _buildTextField(_countryController, 'الدولة', false),
              _buildTextField(_cityController, 'المدينة', false),
              _buildTextField(
                _phoneNumberController,
                'رقم الهاتف',
                false,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.trim().isNotEmpty) {
                    final phoneRegex = RegExp(r'^\+?\d{7,15}$');
                    if (!phoneRegex.hasMatch(value.trim())) {
                      return 'الرجاء إدخال رقم هاتف صالح';
                    }
                  }
                  return null;
                },
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
              SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'شهادات الجودة:',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8,
                children:
                    qualityCertificatesOptions.map((certificate) {
                      final isSelected = selectedQualityCertificates.contains(
                        certificate,
                      );
                      return ChoiceChip(
                        label: Text(certificate),
                        selected: isSelected,
                        onSelected: (selected) {
                          setState(() {
                            if (selected) {
                              selectedQualityCertificates.add(certificate);
                            } else {
                              selectedQualityCertificates.remove(certificate);
                            }
                          });
                        },
                      );
                    }).toList(),
              ),
              SizedBox(height: 12),
              _buildTextField(
                _publicSectorSuccessfulContractsController,
                'عقود القطاع العام الناجحة',
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
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('إلغاء'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[300],
                    ),
                  ),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: isSaving ? null : _saveContractor,
                    child:
                        isSaving
                            ? CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            )
                            : Text('حفظ'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
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
  bool isLoading = false;

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
      setState(() => isLoading = true);

      final fullName = fullNameController.text;
      final email = emailController.text;
      final password = passwordController.text;
      final confirmPassword = confirmPasswordController.text;
      final mobile = mobileController.text;

      final register = Contractor(
        email: email,
        password: password,
        passwordConfirmation: confirmPassword,
        fullName: fullName,
        phoneNumberForUser: mobile,
      );

      final success = await AuthService.register(register);

      if (!mounted) return;

      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تمت الإضافة بنجاح')));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('فشل في إضافة المقاول')));
        Navigator.pop(context);
      }

      setState(() => isLoading = false);
    }
  }

  // void onContinuePressed() async {
  //   if (_formKey.currentState!.validate()) {
  //     setState(() => isLoading = true);

  //     final fullName = fullNameController.text;
  //     final email = emailController.text;
  //     final password = passwordController.text;
  //     final confirmPassword = confirmPasswordController.text;
  //     final mobile = mobileController.text;

  //     final register = Contractor(
  //       email: email,
  //       password: password,
  //       passwordConfirmation: confirmPassword,
  //       fullName: fullName,
  //       phoneNumberForUser: mobile,
  //     );

  //     try {
  //       await AuthService.register(register);
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(const SnackBar(content: Text('تمت الإضافة بنجاح')));
  //       Navigator.pop(context);
  //     } catch (e) {
  //       log('فشل في الإضافة: $e');
  //       if (!mounted) return;
  //       ScaffoldMessenger.of(
  //         context,
  //       ).showSnackBar(SnackBar(content: Text('فشل في الإضافة: $e')));
  //     } finally {
  //       if (mounted) setState(() => isLoading = false);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                      onPressed:
                          isChecked && !isLoading ? onContinuePressed : null,
                      child:
                          isLoading
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                              : const Text('CONTINUE'),
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
