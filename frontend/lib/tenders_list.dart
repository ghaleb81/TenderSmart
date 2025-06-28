// الكود المعدل لشاشة عرض المناقصات TenderListPage
import 'package:flutter/material.dart';
import 'package:tendersmart/bid_list_of_contractor.dart';
import 'package:tendersmart/contractor_profile_page.dart';
import 'package:tendersmart/login_screen.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/notifications_page.dart';
import 'package:tendersmart/saved_tender_list.dart';
import 'package:tendersmart/services/auth_service.dart';
import 'package:tendersmart/services/token_storage.dart';
import 'package:tendersmart/splash_screen.dart';
import 'package:tendersmart/tender_details.dart';
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

  @override
  void initState() {
    super.initState();
    loadUserRole();
    fetchData();
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

  void _filterTenders(String query) {
    final filtered =
        _allTenders.where((tender) {
          final titleMatch = tender.title.toLowerCase().contains(
            query.toLowerCase(),
          );
          final descMatch = tender.descripe.toLowerCase().contains(
            query.toLowerCase(),
          );
          return titleMatch || descMatch;
        }).toList();

    setState(() {
      _filteredTenders = filtered;
    });
  }

  // void _filterTenders(String query) {
  //   final filtered =
  //       _allTenders
  //           .where(
  //             (tender) =>
  //                 tender.title.toLowerCase().contains(query.toLowerCase()),
  //           )
  //           .toList();
  //   setState(() {
  //     _filteredTenders = filtered;
  //   });
  // }

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
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          "Current Tenders",
          style: TextStyle(
            color: Colors.white,
            // color: const Color.fromARGB(255, 1, 16, 39),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: false,
        actions: [
          if (role == 'admin')
            IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              // icon: Icon(Icons.add, color: Colors.black),
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
              decoration: BoxDecoration(color: Colors.blue[900]),
              child: Text(
                'مرحباً بك',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('الملف الشخصي'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ContractorProfilePage(),
                  ),
                );
              },
            ),
            if (role == 'admin')
              Column(
                children: [
                  ListTile(
                    leading: Icon(Icons.people),
                    title: Text('قائمة الموردين'),
                    onTap: () {},
                  ),
                  // ListTile(
                  //   leading: Icon(Icons.people),
                  //   title: Text('قائمة الموردين'),
                  //   onTap: () {},
                  // ),
                  // ListTile(
                  //   leading: Icon(Icons.people),
                  //   title: Text('قائمة الموردين'),
                  //   onTap: () {},
                  // ),
                ],
              )
            else ...[
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
            ListTile(
              leading: Icon(Icons.lock_open),
              title: Text('المناقصات المفتوحة'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TenderListPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.bookmark),
              title: Text('المناقصات المحفوظة'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SavedTenderList()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text('الإشعارات'),
              onTap: () {
                // NotificationsPage;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotificationsPage()),
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
          // الخلفية (الصورة)
          Image.asset(
            'images/image_1.jpg',
            width: double.infinity,
            height: 160,
            fit: BoxFit.cover,
          ),

          // المحتوى
          Padding(
            padding: EdgeInsets.only(top: 100),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: _filterTenders,
                      style: TextStyle(color: Colors.white),
                      // style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Search tenders...',
                        //hintStyle: TextStyle(color: Colors.white24),
                        hintStyle: TextStyle(color: Colors.black54),
                        // prefixIcon: Icon(Icons.search, color: Colors.white),
                        prefixIcon: Icon(Icons.search, color: Colors.black),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 14,
                        ),
                      ),
                    ),
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
                                                Text(tender.stateOfTender.name),
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
                                                              bids: widget.bids,
                                                              addBid:
                                                                  widget.addBid,
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
    );
  }
}
// import 'package:flutter/material.dart';
// import 'package:tendersmart/bid_list_of_contractor.dart';
// import 'package:tendersmart/contractor_profile_page.dart';
// import 'package:tendersmart/login_screen.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/models/Tender.dart';
// import 'package:tendersmart/models/contractor.dart';
// import 'package:tendersmart/new_tender.dart';
// import 'package:tendersmart/saved_tender_list.dart';
// import 'package:tendersmart/services/auth_service.dart';
// import 'package:tendersmart/services/token_storage.dart';
// import 'package:tendersmart/splash_screen.dart';
// import 'package:tendersmart/tender_details.dart';
// import 'package:tendersmart/services/tender_service.dart';

// class TenderListPage extends StatefulWidget {
//   TenderListPage({
//     super.key,
//     // required this.tenders,
//     // required this.onDeleteTender,
//     this.bids,
//     this.addBid,
//     this.switchScreenToTenders,
//     // required this.addContractor,
//     // required this.currentTenders,
//   });

//   // final List<Tender> tenders;
//   // final void Function(Tender tender) onDeleteTender;
//   final void Function(Bid bid)? addBid;
//   List<Bid>? bids;
//   final void Function()? switchScreenToTenders;
//   // final void Function(Contractor contractor) addContractor;
//   // final List<Tender> currentTenders;

//   @override
//   State<TenderListPage> createState() => _TenderListPageState();
// }

