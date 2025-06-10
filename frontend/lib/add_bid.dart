import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendersmart/file_picker_text_field.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/bid_service.dart';
import 'package:tendersmart/services/token_storage.dart';

class AddBid extends StatefulWidget {
  AddBid({super.key, this.addBid, required this.tenderId});
  final void Function(Bid bid)? addBid;
  final tenderId;

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
  final _bidAmountController = TextEditingController();
  final _completionTimeExceptedController = TextEditingController();
  final _technicalMatchedCountController = TextEditingController();
  final _technicalProposalPdfController = TextEditingController();
  // void _addBid(Bid bid) {
  //   setState(() {
  //     Bid_Contractor.add(bid);
  //   });
  // }
  File? _selectedTechnicalProposalPdf;

  @override
  void dispose() {
    super.dispose();
    _bidAmountController.dispose();
    _completionTimeExceptedController.dispose();
    _technicalMatchedCountController.dispose();
    _technicalProposalPdfController.dispose();
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
                controller: _bidAmountController,
                maxLength: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text(': وقت التنفيذ للمقاول'),
                ),
                // onChanged: _saveChangeTitle,
                controller: _completionTimeExceptedController,
                maxLength: 50,
              ),
              TextField(
                decoration: InputDecoration(
                  label: Text(': عدد الشروط الفنية المطابقة'),
                ),
                // onChanged: _saveChangeTitle,
                controller: _technicalMatchedCountController,
                maxLength: 50,
              ),
              FilePickerTextField(
                onFilePicked: (file) {
                  setState(() {
                    _selectedTechnicalProposalPdf = file;
                  });
                },
              ),

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
                    onPressed: () async {
                      final double? enteredBidAmount = double.tryParse(
                        _bidAmountController.text,
                      );
                      final bool bidAmountIsInvalid =
                          enteredBidAmount == null || enteredBidAmount <= 0;

                      final int? enterdCompletionTimeExcepted = int.tryParse(
                        _completionTimeExceptedController.text,
                      );
                      final bool CompletionTimeExceptedIsInvalid =
                          enterdCompletionTimeExcepted == null ||
                          enterdCompletionTimeExcepted <= 0;
                      final int? enteredTechnicalMatchedCount = int.tryParse(
                        _technicalMatchedCountController.text,
                      );
                      final bool TechnicalMatchedCountIsInvalid =
                          enteredTechnicalMatchedCount == null ||
                          enteredTechnicalMatchedCount <= 0;
                      if (bidAmountIsInvalid ||
                          CompletionTimeExceptedIsInvalid ||
                          TechnicalMatchedCountIsInvalid) {
                        // ScaffoldMessenger.of(context).showSnackBar(snackBar);عرض رسالة خطأ لثواني معدودة
                        showDialog(
                          context: context,
                          builder:
                              (ctx) => AlertDialog(
                                icon: Icon(Icons.warning),
                                title: Center(
                                  child: Text(
                                    'إدخال خاطئ',
                                    style: TextStyle(fontSize: 20),
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
                      } else {
                        final contractorId = await TokenStorage.getUserrId();
                        final bid = Bid(
                          contractorId: contractorId,
                          tenderId: widget.tenderId,
                          bidAmount: enteredBidAmount,
                          completionTimeExcepted: enterdCompletionTimeExcepted,
                          technicalMatchedCount: enteredTechnicalMatchedCount,
                        );
                        try {
                          await BidService.addBid(bid);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('تمت الإضافة بنجاح')),
                          );
                          Navigator.pop(context);
                          // setState(() {
                          //   tendersFuture = TenderService.fetchTenders();
                          // });
                        } catch (e, stackTrace) {
                          log('خطأ في الاضافة : $e');
                          log('Stack trace : $stackTrace');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('فشل في الإضافة :$e')),
                          );
                          print(contractorId);
                          print(bid.tenderId);
                          Navigator.pop(context);
                        }
                        // BidService.addBid(
                        //   bidAmount: ,
                        //   completionTime: enterdCompletionTimeExcepted,
                        //   technicalMatched: enteredTechnicalMatchedCount,
                        //   // technicalProposalPdf: _selectedTechnicalProposalPdf,
                        //   // token: TokenStorage.getToken().toString(),
                        // );

                        // widget.addBid(
                        //   Bid(
                        //     tenderId: widget.tenderId,
                        //     bidAmount: enteredBidAmount,
                        //     completionTimeExcepted:
                        //         enterdCompletionTimeExcepted,
                        //     technicalMatchedCount: enteredTechnicalMatchedCount,
                        //     // contractorId:
                        //   ),
                        // );
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
