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
    this.bids,
    this.addBid,
    required this.switchScreenToTenders,
    required this.addContractor,
    required this.currentUserRole,
  });
  final List<Tender> currentTenders;
  final List<Bid>? bids;
  final void Function(Bid bid)? addBid;
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
    return Column(
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