// class _TenderListPageState extends State<TenderListPage> {
//   final List colors = [Colors.lightGreen, Colors.redAccent];
//   String? role;
//   // String stateOfTender ='opened';
//   late Future<List<Tender>> tendersFuture;
//   @override
//   void initState() {
//     super.initState();
//     loadUserRole();
//     tendersFuture = TenderService.fetchTenders();
//   }

//   void loadUserRole() async {
//     role = await TokenStorage.getRole();
//     setState(() {});
//   }

//   // void _addtender(Tender ten) {
//   //   setState(() {
//   //     widget.currentTenders.add(ten);
//   //   });
//   // }

//   void _logout(BuildContext context) async {
//     // 1. تسجيل الخروج من الـ backend وحذف التوكن
//     await AuthService.logout();
//     print(TokenStorage.getToken());
//     // 2. إعادة التوجيه إلى صفحة تسجيل الدخول
//     Navigator.pushAndRemoveUntil(
//       context,
//       MaterialPageRoute(
//         builder:
//             (context) => SplashScreen(
//               // switchScreenToTenders:
//               //     widget
//               //         .switchScreenToTenders!, // مرر دالة وهمية إن لم تكن بحاجة لها الآن
//               // addContractor: (contractor) {}, // نفس الشيء
//             ),
//       ),
//       (route) => false, // هذا يغلق كل الصفحات السابقة ويبدأ من جديد
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     // final String? role = await TokenStorage.getRole();
//     return Scaffold(
//       appBar: AppBar(
//         centerTitle: true,
//         backgroundColor: Colors.blue,
//         title: const Text(
//           'المناقصات الحالية',
//           style: TextStyle(
//             // backgroundColor: Colors.tealAccent,
//             color: Colors.black,
//             fontSize: 20,
//           ),
//         ),

//         // leading: Icon(Icons.add),//leading هي الاشياء التي اريد عرضها قبل العنوان من جهة اليسار
//         actions: [
//           //Icon(Icons.add),
//           // OutlinedButton.icon:currentUserRole=='admin'?
//           // if (widget.currentUserRole == 'admin')
//           if (role == 'admin')
//             OutlinedButton.icon(
//               label: Text('إضافة مناقصة'),
//               onPressed: () {
//                 Navigator.pushReplacementNamed(context, '/newTender');
//                 // showModalBottomSheet(
//                 //   isScrollControlled: true, //يسمح للموديل بملئ الشاشة
//                 //   backgroundColor: Colors.transparent, //لتفادي الحواف البيضاء
//                 //   context: context,
//                 //   builder:
//                 //       (context) => Container(
//                 //         height:
//                 //             MediaQuery.of(context).size.height *
//                 //             0.90, //0.96تفريباً كل الشاشة
//                 //         decoration: BoxDecoration(
//                 //           color: Colors.white,
//                 //           borderRadius: BorderRadius.vertical(
//                 //             top: Radius.circular(20),
//                 //           ),
//                 //         ),
//                 //         child: Column(
//                 //           children: [
//                 //             NewTender(
//                 //               // onAddTender: _addtender,
//                 //               // tendersFuture: tendersFuture,
//                 //             ),
//                 //             // setState(() {

//                 //             // });
//                 //           ],
//                 //         ),
//                 //       ),
//                 // );
//               },
//               icon: Icon(Icons.add),
//             )
//           else
//             SizedBox(),
//         ],
//       ),

//       drawer: Drawer(
//         child: ListView(
//           padding: EdgeInsets.zero,
//           children: [
//             DrawerHeader(
//               decoration: BoxDecoration(color: Colors.blue),
//               child: Text(
//                 'مرحباً بك',
//                 style: TextStyle(color: Colors.white, fontSize: 24),
//               ),
//             ),
//             // ListTile(
//             //   leading: Icon(Icons.home),
//             //   title: Text('الصفحة الرئيسية'),
//             //   onTap: () {
//             //     Navigator.pop(context);
//             //   },
//             // ),
//             ListTile(
//               leading: Icon(Icons.person),
//               title: Text('الملف الشخصي'),
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ContractorProfilePage(),
//                   ),
//                 );
//               },
//             ),

//             if (role == 'admin')
//               ListTile(
//                 leading: Icon(Icons.people),
//                 title: Text('قائمة الموردين'),
//                 onTap:
//                     () => LoginScreen(
//                       // switchScreenToTenders: widget.switchScreenToTenders!,
//                       // addContractor: widget.addContractor,
//                     ),
//               )
//             else
//               Column(
//                 children: [
//                   ListTile(
//                     leading: Icon(Icons.people),
//                     title: Text('قائمة العروض'),
//                     onTap:
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => BidListOfContractor(),
//                           ),
//                         ),
//                   ),
//                   ListTile(
//                     leading: Icon(Icons.people),
//                     title: Text('قائمة المناقصات المحفوظة'),
//                     onTap:
//                         () => Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SavedTenderList(),
//                           ),
//                         ),
//                   ),
//                 ],
//               ),

