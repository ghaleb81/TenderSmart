import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendersmart/models/Tender.dart';

class AddBid extends StatefulWidget {
  const AddBid({
    super.key,
    //  required this.onAddExpense
  });
  // final void Function(Tender expense) onAddExpense;

  @override
  State<AddBid> createState() => _AddBidState();
}

class _AddBidState extends State<AddBid> {
  // var _title = '';
  // _saveChangeTitle(String inputUser){
  //   setState(() {
  //     _title = inputUser;
  //   });
  // }
  final _bid_amountController = TextEditingController();
  final _completion_time_exceptedController = TextEditingController();
  final _technical_matched_countController = TextEditingController();
  final _technical_proposal_pdfController = TextEditingController();

  @override
  void dispose() {
    _bid_amountController.dispose();
    _completion_time_exceptedController.dispose();
    _technical_matched_countController.dispose();
    _technical_proposal_pdfController.dispose();
  } //لتدمير الكونتولار بعد الانتهاء من العمل

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'طلب توريد',
          style: TextStyle(
            // backgroundColor: Colors.tealAccent,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            children: [
              //SizedBox(
              //height: 300,
              //width: double.infinity,
              // child:
              TextField(
                decoration: InputDecoration(
                  label: Text(': الميزانية المقدمة من قبل المقاول'),
                ),
                // onChanged: _saveChangeTitle,
                controller: _bid_amountController,
                maxLength: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text(': وقت التنفيذ للمقاول'),
                ),
                // onChanged: _saveChangeTitle,
                controller: _completion_time_exceptedController,
                maxLength: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text(': عدد الشروط الفنية المطابقة'),
                ),
                // onChanged: _saveChangeTitle,
                controller: _technical_matched_countController,
                maxLength: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text(': ملف العرض الفني المقدم من المقاول'),
                ),
                // onChanged: _saveChangeTitle,
                controller: _technical_proposal_pdfController,
                maxLength: 50,
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: () {}, child: Text('Save')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
