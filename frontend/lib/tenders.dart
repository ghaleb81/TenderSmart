import 'package:flutter/material.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/new_tender.dart';
import 'package:tendersmart/tenders_list.dart';
import 'package:tendersmart/mainScreen.dart';

class Tenders extends StatefulWidget {
  Tenders({
    super.key,
    required this.switchScreenToTenders,
    required this.currentTenders,
    // required this.onDeleteTender,
  });
  void Function() switchScreenToTenders;
  final List<Tender> currentTenders;
  // final void Function(Tender tender) onDeleteTender;
  @override
  State<Tenders> createState() => _TendersState();
}

class _TendersState extends State<Tenders> {
  String currentUserRole = 'admin';
  // final List<Tender> _currentTenders = [
  //   Tender(
  //     title: 'إدارة مقصف كلية الهندسة المعلوماتية',
  //     descripe:
  //         'كلية المعلوماتية التابعة لجامعة الشام الخاصة بحاجة لاستثمار للمقصف بداخلها وادارة خدمة الطلاب على مدار دوام الكلية من الساعة 8 صباحاً حتى 3 عصراً',
  //     location: 'ريف دمشق_التل',
  //     implementationPeriod: 15,
  //     numberOfTechnicalConditions: 3,
  //     registrationDeadline: DateTime(2025, 23, 4),
  //     stateOfTender: StateOfTender.opened,
  //     expectedStartTime: DateTime(2025, 12, 4),
  //     budget: 400000.33,
  //   ),
  //   Tender(
  //     title: 'إدارة المركز الطبي في جامعة الشام الخاصة',
  //     descripe:
  //         'جامعة الشام الخاصة بحاجة لاستثمار للمركز الطبي بداخلها وادارة خدمة المرضى على مدار دوام الكلية من الساعة 8 صباحاً حتى 4 عصراً',
  //     location: 'ريف دمشق_التل',
  //     implementationPeriod: 20,
  //     numberOfTechnicalConditions: 7,
  //     registrationDeadline: DateTime(2025, 23, 4),
  //     stateOfTender: StateOfTender.opened,
  //     expectedStartTime: DateTime(2025, 23, 4),
  //     budget: 33333.222,
  //   ),
  //   Tender(
  //     title: 'إدارة مكتبة في كلية الطب البشري',
  //     descripe: 'descripe',
  //     location: 'ريف دمشق_التل',
  //     implementationPeriod: 10,
  //     numberOfTechnicalConditions: 9,
  //     registrationDeadline: DateTime(2025, 23, 4),
  //     stateOfTender: StateOfTender.opened,
  //     expectedStartTime: DateTime(2025, 23, 4),
  //     budget: 2220022,
  //   ),
  //   Tender(
  //     title: 'توريد مستلزمات طبية لكلية طب الأسنان',
  //     descripe: 'descripe',
  //     location: 'دمشق_المزرعة',
  //     implementationPeriod: 28,
  //     numberOfTechnicalConditions: 5,
  //     registrationDeadline: DateTime(2025, 23, 4),
  //     stateOfTender: StateOfTender.opened,
  //     expectedStartTime: DateTime(2025, 23, 4),
  //     budget: 3333333,
  //   ),
  // ];

  void _addtender(Tender ten) {
    setState(() {
      widget.currentTenders.add(ten);
    });
  }
  //  void switchScreenToNewTender() {
  //   setState(() {
  //     // log(selectedAnswer.toString());
  //     widget.activeScreen = Tenders();
  //   });
  // }

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
                        // padding: EdgeInsets.all(16),
                        child: NewTender(onAddTender: _addtender),
                      ),
                );
              },
              // switchScreenToAddTenderM,
              // showModalBottomSheet(
              //   context: context,
              //   builder: (ctx) => NewTender(onAddExpense: _addtender),
              // );

              // log(_currentTenders.length.toString());
              //showModalBottomSheet(context: context, builder:(ctx)=>)
              // showModalBottomSheet(
              //   context: context,
              //   // builder: (ctx) => NewExpense(onAddExpense: _addExpense),
              // );
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
              switchScreenToTenders: widget.switchScreenToTenders,
              // onDeleteTender: widget.onDeleteTender(Tender tender)
            ),
          ),
        ],
      ),
    );
  }
}
