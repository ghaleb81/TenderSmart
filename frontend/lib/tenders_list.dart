import 'package:flutter/material.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/login_screen.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/new_tender.dart';
import 'package:tendersmart/tender_details.dart';
import 'package:tendersmart/tenders.dart';

class TenderListPage extends StatefulWidget {
  TenderListPage({
    super.key,
    required this.tenders,
    required this.onDeleteTender,
    required this.bids,
    required this.addBid,
    required this.switchScreenToNewTender,
    required this.addContractor,
    required this.currentTenders,
  });

  final List<Tender> tenders;
  final void Function(Tender tender) onDeleteTender;
  final void Function(Bid bid) addBid;
  List<Bid> bids;
  final void Function() switchScreenToNewTender;
  final void Function(Contractor contractor) addContractor;
  final List<Tender> currentTenders;
  @override
  State<TenderListPage> createState() => _TenderListPageState();
}

class _TenderListPageState extends State<TenderListPage> {
  final List colors = [Colors.lightGreen, Colors.redAccent];

  String currentUserRole = '';

  void _addtender(Tender ten) {
    setState(() {
      widget.currentTenders.add(ten);
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
            ListTile(
              leading: Icon(Icons.people),
              title: Text('قائمة الموردين'),
              onTap:
                  () => LoginScreen(
                    switchScreenToNewTender: widget.switchScreenToNewTender,
                    addContractor: widget.addContractor,
                  ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('الملف الشخصي'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('تسجيل الخروج'),
              onTap:
                  () => LoginScreen(
                    switchScreenToNewTender: widget.switchScreenToNewTender,
                    addContractor: widget.addContractor,
                  ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: widget.tenders.length,
        itemBuilder: (context, index) {
          final tender = widget.tenders[index];
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
                              Text("${tender.stateOfTender.name}: الحالة"),
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
                                                tender: widget.tenders[index],
                                                bids: widget.bids,
                                                addBid: widget.addBid,
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
                              Row(
                                children: [
                                  if (currentUserRole == 'admin')
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder:
                                              (ctx) => AlertDialog(
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
                                                  textAlign: TextAlign.center,
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                            const Color.fromARGB(
                                                              255,
                                                              80,
                                                              222,
                                                              85,
                                                            ),
                                                          ),
                                                    ),
                                                    onPressed:
                                                        () =>
                                                            Navigator.pop(ctx),
                                                    child: Text(
                                                      'لا',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  TextButton(
                                                    style: ButtonStyle(
                                                      backgroundColor:
                                                          WidgetStatePropertyAll(
                                                            const Color.fromARGB(
                                                              255,
                                                              254,
                                                              91,
                                                              80,
                                                            ),
                                                          ),
                                                    ),
                                                    onPressed: () {
                                                      widget.onDeleteTender(
                                                        tender,
                                                      );
                                                      Navigator.pop(ctx);
                                                    },
                                                    child: Text(
                                                      'نعم',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                      label: Text('حذف المناقصة'),
                                    )
                                  else
                                    SizedBox(),
                                ],
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
      ),
    );
  }
}
