import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendersmart/file_picker_text_field.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';

class AddBid extends StatefulWidget {
  const AddBid({super.key, required this.addBid});
  final void Function(Bid bid) addBid;

  @override
  State<AddBid> createState() => _AddBidState();
}

class _AddBidState extends State<AddBid> {
  // List<Bid> Bid_Contractor = [
  //   Bid(
  //     bid_amount: 3222,
  //     completion_time_excepted: 2,
  //     technical_matched_count: 5,
  //   ),
  //   Bid(
  //     bid_amount: 444,
  //     completion_time_excepted: 3,
  //     technical_matched_count: 3,
  //   ),
  //   Bid(
  //     bid_amount: 111,
  //     completion_time_excepted: 4,
  //     technical_matched_count: 9,
  //   ),
  // ];
  final _bid_amountController = TextEditingController();
  final _completion_time_exceptedController = TextEditingController();
  final _technical_matched_countController = TextEditingController();
  final _technical_proposal_pdfController = TextEditingController();
  // void _addBid(Bid bid) {
  //   setState(() {
  //     Bid_Contractor.add(bid);
  //   });
  // }

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
        automaticallyImplyLeading: false,
        // leading: IconButton(
        //   onPressed: () => Navigator.pop(context),
        //   icon: Icon(Icons.arrow_back),
        // ),
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'طلب توريد',
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  label: Text(': الميزانية المقدمة من قبل المقاول'),
                ),
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
              FilePickerTextField(),
              // TextField(
              //   decoration: InputDecoration(
              //     label: Text(': ملف العرض الفني المقدم من المقاول'),
              //   ),
              //   // onChanged: _saveChangeTitle,
              //   controller: _technical_proposal_pdfController,
              //   maxLength: 50,
              // ),
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
                  ElevatedButton(
                    onPressed: () {
                      final double? enteredBidAmount = double.tryParse(
                        _bid_amountController.text,
                      );
                      final bool bidAmountIsInvalid =
                          enteredBidAmount == null || enteredBidAmount <= 0;

                      final int? enterdCompletionTimeExcepted = int.tryParse(
                        _completion_time_exceptedController.text,
                      );
                      final bool CompletionTimeExceptedIsInvalid =
                          enterdCompletionTimeExcepted == null ||
                          enterdCompletionTimeExcepted <= 0;
                      final int? enteredTechnicalMatchedCount = int.tryParse(
                        _technical_matched_countController.text,
                      );
                      final bool TechnicalMatchedCountIsInvalid =
                          enteredTechnicalMatchedCount == null ||
                          enteredTechnicalMatchedCount <= 0;
                      //final snackBar = SnackBar(content: Text('Error'));
                      if (bidAmountIsInvalid ||
                          CompletionTimeExceptedIsInvalid ||
                          TechnicalMatchedCountIsInvalid) {
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);عرض رسالة خطأ لثواني معدودة
                        showDialog(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                // title: Text('Invaled Input'),
                                // backgroundColor: Colors.blue,
                                icon: Icon(Icons.warning),
                                title: Center(
                                  child: Text(
                                    'إدخال خاطئ',
                                    style: TextStyle(
                                      fontSize: 20,
                                      // backgroundColor: Colors.blue,
                                    ),
                                  ),
                                ),
                                content: Text(
                                  'الرجاء إدخال قيم صحيحية',
                                  textAlign: TextAlign.center,
                                ),
                                actions: [
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor: WidgetStatePropertyAll(
                                        Colors.blue[200],
                                      ),
                                    ),
                                    onPressed: () => Navigator.pop(ctx),
                                    child: Text('حسناً'),
                                  ),
                                ],
                              ),
                        );
                        // log(_titleController.text);
                        // log(_amountController.text);
                      } else {
                        widget.addBid(
                          Bid(
                            bidAmount: enteredBidAmount,
                            completionTimeExcepted:
                                enterdCompletionTimeExcepted,
                            technicalMatchedCount: enteredTechnicalMatchedCount,
                          ),
                          // Tender(
                          //   title: _titleController.text,
                          //   descripe: _descripeController.text,
                          //   location: _locationController.text,
                          //   implementationPeriod: enteredImplementationPeriod,
                          //   numberOfTechnicalConditions:
                          //       enterednumberOfTechnicalConditions,
                          //   registrationDeadline: _expectedStartTime!,
                          //   stateOfTender: _selectedState,
                          //   budget: enteredBidAmount,
                          //   expectedStartTime: _expectedStartTime!,
                          // ),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Save'),
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
