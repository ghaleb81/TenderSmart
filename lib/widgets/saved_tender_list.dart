import 'package:flutter/material.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/tender_service.dart';
import 'package:tendersmart/widgets/tender_details.dart';

class SavedTenderList extends StatefulWidget {
  const SavedTenderList({super.key});

  @override
  State<SavedTenderList> createState() => _SavedTenderListState();
}

class _SavedTenderListState extends State<SavedTenderList> {
  late Future<List<Tender>> tendersFuture;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tendersFuture = TenderService.fetchSavedTenders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar:
      // AppBar(
      //   centerTitle: true,
      //   backgroundColor: Colors.indigo,
      //   title: const Text(
      //     // 'المناقصات المحفوظة',
      //     'Saved Tenders',
      //     style: TextStyle(
      //       // backgroundColor: Colors.tealAccent,
      //       color: Colors.white,
      //       fontSize: 20,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),

      //   // leading: Icon(Icons.add),//leading هي الاشياء التي اريد عرضها قبل العنوان من جهة اليسار
      // ),
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: const Text(
          'المناقصات المحفوظة',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        elevation: 6,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
        ),
      ),
      body: FutureBuilder<List<Tender>>(
        future: tendersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد مناقصات محفوظة'));
          } else {
            final tenders = snapshot.data!;
            return ListView.builder(
              itemCount: tenders.length,
              itemBuilder: (context, index) {
                final tender = tenders[index];
                return Expanded(
                  child: Card(
                    margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    color:
                        tender.stateOfTender.name == 'opened'
                            ? Colors.green[100]
                            : Colors.red[100],
                    elevation: 3,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Text(
                              tender.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            tender.descripe,
                            style: TextStyle(fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Icon(
                                    Icons.announcement,
                                    color: Colors.blue[800],
                                  ),
                                  Text(tender.stateOfTender.name),
                                ],
                              ),
                              Column(
                                children: [
                                  Icon(
                                    Icons.calendar_today,
                                    color: Colors.orange[800],
                                  ),
                                  Text(
                                    tender.registrationDeadline
                                        .toString()
                                        .split(' ')[0],
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.info,
                                      color: Colors.indigo[800],
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder:
                                              (context) =>
                                                  TenderDetails(tender: tender),
                                        ),
                                      );
                                    },
                                  ),
                                  Text("Details"),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
