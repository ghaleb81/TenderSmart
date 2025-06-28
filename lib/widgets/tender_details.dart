import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:open_file/open_file.dart';
import 'package:tendersmart/widgets/add_bid.dart';
import 'package:tendersmart/widgets/add_contractor.dart';

import 'package:tendersmart/widgets/bid_list.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/widgets/new_tender.dart';
import 'package:tendersmart/services/bid_service.dart';
import 'package:tendersmart/services/contractor_service.dart';
import 'package:tendersmart/services/tender_service.dart';
import 'package:tendersmart/services/token_storage.dart';

// class TenderDetails extends StatefulWidget {
//   TenderDetails({super.key, required this.tender, this.bids, this.addBid});

//   Tender tender;

//   List<Bid>? bids;
//   final void Function(Bid bid)? addBid;

//   @override
//   State<TenderDetails> createState() => _TenderDetailsState();
// }

// class _TenderDetailsState extends State<TenderDetails> {
//   String? role;
//   bool isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     loadUserRole();
//     checkIfFavorite();
//   }

//   void loadUserRole() async {
//     final userRole = await TokenStorage.getRole();
//     setState(() {
//       role = userRole;
//     });
//   }

//   void checkIfFavorite() async {
//     try {
//       final savedTenders = await TenderService.fetchSavedTenders();
//       if (savedTenders != null) {
//         setState(() {
//           isFavorite = savedTenders.any((t) => t.id == widget.tender.id);
//         });
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء التحقق من المناقصات المحفوظة: $e');
//     }
//   }

//   void checkContractorInfo() async {
//     final userrId = await TokenStorage.getUserrId();
//     try {
//       final contractor = await ContractorService.getContractorInfo(
//         // int.tryParse(userrId!) ?? 0,
//       );

//       if (contractor == null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => AddContractor()),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (_) => AddBid(
//                   tenderId: int.tryParse(widget.tender.id!),
//                   // contractorId: contractor.id,
//                   tender: widget.tender,
//                 ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء التحقق من بيانات المقاول')),
//       );
//     }
//   }

//   void toggleFavorite() async {
//     try {
//       if (isFavorite) {
//         await TenderService.cancellationTenders(widget.tender.id!);
//       } else {
//         await TenderService.saveTenders(widget.tender);
//       }
//       setState(() {
//         isFavorite = !isFavorite;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء تحديث حالة المفضلة')),
//       );
//     }
//   }

//   // Future<void> downloadFile(String url, String fileName) async {
//   //   try {
//   //     Directory directory = await getApplicationDocumentsDirectory();

//   //     String savePath = '${directory.path}/$fileName';

//   //     Dio dio = Dio();
//   //     await dio.download(
//   //       url,
//   //       savePath,
//   //       onReceiveProgress: (received, total) {
//   //         if (total != -1) {
//   //           print(
//   //             'Downloading: ${(received / total * 100).toStringAsFixed(0)}%',
//   //           );
//   //         }
//   //       },
//   //     );

