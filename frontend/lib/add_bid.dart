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
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final formatter = DateFormat.yMd();
  DateTime? _selectedDate;
  StateOfTender _selectedCategory = StateOfTender.opened;

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
  } //لتدمير الكونتولار بعد الانتهاء من العمل

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Expanded(
        child: Column(
          children: [
            //SizedBox(
            //height: 300,
            //width: double.infinity,
            // child:
            TextField(
              decoration: InputDecoration(label: Text('Title')),
              // onChanged: _saveChangeTitle,
              controller: _titleController,
              maxLength: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _amountController,
                    keyboardType:
                        TextInputType
                            .number, // ال لتعريف نمط المدخلات التي سيدخلها المستخدم
                    decoration: InputDecoration(
                      prefixText: '\$', //لوضع شيء ثابت قبل النص المدخل
                      label: Text('Amount'),
                    ),
                    // onChanged: _saveChangeTitle,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        _selectedDate == null
                            ? 'No Date Selected'
                            : formatter.format(_selectedDate!),
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
                            lastDate: now,
                            // initialDate: now,
                          );
                          setState(() {
                            _selectedDate = pickedDate;
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
                  value: _selectedCategory,
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
                      _selectedCategory = newCat;
                    });
                  },
                ),
                const Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final double? enteredAmount = double.tryParse(
                      _amountController.text,
                    );
                    final bool amountIsInvalid =
                        enteredAmount == null || enteredAmount <= 0;
                    //final snackBar = SnackBar(content: Text('Error'));
                    if (_titleController.text.trim().isEmpty ||
                        amountIsInvalid ||
                        _selectedDate == null) {
                      // ScaffoldMessenger.of(context).showSnackBar(snackBar);عرض رسالة خطأ لثواني معدودة
                      showDialog(
                        context: context,
                        builder:
                            (ctx) => AlertDialog(
                              title: Text('Invaled Input'),
                              content: Text(
                                'please make sure valied title , amount , date and category was entered',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: Text('okey'),
                                ),
                              ],
                            ),
                      );
                      // log(_titleController.text);
                      // log(_amountController.text);
                    }
                    // else {
                    //   widget.onAddExpense(
                    //     Tender(
                    //       stateOfTender: _selectedCategory,
                    //       expectedStartTime: _selectedDate!,
                    //       title: _titleController.text,
                    //       budget: enteredAmount,
                    //       descripe: '',
                    //       location: '',
                    //       implementationPeriod: 3,
                    //       numberOfTechnicalConditions: 4,
                    //       registrationDeadline: DateTime(2000),
                    //     ),
                    //   );
                    //   Navigator.pop(context);
                    // }
                  },
                  child: Text('Save Expense'),
                  // child: Text('save Expense'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
