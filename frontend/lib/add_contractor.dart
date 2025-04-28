import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddContractor extends StatefulWidget {
  const AddContractor({super.key});

  @override
  State<AddContractor> createState() => _AddContractorState();
}

class _AddContractorState extends State<AddContractor> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final formatter = DateFormat.yMd();
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
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': رقم السجل التجاري/الترخيص'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': البريد الإلكتروني للشركة'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': الدولة/المدينة')),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': رقم الهاتف')),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': سنة تأسيس الشركة')),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': عدد المشاريع المنفذة آخر 5 سنوات'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': شهادات الجودة')),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': العقود الناجحة للقطاع العام'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': Website url/linkedin Profile'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(label: Text(': وصف الشركة')),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            TextField(
              decoration: InputDecoration(
                label: Text(': تحميل الوثائق الرسمية'),
              ),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
          ],
        ),
      ),
    );
  }
}
