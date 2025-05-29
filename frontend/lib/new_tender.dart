import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/tender_service.dart';

class NewTender extends StatefulWidget {
  const NewTender({super.key, required this.onAddTender});
  final void Function(Tender tender) onAddTender;

  @override
  State<NewTender> createState() => _NewTenderState();
}

class _NewTenderState extends State<NewTender> {
  final _titleController = TextEditingController();
  final _descripeController = TextEditingController();
  final _locationController = TextEditingController();
  final _implmentationPeriodController = TextEditingController();
  final _numberOfTechnicalConditionsController = TextEditingController();
  final _budgetController = TextEditingController();
  final formatter = DateFormat.yMd();
  DateTime? _expectedStartTime;
  DateTime? _registrationDeadline;
  StateOfTender _selectedState = StateOfTender.opened;
  late Future<List<Tender>> tendersFuture;

  @override
  void dispose() {
    super.dispose();
    _titleController.dispose();
    _budgetController.dispose();
    _descripeController.dispose();
    _implmentationPeriodController.dispose();
    _numberOfTechnicalConditionsController.dispose();
    _locationController.dispose();
  } //لتدمير الكونتولار بعد الانتهاء من العمل

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 16,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: InputDecoration(label: Text('العنوان')),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 75,
            ),
            TextField(
              decoration: InputDecoration(label: Text('الوصف')),
              // onChanged: _saveChangeTitle,
              controller: _descripeController,
              // maxLength: ,
            ),
            TextField(
              decoration: InputDecoration(label: Text('الموقع')),
              // onChanged: _saveChangeTitle,
              controller: _locationController,
              keyboardType: TextInputType.streetAddress,
            ),
            TextField(
              decoration: InputDecoration(label: Text('وقت التنفيذ(بالأيام)')),
              // onChanged: _saveChangeTitle,
              controller: _implmentationPeriodController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
            ),
            TextField(
              decoration: InputDecoration(label: Text('عدد الشروط الفنية')),
              // onChanged: _saveChangeTitle,
              controller: _numberOfTechnicalConditionsController,
              keyboardType: TextInputType.numberWithOptions(decimal: false),
            ),
            TextField(
              controller: _budgetController,
              keyboardType:
                  TextInputType
                      .number, // ال لتعريف نمط المدخلات التي سيدخلها المستخدم
              decoration: InputDecoration(
                prefixText: 'ٍS.P', //لوضع شيء ثابت قبل النص المدخل
                label: Text('الميزانية'),
              ),
              // onChanged: _saveChangeTitle,
            ),
            Row(
              children: [
                // Flexible(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         _expectedStartTime == null
                //             ? 'الوقت المتوقع للبدء'
                //             : formatter.format(_expectedStartTime!),
                //       ),
                //       IconButton(
                //         onPressed: () async {
                //           final now = DateTime.now();
                //           final firstDate = DateTime(
                //             now.year - 1,
                //             now.month,
                //             now.day,
                //           );
                //           final DateTime? pickedDate = await showDatePicker(
                //             context: context,
                //             firstDate: firstDate,
                //             lastDate: now,
                //             // initialDate: now,
                //           );
                //           setState(() {
                //             _expectedStartTime = pickedDate;
                //           });
                //         },
                //         icon: Icon(Icons.calendar_month),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _registrationDeadline == null
                            ? 'آخر موعد للتقديم'
                            : formatter.format(_registrationDeadline!),
                      ),
                      IconButton(
                        onPressed: () async {
                          final now = DateTime.now();
                          final firstDate = DateTime(
                            now.year - 1,
                            now.month,
                            now.day,
                          );
                          final DateTime? pickedDate = await showDatePicker(
                            context: context,
                            firstDate: firstDate,
                            // lastDate: now,
                            lastDate: DateTime(
                              now.year + 1,
                              now.month,
                              now.day,
                            ),
                            // initialDate: DateTime(now.year+1,now.month,now.day),
                          );
                          setState(() {
                            _registrationDeadline = pickedDate;
                          });
                        },
                        icon: Icon(Icons.calendar_month),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 5),
            Row(
              children: [
                DropdownButton(
                  value: _selectedState,
                  items:
                      StateOfTender.values
                          .map(
                            (e) => DropdownMenuItem(
                              value: e,
                              child: Text(e.name.toUpperCase()),
                            ),
                          )
                          .toList(),
                  onChanged: (newCat) {
                    if (newCat == null) {
                      return;
                    }
                    setState(() {
                      _selectedState = newCat;
                    });
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    'Cancel',
                    style: TextStyle(backgroundColor: Colors.blue[200]),
                  ),
                ),
                SizedBox(width: 5),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
                  ),
                  onPressed: () async {
                    final double? enteredBudget = double.tryParse(
                      _budgetController.text,
                    );
                    final bool budgetIsInvalid =
                        enteredBudget == null || enteredBudget <= 0;

                    final int? enteredImplementationPeriod = int.tryParse(
                      _implmentationPeriodController.text,
                    );
                    final bool implementationPeriodIsInvalid =
                        enteredImplementationPeriod == null ||
                        enteredImplementationPeriod <= 0;
                    final int? enterednumberOfTechnicalConditions =
                        int.tryParse(
                          _numberOfTechnicalConditionsController.text,
                        );
                    final bool numberOfTechnicalConditionsIsInvalid =
                        enterednumberOfTechnicalConditions == null ||
                        enterednumberOfTechnicalConditions <= 0;
                    //final snackBar = SnackBar(content: Text('Error'));
                    if (_titleController.text.trim().isEmpty ||
                        _descripeController.text.trim().isEmpty ||
                        _locationController.text.trim().isEmpty ||
                        budgetIsInvalid ||
                        implementationPeriodIsInvalid ||
                        numberOfTechnicalConditionsIsInvalid ||
                        // _expectedStartTime == null ||
                        _registrationDeadline == null) {
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
                      final newTender = Tender(
                        title: _titleController.text,
                        descripe: _descripeController.text,
                        location: _locationController.text,
                        implementationPeriod: enteredImplementationPeriod,
                        numberOfTechnicalConditions:
                            enterednumberOfTechnicalConditions,
                        registrationDeadline: _registrationDeadline!,
                        stateOfTender: _selectedState,
                        // expectedStartTime: _expectedStartTime!,
                        budget: enteredBudget,
                      );
                      try {
                        await TenderService.addTenders(newTender);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تمت الإضافة بنجاح')),
                        );
                        Navigator.pop(context);
                        tendersFuture;
                        // setState(() {
                        //   tendersFuture = TenderService.fetchTenders();
                        // });
                      } catch (e, stackTrace) {
                        log('خطأ في الاضافة : $e');
                        log('Stack trace : $stackTrace');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('فشل في الإضافة :$e')),
                        );
                        Navigator.pop(context);
                      }
                      // widget.onAddTender(
                      //   Tender(
                      //     title: _titleController.text,
                      //     descripe: _descripeController.text,
                      //     location: _locationController.text,
                      //     implementationPeriod: enteredImplementationPeriod,
                      //     numberOfTechnicalConditions:
                      //         enterednumberOfTechnicalConditions,
                      //     registrationDeadline: _expectedStartTime!,
                      //     stateOfTender: _selectedState,
                      //     budget: enteredBudget,
                      //     expectedStartTime: _expectedStartTime!,
                      //   ),
                      // );
                    }
                  },
                  child: Text('Save Tender'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
