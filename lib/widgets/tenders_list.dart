import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:tendersmart/widgets/admin_report_page.dart';
import 'package:tendersmart/widgets/bid_list_of_contractor.dart';
import 'package:tendersmart/widgets/contractor_list_of_bid.dart';
import 'package:tendersmart/widgets/contractor_profile_page.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/models/contractor.dart';
import 'package:tendersmart/widgets/login_screen.dart';
import 'package:tendersmart/widgets/perfomance_report_page.dart';
import 'package:tendersmart/widgets/saved_tender_list.dart';
import 'package:tendersmart/services/auth_service.dart';
import 'package:tendersmart/services/contractor_service.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'package:tendersmart/widgets/tender_details.dart';
import 'package:tendersmart/services/tender_service.dart';

class TenderListPage extends StatefulWidget {
  TenderListPage({
    super.key,
    this.bids,
    this.addBid,
    this.switchScreenToTenders,
  });

  final void Function(Bid bid)? addBid;
  List<Bid>? bids;
  final void Function()? switchScreenToTenders;

  @override
  State<TenderListPage> createState() => _TenderListPageState();
}

class _TenderListPageState extends State<TenderListPage> {
  String? role;
  List<Tender> _allTenders = [];
  List<Tender> _filteredTenders = [];
  TextEditingController _searchController = TextEditingController();
  bool _showOnlyOpened = false; // فلترة المناقصات المفتوحة
  Contractor? _contractor;

  @override
  void initState() {
    super.initState();
    loadUserRole();
    fetchData();
    loadContractorInfo();
  }

  void loadUserRole() async {
    role = await TokenStorage.getRole();
    setState(() {});
  }

  void fetchData() async {
    List<Tender> tenders = await TenderService.fetchTenders();
    setState(() {
      _allTenders = tenders;
      _filteredTenders = tenders;
    });
  }

  void loadContractorInfo() async {
    try {
      final contractor = await ContractorService.getContractorInfo();
      log(contractor.toString());
      setState(() {
        _contractor = contractor;
      });
    } catch (e) {
      // يمكن هنا تسجيل الخطأ أو إظهار رسالة لاحقاً
    }
  }

  void _filterTenders(String query) {
    final filtered =
        _allTenders.where((tender) {
          final titleMatch = tender.title.toLowerCase().contains(
            query.toLowerCase(),
          );
          final descMatch = tender.descripe.toLowerCase().contains(
            query.toLowerCase(),
          );
          final matchesQuery = titleMatch || descMatch;
          final matchesState =
              !_showOnlyOpened || tender.stateOfTender.name == 'opened';
          return matchesQuery && matchesState;
        }).toList();

    setState(() {
      _filteredTenders = filtered;
    });
  }

