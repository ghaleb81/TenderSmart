// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:tendersmart/models/Tender.dart';
// import 'package:tendersmart/widgets/contractor_profile_page.dart';
// import 'package:tendersmart/widgets/evaluate_bids_page.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/services/bid_service.dart';
// import 'package:tendersmart/services/contractor_service.dart';

// class BidList extends StatefulWidget {
//   final int tenderId;
//   BidList({
//     super.key,
//     required this.tenderId,
//     required this.userId,
//     required this.tender,
//   });
//   int userId;
//   Tender tender;
//   @override
//   State<BidList> createState() => _BidListState();
// }

// class _BidListState extends State<BidList> {
//   late Future<List<Bid>> _futureBids;
//   List<Bid> _currentBids = [];

//   final Color primaryColor = Colors.indigo[800]!;
//   final Color backgroundColor = Colors.grey[100]!;
//   final Color cardColor = Colors.white;
//   final Color onPrimaryColor = Colors.white;
//   final Color textColor = Colors.indigo[900]!;

//   @override
//   void initState() {
//     super.initState();
//     _futureBids = BidService.fetchBids(widget.tenderId);
//   }

//   Future<void> _refresh() async {
//     setState(() {
//       _futureBids = BidService.fetchBids(widget.tenderId);
//     });
//     await _futureBids;
//   }

//   void _goToEvaluate() {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder:
//             (_) =>
//                 EvaluateBidsPage(tenderId: widget.tenderId, bids: _currentBids),
//       ),
//     );
//   }

//   void _showContractorProfile(BuildContext context, int userId) async {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (_) => const Center(child: CircularProgressIndicator()),
//     );
//     setState(() {
//       widget.userId = userId;
//     });
//     final contractor = await ContractorService.fetchContractorByUserId(
//       userId.toString(),
//     );

//     Navigator.pop(context);

//     if (contractor != null) {
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => ContractorProfilePage(userId: userId.toString()),
//         ),
//       );
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تعذّر تحميل بيانات المقاول')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         // textDirection: TextDirection.rtl,
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//           backgroundColor: Colors.indigo,
//           title: const Text(
//             'تفاصيل المناقصة ',
//             style: TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 20,
//               color: Colors.white,
//             ),
//           ),
//           centerTitle: true,
//           elevation: 6,
//           shape: const RoundedRectangleBorder(
//             borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
//           ),
//         ),
//         body: RefreshIndicator(
//           onRefresh: _refresh,
//           child: FutureBuilder<List<Bid>>(
//             future: _futureBids,
//             builder: (context, snapshot) {
//               if (snapshot.connectionState == ConnectionState.waiting) {
//                 return const Center(child: CircularProgressIndicator());
//               }

//               if (snapshot.hasError) {
//                 return Center(
//                   child: Text(
//                     'حدث خطأ: ${snapshot.error}',
//                     style: TextStyle(color: textColor),
//                   ),
//                 );
//               }

//               final bids = snapshot.data ?? [];

//               WidgetsBinding.instance.addPostFrameCallback((_) {
//                 if (mounted) {
//                   setState(() {
//                     _currentBids = bids;
//                   });
//                 }
//               });

//               if (bids.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'لا توجد عروض حالياً',
//                     style: TextStyle(color: textColor),
//                   ),
//                 );
//               }

//               return ListView.builder(
//                 padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
//                 itemCount: bids.length,
//                 itemBuilder: (context, index) {
//                   final bid = bids[index];
//                   final isWinner =
//                       widget.tender.manualWinnerBidId != null &&
//                       bid.id == widget.tender.manualWinnerBidId;

//                   return Container(
//                     margin: const EdgeInsets.only(bottom: 16),
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: isWinner ? Colors.green.shade100 : cardColor,
//                       borderRadius: BorderRadius.circular(16),
//                       boxShadow: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.05),
//                           blurRadius: 6,
//                           offset: const Offset(0, 3),
//                         ),
//                       ],
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'رقم المقاول: ${bid.contractorId}',
//                           style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 16,
//                             color: textColor,
//                           ),
//                         ),
//                         const SizedBox(height: 8),
//                         Text(
//                           'السعر: ${bid.bidAmount} ل.س',
//                           style: TextStyle(color: textColor),
//                         ),
//                         Text(
//                           'مدة التنفيذ: ${bid.completionTime} يوم',
//                           style: TextStyle(color: textColor),
//                         ),
//                         Text(
//                           'التطابق الفني: ${bid.technicalMatchedCount}',
//                           style: TextStyle(color: textColor),
//                         ),
//                         const SizedBox(height: 12),
//                         SizedBox(
//                           width: double.infinity,
//                           child: OutlinedButton.icon(
//                             onPressed:
//                                 () => _showContractorProfile(
//                                   context,
//                                   bid.contractorId!,
//                                 ),
//                             icon: Icon(
//                               Icons.person_outline,
//                               color: primaryColor,
//                             ),
//                             label: Text(
//                               'عرض ملف المقاول',
//                               style: TextStyle(color: primaryColor),
//                             ),
//                             style: OutlinedButton.styleFrom(
//                               padding: const EdgeInsets.symmetric(vertical: 12),
//                               side: BorderSide(color: primaryColor),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               backgroundColor: cardColor,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   );
//                 },
//               );
//             },
//           ),
//         ),
//         floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
//         floatingActionButton:
//             widget.tender.manualWinnerBidId != null
//                 ? null
//                 : Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 20),
//                   child: SizedBox(
//                     width: double.infinity,
//                     child: ElevatedButton.icon(
//                       onPressed: _currentBids.isNotEmpty ? _goToEvaluate : null,
//                       icon: Icon(
//                         Icons.check_circle_outline,
//                         color: onPrimaryColor,
//                       ),
//                       label: Text(
//                         'تقييم العروض',
//                         style: TextStyle(color: onPrimaryColor),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         padding: const EdgeInsets.symmetric(vertical: 14),
//                         backgroundColor: primaryColor,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(16),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//       ),
//     );
//   }
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/widgets/contractor_profile_page.dart';
import 'package:tendersmart/widgets/evaluate_bids_page.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/services/bid_service.dart';
import 'package:tendersmart/services/contractor_service.dart';
import 'package:url_launcher/url_launcher.dart';

