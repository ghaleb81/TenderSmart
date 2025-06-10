import 'package:flutter/material.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/tenders_list.dart';

class Tenders extends StatefulWidget {
  const Tenders({
    super.key,
    required this.currentTenders,
    this.bids,
    this.addBid,
    required this.switchScreenToTenders,
    // required this.addContractor,
  });
  final List<Tender> currentTenders;
  final List<Bid>? bids;
  final void Function(Bid bid)? addBid;
  final void Function() switchScreenToTenders;
  // final void Function(Contractor contractor) addContractor;
  @override
  State<Tenders> createState() => _TendersState();
}

class _TendersState extends State<Tenders> {
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
            tenders: widget.currentTenders,
            onDeleteTender: _deleteTender,
            bids: widget.bids,
            addBid: widget.addBid,
            // addContractor: widget.addContractor,
            currentTenders: widget.currentTenders,
            switchScreenToTenders: widget.switchScreenToTenders,
          ),
        ),
      ],
    );
  }
}
