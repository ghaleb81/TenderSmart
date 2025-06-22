import 'package:flutter/material.dart';
import '../models/contractor.dart';
import '../services/contractor_service.dart';

class ContractorProfilePage extends StatefulWidget {
  ContractorProfilePage({super.key, this.user_id});
  String? user_id;

  @override
  State<ContractorProfilePage> createState() => _ContractorProfilePageState();
}

class _ContractorProfilePageState extends State<ContractorProfilePage> {
  Contractor? contractor;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContractorData();
  }

  Future<void> _loadContractorData() async {
    try {
      Contractor? data = await ContractorService.getContractorInfo(
        int.tryParse(widget.user_id!) ?? 0,
      );
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
        appBar: AppBar(
          title: const Text(
            'ملف المقاول الشخصي',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.blue.shade800,
          centerTitle: true,
        ),
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
                      ElevatedButton.icon(
                        onPressed: () {
                          // الانتقال إلى صفحة التعديل
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

// import 'package:tendersmart/models/contractor.dart';
// import 'package:tendersmart/services/contractor_service.dart';
//
// class ContractorProfilePage extends StatefulWidget {
//   const ContractorProfilePage({super.key});
//
//   @override
//   State<ContractorProfilePage> createState() => _ContractorProfilePageState();
// }
//
// class _ContractorProfilePageState extends State<ContractorProfilePage> {
//   Contractor? contractor;
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _loadContractorData();
//   }
//
//   Future<void> _loadContractorData() async {
//     try {
//       Contractor? data = await ContractorService.getContractorInfo();
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
//
//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       // لجعل النص من اليمين
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(
//             'ملف المقاول الشخصي',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontSize: 20,
//             ),
//           ),
//           backgroundColor: Colors.blue.shade700,
//           centerTitle: true,
//         ),
//         body:
//             isLoading
//                 ? Center(child: CircularProgressIndicator())
//                 : contractor == null
//                 ? Center(child: Text('لم يتم العثور على بيانات'))
//                 : SingleChildScrollView(
//                   padding: EdgeInsets.all(16),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.stretch,
//                     children: [
//                       ..._buildProfileItems(),
//
//                       SizedBox(height: 30),
//                       Center(
//                         child: ElevatedButton.icon(
//                           onPressed: () {
//                             // الانتقال إلى صفحة تعديل الملف الشخصي
//                           },
//                           icon: Icon(Icons.edit),
//                           label: Text('تعديل الملف الشخصي'),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: Colors.blue.shade400,
//                             padding: EdgeInsets.symmetric(
//                               horizontal: 24,
//                               vertical: 12,
//                             ),
//                             textStyle: TextStyle(fontSize: 16),
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(12),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//       ),
//     );
//   }
//
//   List<Widget> _buildProfileItems() {
//     final items = <Map<String, String?>>[
//       {'اسم الشركة': contractor?.companyName},
//       {'رقم السجل التجاري': contractor?.commercialRegistrationNumber},
//       {'البريد الإلكتروني': contractor?.companyEmail},
//       {'الدولة': contractor?.country},
//       {'المدينة': contractor?.city},
//       {'رقم الهاتف': contractor?.phoneNumber},
//       {'سنة التأسيس': contractor?.yearEstablished?.toString()},
//       {
//         'عدد المشاريع آخر 5 سنوات':
//             contractor?.projectsLast5Years?.toString() ?? 'غير محدد',
//       },
//       {
//         'شهادات الجودة':
//             contractor?.qualityCertificates?.join('، ') ?? 'غير محدد',
//       },
//       {
//         'عقود القطاع العام الناجحة':
//             contractor?.publicSectorSuccessfulContracts,
//       },
//       {'الموقع الإلكتروني': contractor?.websiteUrl},
//       {'الملف على LinkedIn': contractor?.linkedinProfile},
//       {'وصف الشركة': contractor?.companyBio},
//     ];
//
//     return items.map((item) {
//       final label = item.keys.first;
//       final value = item.values.first ?? 'غير متوفر';
//       return Card(
//         margin: EdgeInsets.symmetric(vertical: 6),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//         elevation: 2,
//         child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 '$label: ',
//                 style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//               ),
//               Expanded(child: Text(value, style: TextStyle(fontSize: 16))),
//             ],
//           ),
//         ),
//       );
//     }).toList();
//   }
// }
