import 'package:flutter/material.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/tenders.dart';
import 'package:tendersmart/tenders_list.dart';

class TenderDetails extends StatelessWidget {
  TenderDetails({
    super.key,
    required this.tender,
    // required this.tenders,
    // required this.tender,
  });
  final Tender tender;
  // int index;
  // final List<Tender> tenders;
  // final tender;
  @override
  Widget build(BuildContext context) {
    // final tender = tenders[0];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('تفاصيل المناقصة', style: TextStyle(fontSize: 20)),
      ),
      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              // ListView.builder(
              //   itemCount: tenders.length,
              //   itemBuilder: (context, index) {

              // return Expanded(
              // child:
              Card(
                color: Colors.blue[200],
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Expanded(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${tender.title}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("الموقع: ${tender.location}"),
                                  Icon(Icons.location_city),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("يبدأ في: ${tender.expectedStartTime}"),
                                  Icon(Icons.lock_clock),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    " عدد الشروط الفنية: ${tender.numberOfTechnicalConditions}",
                                  ),
                                  Icon(Icons.functions),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "الموعد النهائي للتقديم: ${tender.registrationDeadline}",
                                  ),
                                  Icon(Icons.functions),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    " عدد أيام التنفيذ  : ${tender.implementationPeriod}",
                                  ),
                                  Icon(Icons.summarize),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(" الميزانية: ${tender.budget}"),
                                  Icon(Icons.money),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("الحالة : ${tender.stateOfTender.name}"),
                                  Icon(Icons.announcement),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                " ${tender.descripe}",
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 150),
              Row(
                children: [
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddBid()),
                      );
                      // showModalBottomSheet(
                      //   context: context,
                      //   builder: (context) => AddBid(),
                      // );
                    },
                    label: Text(
                      'إضافة عرض',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    icon: Icon(Icons.add),
                  ),
                  Spacer(),
                  ElevatedButton.icon(
                    style: ButtonStyle(
                      backgroundColor: WidgetStatePropertyAll(Colors.blue[200]),
                    ),
                    onPressed: () {},
                    label: Text(
                      'حفظ المناقصة',
                      style: TextStyle(fontSize: 15, color: Colors.black),
                    ),
                    icon: Icon(Icons.save),
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