//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(SnackBar(content: Text('تم تنزيل الملف إلى: $savePath')));
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(
//   //       context,
//   //     ).showSnackBar(SnackBar(content: Text('خطأ في تحميل الملف: $e')));
//   //   }
//   // }
//   Future<void> downloadFileWithHttp(
//     String url,
//     String fileName,
//     BuildContext context,
//   ) async {
//     try {
//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           'ngrok-skip-browser-warning': 'true', // لتجاوز رسالة ngrok
//         },
//       );

//       if (response.statusCode == 200) {
//         final directory = await getApplicationDocumentsDirectory();
//         final filePath = '${directory.path}/$fileName';
//         final file = File(filePath);

//         await file.writeAsBytes(response.bodyBytes);

//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('تم تنزيل الملف إلى: $filePath')),
//         );
//       } else {
//         throw 'HTTP ${response.statusCode}';
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('فشل تحميل الملف: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.indigo,
//         centerTitle: true,
//         title: Text(
//           'Tender Details',
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed:
//                 () => Navigator.pushReplacementNamed(context, '/tendersScreen'),
//             icon: Icon(Icons.keyboard_arrow_right),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 16),
//             Card(
//               color:
//                   widget.tender.stateOfTender.name == 'opened'
//                       ? Colors.green[100]
//                       : Colors.red[100],
//               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Center(
//                       child: Text(
//                         widget.tender.title,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.indigo[900],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     IconTextRow(
//                       icon: Icons.assignment_turned_in,
//                       iconColor:
//                           widget.tender.stateOfTender.name == 'opened'
//                               ? Colors.green
//                               : Colors.redAccent,
//                       text: "${widget.tender.stateOfTender.name} :الحالة",
//                     ),
//                     IconTextRow(
//                       icon: Icons.calendar_today,
//                       iconColor: Colors.orange,
//                       text:
//                           "${widget.tender.registrationDeadline} :التاريخ النهائي",
//                     ),
//                     IconTextRow(
//                       icon: Icons.info_outline,
//                       iconColor: Colors.purple,
//                       text:
//                           "${widget.tender.numberOfTechnicalConditions} :عدد الشروط الفنية",
//                     ),
//                     IconTextRow(
//                       icon: Icons.location_on,
//                       iconColor: Colors.red,
//                       text: "${widget.tender.location} :الموقع",
//                     ),
//                     IconTextRow(
//                       icon: Icons.timer,
//                       iconColor: Colors.blue,
//                       text:
//                           "${widget.tender.implementationPeriod} :عدد أيام التنفيذ",
//                     ),
//                     IconTextRow(
//                       icon: Icons.attach_money,
//                       iconColor: Colors.teal,
//                       text: "${widget.tender.budget} :الميزانية",
//                     ),
//                     if (role == 'admin')
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             final userId = await TokenStorage.getUserrId();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => BidList(
//                                       userId: int.tryParse(userId!) ?? 0,
//                                       tenderId:
//                                           int.tryParse(widget.tender.id!) ?? 0,
//                                     ),
//                               ),
//                             );
//                           },
//                           child: Text('قائمة العروض'),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 widget.tender.descripe,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (role == 'contractor')
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (widget.tender.stateOfTender.name == 'opened')
//                         ElevatedButton.icon(
//                           onPressed: () {

//                             checkContractorInfo();
//                           },
//                           label: Text(
//                             'إضافة عرض',
//                             style: TextStyle(fontSize: 15, color: Colors.black),
//                           ),
//                           icon: Icon(Icons.add),
//                         )
//                       else
//                         SizedBox(),
//                       SizedBox(width: 20),
//                       IconButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStatePropertyAll(
//                             Colors.blue[200],
//                           ),
//                         ),
//                         onPressed: () {
//                           toggleFavorite();
//                         },
//                         icon: Icon(
//                           isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: isFavorite ? Colors.red : Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12),
//                   if (widget.tender.technicalFileUrl != null)
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         final fileUrl = widget.tender.technicalFileUrl!;
//                         final fileName = fileUrl.split('/').last;
//                         // downloadFile(fileUrl, fileName);
//                         downloadFileWithHttp(
//                           widget.tender.technicalFileUrl!,
//                           'specs.pdf',
//                           context,
//                         );
//                       },
//                       icon: Icon(Icons.download),
//                       label: Text('تحميل دفتر الشروط'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo[100],
//                         foregroundColor: Colors.black,
//                       ),
//                     ),
//                 ],
//               )
//             else
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.edit),
//                 label: const Text('تعديل المناقصة'),
//                 onPressed: () async {
//                   final updated = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => NewTender(existingTender: widget.tender),
//                     ),
//                   );
//                   if (updated != null) setState(() => widget.tender = updated);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class IconTextRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color iconColor;

//   const IconTextRow({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Text(
//               text,
//               textAlign: TextAlign.right,
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//           SizedBox(width: 8),
//           Icon(icon, size: 20, color: iconColor),
//         ],
//       ),
//     );
//   }
// }
class TenderDetails extends StatefulWidget {
  TenderDetails({super.key, required this.tender, this.bids, this.addBid});

  Tender tender;
  List<Bid>? bids;
  final void Function(Bid bid)? addBid;

  @override
  State<TenderDetails> createState() => _TenderDetailsState();
}

class _TenderDetailsState extends State<TenderDetails> {
  String? role;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadUserRole();
    checkIfFavorite();
  }

  void loadUserRole() async {
    final userRole = await TokenStorage.getRole();
    setState(() {
      role = userRole;
    });
  }

  void checkIfFavorite() async {
    try {
      final savedTenders = await TenderService.fetchSavedTenders();
      if (savedTenders != null) {
        setState(() {
          isFavorite = savedTenders.any((t) => t.id == widget.tender.id);
        });
      }
    } catch (e) {
      print('حدث خطأ أثناء التحقق من المناقصات المحفوظة: $e');
    }
  }

  // Future<void> checkContractorInfo() async {
  //   final userId = await TokenStorage.getUserrId();

  //   // تحقق هل سبق تقديم عرض
  //   final bids = await BidService.fetchBids(int.parse(widget.tender.id!));
  //   final alreadySubmitted = bids.any(
  //     (bid) => bid.contractorId.toString() == userId,
  //   );

  //   if (alreadySubmitted) {
  //     showDialog(
  //       context: context,
  //       builder:
  //           (context) => AlertDialog(
  //             title: const Text('تنبيه'),
  //             content: const Text(
  //               'لقد قمت بتقديم عرض على هذه المناقصة من قبل.',
  //             ),
  //             actions: [
  //               TextButton(
  //                 onPressed: () => Navigator.pop(context),
  //                 child: const Text('حسناً'),
  //               ),
  //             ],
  //           ),
  //     );
  //     return;
  //   }

  //   try {
  //     final contractor = await ContractorService.fetchContractorByUserId(
  //       userId!,
  //     );
  //     log(contractor.toString());

  //     if (contractor == null) {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (_) => AddContractor()),
  //       );
  //     } else {
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder:
  //               (_) => AddBid(
  //                 tenderId: int.tryParse(widget.tender.id!),
  //                 tender: widget.tender,
  //                 contractorId: contractor.id,
  //               ),
  //         ),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('حدث خطأ أثناء التحقق من بيانات المقاول')),
  //     );
  //   }
  // }
  Future<void> checkContractorInfo() async {
    final userId = await TokenStorage.getUserrId();

    try {
      final contractor = await ContractorService.fetchContractorByUserId(
        userId!,
      );

      if (contractor == null) {
        // لم يقم بتسجيل معلوماته كمقاول بعد
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddContractor(isEditing: false)),
        );

        return;
      }

      // تحقق هل سبق تقديم عرض لهذه المناقصة
      final bids = await BidService.fetchBids(int.parse(widget.tender.id!));
      final alreadySubmitted = bids.any(
        (bid) => bid.contractorId == contractor.id,
      );

      if (alreadySubmitted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('تنبيه'),
                content: const Text(
                  'لقد قمت بتقديم عرض على هذه المناقصة من قبل.',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('حسناً'),
                  ),
                ],
              ),
        );
        return;
      }

      // السماح له بتقديم عرض
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => AddBid(
                tenderId: int.tryParse(widget.tender.id!),
                tender: widget.tender,
                contractorId: contractor.id,
              ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء التحقق من بيانات المقاول')),
      );
    }
  }

  void toggleFavorite() async {
    try {
      if (isFavorite) {
        await TenderService.cancellationTenders(widget.tender.id!);
      } else {
        await TenderService.saveTenders(widget.tender);
      }
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحديث حالة المفضلة')),
      );
    }
  }

  Future<void> downloadFileWithHttp(
    String url,
    String fileName,
    BuildContext context,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {'ngrok-skip-browser-warning': 'true'},
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/$fileName';
        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تم تنزيل الملف إلى: $filePath')),
        );
      } else {
        throw 'HTTP ${response.statusCode}';
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('فشل تحميل الملف: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: Colors.indigo,
      //   centerTitle: true,
      //   title: Text(
      //     'تفاصيل المناقصة',
      //     style: TextStyle(
      //       fontSize: 20,
      //       color: Colors.white,
      //       fontWeight: FontWeight.bold,
      //     ),
      //   ),
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

        actions: [
          IconButton(
            onPressed:
                () => Navigator.pushReplacementNamed(context, '/tendersScreen'),
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 16),
            Card(
              color:
                  widget.tender.stateOfTender.name == 'opened'
                      ? Colors.green[100]
                      : Colors.red[100],
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Center(
                      child: Text(
                        widget.tender.title,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[900],
                        ),
                      ),
                    ),
                    SizedBox(height: 12),
                    IconTextRow(
                      icon: Icons.assignment_turned_in,
                      iconColor:
                          widget.tender.stateOfTender.name == 'opened'
                              ? Colors.green
                              : Colors.redAccent,
                      text: "${widget.tender.stateOfTender.name} :الحالة",
                    ),
                    IconTextRow(
                      icon: Icons.calendar_today,
                      iconColor: Colors.orange,
                      text:
                          "${widget.tender.registrationDeadline} :التاريخ النهائي",
                    ),
                    IconTextRow(
                      icon: Icons.info_outline,
                      iconColor: Colors.purple,
                      text:
                          "${widget.tender.numberOfTechnicalConditions} :عدد الشروط الفنية",
                    ),
                    IconTextRow(
                      icon: Icons.location_on,
                      iconColor: Colors.red,
                      text: "${widget.tender.location} :الموقع",
                    ),
                    IconTextRow(
                      icon: Icons.timer,
                      iconColor: Colors.blue,
                      text:
                          "${widget.tender.implementationPeriod} :عدد أيام التنفيذ",
                    ),
                    IconTextRow(
                      icon: Icons.attach_money,
                      iconColor: Colors.teal,
                      text: "${widget.tender.budget} :الميزانية",
                    ),
                    if (role == 'admin')
                      Center(
                        child: ElevatedButton(
                          onPressed: () async {
                            final userId = await TokenStorage.getUserrId();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BidList(
                                      tender: widget.tender,
                                      userId: int.tryParse(userId!) ?? 0,
                                      tenderId:
                                          int.tryParse(widget.tender.id!) ?? 0,
                                    ),
                              ),
                            );
                          },
                          child: Text('قائمة العروض'),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                widget.tender.descripe,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(height: 20),
            if (role == 'contractor')
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.tender.stateOfTender.name == 'opened')
                        ElevatedButton.icon(
                          onPressed: () {
                            checkContractorInfo();
                          },
                          label: Text(
                            'إضافة عرض',
                            style: TextStyle(fontSize: 15, color: Colors.black),
                          ),
                          icon: Icon(Icons.add),
                        ),
                      SizedBox(width: 20),
                      IconButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.blue[200],
                          ),
                        ),
                        onPressed: () {
                          toggleFavorite();
                        },
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  if (widget.tender.technicalFileUrl != null)
                    ElevatedButton.icon(
                      onPressed: () {
                        final fileUrl = widget.tender.technicalFileUrl!;
                        final fileName = fileUrl.split('/').last;
                        downloadFileWithHttp(fileUrl, 'specs.pdf', context);
                      },
                      icon: Icon(Icons.download),
                      label: Text('تحميل دفتر الشروط'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.indigo[100],
                        foregroundColor: Colors.black,
                      ),
                    ),
                ],
              )
            else
              ElevatedButton.icon(
                icon: const Icon(Icons.edit),
                label: const Text('تعديل المناقصة'),
                onPressed: () async {
                  final updated = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => NewTender(existingTender: widget.tender),
                    ),
                  );
                  if (updated != null) setState(() => widget.tender = updated);
                },
              ),
          ],
        ),
      ),
    );
  }
}

