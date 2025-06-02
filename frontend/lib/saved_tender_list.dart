import 'package:flutter/material.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/tender_service.dart';
import 'package:tendersmart/tender_details.dart';

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
      ),
      body: FutureBuilder<List<Tender>>(
        future: tendersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('خطأ : ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('لا توجد مناقصات حالياً'));
          } else {
            final tenders = snapshot.data!;
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '${tender.title}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                ' _${index + 1}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // Text(
                              //   '${tender.title}_${index + 1}',
                              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              // ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Padding(
                            padding: EdgeInsets.all(12),
                            child: Column(
                              children: [
                                Row(
                                  children: [
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
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${tender.stateOfTender.name}: الحالة",
                                    ),
                                    Icon(Icons.announcement),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        ElevatedButton.icon(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder:
                                                    (context) => TenderDetails(
                                                      tender: tenders[index],
                                                      // isFavorite: true,
                                                      // bids: widget.bids,
                                                      //  addBid: widget.addBid,
                                                    ),
                                              ),
                                            );
                                          },
                                          icon: Icon(Icons.details),
                                          label: Text('تفاصيل المناقصة'),
                                        ),
                                      ],
                                    ),
                                    SizedBox(width: 10),
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
        },
      ),
    );
  }
}
