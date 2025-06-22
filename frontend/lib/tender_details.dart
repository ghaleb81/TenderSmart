import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/add_contractor.dart';
import 'package:tendersmart/bid_list.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/new_tender.dart';
import 'package:tendersmart/services/contractor_service.dart';
import 'package:tendersmart/services/tender_service.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'package:url_launcher/url_launcher.dart';

// الكلاسات Tender, Bid, TokenStorage, TenderService, ContractorService, AddContractor, AddBid, NewTender, BidList
// مفترض موجودة عندك في مشروعك

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

  void checkContractorInfo() async {
    final userrId = await TokenStorage.getUserrId();
    try {
      final contractor = await ContractorService.getContractorInfo(
        int.tryParse(userrId!) ?? 0,
      );

      if (contractor == null) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddContractor()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (_) => AddBid(
                  tenderId: int.tryParse(widget.tender.id!),
                  contractorId: contractor.id,
                  tender: widget.tender,
                ),
          ),
        );
      }
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

  Future<void> downloadFile(String url, String fileName) async {
    try {
      // طلب صلاحيات التخزين (Android فقط)
      if (Platform.isAndroid) {
        var status = await Permission.storage.request();
        if (!status.isGranted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('يرجى منح صلاحيات التخزين لتنزيل الملف')),
          );
          return;
        }
      }

      // مسار حفظ الملف
      Directory directory;
      if (Platform.isAndroid) {
        directory = (await getExternalStorageDirectory())!;
      } else if (Platform.isIOS) {
        directory = await getApplicationDocumentsDirectory();
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      String savePath = '${directory.path}/$fileName';

      Dio dio = Dio();
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            print(
              'Downloading: ${(received / total * 100).toStringAsFixed(0)}%',
            );
          }
        },
      );

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('تم تنزيل الملف إلى: $savePath')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ في تحميل الملف: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.indigo,
        centerTitle: true,
        title: Text(
          'Tender Details',
          style: TextStyle(
            fontSize: 20,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => BidList(
                                      // bids: widget.bids,
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
                        )
                      else
                        SizedBox(),
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
                        downloadFile(fileUrl, fileName);
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
// import 'dart:html' as html;

// class TenderDetails extends StatefulWidget {
//   TenderDetails({super.key, required this.tender, this.bids, this.addBid});
//
//   Tender tender;
//   List<Bid>? bids;
//   final void Function(Bid bid)? addBid;
//
//   @override
//   State<TenderDetails> createState() => _TenderDetailsState();
// }
//
// class _TenderDetailsState extends State<TenderDetails> {
//   String? role;
//   bool isFavorite = false;
//   late Future<List<Tender>> savedTenders;
//
//   @override
//   void initState() {
//     super.initState();
//     loadUserRole();
//     checkIfFavorite();
//   }
//
//   void loadUserRole() async {
//     final userRole = await TokenStorage.getRole();
//     setState(() {
//       role = userRole;
//     });
//   }
//
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
//
//   // void downloadFile(String url, String fileName) {
//   //   final anchor =
//   //       // html.AnchorElement(href: url)
//   //         ..setAttribute("download", fileName)
//   //         ..click();
//   // }
//
//   void checkContractorInfo() async {
//     try {
//       final contractor = await ContractorService.getContractorInfo();
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
//                   contractorId: contractor.id,
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
//
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
//
//   // void downloadTechnicalFile() async {
//   //   final url = widget.tender.technicalFileUrl;
//   //   if (url != null && await canLaunchUrl(Uri.parse(url))) {
//   //     await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
//   //   } else {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('رابط التحميل غير متوفر أو غير صالح')),
//   //     );
//   //   }
//   // }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.indigo,
//         // backgroundColor: Colors.indigo,
//         centerTitle: true,
//         title: Text(
//           'Tender Details',
//           // 'تفاصيل المناقصة',
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
//               //  Colors.indigo[50],
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
//                           onPressed: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder:
//                                     (context) => BidList(
//                                       bids: widget.bids,
//                                       // tenderId: widget.tender.id,
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
//                           backgroundColor: WidgetStatePropertyAll(
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
//                   // if (widget.tender.technicalFileUrl != null)
//                   //   ElevatedButton.icon(
//                   //     onPressed: () {
//                   //       final fileUrl = widget.tender.technicalFileUrl!;
//                   //       final fileName = fileUrl.split('/').last;
//                   //       downloadFile(fileUrl, fileName);
//                   //     },
//                   //     icon: Icon(Icons.download),
//                   //     label: Text('تحميل دفتر الشروط'),
//                   //     style: ElevatedButton.styleFrom(
//                   //       backgroundColor: Colors.indigo[100],
//                   //       foregroundColor: Colors.black,
//                   //       //   ),,
//                   //     ),
//                   //   ),
//                   // ElevatedButton.icon(
//                   //   onPressed: () {
//                   //     launchUrl(
//                   //       Uri.parse(widget.tender.technicalFileUrl!),
//                   //       webOnlyWindowName: '_blank',
//                   //     );
//                   //   }, // downloadTechnicalFile,
//                   //   icon: Icon(Icons.file_download),
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
//
// class IconTextRow extends StatelessWidget {
//   final IconData icon;
//   final String text;
//   final Color iconColor;
//
//   const IconTextRow({
//     super.key,
//     required this.icon,
//     required this.text,
//     required this.iconColor,
//   });
//
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

// import 'package:flutter/material.dart';
// import 'package:tendersmart/add_bid.dart';
// import 'package:tendersmart/add_contractor.dart';
// import 'package:tendersmart/bid_list.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/models/Tender.dart';
// import 'package:tendersmart/services/contractor_service.dart';
// import 'package:tendersmart/services/tender_service.dart';
// import 'package:tendersmart/services/token_storage.dart';

// class TenderDetails extends StatefulWidget {
//   TenderDetails({
//     super.key,
//     required this.tender,
//     this.bids,
//     this.addBid,
//     // this.currentUserRole,
//     // this.isFavorite,
//   });
//   final Tender tender;
//   List<Bid>? bids;
//   final void Function(Bid bid)? addBid;
//   // final String? currentUserRole;

//   @override
//   State<TenderDetails> createState() => _TenderDetailsState();
// }

// class _TenderDetailsState extends State<TenderDetails> {
//   String? role;
//   bool isFavorite = false;
//   late Future<List<Tender>> savedTenders;

//   @override
//   void initState() {
//     super.initState();
//     loadUserRole();
//     // savedTenders = TenderService.fetchSavedTenders();
//     // checkContractorInfo();
//     checkIfFavorite();
//     // isFavorite = widget.isFavorite ?? false;
//   }

//   void loadUserRole() async {
//     final userRole = await TokenStorage.getRole();
//     setState(() {
//       role = userRole;
//     });
//   }

//   // التحقق إذا كانت المناقصة محفوظة
//   // void checkIfFavorite() async {
//   //   try {
//   //     final savedTenders = await TenderService.fetchSavedTenders();
//   //     print('المناقصات المحفوظة: $savedTenders');

//   //     setState(() {
//   //       isFavorite = savedTenders.any((t) => t.id == widget.tender.id);
//   //     });
//   //   } catch (e) {
//   //     print('حدث خطأ أثناء التحقق من المناقصات المحفوظة: $e');
//   //   }
//   // }
//   void checkIfFavorite() async {
//     try {
//       final savedTenders = await TenderService.fetchSavedTenders();
//       print('المناقصات المحفوظة: $savedTenders');

//       if (savedTenders == null) {
//         print('المناقصات المحفوظة فارغة أو null');
//       } else {
//         setState(() {
//           isFavorite = savedTenders.any((t) => t.id == widget.tender.id);
//         });
//       }
//     } catch (e) {
//       print('حدث خطأ أثناء التحقق من المناقصات المحفوظة: $e');
//     }
//   }

//   void checkContractorInfo() async {
//     try {
//       final contractor = await ContractorService.getContractorInfo();
//       log(contractor.toString());
//       if (contractor == null) {
//         // لا يوجد معلومات، انتقل لواجهة إضافة معلومات المقاول
//         // Navigator.pushReplacement(
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => AddContractor()),
//         );
//       } else {
//         // توجد معلومات، انتقل لواجهة إضافة العرض
//         // Navigator.pushReplacement(
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (_) => AddBid(tenderId: widget.tender.id)),
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
//         await TenderService.saveTenders(
//           widget.tender,
//           // widget.tender.id.toString(),
//         );
//       }
//       // تحديث الحالة بعد التغيير
//       setState(() {
//         isFavorite = !isFavorite;
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('حدث خطأ أثناء تحديث حالة المفضلة')),
//       );
//     }
//   }
//   // void openAddBidPage(BuildContext context, String tenderId) async {
//   //   final contractorInfo = await ContractorService.getContractorInfo();

