import 'package:flutter/material.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/services/contractor_service.dart';

class ContractorProfilePage extends StatefulWidget {
  const ContractorProfilePage({super.key});

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
      // استدعاء الدالة التي تجلب بيانات المقاول من الباكند
      Contractor? data = await ContractorService.getContractorInfo();

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
    return Scaffold(
      appBar: AppBar(
        title: Text('ملف المقاول الشخصي'),
        backgroundColor: Colors.blue,
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : contractor == null
              ? Center(child: Text('لم يتم العثور على بيانات'))
              : SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🟢 عرض اسم الشركة
                    _buildProfileItem('اسم الشركة', contractor!.companyName),
                    _buildProfileItem(
                      'رقم السجل التجاري',
                      contractor!.commercialRegistrationNumber,
                    ),
                    _buildProfileItem(
                      'البريد الإلكتروني',
                      contractor!.companyEmail,
                    ),
                    _buildProfileItem('الدولة', contractor!.country),
                    _buildProfileItem('المدينة', contractor!.city),
                    _buildProfileItem('رقم الهاتف', contractor!.phoneNumber),
                    // _buildProfileItem('سنة التأسيس', contractor!.yearEstablished),
                    _buildProfileItem(
                      'عدد المشاريع آخر 5 سنوات',
                      contractor!.projectsLast5Years?.toString() ?? 'غير محدد',
                    ),
                    // _buildProfileItem('شهادات الجودة', contractor!.qualityCertificates.join(', ')),
                    _buildProfileItem(
                      'عقود القطاع العام الناجحة',
                      contractor!.publicSectorSuccessfulContracts,
                    ),
                    _buildProfileItem(
                      'الموقع الإلكتروني',
                      contractor!.websiteUrl,
                    ),
                    _buildProfileItem(
                      'الملف على LinkedIn',
                      contractor!.linkedinProfile,
                    ),
                    _buildProfileItem('وصف الشركة', contractor!.companyBio),

                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          // الانتقال إلى صفحة تعديل الملف (اختياري)
                          // Navigator.push(context, MaterialPageRoute(
                          //   builder: (context) => EditContractorPage(contractor: contractor!),
                          // ));
                        },
                        child: Text('تعديل الملف الشخصي'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[200],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildProfileItem(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label: ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'غير متوفر')),
        ],
      ),
    );
  }
}
