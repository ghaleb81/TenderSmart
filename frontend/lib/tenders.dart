import 'package:flutter/material.dart';
import 'package:tendersmart/login_screen.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/new_tender.dart';
import 'package:tendersmart/tenders_list.dart';
import 'package:tendersmart/mainScreen.dart';

class Tenders extends StatefulWidget {
  Tenders({
    super.key,
    required this.currentTenders,
    required this.bids,
    required this.addBid,
    required this.switchScreenToTenders,
    required this.addContractor,
    required this.currentUserRole,
  });
  final List<Tender> currentTenders;
  final List<Bid> bids;
  final void Function(Bid bid) addBid;
  final void Function() switchScreenToTenders;
  final void Function(Contractor contractor) addContractor;
  final String currentUserRole;
  @override
  State<Tenders> createState() => _TendersState();
}

class _TendersState extends State<Tenders> {
  String currentUserRole = 'admin';

  // void _addtender(Tender ten) {
  //   setState(() {
  //     widget.currentTenders.add(ten);
  //   });
  // }

  void _deleteTender(Tender tender) {
    setState(() {
      widget.currentTenders.remove(tender);
    });
  }

  @override
  Widget build(BuildContext context) {
    return
    //  Scaffold(
    //   appBar: AppBar(
    //     centerTitle: true,
    //     backgroundColor: Colors.blue,
    //     title: const Text(
    //       'المناقصات الحالية',
    //       style: TextStyle(
    //         // backgroundColor: Colors.tealAccent,
    //         color: Colors.black,
    //         fontSize: 20,
    //       ),
    //     ),
    //     // leading: Icon(Icons.add),//leading هي الاشياء التي اريد عرضها قبل العنوان من جهة اليسار
    //     actions: [
    //       //Icon(Icons.add),
    //       // OutlinedButton.icon:currentUserRole=='admin'?
    //       if (currentUserRole == 'admin')
    //         OutlinedButton.icon(
    //           label: Text('إضافة مناقصة'),
    //           onPressed: () {
    //             showModalBottomSheet(
    //               isScrollControlled: true, //يسمح للموديل بملئ الشاشة
    //               backgroundColor: Colors.transparent, //لتفادي الحواف البيضاء
    //               context: context,
    //               builder:
    //                   (context) => Container(
    //                     height:
    //                         MediaQuery.of(context).size.height *
    //                         0.90, //0.96تفريباً كل الشاشة
    //                     decoration: BoxDecoration(
    //                       color: Colors.white,
    //                       borderRadius: BorderRadius.vertical(
    //                         top: Radius.circular(20),
    //                       ),
    //                     ),
    //                     child: NewTender(onAddTender: _addtender),
    //                   ),
    //             );
    //           },
    //           icon: Icon(Icons.add),
    //         )
    //       else
    //         SizedBox(),
    //     ],
    //   ),
    //   drawer: Drawer(
    //     child: ListView(
    //       padding: EdgeInsets.zero,
    //       children: [
    //         DrawerHeader(
    //           decoration: BoxDecoration(color: Colors.blue),
    //           child: Text(
    //             'مرحباً بك',
    //             style: TextStyle(color: Colors.white, fontSize: 24),
    //           ),
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.home),
    //           title: Text('الصفحة الرئيسية'),
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.person),
    //           title: Text('الملف الشخصي'),
    //           onTap: () {
    //             Navigator.pop(context);
    //           },
    //         ),
    //         ListTile(
    //           leading: Icon(Icons.logout),
    //           title: Text('تسجيل الخروج'),
    //           onTap:
    //               () => LoginScreen(
    //                 switchScreenToNewTender: widget.switchScreenToNewTender,
    //                 addContractor: widget.addContractor,
    //               ),
    //         ),
    //       ],
    //     ),
    //   ),
    //   body:
    Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: TenderListPage(
            // tenders: widget.currentTenders,
            tenders: widget.currentTenders,
            onDeleteTender: _deleteTender,
            bids: widget.bids,
            addBid: widget.addBid,
            addContractor: widget.addContractor,
            currentTenders: widget.currentTenders,
            switchScreenToTenders: widget.switchScreenToTenders,
            currentUserRole: widget.currentUserRole,
          ),
        ),
      ],
      //   ),
    );
  }
}
