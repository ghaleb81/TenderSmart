import 'package:flutter/material.dart';
import 'package:tendersmart/widgets/add_contractor.dart';
import 'package:tendersmart/services/token_storage.dart';
import '../../models/contractor.dart';
import '../../services/contractor_service.dart';

class ContractorProfilePage extends StatefulWidget {
  ContractorProfilePage({super.key, required this.userId});
  String userId;

  @override
  State<ContractorProfilePage> createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  Contractor? contractor;
  bool isLoading = true;
  String? role;

  @override
  void initState() {
    super.initState();
    _loadContractorData();
    // final role = await TokenStorage.getRole();
  }

  loadUserRole() async {
    final userRole = await TokenStorage.getRole();
    setState(() {
      role = userRole;
    });
  }

  Future<void> _loadContractorData() async {
    try {
      // final userId = await TokenStorage.getUserrId();

      Contractor? data = await ContractorService.fetchContractorByUserId(
        widget.userId,
        // widget.user_id!,
        // int.tryParse(widget.user_id!) ?? 0,
      );
      // Contractor? data = await ContractorService.fetchContractorByUserId(
      //   widget.user_id!,
      //   // int.tryParse(widget.user_id!) ?? 0,
      // );
      setState(() {
        contractor = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ في جلب البيانات: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text(
            'ملف المقاول الشخصي  ',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Colors.white,
            ),
          ),
          centerTitle: true,
          elevation: 6,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
        ),
        // appBar: AppBar(
        //   title: const Text(
        //     'ملف المقاول الشخصي',
        //     style: TextStyle(fontWeight: FontWeight.bold),
        //   ),
        //   backgroundColor: Colors.blue.shade800,
        //   centerTitle: true,
        // ),
        body:
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : contractor == null
                ? const Center(child: Text('لم يتم العثور على بيانات'))
                : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // صورة رمزية أو شعار الشركة
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(
                          Icons.business,
                          size: 50,
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        contractor?.companyName ?? 'شركة غير معروفة',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 24),
                      ..._buildProfileCards(),

                      const SizedBox(height: 30),

                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // الانتقال إلى صفحة التعديل
                      //   },
                      //   icon: const Icon(Icons.edit),
                      //   label: const Text('تعديل الملف الشخصي'),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.blue.shade600,
                      //     padding: const EdgeInsets.symmetric(
                      //       horizontal: 32,
                      //       vertical: 14,
                      //     ),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(20),
                      //     ),
                      //     textStyle: const TextStyle(fontSize: 16),
                      //   ),
                      // )
                      // if (role == 'contractor')
                      ElevatedButton.icon(
                        onPressed: () async {
                          final updated = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) => AddContractor(
                                    existingContractor: contractor,
                                    isEditing: true,
                                    // contractor: contractor, // نمرّر المعلومات الحالية
                                    // isEdit: true, // وضع التعديل
                                  ),
                            ),
                          );
                          if (updated == true) {
                            _loadContractorData(); // إعادة تحميل البيانات بعد التعديل
                          }
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('تعديل الملف الشخصي'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 14,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          textStyle: const TextStyle(fontSize: 16),
                        ),
                      ),
                      // else
                      // SizedBox(),
                    ],
                  ),
                ),
      ),
    );
  }

  List<Widget> _buildProfileCards() {
    final List<Map<String, dynamic>> items = [
      {
        'label': 'رقم السجل التجاري',
        'value': contractor?.commercialRegistrationNumber,
        'icon': Icons.confirmation_number,
      },
      {
        'label': 'البريد الإلكتروني',
        'value': contractor?.companyEmail,
        'icon': Icons.email,
      },
      {'label': 'الدولة', 'value': contractor?.country, 'icon': Icons.flag},
      {
        'label': 'المدينة',
        'value': contractor?.city,
        'icon': Icons.location_city,
      },
      {
        'label': 'رقم الهاتف',
        'value': contractor?.phoneNumber,
        'icon': Icons.phone,
      },
      {
        'label': 'سنة التأسيس',
        'value': contractor?.yearEstablished?.toString(),
        'icon': Icons.calendar_today,
      },
      {
        'label': 'عدد المشاريع آخر 5 سنوات',
        'value': contractor?.projectsLast5Years?.toString(),
        'icon': Icons.bar_chart,
      },
      {
        'label': 'شهادات الجودة',
        'value': contractor?.qualityCertificates?.join('، '),
        'icon': Icons.verified,
      },
      {
        'label': 'عقود القطاع العام الناجحة',
        'value': contractor?.publicSectorSuccessfulContracts,
        'icon': Icons.assignment_turned_in,
      },
      {
        'label': 'الموقع الإلكتروني',
        'value': contractor?.websiteUrl,
        'icon': Icons.language,
      },
      {
        'label': 'LinkedIn',
        'value': contractor?.linkedinProfile,
        'icon': Icons.link,
      },
      {
        'label': 'وصف الشركة',
        'value': contractor?.companyBio,
        'icon': Icons.description,
      },
    ];

    return items.map((item) {
      final String label = item['label'];
      final String value = item['value'] ?? 'غير متوفر';
      final IconData icon = item['icon'];

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, color: Colors.blue.shade600),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(value, style: const TextStyle(fontSize: 15)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

// class ContractorProfilePage extends StatefulWidget {
//   ContractorProfilePage({super.key, required this.userId});
//   String userId;

//   @override
//   State<ContractorProfilePage> createState() => _ContractorProfilePageState();
// }

// class _ContractorProfilePageState extends State<ContractorProfilePage> {
//   Contractor? contractor;
//   bool isLoading = true;
//   String? role;

//   @override
//   void initState() {
//     super.initState();
//     _loadContractorData();
//     // final role = await TokenStorage.getRole();
//   }

//   loadUserRole() async {
//     final userRole = await TokenStorage.getRole();
//     setState(() {
//       role = userRole;
//     });
//   }

//   Future<void> _loadContractorData() async {
//     try {
//       // final userId = await TokenStorage.getUserrId();

//       Contractor? data = await ContractorService.fetchContractorByUserId(
//         widget.userId,
//         // widget.user_id!,
//         // int.tryParse(widget.user_id!) ?? 0,
//       );
//       // Contractor? data = await ContractorService.fetchContractorByUserId(
//       //   widget.user_id!,
//       //   // int.tryParse(widget.user_id!) ?? 0,
//       // );
//       setState(() {
//         contractor = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('حدث خطأ في جلب البيانات: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'ملف المقاول الشخصي',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.blue.shade800,
//           centerTitle: true,
//         ),
//         body:
//             isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : contractor == null
//                 ? const Center(child: Text('لم يتم العثور على بيانات'))
//                 : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       // صورة رمزية أو شعار الشركة
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.blue.shade100,
//                         child: Icon(
//                           Icons.business,
//                           size: 50,
//                           color: Colors.blue.shade700,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         contractor?.companyName ?? 'شركة غير معروفة',
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       ..._buildProfileCards(),

//                       const SizedBox(height: 30),
//                       if (role == 'contractor')
//                         // ElevatedButton.icon(
//                         //   onPressed: () {
//                         //     // الانتقال إلى صفحة التعديل
//                         //   },
//                         //   icon: const Icon(Icons.edit),
//                         //   label: const Text('تعديل الملف الشخصي'),
//                         //   style: ElevatedButton.styleFrom(
//                         //     backgroundColor: Colors.blue.shade600,
//                         //     padding: const EdgeInsets.symmetric(
//                         //       horizontal: 32,
//                         //       vertical: 14,
//                         //     ),
//                         //     shape: RoundedRectangleBorder(
//                         //       borderRadius: BorderRadius.circular(20),
//                         //     ),
//                         //     textStyle: const TextStyle(fontSize: 16),
//                         //   ),
//                         // )
//                         ElevatedButton.icon(
//                           onPressed: () async {
//                             final updated = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) => AddContractor(
//                                       existingContractor: contractor,
//                                       // contractor: contractor, // نمرّر المعلومات الحالية
//                                       // isEdit: true, // وضع التعديل
//                                     ),
//                               ),
//                             );
//                             if (updated == true) {
//                               _loadContractorData(); // إعادة تحميل البيانات بعد التعديل
//                             }
//                           },
//                           icon: const Icon(Icons.edit),
//                           label: const Text('تعديل الملف الشخصي'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade600,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 32,
//                               vertical: 14,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             textStyle: const TextStyle(fontSize: 16),
//                           ),
//                         )
//                       else
//                         SizedBox(),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }

//   List<Widget> _buildProfileCards() {
//     final List<Map<String, dynamic>> items = [
//       {
//         'label': 'رقم السجل التجاري',
//         'value': contractor?.commercialRegistrationNumber,
//         'icon': Icons.confirmation_number,
//       },
//       {
//         'label': 'البريد الإلكتروني',
//         'value': contractor?.companyEmail,
//         'icon': Icons.email,
//       },
//       {'label': 'الدولة', 'value': contractor?.country, 'icon': Icons.flag},
//       {
//         'label': 'المدينة',
//         'value': contractor?.city,
//         'icon': Icons.location_city,
//       },
//       {
//         'label': 'رقم الهاتف',
//         'value': contractor?.phoneNumber,
//         'icon': Icons.phone,
//       },
//       {
//         'label': 'سنة التأسيس',
//         'value': contractor?.yearEstablished?.toString(),
//         'icon': Icons.calendar_today,
//       },
//       {
//         'label': 'عدد المشاريع آخر 5 سنوات',
//         'value': contractor?.projectsLast5Years?.toString(),
//         'icon': Icons.bar_chart,
//       },
//       {
//         'label': 'شهادات الجودة',
//         'value': contractor?.qualityCertificates?.join('، '),
//         'icon': Icons.verified,
//       },
//       {
//         'label': 'عقود القطاع العام الناجحة',
//         'value': contractor?.publicSectorSuccessfulContracts,
//         'icon': Icons.assignment_turned_in,
//       },
//       {
//         'label': 'الموقع الإلكتروني',
//         'value': contractor?.websiteUrl,
//         'icon': Icons.language,
//       },
//       {
//         'label': 'LinkedIn',
//         'value': contractor?.linkedinProfile,
//         'icon': Icons.link,
//       },
//       {
//         'label': 'وصف الشركة',
//         'value': contractor?.companyBio,
//         'icon': Icons.description,
//       },
//     ];

//     return items.map((item) {
//       final String label = item['label'];
//       final String value = item['value'] ?? 'غير متوفر';
//       final IconData icon = item['icon'];

//       return Card(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(icon, color: Colors.blue.shade600),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(value, style: const TextStyle(fontSize: 15)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }).toList();
//   }
// }

// class ContractorProfilePage extends StatefulWidget {
//   ContractorProfilePage({super.key, required this.userId});
//   String userId;

//   @override
//   State<ContractorProfilePage> createState() => _ContractorProfilePageState();
// }

// class _ContractorProfilePageState extends State<ContractorProfilePage> {
//   Contractor? contractor;
//   bool isLoading = true;
//   String? role;

//   @override
//   void initState() {
//     super.initState();
//     _loadContractorData();
//     // final role = await TokenStorage.getRole();
//   }

//   loadUserRole() async {
//     final userRole = await TokenStorage.getRole();
//     setState(() {
//       role = userRole;
//     });
//   }

//   Future<void> _loadContractorData() async {
//     try {
//       // final userId = await TokenStorage.getUserrId();

//       Contractor? data = await ContractorService.fetchContractorByUserId(
//         widget.userId,
//         // widget.user_id!,
//         // int.tryParse(widget.user_id!) ?? 0,
//       );
//       // Contractor? data = await ContractorService.fetchContractorByUserId(
//       //   widget.user_id!,
//       //   // int.tryParse(widget.user_id!) ?? 0,
//       // );
//       setState(() {
//         contractor = data;
//         isLoading = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoading = false;
//       });
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('حدث خطأ في جلب البيانات: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'ملف المقاول الشخصي',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           backgroundColor: Colors.blue.shade800,
//           centerTitle: true,
//         ),
//         body:
//             isLoading
//                 ? const Center(child: CircularProgressIndicator())
//                 : contractor == null
//                 ? const Center(child: Text('لم يتم العثور على بيانات'))
//                 : SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: Column(
//                     children: [
//                       // صورة رمزية أو شعار الشركة
//                       CircleAvatar(
//                         radius: 50,
//                         backgroundColor: Colors.blue.shade100,
//                         child: Icon(
//                           Icons.business,
//                           size: 50,
//                           color: Colors.blue.shade700,
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         contractor?.companyName ?? 'شركة غير معروفة',
//                         style: const TextStyle(
//                           fontSize: 22,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 24),
//                       ..._buildProfileCards(),

//                       const SizedBox(height: 30),
//                       if (role == 'contractor')
//                         // ElevatedButton.icon(
//                         //   onPressed: () {
//                         //     // الانتقال إلى صفحة التعديل
//                         //   },
//                         //   icon: const Icon(Icons.edit),
//                         //   label: const Text('تعديل الملف الشخصي'),
//                         //   style: ElevatedButton.styleFrom(
//                         //     backgroundColor: Colors.blue.shade600,
//                         //     padding: const EdgeInsets.symmetric(
//                         //       horizontal: 32,
//                         //       vertical: 14,
//                         //     ),
//                         //     shape: RoundedRectangleBorder(
//                         //       borderRadius: BorderRadius.circular(20),
//                         //     ),
//                         //     textStyle: const TextStyle(fontSize: 16),
//                         //   ),
//                         // )
//                         ElevatedButton.icon(
//                           onPressed: () async {
//                             final updated = await Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (_) => AddContractor(
//                                       existingContractor: contractor,
//                                       // contractor: contractor, // نمرّر المعلومات الحالية
//                                       // isEdit: true, // وضع التعديل
//                                     ),
//                               ),
//                             );
//                             if (updated == true) {
//                               _loadContractorData(); // إعادة تحميل البيانات بعد التعديل
//                             }
//                           },
//                           icon: const Icon(Icons.edit),
//                           label: const Text('تعديل الملف الشخصي'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade600,
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 32,
//                               vertical: 14,
//                             ),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(20),
//                             ),
//                             textStyle: const TextStyle(fontSize: 16),
//                           ),
//                         )
//                       else
//                         SizedBox(),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }

//   List<Widget> _buildProfileCards() {
//     final List<Map<String, dynamic>> items = [
//       {
//         'label': 'رقم السجل التجاري',
//         'value': contractor?.commercialRegistrationNumber,
//         'icon': Icons.confirmation_number,
//       },
//       {
//         'label': 'البريد الإلكتروني',
//         'value': contractor?.companyEmail,
//         'icon': Icons.email,
//       },
//       {'label': 'الدولة', 'value': contractor?.country, 'icon': Icons.flag},
//       {
//         'label': 'المدينة',
//         'value': contractor?.city,
//         'icon': Icons.location_city,
//       },
//       {
//         'label': 'رقم الهاتف',
//         'value': contractor?.phoneNumber,
//         'icon': Icons.phone,
//       },
//       {
//         'label': 'سنة التأسيس',
//         'value': contractor?.yearEstablished?.toString(),
//         'icon': Icons.calendar_today,
//       },
//       {
//         'label': 'عدد المشاريع آخر 5 سنوات',
//         'value': contractor?.projectsLast5Years?.toString(),
//         'icon': Icons.bar_chart,
//       },
//       {
//         'label': 'شهادات الجودة',
//         'value': contractor?.qualityCertificates?.join('، '),
//         'icon': Icons.verified,
//       },
//       {
//         'label': 'عقود القطاع العام الناجحة',
//         'value': contractor?.publicSectorSuccessfulContracts,
//         'icon': Icons.assignment_turned_in,
//       },
//       {
//         'label': 'الموقع الإلكتروني',
//         'value': contractor?.websiteUrl,
//         'icon': Icons.language,
//       },
//       {
//         'label': 'LinkedIn',
//         'value': contractor?.linkedinProfile,
//         'icon': Icons.link,
//       },
//       {
//         'label': 'وصف الشركة',
//         'value': contractor?.companyBio,
//         'icon': Icons.description,
//       },
//     ];

//     return items.map((item) {
//       final String label = item['label'];
//       final String value = item['value'] ?? 'غير متوفر';
//       final IconData icon = item['icon'];

//       return Card(
//         margin: const EdgeInsets.symmetric(vertical: 6),
//         elevation: 3,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Icon(icon, color: Colors.blue.shade600),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       label,
//                       style: const TextStyle(
//                         fontSize: 14,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(value, style: const TextStyle(fontSize: 15)),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       );
//     }).toList();
//   }
// }
