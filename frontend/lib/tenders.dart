import 'package:flutter/material.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/new_tender.dart';
import 'package:tendersmart/tenders_list.dart';
import 'package:tendersmart/mainScreen.dart';

class Tenders extends StatefulWidget {
  Tenders({super.key, required this.currentTenders});
  final List<Tender> currentTenders;
  @override
  State<Tenders> createState() => _TendersState();
}

class _TendersState extends State<Tenders> {
  String currentUserRole = 'admin';

  void _addtender(Tender ten) {
    setState(() {
      widget.currentTenders.add(ten);
    });
  }

  void _deleteTender(Tender tender) {
    setState(() {
      widget.currentTenders.remove(tender);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text(
          'المناقصات الحالية',
          style: TextStyle(
            // backgroundColor: Colors.tealAccent,
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        // leading: Icon(Icons.add),//leading هي الاشياء التي اريد عرضها قبل العنوان من جهة اليسار
        actions: [
          //Icon(Icons.add),
          // OutlinedButton.icon:currentUserRole=='admin'?
          if (currentUserRole == 'admin')
            OutlinedButton.icon(
              label: Text('إضافة مناقصة'),
              onPressed: () {
                // switchScreenToAddTenderM,
                showModalBottomSheet(
                  isScrollControlled: true, //يسمح للموديل بملئ الشاشة
                  backgroundColor: Colors.transparent, //لتفادي الحواف البيضاء
                  context: context,
                  builder:
                      (context) => Container(
                        height:
                            MediaQuery.of(context).size.height *
                            0.90, //0.96تفريباً كل الشاشة
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20),
                          ),
                        ),
                        child: NewTender(onAddTender: _addtender),
                      ),
                );
              },
              icon: Icon(Icons.add),
            )
          else
            SizedBox(),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: TenderListPage(
              tenders: widget.currentTenders,
              onDeleteTender: _deleteTender,
            ),
          ),
        ],
      ),
    );
  }
}
