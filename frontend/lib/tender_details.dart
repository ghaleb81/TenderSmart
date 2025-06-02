import 'package:flutter/material.dart';
import 'package:tendersmart/add_bid.dart';
import 'package:tendersmart/add_contractor.dart';
import 'package:tendersmart/bid_list.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/contractor_service.dart';
import 'package:tendersmart/services/tender_service.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'package:tendersmart/tenders.dart';
import 'package:tendersmart/tenders_list.dart';

class TenderDetails extends StatefulWidget {
  TenderDetails({
    super.key,
    required this.tender,
    this.bids,
    this.addBid,
    this.currentUserRole,
    // this.isFavorite,
  });
  final Tender tender;
  List<Bid>? bids;
  final void Function(Bid bid)? addBid;
  final String? currentUserRole;

  @override
  State<TenderDetails> createState() => _TenderDetailsState();
}

class _TenderDetailsState extends State<TenderDetails> {
  String? role;
  bool isFavorite = false;

  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserRole();
    // checkContractorInfo();
    checkIfFavorite();
  }

  void loadUserRole() async {
    role = await TokenStorage.getRole();
  }

  // التحقق إذا كانت المناقصة محفوظة
  void checkIfFavorite() async {
    try {
      List<Tender> savedTenders = await TenderService.fetchSavedTenders();
      setState(() {
        isFavorite = savedTenders.any((t) => t.id == widget.tender.id);
      });
    } catch (e) {
      print('حدث خطأ أثناء التحقق من المناقصات المحفوظة: $e');
    }
  }

  void checkContractorInfo() async {
    try {
      final contractor = await ContractorService.getContractorInfo();
      if (contractor == null) {
        // لا يوجد معلومات، انتقل لواجهة إضافة معلومات المقاول
        // Navigator.pushReplacement(
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddContractor()),
        );
      } else {
        // توجد معلومات، انتقل لواجهة إضافة العرض
        // Navigator.pushReplacement(
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => AddBid(tenderId: widget.tender.id)),
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
        await TenderService.saveTenders(
          widget.tender,
          widget.tender.id.toString(),
        );
      }
      // تحديث الحالة بعد التغيير
      setState(() {
        isFavorite = !isFavorite;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ أثناء تحديث حالة المفضلة')),
      );
    }
  }
  // void openAddBidPage(BuildContext context, String tenderId) async {
  //   final contractorInfo = await ContractorService.getContractorInfo();

  //   if (contractorInfo == null || contractorInfo.companyName == null) {
  //     // لم يتم إدخال بيانات المقاول
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder:
  //             (context) => AddContractor(
  //               addContractor: (contractor) {
  //                 // بعد الإضافة الناجحة للمقاول، يمكن فتح صفحة العرض
  //                 Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => AddBid(tenderId: tenderId),
  //                   ),
  //                 );
  //               },
  //             ),
  //       ),
  //     );
  //   } else {
  //     // بيانات المقاول موجودة، افتح صفحة العرض مباشرة
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) => AddBid(tenderId: tenderId)),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.blue,
        centerTitle: true,

        title: Text('تفاصيل المناقصة', style: TextStyle(fontSize: 20)),

        actions: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.keyboard_arrow_right),
          ),
        ],
      ),

      body: SingleChildScrollView(
        child: SizedBox(
          child: Column(
            children: [
              Card(
                color: Colors.blue[200],
                margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Expanded(
                    child: Column(
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          '${widget.tender.title}',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Padding(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            // mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text("الموقع: ${widget.tender.location}"),
                                  Icon(Icons.location_on),
                                ],
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.end,
                              //   children: [
                              //     Text("يبدأ في: ${tender.expectedStartTime}"),
                              //     Icon(Icons.lock_clock),
                              //   ],
                              // ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    " عدد الشروط الفنية: ${widget.tender.numberOfTechnicalConditions}",
                                  ),
                                  Icon(Icons.format_list_numbered),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "الموعد النهائي للتقديم: ${widget.tender.registrationDeadline}",
                                  ),
                                  Icon(Icons.format_list_numbered),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    " عدد أيام التنفيذ  : ${widget.tender.implementationPeriod}",
                                  ),
                                  Icon(Icons.calendar_today),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(" الميزانية: ${widget.tender.budget}"),
                                  Icon(Icons.attach_money),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    "الحالة : ${widget.tender.stateOfTender.name}",
                                  ),
                                  Icon(Icons.assignment_turned_in),
                                ],
                              ),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (widget.currentUserRole == 'admin')
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder:
                                                (context) => BidList(
                                                  bids: widget.bids,
                                                  currentUserRole:
                                                      widget.currentUserRole!,
                                                ),
                                          ),
                                        );
                                      },
                                      child: Text('قائمة العروض'),
                                    )
                                  else
                                    SizedBox(),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Text(
                textAlign: TextAlign.center,
                " ${widget.tender.descripe}",
                softWrap: true,
                overflow: TextOverflow.visible,
              ),
              SizedBox(height: 150),
              if (role == 'contractor')
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.blue[200],
                        ),
                      ),
                      onPressed: () {
                        checkContractorInfo();
                        // final tenderId = widget.tender.id;
                        // openAddBidPage(context, tenderId!);
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder:
                        //         (context) => AddBid(
                        //           tenderId: widget.tender.id,
                        //           //addBid: widget.addBid,
                        //         ),
                        //   ),
                        // );
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
                        backgroundColor: WidgetStatePropertyAll(
                          Colors.blue[200],
                        ),
                      ),
                      onPressed: () {
                        toggleFavorite();
                        // isFavorite
                        //     ? await TenderService.saveTenders(
                        //       widget.tender,
                        //       widget.tender.id.toString(),
                        //     )
                        //     : await TenderService.cancellationTenders(
                        //       widget.tender.id!,
                        //     );
                      },
                      // label: Text(
                      //   'حفظ المناقصة',
                      //   style: TextStyle(fontSize: 15, color: Colors.black),
                      // ),
                      icon: Icon(
                        //Icon(Icons.favorite_border),
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                )
              else
                SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