class IconTextRow extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color iconColor;

  const IconTextRow({
    super.key,
    required this.icon,
    required this.text,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Text(
              text,
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 14),
            ),
          ),
          SizedBox(width: 8),
          Icon(icon, size: 20, color: iconColor),
        ],
      ),
    );
  }
}

// class TenderDetails extends StatefulWidget {
//   TenderDetails({super.key, required this.tender, this.bids, this.addBid});

//   Tender tender;

//   List<Bid>? bids;
//   final void Function(Bid bid)? addBid;

//   @override
//   State<TenderDetails> createState() => _TenderDetailsState();
// }

// class _TenderDetailsState extends State<TenderDetails> {
//   String? role;
//   bool isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     loadUserRole();
//     checkIfFavorite();
//   }

//   void loadUserRole() async {
//     final userRole = await TokenStorage.getRole();
//     setState(() {
//       role = userRole;
//     });
//   }

//   void checkIfFavorite() async {
//     try {
//       final savedTenders = await TenderService.fetchSavedTenders();
//       if (savedTenders != null) {
//         setState(() {
//           isFavorite = savedTenders.any((t) => t.id == widget.tender.id);
//         });
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء التحقق من المناقصات المحفوظة: $e');
//     }
//   }

//   void checkContractorInfo() async {
//     final userrId = await TokenStorage.getUserrId();
//     try {
//       final contractor = await ContractorService.getContractorInfo(
//         // هنا يمكن إلغاء التعليق وتمرير id المستخدم لو تحتاج
//         // int.tryParse(userrId!) ?? 0,
//       );

