import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:tendersmart/contractor_profile_page.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/services/bid_service.dart';

class BidList extends StatefulWidget {
  final int tenderId;

  const BidList({super.key, required this.tenderId});

  @override
  State<BidList> createState() => _BidListState();
}

class _BidListState extends State<BidList> {
  late Future<List<Bid>> futureBids;

  @override
  void initState() {
    super.initState();
    futureBids = BidService.fetchBids(widget.tenderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('عروض المناقصة')),
      body: FutureBuilder<List<Bid>>(
        future: futureBids,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('خطأ: ${snapshot.error}'));
          }

          final bids = snapshot.data ?? [];

          if (bids.isEmpty) {
            return const Center(child: Text('لا توجد عروض حالياً'));
          }

          return ListView.builder(
            itemCount: bids.length,
            itemBuilder: (context, index) {
              final bid = bids[index];
              return InkWell(
                onTap: () async {
                  final confirmed = await showDialog(
                    context: context,
                    builder:
                        (ctx) => AlertDialog(
                          title: Text(
                            "اختيار الفائز",
                            textAlign: TextAlign.center,
                          ),
                          content: Text(
                            "هل انت متأكد من اختيار المقاول الذي معرفه الخاص هو ${bid.contractorId}",
                            textAlign: TextAlign.center,
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, false),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(ctx, true),
                              child: Text("Yes"),
                            ),
                          ],
                        ),
                  );
                  if (confirmed == true) {
                    try {
                      await BidService.chooseWinner(bid.id!, widget.tenderId);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('تم اختيار المقاول كفائز بنجاح'),
                        ),
                      );
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('حدث خطأ أثناء اختيار الفائز')),
                      );
                    }
                  }
                  // await TenderService.deleteTender(
                  //   tender.id!,
                  // );
                  // fetchData();
                },
                child: Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    title: Text('المقاول رقم: ${bid.contractorId}'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('السعر: ${bid.bidAmount} ل.س'),
                        Text('مدة التنفيذ: ${bid.completionTime} يوم'),
                        Text('عدد الشروط الفنية: ${bid.technicalMatchedCount}'),
                      ],
                    ),
                    trailing: ElevatedButton(
                      child: const Text('عرض المقاول'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (_) => ContractorProfilePage(
                                  user_id: bid.contractorId.toString(),
                                ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


// class BidList extends StatefulWidget {
//   const BidList({super.key, required this.tenderId});

//   /// معرّف المناقصة التي نريد عرض عروضها
//   final int tenderId;

//   @override
//   State<BidList> createState() => _BidListState();
// }

// class _BidListState extends State<BidList> {
//   late Future<List<Bid>> _bidsFuture;

//   @override
//   void initState() {
//     super.initState();
//     log('tenderId = ${widget.tenderId}');
//     _bidsFuture = BidService.fetchBids(widget.tenderId);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return 
//     Scaffold(
//       appBar: AppBar(title: const Text('قائمة العروض')),
//       body: FutureBuilder<List<Bid>>(
//         future: _bidsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return const Center(child: Text('لا توجد عروض حالياً'));
//           }

//           final bids =
//               snapshot.data!..sort(
//                 (a, b) => (b.finalScore ?? 0).compareTo(a.finalScore ?? 0),
//               );

//           return ListView.separated(
//             padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//             itemCount: bids.length,
//             separatorBuilder: (_, __) => const SizedBox(height: 8),
//             itemBuilder: (context, index) {
//               final bid = bids[index];
//               return InkWell(
//                 onTap:
//                     () => {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                           content: Text(
//                             'تم اختيار المقاول رقم '
//                             '${bid.contractorId} كفائز.',
//                           ),
//                         ),
//                       ),
//                     },
//                 child: Card(
//                   elevation: 3,
//                   child: ListTile(
//                     title: Text('مقاول رقم: ${bid.contractorId}'),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         const SizedBox(height: 4),
//                         Text('قيمة العرض: ${bid.bidAmount.toStringAsFixed(2)}'),
//                         const SizedBox(height: 4),
//                         Text(
//                           'النتيجة النهائية: '
//                           '${(bid.finalScore ?? 0).toStringAsFixed(2)}',
//                         ),
//                       ],
//                     ),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         // TODO: استدعاء API لاختيار الفائز
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(
//                             content: Text(
//                               'تم اختيار المقاول رقم '
//                               '${bid.contractorId} كفائز.',
//                             ),
//                           ),
//                         );
//                       },
//                       child: const Text('اختيار كفائز'),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           );
//         },
//       ),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:tendersmart/mainScreen.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/services/bid_service.dart';
// import 'package:tendersmart/tenders_list.dart';

// class BidList extends StatefulWidget {
//   BidList({super.key, this.bids, this.tenderId});
//   List<Bid>? bids;
//   final tenderId;
//   // final String currentUserRole;
//   @override
//   State<BidList> createState() => _BidListState();
// }

// class _BidListState extends State<BidList> {
//   late Future<List<Bid>> bidsFuture;
//   @override
//   void initState() {
//     super.initState();
//     // loadUserRole();
//     bidsFuture = BidService.fetchBids(int.tryParse(widget.tenderId) ?? 0);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('قائمة العروض')),
//       body: FutureBuilder(
//         future: bidsFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('خطأ : ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('لا توجد عروض حالياً'));
//           } else {
//             final bids = snapshot.data!;
//             return ListView.builder(
//               itemCount: bids.length,
//               itemBuilder: (context, index) {
//                 final bid = bids[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                   child: ListTile(
//                     // title: Text(bid.tenderId),
//                     subtitle: Text(bid.bidAmount.toString()),
//                     trailing: ElevatedButton(
//                       onPressed: () {
//                         // sendWinnerOffer(offer['id']);
//                       },
//                       child: Text('اختيار كفائز'),
//                     ),
//                   ),
//                 );
//               },
//             );
//             // ListView.builder(
//             //   itemCount: bids.length,
//             //   itemBuilder: (context, index) {
//             //     final bid = bids[index];
//             //     return Expanded(
//             //       child: Card(
//             //         child: Column(
//             //           children: [
//             //             Row(children: [Text(bid.tenderId)]),
//             //           ],
//             //         ),
//             //       ),
//             //     );
//             //   },
//             // );
//           }
//         },
//       ),

//       //  ListView.builder(
//       //   itemCount: widget.bids!.length,
//       //   itemBuilder: (context, index) {
//       //     final bid = widget.bids![index];
//       //     return Card(
//       //       margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//       //       child: ListTile(
//       //         title: Text(bid.tenderId),
//       //         subtitle: Text(bid.bidAmount.toString()),
//       //         trailing: ElevatedButton(
//       //           onPressed: () {
//       //             // sendWinnerOffer(offer['id']);
//       //           },
//       //           child: Text('اختيار كفائز'),
//       //         ),
//       //       ),
//       //     );
//       //   },
//       // ),
//     );
//   }
// }// @override

  // Widget build(BuildContext context) {
  //   return
  //   Scaffold(
  //     appBar: AppBar(
  //       backgroundColor: Colors.blue,
  //       centerTitle: true,
  //       title: Text('قائمة العروض'),
  //       actions: [
  //         IconButton(
  //           onPressed: () => Navigator.pop(context),
  //           icon: Icon(Icons.keyboard_arrow_right),
  //         ),
  //       ],
  //     ),
  //     drawer: Drawer(
  //       child: ListView(
  //         padding: EdgeInsets.zero,
  //         children: [
  //           DrawerHeader(
  //             decoration: BoxDecoration(color: Colors.blue),
  //             child: Text(
  //               'مرحباً بك',
  //               style: TextStyle(color: Colors.white, fontSize: 24),
  //             ),
  //           ),
  //           ListTile(
  //             leading: Icon(Icons.home),
  //             title: Text('الصفحة الرئيسية'),
  //             onTap: () {
  //               TenderListPage;
  //               // Navigator.pop(context);
  //             },
  //           ),
  //           if (widget.currentUserRole == 'admin')
  //             ListTile(
  //               leading: Icon(Icons.home),
  //               title: Text('التقييم الذكي'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //             )
  //           else
  //             SizedBox(),
  //           if (widget.currentUserRole == 'admin')
  //             ListTile(
  //               leading: Icon(Icons.home),
  //               title: Text('التقييم اليدوي'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //               },
  //             )
  //           else
  //             SizedBox(),
  //           // OutlinedButton(
  //           //   onPressed: () {},
  //           //   child: Text('التقييم بإستخدام الذكاء الاصطناعي'),
  //           // ),
  //           // OutlinedButton(onPressed: () {}, child: Text('التقييم اليدوي')),
  //           ListTile(
  //             leading: Icon(Icons.person),
  //             title: Text('الملف الشخصي'),
  //             onTap: () {
  //               Navigator.pop(context);
  //             },
  //           ),
  //         ],
  //       ),
  //     ),
  //     body: ListView.builder(
  //       itemCount: widget.bids!.length,
  //       itemBuilder: (context, index) {
  //         final bid = widget.bids![index];
  //         return Expanded(
  //           child: Card(
  //             color: Colors.blue[200],
  //             margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
  //             elevation: 4,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(12),
  //             ),
  //             child: Padding(
  //               padding: const EdgeInsets.all(16.0),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         'S.P${bid.bidAmount}',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           // fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         ': الميزانية المقدمة من قبل المورد_',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           // fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                       Text(
  //                         '${index + 1}',
  //                         style: TextStyle(
  //                           fontSize: 18,
  //                           // fontWeight: FontWeight.bold,
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         textAlign: TextAlign.center,
  //                         " ${bid.completionTimeExcepted}",
  //                         softWrap: true,
  //                         overflow: TextOverflow.visible,
  //                       ),
  //                       Text(
  //                         textAlign: TextAlign.center,
  //                         ": وقت التنفيذ للمقاول",
  //                         softWrap: true,
  //                         overflow: TextOverflow.visible,
  //                       ),
  //                     ],
  //                   ),
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Text(
  //                         textAlign: TextAlign.center,
  //                         " ${bid.technicalMatchedCount}",
  //                         softWrap: true,
  //                         overflow: TextOverflow.visible,
  //                       ),
  //                       Text(
  //                         textAlign: TextAlign.center,
  //                         ": عدد الشروط الفنية الطابقة",
  //                         softWrap: true,
  //                         overflow: TextOverflow.visible,
  //                       ),
  //                     ],
  //                   ),
  //                   Row(children: [

  //                     ],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         );
  //       },
  //     ),
  //   );
  // }

