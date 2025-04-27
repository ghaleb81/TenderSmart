import 'package:flutter/material.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/tender_details.dart';
import 'package:tendersmart/tenders.dart';

class TenderListPage extends StatelessWidget {
  TenderListPage({
    super.key,
    required this.tenders,
    // required this.showTenderDetails,
    required this.switchScreenToTenders,

    // required this.switchScreenToTenderDetails,
    required this.onDeleteTender,
  });
  // void onDeleteTender(Tender tender) {
  //   tenders.remove(tender);
  // }

  final List<Tender> tenders;
  // final void Function() showTenderDetails;
  final List colors = [Colors.lightGreen, Colors.redAccent];
  final void Function() switchScreenToTenders;
  // final void Function() switchScreenToTenderDetails;
  final void Function(Tender tender) onDeleteTender;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: tenders.length,
      itemBuilder: (context, index) {
        final tender = tenders[index];
        return Expanded(
          child: Card(
            color: Colors.blue[200],
            margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${index + 1}_${tender.title}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      // mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            // Icon(Icons.title),
                            Expanded(
                              child: Text(
                                textAlign: TextAlign.center,
                                " ${tender.descripe}",
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          ],
                        ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.location_city),
                        //     Text("الموقع: ${tender.location}"),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.lock_clock),
                        //     Text("يبدأ في: ${tender.expectedStartTime}"),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.functions),
                        //     Text(
                        //       " عدد الشروط الفنية: ${tender.numberOfTechnicalConditions}",
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: [
                        //     Icon(Icons.money),
                        //     Text(" الميزانية: ${tender.budget}"),
                        //   ],
                        // ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("الحالة : ${tender.stateOfTender.name}"),
                            Icon(Icons.announcement),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => TenderDetails(
                                          switchScreenToTenders:
                                              switchScreenToTenders,
                                          tender: tenders[index],
                                        ),
                                  ),
                                );
                              },
                              // showTenderDetails,
                              // () => {
                              //   showModalBottomSheet(
                              //     context: context,
                              //     builder:
                              //         (ctx) => () {
                              //           ;
                              //         },
                              //     //  AddBid(
                              //     //   onAddExpense: (Tender expense) {},
                              //     // ),
                              //   ),
                              // },
                              icon: Icon(Icons.details),
                              label: Text('تفاصيل المناقصة'),
                            ),
                            Spacer(),

                            // ElevatedButton.icon(
                            //   onPressed: () => {},
                            //   icon: Icon(Icons.save),
                            //   label: Text('التعديل على المناقصة'),
                            // ),
                            // // ElevatedButton.icon(
                            // //   onPressed: () => {},
                            // //   icon: Icon(Icons.save),
                            // //   label: Text('حفظ'),
                            // // ),
                            // Spacer(),
                            ElevatedButton.icon(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (ctx) => AlertDialog(
                                        // title: Text('Invaled Input'),
                                        // backgroundColor: Colors.blue,
                                        icon: Icon(Icons.warning),
                                        title: Center(
                                          child: Text(
                                            'تحذير',
                                            style: TextStyle(
                                              fontSize: 20,
                                              // backgroundColor: Colors.blue,
                                            ),
                                          ),
                                        ),
                                        content: Text(
                                          'هل أنت متأكد من حذف المناقصة',
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx),
                                            child: Text('لا'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              onDeleteTender(tender);
                                              Navigator.pop(ctx);
                                            },
                                            child: Text('نعم'),
                                          ),
                                        ],
                                      ),
                                );
                              },
                              icon: Icon(Icons.delete),
                              label: Text('حذف المناقصة'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}



 // ListTile(
            //   title: Text(tenders[index].title),
            //   onTap: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder:
            //             (context) => TenderDetails(
            //               // index: index,
            //               switchScreenToTender: showTenderDetails,
            //               tenders: tenders,
            //             ),
            //       ),
            //     );
            //   },
            // ),