//       if (contractor == null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => AddContractor()),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (_) => AddBid(
//                   tenderId: int.tryParse(widget.tender.id!),
//                   // contractorId: contractor.id,
//                   tender: widget.tender,
//                 ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء التحقق من بيانات المقاول')),
//       );
//     }
//   }

//   void toggleFavorite() async {
//     try {
//       if (isFavorite) {
//         await TenderService.cancellationTenders(widget.tender.id!);
//       } else {
//         await TenderService.saveTenders(widget.tender);
//       }
//       setState(() {
//         isFavorite = !isFavorite;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء تحديث حالة المفضلة')),
//       );
//     }
//   }

//   Future<void> downloadFile(String url, String fileName) async {
//     try {
//       // طلب صلاحيات التخزين (Android فقط)
//       if (Platform.isAndroid) {
//         var status = await Permission.storage.request();
//         if (!status.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('يرجى منح صلاحيات التخزين لتنزيل الملف')),
//           );
//           return;
//         }
//       }

//       // اسم الملف مع إضافة id المناقصة
//       final saveFileName = 'دفتر_الشروط_${widget.tender.id}.pdf';

//       // مسار حفظ الملف - مجلد التنزيلات في Android
//       Directory directory;

//       if (Platform.isAndroid) {
//         directory = Directory('/storage/emulated/0/Download');
//         if (!await directory.exists()) {
//           directory = await getExternalStorageDirectory() ?? directory;
//         }
//       } else if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       } else {
//         directory = await getApplicationDocumentsDirectory();
//       }

