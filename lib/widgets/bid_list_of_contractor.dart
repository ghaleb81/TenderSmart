import 'package:flutter/material.dart';
import 'package:tendersmart/widgets/add_bid.dart';
import 'package:tendersmart/models/Bid.dart';
import 'package:tendersmart/models/Tender.dart';
import 'package:tendersmart/services/bid_service.dart';

// import 'package:tendersmart/services/contractor_service.dart';
//🔵 استخدم ألوان مخصصة لبطاقات العروض
const _gradientStart = Color(0xFFe0f2fe);
const _gradientEnd = Color(0xFFf1f5f9);
final _primaryColor = Colors.indigo[800];

class BidListOfContractor extends StatefulWidget {
  const BidListOfContractor({super.key});

  @override
  State<BidListOfContractor> createState() => _BidListOfContractorState();
}

class _BidListOfContractorState extends State<BidListOfContractor> {
  late Future<List<Bid>> _bidsFuture;

  @override
  void initState() {
    super.initState();
    _bidsFuture = BidService.fetchPreviousBids();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFf8fafc),
        appBar: AppBar(
          backgroundColor: _primaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text('عروضي السابقة'),
          centerTitle: true,
        ),
        body: FutureBuilder<List<Bid>>(
          future: _bidsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('خطأ: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text('لا توجد عروض سابقة'));
            }

            final bids = snapshot.data!;

            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
              itemCount: bids.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final bid = bids[index];
                return _BidCard(bid: bid);
              },
            );
          },
        ),
      ),
    );
  }
}

class _BidCard extends StatelessWidget {
  const _BidCard({required this.bid});
  final Bid bid;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tender = bid.tenderBids!;