  void _logout(BuildContext context) async {
    await AuthService.logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: false,
          actions: [
            if (role == 'admin')
              IconButton(
                icon: Icon(Icons.add, color: Colors.white),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/newTender');
                },
              ),
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(color: Colors.indigo),
                child: Text(
                  'مرحباً بك',
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
              if (role == 'contractor')
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('الملف الشخصي'),
                  onTap: () async {
                    final userId = await TokenStorage.getUserrId();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ContractorProfilePage(userId: userId!),
                      ),
                    );
                  },
                ),
              if (role == 'admin')
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('قائمة الموردين'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ContractorListOfBid(),
                      ),
                    );
                  },
                )
              else
                Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.bookmark),
                      title: Text('المناقصات المحفوظة'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SavedTenderList(),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.list),
                      title: Text('قائمة العروض'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BidListOfContractor(),
                          ),
                        );
                      },
                    ),
                  ],
                ),

              ListTile(
                leading: Icon(Icons.person),
                title: Text(' أداء المناقصات'),
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PerformanceReportScreen(),
                    ),
                  );
                },
              ),
              if ((role == 'admin') || (role == 'committee'))
                ListTile(
                  leading: Icon(Icons.people),
                  title: Text('تقارير النظام'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminReportScreen(),
                      ),
                    );
                  },
                ),
              ListTile(
                leading: Icon(Icons.logout),
                title: Text('تسجيل الخروج'),
                onTap: () => _logout(context),
              ),
            ],
          ),
        ),
        body: Stack(
          children: [
            Image.asset(
              'images/image_1.jpg',
              width: double.infinity,
              height: 160,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: EdgeInsets.only(top: 100),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: TextField(
                            controller: _searchController,
                            onChanged: _filterTenders,
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                              hintText: 'ابحث عن مناقصة...',
                              hintStyle: TextStyle(color: Colors.black54),
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 14,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Checkbox(
                              value: _showOnlyOpened,
                              onChanged: (value) {
                                setState(() {
                                  _showOnlyOpened = value!;
                                });
                                _filterTenders(_searchController.text);
                              },
                            ),
                            Text(
                              'عرض المناقصات المفتوحة فقط',
                              style: TextStyle(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: Expanded(
                      child:
                          _filteredTenders.isEmpty
                              ? Center(
                                child: Text('No tenders match your search'),
                              )
                              : ListView.builder(
                                padding: EdgeInsets.only(top: 8),
                                itemCount: _filteredTenders.length,
                                itemBuilder: (context, index) {
                                  final tender = _filteredTenders[index];
                                  return Card(
                                    margin: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 8,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    color:
                                        tender.stateOfTender.name == 'opened'
                                            ? Colors.green[100]
                                            : Colors.red[100],
                                    elevation: 3,
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Center(
                                            child: Text(
                                              '${index + 1}_${tender.title}',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            tender.descripe,
                                            style: TextStyle(fontSize: 14),
                                            textAlign: TextAlign.center,
                                          ),
                                          SizedBox(height: 10),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: [
                                                  Icon(
                                                    Icons.announcement,
                                                    color: Colors.blue[800],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    tender.stateOfTender.name,
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Icon(
                                                    Icons.calendar_today,
                                                    color: Colors.orange[800],
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(
                                                    tender.registrationDeadline
                                                        .toString()
                                                        .split(' ')[0],
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  IconButton(
                                                    icon: Icon(
                                                      Icons.info,
                                                      color: Colors.indigo[800],
                                                    ),
                                                    onPressed: () {
                                                      Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder:
                                                              (
                                                                context,
                                                              ) => TenderDetails(
                                                                tender: tender,
                                                                bids:
                                                                    widget.bids,
                                                                addBid:
                                                                    widget
                                                                        .addBid,
                                                              ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                  SizedBox(height: 2),
                                                  Text("Details"),
                                                ],
                                              ),
                                              if (role == 'admin')
                                                IconButton(
                                                  icon: Icon(
                                                    Icons.delete_forever,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () async {
                                                    final confirmed = await showDialog(
                                                      context: context,
                                                      builder:
                                                          (ctx) => AlertDialog(
                                                            title: Text(
                                                              "Confirm Delete",
                                                            ),
                                                            content: Text(
                                                              "Are you sure you want to delete this tender?",
                                                            ),
                                                            actions: [
                                                              TextButton(
                                                                onPressed:
                                                                    () =>
                                                                        Navigator.pop(
                                                                          ctx,
                                                                          false,
                                                                        ),
                                                                child: Text(
                                                                  "Cancel",
                                                                ),
                                                              ),
                                                              TextButton(
                                                                onPressed:
                                                                    () =>
                                                                        Navigator.pop(
                                                                          ctx,
                                                                          true,
                                                                        ),
                                                                child: Text(
                                                                  "Yes",
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                    );
                                                    if (confirmed == true) {
                                                      await TenderService.deleteTender(
                                                        tender.id!,
                                                      );
                                                      fetchData();
                                                    }
                                                  },
                                                ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class TenderListPage extends StatefulWidget {
//   TenderListPage({
//     super.key,
//     this.bids,
//     this.addBid,
//     this.switchScreenToTenders,
//   });

//   final void Function(Bid bid)? addBid;
//   List<Bid>? bids;
//   final void Function()? switchScreenToTenders;

//   @override
//   State<TenderListPage> createState() => _TenderListPageState();
// }

// class _TenderListPageState extends State<TenderListPage> {
//   String? role;
//   List<Tender> _allTenders = [];
//   List<Tender> _filteredTenders = [];
//   TextEditingController _searchController = TextEditingController();

//   Contractor? _contractor;

//   @override
//   void initState() {
//     super.initState();
//     loadUserRole();
//     fetchData();
//     loadContractorInfo();
//   }

//   void loadUserRole() async {
//     role = await TokenStorage.getRole();
//     setState(() {});
//   }

//   void fetchData() async {
//     List<Tender> tenders = await TenderService.fetchTenders();
//     setState(() {
//       _allTenders = tenders;
//       _filteredTenders = tenders;
//     });
//   }

//   void loadContractorInfo() async {
//     try {
//       final contractor = await ContractorService.getContractorInfo();
//       log(contractor.toString());
//       setState(() {
//         _contractor = contractor;
//       });
//     } catch (e) {
//       // يمكن هنا تسجيل الخطأ أو إظهار رسالة لاحقاً
//     }
//   }

//   void _filterTenders(String query) {
//     final filtered =
//         _allTenders.where((tender) {
//           final titleMatch = tender.title.toLowerCase().contains(
//             query.toLowerCase(),
//           );
//           final descMatch = tender.descripe.toLowerCase().contains(
//             query.toLowerCase(),
//           );
//           return titleMatch || descMatch;
//         }).toList();

//     setState(() {
//       _filteredTenders = filtered;
//     });
//   }

//   void _logout(BuildContext context) async {
//     await AuthService.logout();
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(builder: (context) => LoginScreen()),
//       (route) => false,
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         // title: Text(
//         //   "Current Tenders",
//         //   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         // ),
//         centerTitle: false,
//         actions: [
//           if (role == 'admin')
//             IconButton(
//               icon: Icon(Icons.add, color: Colors.white),
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/newTender');
//               },
//             ),
//         ],
//       ),
//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.indigo),

//               child: Text(
//                 'مرحباً بك',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             if (role == 'contractor')
//               ListTile(
//                 leading: Icon(Icons.person),
//                 title: Text('الملف الشخصي'),
//                 onTap: () async {
//                   final userId = await TokenStorage.getUserrId();
//                   // if (_contractor != null) {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder:
//                           (context) => ContractorProfilePage(userId: userId!),
//                     ),
//                   );
//                 },
//                 //   else {
//                 //     ScaffoldMessenger.of(context).showSnackBar(
//                 //       SnackBar(content: Text('تعذر تحميل بيانات الملف الشخصي')),
//                 //     );
//                 //   }
//                 // },
//               ),

//             // ListTile(
//             //   leading: Icon(Icons.person),
//             //   title: Text(' أداء المناقصات'),
//             //   onTap: () async {
//             //     // final userId = await TokenStorage.getUserrId();
//             //     // if (_contractor != null) {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(
//             //         builder: (context) => PerformanceReportScreen(),
//             //       ),
//             //     );
//             //     //   } else {
//             //     //     ScaffoldMessenger.of(context).showSnackBar(
//             //     //       SnackBar(content: Text('تعذر تحميل بيانات الملف الشخصي')),
//             //     //     );
//             //     //   }
//             //   },
//             // ),
//             if (role == 'admin')
//               ListTile(
//                 leading: Icon(Icons.people),
//                 title: Text('قائمة الموردين'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => ContractorListOfBid(),
//                     ),
//                   );
//                 },
//               )
//             else
//               Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.bookmark),
//                     title: Text('المناقصات المحفوظة'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SavedTenderList(),
//                         ),
//                       );
//                     },
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.list),
//                     title: Text('قائمة العروض'),
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => BidListOfContractor(),
//                         ),
//                       );
//                     },
//                   ),
//                   // ListTile(
//                   //   leading: Icon(Icons.notifications),
//                   //   title: Text('الإشعارات'),
//                   //   onTap: () {
//                   //     Navigator.push(
//                   //       context,
//                   //       MaterialPageRoute(
//                   //         builder: (context) => NotificationsPage(),
//                   //       ),
//                   //     );
//                   //   },
//                   // ),
//                 ],
//               ),
//             ListTile(
//               leading: Icon(Icons.lock_open),
//               title: Text('المناقصات المفتوحة'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => TenderListPage()),
//                 );
//               },
//             ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text(' أداء المناقصات'),
//               onTap: () async {
//                 // final userId = await TokenStorage.getUserrId();
//                 // if (_contractor != null) {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => PerformanceReportScreen(),
//                   ),
//                 );
//                 //   } else {
//                 //     ScaffoldMessenger.of(context).showSnackBar(
//                 //       SnackBar(content: Text('تعذر تحميل بيانات الملف الشخصي')),
//                 //     );
//                 //   }
//               },
//             ),
//             if ((role == 'admin') || (role == 'committee'))
//               ListTile(
//                 leading: Icon(Icons.people),
//                 title: Text('تقارير النظام'),
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     MaterialPageRoute(
//                       builder: (context) => AdminReportScreen(),
//                     ),
//                   );
//                 },
//               )
//             else
//               SizedBox(),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('تسجيل الخروج'),
//               onTap: () => _logout(context),
//             ),
//           ],
//         ),
//       ),
//       body: Stack(
//         children: [
//           Image.asset(
//             'images/image_1.jpg',
//             width: double.infinity,
//             height: 160,
//             fit: BoxFit.cover,
//           ),
//           Padding(
//             padding: EdgeInsets.only(top: 100),
//             child: Column(
//               children: [
//                 Padding(
//                   padding: EdgeInsets.symmetric(horizontal: 16),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(0.3),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: TextField(
//                       controller: _searchController,
//                       onChanged: _filterTenders,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         hintText: 'Search tenders...',
//                         hintStyle: TextStyle(color: Colors.black54),
//                         prefixIcon: Icon(Icons.search, color: Colors.black),
//                         border: InputBorder.none,
//                         contentPadding: EdgeInsets.symmetric(
//                           horizontal: 12,
//                           vertical: 14,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 Directionality(
//                   textDirection: TextDirection.rtl,
//                   child: Expanded(
//                     child:
//                         _filteredTenders.isEmpty
//                             ? Center(
//                               child: Text('No tenders match your search'),
//                             )
//                             : ListView.builder(
//                               padding: EdgeInsets.only(top: 8),
//                               itemCount: _filteredTenders.length,
//                               itemBuilder: (context, index) {
//                                 final tender = _filteredTenders[index];
//                                 return Card(
//                                   margin: EdgeInsets.symmetric(
//                                     horizontal: 16,
//                                     vertical: 8,
//                                   ),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(15),
//                                   ),
//                                   color:
//                                       tender.stateOfTender.name == 'opened'
//                                           ? Colors.green[100]
//                                           : Colors.red[100],
//                                   elevation: 3,
//                                   child: Padding(
//                                     padding: EdgeInsets.all(16),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Center(
//                                           child: Text(
//                                             '${index + 1}_${tender.title}',
//                                             style: TextStyle(
//                                               fontSize: 18,
//                                               fontWeight: FontWeight.bold,
//                                             ),
//                                           ),
//                                         ),
//                                         SizedBox(height: 8),
//                                         Text(
//                                           tender.descripe,
//                                           style: TextStyle(fontSize: 14),
//                                           textAlign: TextAlign.center,
//                                         ),
//                                         SizedBox(height: 10),
//                                         Row(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.spaceEvenly,
//                                           children: [
//                                             Column(
//                                               children: [
//                                                 Icon(
//                                                   Icons.announcement,
//                                                   color: Colors.blue[800],
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Text(tender.stateOfTender.name),
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 Icon(
//                                                   Icons.calendar_today,
//                                                   color: Colors.orange[800],
//                                                 ),
//                                                 SizedBox(height: 5),
//                                                 Text(
//                                                   tender.registrationDeadline
//                                                       .toString()
//                                                       .split(' ')[0],
//                                                 ),
//                                               ],
//                                             ),
//                                             Column(
//                                               children: [
//                                                 IconButton(
//                                                   icon: Icon(
//                                                     Icons.info,
//                                                     color: Colors.indigo[800],
//                                                   ),
//                                                   onPressed: () {
//                                                     log(
//                                                       '${tender.manualWinnerBidId}',
//                                                     );
//                                                     Navigator.push(
//                                                       context,
//                                                       MaterialPageRoute(
//                                                         builder:
//                                                             (
//                                                               context,
//                                                             ) => TenderDetails(
//                                                               // userId: widget.,
//                                                               tender: tender,
//                                                               bids: widget.bids,
//                                                               addBid:
//                                                                   widget.addBid,
//                                                             ),
//                                                       ),
//                                                     );
//                                                   },
//                                                 ),
//                                                 SizedBox(height: 2),
//                                                 Text("Details"),
//                                               ],
//                                             ),
//                                             if (role == 'admin')
//                                               IconButton(
//                                                 icon: Icon(
//                                                   Icons.delete_forever,
//                                                   color: Colors.red,
//                                                 ),
//                                                 onPressed: () async {
//                                                   final confirmed = await showDialog(
//                                                     context: context,
//                                                     builder:
//                                                         (ctx) => AlertDialog(
//                                                           title: Text(
//                                                             "Confirm Delete",
//                                                           ),
//                                                           content: Text(
//                                                             "Are you sure you want to delete this tender?",
//                                                           ),
//                                                           actions: [
//                                                             TextButton(
//                                                               onPressed:
//                                                                   () =>
//                                                                       Navigator.pop(
//                                                                         ctx,
//                                                                         false,
//                                                                       ),
//                                                               child: Text(
//                                                                 "Cancel",
//                                                               ),
//                                                             ),
//                                                             TextButton(
//                                                               onPressed:
//                                                                   () =>
//                                                                       Navigator.pop(
//                                                                         ctx,
//                                                                         true,
//                                                                       ),
//                                                               child: Text(
//                                                                 "Yes",
//                                                               ),
//                                                             ),
//                                                           ],
//                                                         ),
//                                                   );
//                                                   if (confirmed == true) {
//                                                     await TenderService.deleteTender(
//                                                       tender.id!,
//                                                     );
//                                                     fetchData();
//                                                   }
//                                                 },
//                                               ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 );
//                               },
//                             ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