//       final savePath = '${directory.path}/$saveFileName';

//       Dio dio = Dio();
//       await dio.download(
//         url,
//         savePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             print(
//               'Downloading: ${(received / total * 100).toStringAsFixed(0)}%',
//             );
//           }
//         },
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('تم تنزيل الملف إلى: $savePath')));

//       // فتح الملف تلقائياً بعد التنزيل
//       await OpenFile.open(savePath);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ في تحميل الملف: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.indigo,
//         centerTitle: true,
//         title: Text(
//           'تفاصيل المناقصة',
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed:
//                 () => Navigator.pushReplacementNamed(context, '/tendersScreen'),
//             icon: Icon(Icons.keyboard_arrow_right),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 16),
//             Card(
//               color:
//                   widget.tender.stateOfTender.name == 'opened'
//                       ? Colors.green[100]
//                       : Colors.red[100],
//               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Center(
//                       child: Text(
//                         widget.tender.title,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.indigo[900],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     IconTextRow(
//                       icon: Icons.assignment_turned_in,
//                       iconColor:
//                           widget.tender.stateOfTender.name == 'opened'
//                               ? Colors.green
//                               : Colors.redAccent,
//                       text: "${widget.tender.stateOfTender.name} :الحالة",
//                     ),
//                     IconTextRow(
//                       icon: Icons.calendar_today,
//                       iconColor: Colors.orange,
//                       text:
//                           "${widget.tender.registrationDeadline.toLocal().toString().split(' ')[0]} :التاريخ النهائي",
//                     ),
//                     IconTextRow(
//                       icon: Icons.info_outline,
//                       iconColor: Colors.purple,
//                       text:
//                           "${widget.tender.numberOfTechnicalConditions} :عدد الشروط الفنية",
//                     ),
//                     IconTextRow(
//                       icon: Icons.location_on,
//                       iconColor: Colors.red,
//                       text: "${widget.tender.location} :الموقع",
//                     ),
//                     IconTextRow(
//                       icon: Icons.timer,
//                       iconColor: Colors.blue,
//                       text:
//                           "${widget.tender.implementationPeriod} :عدد أيام التنفيذ",
//                     ),
//                     IconTextRow(
//                       icon: Icons.attach_money,
//                       iconColor: Colors.teal,
//                       text: "${widget.tender.budget} :الميزانية",
//                     ),
//                     if (role == 'admin')
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             final userId = await TokenStorage.getUserrId();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => BidList(
//                                       userId: int.tryParse(userId!) ?? 0,
//                                       tenderId:
//                                           int.tryParse(widget.tender.id!) ?? 0,
//                                     ),
//                               ),
//                             );
//                           },
//                           child: Text('قائمة العروض'),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 widget.tender.descripe,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (role == 'contractor')
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (widget.tender.stateOfTender.name == 'opened')
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             checkContractorInfo();
//                           },
//                           label: Text(
//                             'إضافة عرض',
//                             style: TextStyle(fontSize: 15, color: Colors.black),
//                           ),
//                           icon: Icon(Icons.add),
//                         )
//                       else
//                         SizedBox(),
//                       SizedBox(width: 20),
//                       IconButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStatePropertyAll(
//                             Colors.blue[200],
//                           ),
//                         ),
//                         onPressed: () {
//                           toggleFavorite();
//                         },
//                         icon: Icon(
//                           isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: isFavorite ? Colors.red : Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12),
//                   if (widget.tender.technicalFileUrl != null)
//                     ElevatedButton.icon(
//                       onPressed:
//                           (widget.tender.technicalFileUrl == null ||
//                                   widget.tender.technicalFileUrl!.isEmpty)
//                               ? null // تعطيل الزر إذا الرابط فارغ أو null
//                               : () {
//                                 final fileUrl = widget.tender.technicalFileUrl!;
//                                 final fileName = fileUrl.split('/').last;
//                                 downloadFile(fileUrl, fileName);
//                               },
//                       icon: Icon(Icons.download),
//                       label: Text('تحميل دفتر الشروط'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor:
//                             (widget.tender.technicalFileUrl == null ||
//                                     widget.tender.technicalFileUrl!.isEmpty)
//                                 ? Colors
//                                     .grey // لون رمادي للزر المعطل
//                                 : Colors.indigo[100],
//                         foregroundColor: Colors.black,
//                       ),
//                     ),
//                   // ElevatedButton.icon(
//                   //   onPressed: () {
//                   //     final fileUrl = widget.tender.technicalFileUrl!;
//                   //     final fileName = fileUrl.split('/').last;
//                   //     downloadFile(fileUrl, fileName);
//                   //   },
//                   //   icon: Icon(Icons.download),
//                   //   label: Text('تحميل دفتر الشروط'),
//                   //   style: ElevatedButton.styleFrom(
//                   //     backgroundColor: Colors.indigo[100],
//                   //     foregroundColor: Colors.black,
//                   //   ),
//                   // ),
//                 ],
//               )
//             else
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.edit),
//                 label: const Text('تعديل المناقصة'),
//                 onPressed: () async {
//                   final updated = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => NewTender(existingTender: widget.tender),
//                     ),
//                   );
//                   if (updated != null) setState(() => widget.tender = updated);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class IconTextRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color iconColor;

