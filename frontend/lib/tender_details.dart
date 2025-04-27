import 'package:flutter/material.dart';
import 'package:tendersmart/models/Tender.dart';

class TenderDetails extends StatelessWidget {
  TenderDetails({
    super.key,
    required this.switchScreenToTenders,
    required this.tender,
    // required this.tenders,
    // required this.tender,
  });
  void Function() switchScreenToTenders;
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
          onPressed: switchScreenToTenders,
          icon: Icon(Icons.arrow_back),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('تفاصيل المناقصة', style: TextStyle(fontSize: 20)),
      ),
      body: SizedBox(
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
                    crossAxisAlignment: CrossAxisAlignment.center,
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
                          // crossAxisAlignment: CrossAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Row(
                              children: [
                                // Icon(Icons.title),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,

                                    children: [],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.location_city),
                                Text("الموقع: ${tender.location}"),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.lock_clock),
                                Text("يبدأ في: ${tender.expectedStartTime}"),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.functions),
                                Text(
                                  " عدد الشروط الفنية: ${tender.numberOfTechnicalConditions}",
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.money),
                                Text(" الميزانية: ${tender.budget}"),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.announcement),
                                Text("الحالة : ${tender.stateOfTender.name}"),
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
            Center(
              child: Text(
                " ${tender.descripe}",
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
            ),
          ],
        ),
      ),
    );
  }

  //   ),
}