class BidList extends StatefulWidget {
  final int tenderId;
  BidList({
    super.key,
    required this.tenderId,
    required this.userId,
    required this.tender,
  });
  int userId;
  Tender tender;
  @override
  State<BidList> createState() => _BidListState();
}

class _BidListState extends State<BidList> {
  late Future<List<Bid>> _futureBids;
  List<Bid> _currentBids = [];

  final Color primaryColor = Colors.indigo[800]!;
  final Color backgroundColor = Colors.grey[100]!;
  final Color cardColor = Colors.white;
  final Color onPrimaryColor = Colors.white;
  final Color textColor = Colors.indigo[900]!;

  @override
  void initState() {
    super.initState();
    _futureBids = BidService.fetchBids(widget.tenderId);
  }

  Future<void> _refresh() async {
    setState(() {
      _futureBids = BidService.fetchBids(widget.tenderId);
    });
    await _futureBids;
  }

  void _goToEvaluate() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) =>
                EvaluateBidsPage(tenderId: widget.tenderId, bids: _currentBids),
      ),
    );
  }

  void _showContractorProfile(BuildContext context, int userId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    setState(() {
      widget.userId = userId;
    });
    final contractor = await ContractorService.fetchContractorByUserId(
      userId.toString(),
    );

    Navigator.pop(context);

    if (contractor != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ContractorProfilePage(userId: userId.toString()),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر تحميل بيانات المقاول')),
      );
    }
  }

  Future<void> _downloadTechnicalProposal(String? relativePath) async {
    if (relativePath == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('لا يوجد ملف للعرض الفني')));
      return;
    }
    final url = 'https://your-api-domain.com/storage/$relativePath';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تعذّر فتح ملف العرض الفني')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // textDirection: TextDirection.rtl,
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text(
            'تفاصيل المناقصة ',
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
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: FutureBuilder<List<Bid>>(
            future: _futureBids,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'حدث خطأ: ${snapshot.error}',
                    style: TextStyle(color: textColor),
                  ),
                );
              }

              final bids = snapshot.data ?? [];

              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  setState(() {
                    _currentBids = bids;
                  });
                }
              });

              if (bids.isEmpty) {
                return Center(
                  child: Text(
                    'لا توجد عروض حالياً',
                    style: TextStyle(color: textColor),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
                itemCount: bids.length,
                itemBuilder: (context, index) {
                  final bid = bids[index];
                  final isWinner =
                      widget.tender.manualWinnerBidId != null &&
                      bid.id == widget.tender.manualWinnerBidId;

                  return AbsorbPointer(
                    absorbing: isWinner,
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isWinner ? Colors.green.shade100 : cardColor,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'رقم المقاول: ${bid.contractorId}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: textColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'السعر: ${bid.bidAmount} ل.س',
                            style: TextStyle(color: textColor),
                          ),
                          Text(
                            'مدة التنفيذ: ${bid.completionTime} يوم',
                            style: TextStyle(color: textColor),
                          ),
                          Text(
                            'التطابق الفني: ${bid.technicalMatchedCount}',
                            style: TextStyle(color: textColor),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed:
                                bid.technicalProposalPdf != null
                                    ? () => _downloadTechnicalProposal(
                                      bid.technicalProposalPdf,
                                    )
                                    : null,
                            icon: const Icon(Icons.download),
                            label: const Text('تحميل العرض الفني'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: OutlinedButton.icon(
                              onPressed:
                                  () => _showContractorProfile(
                                    context,
                                    bid.contractorId!,
                                  ),
                              icon: Icon(
                                Icons.person_outline,
                                color: primaryColor,
                              ),
                              label: Text(
                                'عرض ملف المقاول',
                                style: TextStyle(color: primaryColor),
                              ),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 12,
                                ),
                                side: BorderSide(color: primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: cardColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton:
            widget.tender.manualWinnerBidId != null
                ? null
                : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _currentBids.isNotEmpty ? _goToEvaluate : null,
                      icon: Icon(
                        Icons.check_circle_outline,
                        color: onPrimaryColor,
                      ),
                      label: Text(
                        'تقييم العروض',
                        style: TextStyle(color: onPrimaryColor),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
      ),
    );
  }
}