//   const IconTextRow({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Text(
//               text,
//               textAlign: TextAlign.right,
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//           SizedBox(width: 8),
//           Icon(icon, size: 20, color: iconColor),
//         ],
//       ),
//     );
//   }
// }

// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:dio/dio.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:flutter/material.dart';
// import 'package:tendersmart/add_bid.dart';
// import 'package:tendersmart/add_contractor.dart';
// import 'package:tendersmart/bid_list.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/models/Tender.dart';
// import 'package:tendersmart/new_tender.dart';
// import 'package:tendersmart/services/contractor_service.dart';
// import 'package:tendersmart/services/tender_service.dart';
// import 'package:tendersmart/services/token_storage.dart';
// import 'package:url_launcher/url_launcher.dart';

// class TenderDetails extends StatefulWidget {
//   TenderDetails({super.key, required this.tender, this.bids, this.addBid});

//   Tender tender;

//   List<Bid>? bids;
//   final void Function(Bid bid)? addBid;

//   @override
//   State<TenderDetails> createState() => _TenderDetailsState();
// }

// class _TenderDetailsState extends State<TenderDetails> {
//   String? role;
//   bool isFavorite = false;

//   @override
//   void initState() {
//     super.initState();
//     loadUserRole();
//     checkIfFavorite();
//   }