//             // SizedBox(),
//             ListTile(
//               leading: Icon(Icons.logout),
//               title: Text('تسجيل الخروج'),
//               onTap: () => _logout(context),
//               //  LoginScreen(
//               //   switchScreenToTenders: widget.switchScreenToTenders,
//               //   addContractor: widget.addContractor,
//               // ),
//             ),
//           ],
//         ),
//       ),
//       body: FutureBuilder<List<Tender>>(
//         future: tendersFuture,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('خطأ : ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//             return Center(child: Text('لا توجد مناقصات حالياً'));
//           } else {
//             final tenders = snapshot.data!;
//             return ListView.builder(
//               itemCount: tenders.length,
//               itemBuilder: (context, index) {
//                 final tender = tenders[index];
//                 final stateOfTender = tender.stateOfTender.name;
//                 print(stateOfTender);
//                 return Expanded(
//                   child: Card(
//                     color:
//                         stateOfTender == 'opened'
//                             ? Colors.blue[200]
//                             : Colors.red[200],
//                     // Colors.blue[200],
//                     margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//                     elevation: 4,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text(
//                                 '${tender.title}',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               Text(
//                                 ' _${index + 1}',
//                                 style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                               // Text(
//                               //   '${tender.title}_${index + 1}',
//                               //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                               // ),
//                             ],
//                           ),
//                           SizedBox(height: 8),
//                           Padding(
//                             padding: EdgeInsets.all(12),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Expanded(
//                                       child: Text(
//                                         textAlign: TextAlign.center,
//                                         " ${tender.descripe}",
//                                         softWrap: true,
//                                         overflow: TextOverflow.visible,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Text(
//                                       "${tender.stateOfTender.name}: الحالة",
//                                     ),
//                                     Icon(Icons.announcement),
//                                   ],
//                                 ),
//                                 SizedBox(height: 10),
//                                 Row(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   children: [
//                                     Row(
//                                       children: [
//                                         ElevatedButton.icon(
//                                           onPressed: () {
//                                             Navigator.push(
//                                               context,
//                                               MaterialPageRoute(
//                                                 builder:
//                                                     (context) => TenderDetails(
//                                                       tender: tenders[index],
//                                                       // isFavorite: false,
//                                                       bids: widget.bids,
//                                                       addBid: widget.addBid,
//                                                       // currentUserRole:
//                                                       //     widget
//                                                       //         .currentUserRole!,
//                                                     ),
//                                               ),
//                                             );
//                                           },
//                                           icon: Icon(Icons.details),
//                                           label: Text('تفاصيل المناقصة'),
//                                         ),
//                                       ],
//                                     ),
//                                     SizedBox(width: 10),
//                                     Row(
//                                       children: [
//                                         // if (widget.currentUserRole == 'admin')
//                                         if (role == 'admin')
//                                           ElevatedButton.icon(
//                                             onPressed: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (ctx) => AlertDialog(
//                                                       icon: Icon(Icons.warning),
//                                                       title: Center(
//                                                         child: Text(
//                                                           'تحذير',
//                                                           style: TextStyle(
//                                                             fontSize: 20,
//                                                             // backgroundColor: Colors.blue,
//                                                           ),
//                                                         ),
//                                                       ),
//                                                       content: Text(
//                                                         'هل أنت متأكد من حذف المناقصة',
//                                                         textAlign:
//                                                             TextAlign.center,
//                                                       ),
//                                                       actions: [
//                                                         TextButton(
//                                                           style: ButtonStyle(
//                                                             backgroundColor:
//                                                                 WidgetStatePropertyAll(
//                                                                   const Color.fromARGB(
//                                                                     255,
//                                                                     80,
//                                                                     222,
//                                                                     85,
//                                                                   ),
//                                                                 ),
//                                                           ),
//                                                           onPressed:
//                                                               () =>
//                                                                   Navigator.pop(
//                                                                     ctx,
//                                                                   ),
//                                                           child: Text(
//                                                             'لا',
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                         TextButton(
//                                                           style: ButtonStyle(
//                                                             backgroundColor:
//                                                                 WidgetStatePropertyAll(
//                                                                   const Color.fromARGB(
//                                                                     255,
//                                                                     254,
//                                                                     91,
//                                                                     80,
//                                                                   ),
//                                                                 ),
//                                                           ),
//                                                           onPressed: () async {
//                                                             print(
//                                                               'سيتم حذف المناقصة',
//                                                             );
//                                                             print(
//                                                               "ID : ${tender.id}",
//                                                             );
//                                                             await TenderService.deleteTender(
//                                                               tender.id!,
//                                                             );
//                                                             print(
//                                                               'تم حذف المناقصة',
//                                                             );
//                                                             Navigator.pushReplacementNamed(
//                                                               context,
//                                                               '/tendersScreen',
//                                                             );
//                                                           },
//                                                           child: Text(
//                                                             'نعم',
//                                                             style: TextStyle(
//                                                               color:
//                                                                   Colors.black,
//                                                             ),
//                                                           ),
//                                                         ),
//                                                       ],
//                                                     ),
//                                               );
//                                             },
//                                             icon: Icon(Icons.delete),
//                                             label: Text('حذف المناقصة'),
//                                           )
//                                         else
//                                           SizedBox(),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