//   //   if (contractorInfo == null || contractorInfo.companyName == null) {
//   //     // لم يتم إدخال بيانات المقاول
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(
//   //         builder:
//   //             (context) => AddContractor(
//   //               addContractor: (contractor) {
//   //                 // بعد الإضافة الناجحة للمقاول، يمكن فتح صفحة العرض
//   //                 Navigator.pushReplacement(
//   //                   context,
//   //                   MaterialPageRoute(
//   //                     builder: (context) => AddBid(tenderId: tenderId),
//   //                   ),
//   //                 );
//   //               },
//   //             ),
//   //       ),
//   //     );
//   //   } else {
//   //     // بيانات المقاول موجودة، افتح صفحة العرض مباشرة
//   //     Navigator.push(
//   //       context,
//   //       MaterialPageRoute(builder: (context) => AddBid(tenderId: tenderId)),
//   //     );
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.blue,
//         centerTitle: true,

//         title: Text('تفاصيل المناقصة', style: TextStyle(fontSize: 20)),

//         actions: [
//           IconButton(
//             onPressed: () => Navigator.pop(context),
//             icon: Icon(Icons.keyboard_arrow_right),
//           ),
//         ],
//       ),

//       body: SingleChildScrollView(
//         child: SizedBox(
//           child: Column(
//             children: [
//               Card(
//                 color: Colors.blue[200],
//                 margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//                 elevation: 4,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Expanded(
//                     child: Column(
//                       // crossAxisAlignment: CrossAxisAlignment.center,
//                       children: [
//                         Text(
//                           '${widget.tender.title}',
//                           style: TextStyle(
//                             fontSize: 18,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         SizedBox(height: 8),
//                         Padding(
//                           padding: EdgeInsets.all(12),
//                           child: Column(
//                             // mainAxisAlignment: MainAxisAlignment.end,
//                             children: [
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text("الموقع: ${widget.tender.location}"),
//                                   Icon(Icons.location_on),
//                                 ],
//                               ),
//                               // Row(
//                               //   mainAxisAlignment: MainAxisAlignment.end,
//                               //   children: [
//                               //     Text("يبدأ في: ${tender.expectedStartTime}"),
//                               //     Icon(Icons.lock_clock),
//                               //   ],
//                               // ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     " عدد الشروط الفنية: ${widget.tender.numberOfTechnicalConditions}",
//                                   ),
//                                   Icon(Icons.format_list_numbered),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "الموعد النهائي للتقديم: ${widget.tender.registrationDeadline}",
//                                   ),
//                                   Icon(Icons.format_list_numbered),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     " عدد أيام التنفيذ  : ${widget.tender.implementationPeriod}",
//                                   ),
//                                   Icon(Icons.calendar_today),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(" الميزانية: ${widget.tender.budget}"),
//                                   Icon(Icons.attach_money),
//                                 ],
//                               ),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   Text(
//                                     "الحالة : ${widget.tender.stateOfTender.name}",
//                                   ),
//                                   Icon(Icons.assignment_turned_in),
//                                 ],
//                               ),
//                               SizedBox(height: 10),
//                               Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   if (role == 'admin')
//                                     ElevatedButton(
//                                       onPressed: () {
//                                         Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder:
//                                                 (context) => BidList(
//                                                   bids: widget.bids,
//                                                   // currentUserRole:
//                                                   //     widget.currentUserRole!,
//                                                 ),
//                                           ),
//                                         );
//                                       },
//                                       child: Text('قائمة العروض'),
//                                     )
//                                   else
//                                     SizedBox(),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Text(
//                 textAlign: TextAlign.center,
//                 " ${widget.tender.descripe}",
//                 // " ${role}",
//                 softWrap: true,
//                 overflow: TextOverflow.visible,
//               ),
//               SizedBox(height: 150),
//               if (role == 'contractor')
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                       style: ButtonStyle(
//                         // backgroundColor: WidgetStatePropertyAll(
//                         //   Colors.blue[200],
//                         // ),
//                       ),
//                       onPressed: () {
//                         checkContractorInfo();
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder: (_) => AddBid(tenderId: widget.tender.id),
//                         //   ),
//                         // );
//                         // final tenderId = widget.tender.id;
//                         // openAddBidPage(context, tenderId!);
//                         // Navigator.push(
//                         //   context,
//                         //   MaterialPageRoute(
//                         //     builder:
//                         //         (context) => AddBid(
//                         //           tenderId: widget.tender.id,
//                         //           //addBid: widget.addBid,
//                         //         ),
//                         //   ),
//                         // );
//                       },
//                       label: Text(
//                         'إضافة عرض',
//                         style: TextStyle(fontSize: 15, color: Colors.black),
//                       ),
//                       icon: Icon(Icons.add),
//                     ),
//                     SizedBox(width: 20),
//                     IconButton(
//                       style: ButtonStyle(
//                         backgroundColor: WidgetStatePropertyAll(
//                           Colors.blue[200],
//                         ),
//                       ),
//                       onPressed: () {
//                         toggleFavorite();
//                         // isFavorite
//                         //     ? await TenderService.saveTenders(
//                         //       widget.tender,
//                         //       widget.tender.id.toString(),
//                         //     )
//                         //     : await TenderService.cancellationTenders(
//                         //       widget.tender.id!,
//                         //     );
//                       },
//                       // label: Text(
//                       //   'حفظ المناقصة',
//                       //   style: TextStyle(fontSize: 15, color: Colors.black),
//                       // ),
//                       icon: Icon(
//                         //Icon(Icons.favorite_border),
//                         isFavorite ? Icons.favorite : Icons.favorite_border,
//                         color: isFavorite ? Colors.red : Colors.grey,
//                       ),
//                     ),
//                   ],
//                 )
//               else
//                 SizedBox(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