//   void loadUserRole() async {
//     final userRole = await TokenStorage.getRole();
//     setState(() {
//       role = userRole;
//     });
//   }

//   void checkIfFavorite() async {
//     try {
//       final savedTenders = await TenderService.fetchSavedTenders();
//       if (savedTenders != null) {
//         setState(() {
//           isFavorite = savedTenders.any((t) => t.id == widget.tender.id);
//         });
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء التحقق من المناقصات المحفوظة: $e');
//     }
//   }

//   void checkContractorInfo() async {
//     final userrId = await TokenStorage.getUserrId();
//     try {
//       final contractor = await ContractorService.getContractorInfo(
//         // int.tryParse(userrId!) ?? 0,
//       );

//       if (contractor == null) {
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => AddContractor()),
//         );
//       } else {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder:
//                 (_) => AddBid(
//                   tenderId: int.tryParse(widget.tender.id!),
//                   // contractorId: contractor.id,
//                   tender: widget.tender,
//                 ),
//           ),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء التحقق من بيانات المقاول')),
//       );
//     }
//   }

//   void toggleFavorite() async {
//     try {
//       if (isFavorite) {
//         await TenderService.cancellationTenders(widget.tender.id!);
//       } else {
//         await TenderService.saveTenders(widget.tender);
//       }
//       setState(() {
//         isFavorite = !isFavorite;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء تحديث حالة المفضلة')),
//       );
//     }
//   }

//   Future<void> downloadFile(String url, String fileName) async {
//     try {
//       // طلب صلاحيات التخزين (Android فقط)
//       if (Platform.isAndroid) {
//         var status = await Permission.storage.request();
//         if (!status.isGranted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(content: Text('يرجى منح صلاحيات التخزين لتنزيل الملف')),
//           );
//           return;
//         }
//       }

//       // مسار حفظ الملف
//       Directory directory;
//       if (Platform.isAndroid) {
//         directory = (await getExternalStorageDirectory())!;
//       } else if (Platform.isIOS) {
//         directory = await getApplicationDocumentsDirectory();
//       } else {
//         directory = await getApplicationDocumentsDirectory();
//       }

//       String savePath = '${directory.path}/$fileName';

//       Dio dio = Dio();
//       await dio.download(
//         url,
//         savePath,
//         onReceiveProgress: (received, total) {
//           if (total != -1) {
//             print(
//               'Downloading: ${(received / total * 100).toStringAsFixed(0)}%',
//             );
//           }
//         },
//       );

