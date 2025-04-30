import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendersmart/models/contractor.dart';

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
  AddContractor({super.key, required this.addContractor});
  void Function(Contractor contractot) addContractor;
  @override
  State<AddContractor> createState() => _AddContractorState();
}

class _AddContractorState extends State<AddContractor> {
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
              controller: _companyNameController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': رقم السجل التجاري/الترخيص'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _commercialRegistrationNumberController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': البريد الإلكتروني للشركة'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _companyEmailController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': الدولة/المدينة')),
              // onChanged: _saveChangeTitle,
              controller: _countryCityController,
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
              controller: _yearEstablishedController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': عدد المشاريع المنفذة آخر 5 سنوات'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _projectsLast5YearsController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': شهادات الجودة')),
              // onChanged: _saveChangeTitle,
              controller: _qualityCertificatesController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': العقود الناجحة للقطاع العام'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _publicSectorSuccessfulContractsController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': Website url/linkedin Profile'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _websiteUrlLinkedinProfileController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': وصف الشركة')),
              // onChanged: _saveChangeTitle,
              controller: _companyBioController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': تحميل الوثائق الرسمية'),
              ),
              // onChanged: _saveChangeTitle,
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
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ContractorInformation(
                              addContractor: widget.addContractor,
                            ),
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
  ContractorInformation({super.key, required this.addContractor});
  void Function(Contractor contractor) addContractor;
  @override
  State<ContractorInformation> createState() => _ContractorInformationState();
}

class _ContractorInformationState extends State<ContractorInformation> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  void _submit() {
    String emailOfCompany = _companyEmailController.text;
    String email = _emailController.text;
    String password = _passwordController.text;

    if (ContractorValidator.isValid(email, password, emailOfCompany)) {
      // widget.addContractor(
      //   Contractor(
      //     companyName: companyName,
      //     commercialRegistrationNumber: commercialRegistrationNumber,
      //     companyEmail: companyEmail,
      //     countryCity: countryCity,
      //     phoneNumber: phoneNumber,
      //     yearEstablished: yearEstablished,
      //     projectsLast5Years: projectsLast5Years,
      //     qualityCertificates: qualityCertificates,
      //     publicSectorSuccessfulContracts: publicSectorSuccessfulContracts,
      //     websiteUrlOrLinkedinProfile: websiteUrlOrLinkedinProfile,
      //     companyBio: companyBio,
      //     uploadOfficialDocumentsAmount: uploadOfficialDocumentsAmount,
      //     email: email,
      //     password: password,
      //   ),
      // );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم تسجيل الدخول بنجاح')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('البريد الإلتروني أو كلمة المرور غير صالحين')),
      );
    }
  }

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
              controller: _emailController,
            ),
            TextField(
              textAlign: TextAlign.end,
              decoration: InputDecoration(label: Text(': كلمة المرور')),
              // keyboardType: TextInputType.visiblePassword,
              obscureText: true,
              controller: _passwordController,
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _submit();
                    // Navigator.pop(context);
                  },
                  child: Text('Save'),
                ),
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