    return GestureDetector(
      onTap: () => _showTenderDetails(context, tender),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [_gradientStart, _gradientEnd],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.request_quote_rounded, color: _primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    tender.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _primaryColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.price_check,
                label: 'قيمة العرض',
                value: '${bid.bidAmount} ل.س',
              ),
              _InfoRow(
                icon: Icons.timelapse,
                label: 'مدة التنفيذ',
                value: '${bid.completionTime} يوم',
              ),
              _InfoRow(
                icon: Icons.check_circle_outline,
                label: 'المطابقة الفنية',
                value:
                    '${bid.technicalMatchedCount} / ${tender.numberOfTechnicalConditions}',
              ),
              if (bid.finalScore != null)
                _InfoRow(
                  icon: Icons.score,
                  label: 'النتيجة',
                  value: bid.finalScore.toString(),
                ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  onPressed: () => _showTenderDetails(context, bid.tenderBids!),
                  icon: const Icon(Icons.description_outlined),
                  label: const Text(
                    'تفاصيل المناقصة',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              if (tender.stateOfTender.name != 'مغلقة')
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit_note_rounded),
                    label: const Text('تعديل العرض'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _primaryColor,
                      side: BorderSide(color: _primaryColor!),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (_) => AddBid(
                                existingBid: bid,
                                contractorId: bid.contractorId,
                                tenderId: bid.tenderId,
                              ),
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: _primaryColor),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              '$label: ',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Text(value, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}

void _showTenderDetails(BuildContext context, Tender tender) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
    ),
    builder:
        (context) => DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.7,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          builder:
              (_, controller) => Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                  child: ListView(
                    controller: controller,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        tender.title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      _DetailTile(
                        icon: Icons.description,
                        label: 'الوصف',
                        value: tender.descripe,
                      ),
                      _DetailTile(
                        icon: Icons.location_on_outlined,
                        label: 'الموقع',
                        value: tender.location,
                      ),
                      _DetailTile(
                        icon: Icons.paid,
                        label: 'الميزانية',
                        value: '${tender.budget} ل.س',
                      ),
                      _DetailTile(
                        icon: Icons.timer,
                        label: 'مدة التنفيذ',
                        value: '${tender.implementationPeriod} يوم',
                      ),
                      _DetailTile(
                        icon: Icons.checklist_rtl,
                        label: 'الشروط الفنية',
                        value: tender.numberOfTechnicalConditions.toString(),
                      ),
                      _DetailTile(
                        icon: Icons.info_outline,
                        label: 'الحالة',
                        value: tender.stateOfTender.name,
                      ),
                      _DetailTile(
                        icon: Icons.calendar_month,
                        label: 'آخر موعد للتقديم',
                        value: tender.registrationDeadline.toString(),
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _primaryColor,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        onPressed: () => Navigator.pop(context),
                        child: const Text(
                          'إغلاق',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ),
  );
}

class _DetailTile extends StatelessWidget {
  const _DetailTile({
    required this.icon,
    required this.label,
    required this.value,
  });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 22, color: _primaryColor),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(height: 1.4),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// const _gradientStart = Color(0xFFe0f2fe); // الأزرق الفاتح
// const _gradientEnd = Color(0xFFf1f5f9); // الرمادي الفاتح
// final _primaryColor = Colors.indigo[800]; // أزرق رئيسي

// class BidListOfContractor extends StatefulWidget {
//   const BidListOfContractor({super.key});

//   @override
//   State<BidListOfContractor> createState() => _BidListOfContractorState();
// }

// class _BidListOfContractorState extends State<BidListOfContractor> {
//   late Future<List<Bid>> _bidsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _bidsFuture = BidService.fetchPreviousBids();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: const Color(0xFFf8fafc),
//         appBar: AppBar(
//           backgroundColor: _primaryColor,
//           foregroundColor: Colors.white,
//           elevation: 0,
//           title: const Text('عروضي السابقة'),
//           centerTitle: true,
//         ),
//         body: FutureBuilder<List<Bid>>(
//           future: _bidsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('خطأ: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('لا توجد عروض سابقة'));
//             }

//             final bids = snapshot.data!;

//             return ListView.separated(
//               padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
//               itemCount: bids.length,
//               separatorBuilder: (_, __) => const SizedBox(height: 12),
//               itemBuilder: (context, index) {
//                 final bid = bids[index];
//                 return _BidCard(bid: bid);
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

// //🌟 كرت عرض مُحسَّن بمظهر جذاب
// class _BidCard extends StatelessWidget {
//   const _BidCard({required this.bid});

//   final Bid bid;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return GestureDetector(
//       onTap: () => _showTenderDetails(context, bid.tenderBids!),
//       child: Container(
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [_gradientStart, _gradientEnd],
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 8,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Row(
//                 children: [
//                   Icon(Icons.request_quote_rounded, color: _primaryColor),
//                   const SizedBox(width: 8),
//                   Text(
//                     bid.tenderBids!.title,
//                     style: theme.textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                       color: _primaryColor,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 12),
//               _InfoRow(
//                 icon: Icons.price_check,
//                 label: 'قيمة العرض',
//                 value: '${bid.bidAmount} ل.س',
//               ),
//               _InfoRow(
//                 icon: Icons.timelapse,
//                 label: 'مدة التنفيذ',
//                 value: '${bid.completionTime} يوم',
//               ),
//               _InfoRow(
//                 icon: Icons.check_circle_outline,
//                 label: 'المطابقة الفنية',
//                 value:
//                     '${bid.technicalMatchedCount} / ${bid.tenderBids!.numberOfTechnicalConditions}',
//               ),
//               // _InfoRow(
//               //   icon: Icons.score,
//               //   label: 'النتيجة',
//               //   value: bid.finalBidScore.toString(),
//               // ),
//               const SizedBox(height: 16),
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton.icon(
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: _primaryColor,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     padding: const EdgeInsets.symmetric(vertical: 14),
//                   ),
//                   onPressed: () => _showTenderDetails(context, bid.tenderBids!),
//                   icon: const Icon(Icons.description_outlined),
//                   label: const Text(
//                     'تفاصيل المناقصة',
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// //🔍 صف معلومات صغيرة مع أيقونة
// class _InfoRow extends StatelessWidget {
//   const _InfoRow({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });
//   final IconData icon;
//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: _primaryColor),
//           const SizedBox(width: 6),
//           Expanded(
//             child: Text(
//               '$label: ',
//               style: theme.textTheme.bodyMedium?.copyWith(
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           Text(value, style: theme.textTheme.bodyMedium),
//         ],
//       ),
//     );
//   }
// }

// //🗂️ نافذة التفاصيل بمظهر عصري
// void _showTenderDetails(BuildContext context, Tender tender) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     backgroundColor: Colors.white,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
//     ),
//     builder:
//         (context) => DraggableScrollableSheet(
//           expand: false,
//           initialChildSize: 0.7,
//           maxChildSize: 0.9,
//           minChildSize: 0.5,
//           builder:
//               (_, controller) => Directionality(
//                 textDirection: TextDirection.rtl,
//                 child: Padding(
//                   padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
//                   child: ListView(
//                     controller: controller,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 4,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[300],
//                             borderRadius: BorderRadius.circular(2),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 16),
//                       Text(
//                         tender.title,
//                         style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: _primaryColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 20),
//                       _DetailTile(
//                         icon: Icons.description,
//                         label: 'الوصف',
//                         value: tender.descripe,
//                       ),
//                       _DetailTile(
//                         icon: Icons.location_on_outlined,
//                         label: 'الموقع',
//                         value: tender.location,
//                       ),
//                       _DetailTile(
//                         icon: Icons.paid,
//                         label: 'الميزانية',
//                         value: '${tender.budget} ل.س',
//                       ),
//                       _DetailTile(
//                         icon: Icons.timer,
//                         label: 'مدة التنفيذ',
//                         value: '${tender.implementationPeriod} يوم',
//                       ),
//                       _DetailTile(
//                         icon: Icons.checklist_rtl,
//                         label: 'الشروط الفنية',
//                         value: tender.numberOfTechnicalConditions.toString(),
//                       ),
//                       _DetailTile(
//                         icon: Icons.info_outline,
//                         label: 'الحالة',
//                         value: tender.stateOfTender.name,
//                       ),
//                       _DetailTile(
//                         icon: Icons.calendar_month,
//                         label: 'آخر موعد للتقديم',
//                         value: tender.registrationDeadline.toString(),
//                       ),
//                       const SizedBox(height: 32),
//                       ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: _primaryColor,
//                           minimumSize: const Size.fromHeight(48),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(14),
//                           ),
//                         ),
//                         onPressed: () => Navigator.pop(context),
//                         child: const Text(
//                           'إغلاق',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//         ),
//   );
// }

// class _DetailTile extends StatelessWidget {
//   const _DetailTile({
//     required this.icon,
//     required this.label,
//     required this.value,
//   });
//   final IconData icon;
//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Icon(icon, size: 22, color: _primaryColor),
//           const SizedBox(width: 10),
//           Expanded(
//             child: RichText(
//               text: TextSpan(
//                 style: Theme.of(
//                   context,
//                 ).textTheme.bodyMedium?.copyWith(height: 1.4),
//                 children: [
//                   TextSpan(
//                     text: '$label: ',
//                     style: const TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   TextSpan(text: value),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class BidListOfContractor extends StatefulWidget {
//   const BidListOfContractor({super.key});

//   @override
//   State<BidListOfContractor> createState() => _BidListOfContractorState();
// }

// class _BidListOfContractorState extends State<BidListOfContractor> {
//   late Future<List<Bid>> _bidsFuture;

//   @override
//   void initState() {
//     super.initState();
//     _bidsFuture = BidService.fetchPreviousBids();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('عروضي السابقة')),
//         body: FutureBuilder<List<Bid>>(
//           future: _bidsFuture,
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             } else if (snapshot.hasError) {
//               return Center(child: Text('خطأ: ${snapshot.error}'));
//             } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//               return const Center(child: Text('لا توجد عروض سابقة'));
//             }

//             final bids = snapshot.data!;

//             return ListView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: bids.length,
//               itemBuilder: (context, index) {
//                 final bid = bids[index];
//                 return Card(
//                   elevation: 4,
//                   margin: const EdgeInsets.symmetric(
//                     vertical: 8,
//                     horizontal: 4,
//                   ),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(15),
//                   ),
//                   child: Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Text('رقم العرض: ${bid.id}', style: const TextStyle(fontWeight: FontWeight.bold)),
//                         Text('المبلغ: ${bid.bidAmount}'),
//                         Text('مدة التنفيذ: ${bid.completionTimeExcepted} يوم'),
//                         Text(
//                           'العناصر المطابقة: ${bid.technicalMatchedCount} من ${bid.tenderBids!.numberOfTechnicalConditions}',
//                         ),
//                         Text('نتيجة التقييم: ${bid.finalBidScore}'),
//                         const SizedBox(height: 10),
//                         Align(
//                           alignment: Alignment.centerLeft,
//                           child: ElevatedButton(
//                             onPressed:
//                                 () =>
//                                     showTenderDetails(context, bid.tenderBids!),
//                             child: const Text('تفاصيل المناقصة'),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }

//   void showTenderDetails(BuildContext context, Tender tender) {
//     showModalBottomSheet(
//       context: context,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder:
//           (context) => Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: ListView(
//               shrinkWrap: true,
//               children: [
//                 Text(
//                   tender.title,
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Text('الوصف: ${tender.descripe}'),
//                 Text('الموقع: ${tender.location}'),
//                 Text('الميزانية التقديرية: ${tender.budget}'),
//                 Text(
//                   'مدة التنفيذ المتوقعة: ${tender.implementationPeriod} يوم',
//                 ),
//                 Text(
//                   'عدد الشروط الفنية: ${tender.numberOfTechnicalConditions}',
//                 ),
//                 Text('حالة المناقصة: ${tender.stateOfTender}'),
//                 Text('تاريخ الإغلاق: ${tender.registrationDeadline}'),
//               ],
//             ),
//           ),
//     );
//   }
// }
// class BidListOfContractor extends StatelessWidget {
//   const BidListOfContractor({super.key, required this.bids});

//   /// القائمة الجاهزة من العروض بعد جلبها من الباك‑إند
//   final List<Bid> bids;

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(title: const Text('عروضي السابقة'), centerTitle: true),
//         body:
//             bids.isEmpty
//                 ? const Center(child: Text('لا توجد عروض بعد'))
//                 : ListView.separated(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: bids.length,
//                   separatorBuilder: (_, __) => const SizedBox(height: 12),
//                   itemBuilder: (context, index) {
//                     final bid = bids[index];
//                     return _BidCard(bid: bid);
//                   },
//                 ),
//       ),
//     );
//   }
// }

// /// كرت مفرد لعرض تفاصيل مختصرة لكل عرض
// class _BidCard extends StatelessWidget {
//   const _BidCard({required this.bid});

//   final Bid bid;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//       child: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               'قيمة العرض: ${bid.bidAmount}',
//               style: theme.textTheme.titleMedium,
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 Expanded(
//                   child: Text(
//                     'مدة التنفيذ: ${bid.completionTimeExcepted} يوم',
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                 ),
//                 Expanded(
//                   child: Text(
//                     'المطابقة الفنية: ${bid.technicalMatchedCount} / 10',
//                     style: theme.textTheme.bodyMedium,
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 8),
//             Text(
//               'الدرجة النهائية: ${bid.finalBidScore}',
//               style: theme.textTheme.bodyMedium,
//             ),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               onPressed: () => _showTenderDetails(context, bid.tenderBids!),
//               icon: const Icon(Icons.description_outlined),
//               label: const Text('تفاصيل المناقصة'),
//               style: ElevatedButton.styleFrom(
//                 minimumSize: const Size.fromHeight(48),
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// /// نافذة منبثقة لعرض التفاصيل الكاملة للمناقصة
// void _showTenderDetails(BuildContext context, Tender tender) {
//   showModalBottomSheet(
//     context: context,
//     isScrollControlled: true,
//     shape: const RoundedRectangleBorder(
//       borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//     ),
//     builder: (context) {
//       final theme = Theme.of(context);
//       return Directionality(
//         textDirection: TextDirection.rtl,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
//           child: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Center(
//                   child: Container(
//                     width: 40,
//                     height: 4,
//                     margin: const EdgeInsets.only(bottom: 16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[400],
//                       borderRadius: BorderRadius.circular(2),
//                     ),
//                   ),
//                 ),
//                 Text(tender.title, style: theme.textTheme.titleLarge),
//                 const SizedBox(height: 12),
//                 _DetailRow(label: 'الوصف', value: tender.descripe),
//                 _DetailRow(label: 'الموقع', value: tender.location),
//                 _DetailRow(
//                   label: 'الميزانية التقديرية',
//                   value: '${tender.budget} ل.س',
//                 ),
//                 _DetailRow(
//                   label: 'مدة التنفيذ (يوم)',
//                   value: tender.implementationPeriod.toString(),
//                 ),
//                 // _DetailRow(
//                 //   label: 'آخر موعد للتقديم',
//                 //   value: tender.,
//                 // ),
//                 const SizedBox(height: 24),
//                 ElevatedButton(
//                   onPressed: () => Navigator.pop(context),
//                   style: ElevatedButton.styleFrom(
//                     minimumSize: const Size.fromHeight(48),
//                   ),
//                   child: const Text('إغلاق'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }

// /// صف صغير لعنصر عنوان + قيمة
// class _DetailRow extends StatelessWidget {
//   const _DetailRow({required this.label, required this.value});
//   final String label;
//   final String value;

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             '$label: ',
//             style: theme.textTheme.bodyMedium?.copyWith(
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Expanded(child: Text(value, style: theme.textTheme.bodyMedium)),
//         ],
//       ),
//     );
//   }
// }

// /// دالة مساعدة لتحويل الرد JSON إلى List<Bid>
// List<Bid> parseBids(String jsonResponse) {
//   final parsed = json.decode(jsonResponse) as List<dynamic>;
//   return parsed.map((e) => Bid.fromJson(e as Map<String, dynamic>)).toList();
// }

// import 'package:flutter/material.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/services/bid_service.dart';
// import 'package:tendersmart/services/contractor_service.dart';

// class BidListOfContractor extends StatefulWidget {
//   const BidListOfContractor({super.key});

//   @override
//   State<BidListOfContractor> createState() => _BidListOfContractorState();
// }

// class _BidListOfContractorState extends State<BidListOfContractor> {
//   late Future<List<Bid>> bidsFuture;
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     // loadUserRole();
//     bidsFuture = BidService.fetchPreviousBids();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('قائمة العروض')),
//       body: FutureBuilder<List<Bid>>(
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
//                       child: Text('تعديل العرض'),
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
//   // import 'package:flutter/material.dart';
//   // import 'package:tendersmart/mainScreen.dart';
//   // import 'package:tendersmart/models/Bid.dart';
//   // import 'package:tendersmart/tenders_list.dart';

//   // class BidList extends StatefulWidget {
//   //   BidList({super.key, this.bids});
//   //   List<Bid>? bids;
//   //   // final String currentUserRole;
//   //   @override
//   //   State<BidList> createState() => _BidListState();
//   // }

//   // class _BidListState extends State<BidList> {
//   //   @override
//   //   Widget build(BuildContext context) {
//   //     return
//   //   }
//   // @override

//   // Widget build(BuildContext context) {
//   //   return
//   //   Scaffold(
//   //     appBar: AppBar(
//   //       backgroundColor: Colors.blue,
//   //       centerTitle: true,
//   //       title: Text('قائمة العروض'),
//   //       actions: [
//   //         IconButton(
//   //           onPressed: () => Navigator.pop(context),
//   //           icon: Icon(Icons.keyboard_arrow_right),
//   //         ),
//   //       ],
//   //     ),
//   //     drawer: Drawer(
//   //       child: ListView(
//   //         padding: EdgeInsets.zero,
//   //         children: [
//   //           DrawerHeader(
//   //             decoration: BoxDecoration(color: Colors.blue),
//   //             child: Text(
//   //               'مرحباً بك',
//   //               style: TextStyle(color: Colors.white, fontSize: 24),
//   //             ),
//   //           ),
//   //           ListTile(
//   //             leading: Icon(Icons.home),
//   //             title: Text('الصفحة الرئيسية'),
//   //             onTap: () {
//   //               TenderListPage;
//   //               // Navigator.pop(context);
//   //             },
//   //           ),
//   //           if (widget.currentUserRole == 'admin')
//   //             ListTile(
//   //               leading: Icon(Icons.home),
//   //               title: Text('التقييم الذكي'),
//   //               onTap: () {
//   //                 Navigator.pop(context);
//   //               },
//   //             )
//   //           else
//   //             SizedBox(),
//   //           if (widget.currentUserRole == 'admin')
//   //             ListTile(
//   //               leading: Icon(Icons.home),
//   //               title: Text('التقييم اليدوي'),
//   //               onTap: () {
//   //                 Navigator.pop(context);
//   //               },
//   //             )
//   //           else
//   //             SizedBox(),
//   //           // OutlinedButton(
//   //           //   onPressed: () {},
//   //           //   child: Text('التقييم بإستخدام الذكاء الاصطناعي'),
//   //           // ),
//   //           // OutlinedButton(onPressed: () {}, child: Text('التقييم اليدوي')),
//   //           ListTile(
//   //             leading: Icon(Icons.person),
//   //             title: Text('الملف الشخصي'),
//   //             onTap: () {
//   //               Navigator.pop(context);
//   //             },
//   //           ),
//   //         ],
//   //       ),
//   //     ),
//   //     body: ListView.builder(
//   //       itemCount: widget.bids!.length,
//   //       itemBuilder: (context, index) {
//   //         final bid = widget.bids![index];
//   //         return Expanded(
//   //           child: Card(
//   //             color: Colors.blue[200],
//   //             margin: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//   //             elevation: 4,
//   //             shape: RoundedRectangleBorder(
//   //               borderRadius: BorderRadius.circular(12),
//   //             ),
//   //             child: Padding(
//   //               padding: const EdgeInsets.all(16.0),
//   //               child: Column(
//   //                 children: [
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: [
//   //                       Text(
//   //                         'S.P${bid.bidAmount}',
//   //                         style: TextStyle(
//   //                           fontSize: 18,
//   //                           // fontWeight: FontWeight.bold,
//   //                         ),
//   //                       ),
//   //                       Text(
//   //                         ': الميزانية المقدمة من قبل المورد_',
//   //                         style: TextStyle(
//   //                           fontSize: 18,
//   //                           // fontWeight: FontWeight.bold,
//   //                         ),
//   //                       ),
//   //                       Text(
//   //                         '${index + 1}',
//   //                         style: TextStyle(
//   //                           fontSize: 18,
//   //                           // fontWeight: FontWeight.bold,
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: [
//   //                       Text(
//   //                         textAlign: TextAlign.center,
//   //                         " ${bid.completionTimeExcepted}",
//   //                         softWrap: true,
//   //                         overflow: TextOverflow.visible,
//   //                       ),
//   //                       Text(
//   //                         textAlign: TextAlign.center,
//   //                         ": وقت التنفيذ للمقاول",
//   //                         softWrap: true,
//   //                         overflow: TextOverflow.visible,
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   Row(
//   //                     mainAxisAlignment: MainAxisAlignment.center,
//   //                     children: [
//   //                       Text(
//   //                         textAlign: TextAlign.center,
//   //                         " ${bid.technicalMatchedCount}",
//   //                         softWrap: true,
//   //                         overflow: TextOverflow.visible,
//   //                       ),
//   //                       Text(
//   //                         textAlign: TextAlign.center,
//   //                         ": عدد الشروط الفنية الطابقة",
//   //                         softWrap: true,
//   //                         overflow: TextOverflow.visible,
//   //                       ),
//   //                     ],
//   //                   ),
//   //                   Row(children: [

//   //                     ],
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           ),
//   //         );
//   //       },
//   //     ),
//   //   );
//   // }
//   // }
// }