//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('تم تنزيل الملف إلى: $savePath')));
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ في تحميل الملف: $e')));
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.indigo,
//         centerTitle: true,
//         title: Text(
//           'Tender Details',
//           style: TextStyle(
//             fontSize: 20,
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         actions: [
//           IconButton(
//             onPressed:
//                 () => Navigator.pushReplacementNamed(context, '/tendersScreen'),
//             icon: Icon(Icons.keyboard_arrow_right),
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             SizedBox(height: 16),
//             Card(
//               color:
//                   widget.tender.stateOfTender.name == 'opened'
//                       ? Colors.green[100]
//                       : Colors.red[100],
//               margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               elevation: 4,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(12),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Center(
//                       child: Text(
//                         widget.tender.title,
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.indigo[900],
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 12),
//                     IconTextRow(
//                       icon: Icons.assignment_turned_in,
//                       iconColor:
//                           widget.tender.stateOfTender.name == 'opened'
//                               ? Colors.green
//                               : Colors.redAccent,
//                       text: "${widget.tender.stateOfTender.name} :الحالة",
//                     ),
//                     IconTextRow(
//                       icon: Icons.calendar_today,
//                       iconColor: Colors.orange,
//                       text:
//                           "${widget.tender.registrationDeadline} :التاريخ النهائي",
//                     ),
//                     IconTextRow(
//                       icon: Icons.info_outline,
//                       iconColor: Colors.purple,
//                       text:
//                           "${widget.tender.numberOfTechnicalConditions} :عدد الشروط الفنية",
//                     ),
//                     IconTextRow(
//                       icon: Icons.location_on,
//                       iconColor: Colors.red,
//                       text: "${widget.tender.location} :الموقع",
//                     ),
//                     IconTextRow(
//                       icon: Icons.timer,
//                       iconColor: Colors.blue,
//                       text:
//                           "${widget.tender.implementationPeriod} :عدد أيام التنفيذ",
//                     ),
//                     IconTextRow(
//                       icon: Icons.attach_money,
//                       iconColor: Colors.teal,
//                       text: "${widget.tender.budget} :الميزانية",
//                     ),
//                     if (role == 'admin')
//                       Center(
//                         child: ElevatedButton(
//                           onPressed: () async {
//                             final userId = await TokenStorage.getUserrId();
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => BidList(
//                                       userId: int.tryParse(userId!) ?? 0,
//                                       // bids: widget.bids,
//                                       tenderId:
//                                           int.tryParse(widget.tender.id!) ?? 0,
//                                     ),
//                               ),
//                             );
//                           },
//                           child: Text('قائمة العروض'),
//                         ),
//                       ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Text(
//                 widget.tender.descripe,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(fontSize: 16),
//               ),
//             ),
//             SizedBox(height: 20),
//             if (role == 'contractor')
//               Column(
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       if (widget.tender.stateOfTender.name == 'opened')
//                         ElevatedButton.icon(
//                           onPressed: () {
//                             checkContractorInfo();
//                           },
//                           label: Text(
//                             'إضافة عرض',
//                             style: TextStyle(fontSize: 15, color: Colors.black),
//                           ),
//                           icon: Icon(Icons.add),
//                         )
//                       else
//                         SizedBox(),
//                       SizedBox(width: 20),
//                       IconButton(
//                         style: ButtonStyle(
//                           backgroundColor: MaterialStatePropertyAll(
//                             Colors.blue[200],
//                           ),
//                         ),
//                         onPressed: () {
//                           toggleFavorite();
//                         },
//                         icon: Icon(
//                           isFavorite ? Icons.favorite : Icons.favorite_border,
//                           color: isFavorite ? Colors.red : Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 12),
//                   if (widget.tender.technicalFileUrl != null)
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         final fileUrl = widget.tender.technicalFileUrl!;
//                         final fileName = fileUrl.split('/').last;
//                         downloadFile(fileUrl, fileName);
//                       },
//                       icon: Icon(Icons.download),
//                       label: Text('تحميل دفتر الشروط'),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.indigo[100],
//                         foregroundColor: Colors.black,
//                       ),
//                     ),
//                 ],
//               )
//             else
//               ElevatedButton.icon(
//                 icon: const Icon(Icons.edit),
//                 label: const Text('تعديل المناقصة'),
//                 onPressed: () async {
//                   final updated = await Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (_) => NewTender(existingTender: widget.tender),
//                     ),
//                   );
//                   if (updated != null) setState(() => widget.tender = updated);
//                 },
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class IconTextRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color iconColor;

//   const IconTextRow({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.iconColor,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: [
//           Expanded(
//             child: Text(
//               text,
//               textAlign: TextAlign.right,
//               style: TextStyle(fontSize: 14),
//             ),
//           ),
//           SizedBox(width: 8),
//           Icon(icon, size: 20, color: iconColor),
//         ],
//       ),
//     );
//   }
// }
