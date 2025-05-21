import 'package:flutter/material.dart';
import 'package:tendersmart/models/Bid.dart';

class BidList extends StatefulWidget {
  BidList({super.key, required this.bids, required this.currentUserRole});
  List<Bid> bids;
  final String currentUserRole;
  @override
  State<BidList> createState() => _BidListState();
}

class _BidListState extends State<BidList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: Text('قائمة العروض'),
        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                'مرحباً بك',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('الصفحة الرئيسية'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            if (widget.currentUserRole == 'admin')
              ListTile(
                leading: Icon(Icons.home),
                title: Text('التقييم الذكي'),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            else
              SizedBox(),
            if (widget.currentUserRole == 'admin')
              ListTile(
                leading: Icon(Icons.home),
                title: Text('التقييم اليدوي'),
                onTap: () {
                  Navigator.pop(context);
                },
              )
            else
              SizedBox(),
            // OutlinedButton(
            //   onPressed: () {},
            //   child: Text('التقييم بإستخدام الذكاء الاصطناعي'),
            // ),
            // OutlinedButton(onPressed: () {}, child: Text('التقييم اليدوي')),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('الملف الشخصي'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: widget.bids.length,
        itemBuilder: (context, index) {
          final bid = widget.bids[index];
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
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'S.P${bid.bidAmount}',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          ': الميزانية المقدمة من قبل المورد_',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${index + 1}',
                          style: TextStyle(
                            fontSize: 18,
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          " ${bid.completionTimeExcepted}",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          ": وقت التنفيذ للمقاول",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          textAlign: TextAlign.center,
                          " ${bid.technicalMatchedCount}",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                        Text(
                          textAlign: TextAlign.center,
                          ": عدد الشروط الفنية الطابقة",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                        ),
                      ],
                    ),
                    Row(children: [
                       
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
