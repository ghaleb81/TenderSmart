import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddContractor extends StatefulWidget {
  const AddContractor({super.key});

  @override
  State<AddContractor> createState() => _AddContractorState();
}

class _AddContractorState extends State<AddContractor> {
  final _company_nameController = TextEditingController();
  final _commercial_registration_numberController = TextEditingController();
  final _company_emailController = TextEditingController();
  final _country_cityController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _year_establishedController = TextEditingController();
  final _projects_last_5_yearsController = TextEditingController();
  final _quality_certificatesController = TextEditingController();
  final _public_sector_successful_contractsController = TextEditingController();
  final _website_url_linkedin_profileController = TextEditingController();
  final _company_bioController = TextEditingController();
  final _upload_official_documents_amountController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('اهلاً بك'), backgroundColor: Colors.blue),
      body: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(label: Text(': اسم الشركة')),
              // onChanged: _saveChangeTitle,
              controller: _company_nameController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': رقم السجل التجاري/الترخيص'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _commercial_registration_numberController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': البريد الإلكتروني للشركة'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _company_emailController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': الدولة/المدينة')),
              // onChanged: _saveChangeTitle,
              controller: _country_cityController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': رقم الهاتف')),
              // onChanged: _saveChangeTitle,
              controller: _phoneNumberController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': سنة تأسيس الشركة')),
              // onChanged: _saveChangeTitle,
              controller: _year_establishedController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': عدد المشاريع المنفذة آخر 5 سنوات'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _projects_last_5_yearsController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': شهادات الجودة')),
              // onChanged: _saveChangeTitle,
              controller: _quality_certificatesController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': العقود الناجحة للقطاع العام'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _public_sector_successful_contractsController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': Website url/linkedin Profile'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _website_url_linkedin_profileController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': وصف الشركة')),
              // onChanged: _saveChangeTitle,
              controller: _company_bioController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': تحميل الوثائق الرسمية'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _upload_official_documents_amountController,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContractorInformation(),
                      ),
                    );
                  },
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

class ContractorInformation extends StatefulWidget {
  const ContractorInformation({super.key});

  @override
  State<ContractorInformation> createState() => _ContractorInformationState();
}

class _ContractorInformationState extends State<ContractorInformation> {
  final _cotractorEmailController = TextEditingController();
  final _cotractorPasswordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Colors.blue, Colors.indigo]),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(
                label: Text(': البريد الإلتروني', textAlign: TextAlign.center),
              ),
              keyboardType: TextInputType.emailAddress,
              controller: _cotractorEmailController,
            ),
            TextField(
              textAlign: TextAlign.end,
              decoration: InputDecoration(label: Text(': كلمة المرور')),
              keyboardType: TextInputType.visiblePassword,
              controller: _cotractorPasswordController,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(onPressed: () {}, child: Text('Save')),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
