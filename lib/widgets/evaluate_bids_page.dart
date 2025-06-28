// import 'dart:convert';
// import 'package:flutter/material.dart';
// import '../services/bid_service.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../services/bid_service.dart';
import '../../models/Bid.dart'; // تأكد أن ملف Bid يحتوي على toJson

// class EvaluateBidsPage extends StatefulWidget {
//   final int tenderId;
//   final List<Bid> bids;

//   const EvaluateBidsPage({
//     super.key,
//     required this.tenderId,
//     required this.bids,
//   });

//   @override
//   State<EvaluateBidsPage> createState() => _EvaluateBidsPageState();
// }

// class _EvaluateBidsPageState extends State<EvaluateBidsPage> {
//   bool _sendingWinner = false;
//   List<Map<String, dynamic>> _bids = [];
//   int? _winnerBidId;

//   @override
//   void initState() {
//     super.initState();
//     _loadLocalBids();
//   }

//   void _loadLocalBids() {
//     _bids =
//         widget.bids.map((bid) {
//           return {
//             'id': bid.id,
//             'contractor_id': bid.contractorId,
//             'predicted_score': bid.predictedScore ?? 0.0,
//             'technicalMatchedCount': bid.technicalMatchedCount ?? 0,
//             'bidAmount': bid.bidAmount ?? 0,
//             'completionTime': bid.completionTime ?? 0,
//           };
//         }).toList();

//     final winnerBid = widget.bids.firstWhere(
//       (b) => b.id == widget.bids.map((b) => b.id).reduce((a, b) => a ?? b),
//       orElse: () => widget.bids.first,
//     );
//     _winnerBidId = winnerBid.id;
//   }

//   Future<void> _setManualWinner(int bidId) async {
//     setState(() => _sendingWinner = true);
//     try {
//       await BidService.selectWinningBid(widget.tenderId, bidId);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم اختيار العرض الفائز بنجاح')),
//       );
//       Navigator.pop(context, bidId);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ أثناء الحفظ: $e')));
//     } finally {
//       if (mounted) setState(() => _sendingWinner = false);
//     }
//   }

//   Widget _buildBidCard(Map<String, dynamic> bid) {
//     final isWinner = bid['id'] == _winnerBidId;
//     return InkWell(
//       onTap: _sendingWinner ? null : () => _setManualWinner(bid['id']),
//       borderRadius: BorderRadius.circular(12),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 'مقاول رقم: ${bid['contractor_id']}',
//                 style: const TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 4),
//               Text(
//                 'الدرجة: ${(bid['predicted_score'] as double).toStringAsFixed(2)}',
//               ),
//               Text('الشروط المطابقة: ${bid['technicalMatchedCount']}'),
//               Text('السعر: ${bid['bidAmount']} ل.س'),
//               Text('مدة التنفيذ: ${bid['completionTime']} يوم'),
//               if (isWinner)
//                 const Align(
//                   alignment: Alignment.centerLeft,
//                   child: Icon(Icons.emoji_events, color: Colors.amber),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//           backgroundColor: Colors.indigo,
//           title: const Text(
//             'اختر العرض الفائز ',
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
//         body: Stack(
//           children: [
//             if (_bids.isEmpty)
//               const Center(child: Text('لا توجد عروض حالياً'))
//             else
//               ListView.builder(
//                 padding: const EdgeInsets.only(top: 12, bottom: 90),
//                 itemCount: _bids.length,
//                 itemBuilder: (context, i) => _buildBidCard(_bids[i]),
//               ),
//             if (_sendingWinner)
//               Container(
//                 color: Colors.black38,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class EvaluateBidsPage extends StatefulWidget {
  final int tenderId;
  final List<Bid> bids;

  const EvaluateBidsPage({
    super.key,
    required this.tenderId,
    required this.bids,
  });

  @override
  State<EvaluateBidsPage> createState() => _EvaluateBidsPageState();
}

class _EvaluateBidsPageState extends State<EvaluateBidsPage> {
  bool _sendingWinner = false;
  List<Map<String, dynamic>> _bids = [];
  int? _winnerBidId;

  @override
  void initState() {
    super.initState();
    _loadLocalBids();
  }

  void _loadLocalBids() {
    _bids =
        widget.bids.map((bid) {
          return {
            'id': bid.id,
            'contractor_id': bid.contractorId,
            'predicted_score': bid.predictedScore ?? 0.0,
            'technicalMatchedCount': bid.technicalMatchedCount,
            'bidAmount': bid.bidAmount,
            'completionTime': bid.completionTime,
          };
        }).toList();

    final winnerBid = widget.bids.firstWhere(
      (b) => b.id == widget.bids.map((b) => b.id).reduce((a, b) => a ?? b),
      orElse: () => widget.bids.first,
    );
    _winnerBidId = winnerBid.id;
  }

  Future<void> _setManualWinner(int bidId) async {
    setState(() => _sendingWinner = true);
    try {
      await BidService.selectWinningBid(widget.tenderId, bidId);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم اختيار العرض الفائز بنجاح')),
      );
      Navigator.pushReplacementNamed(context, 'tendersScreen');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('خطأ أثناء الحفظ: $e')));
    } finally {
      if (mounted) setState(() => _sendingWinner = false);
    }
  }

  Widget _buildBidCard(Map<String, dynamic> bid) {
    final isWinner = bid['id'] == _winnerBidId;
    return InkWell(
      onTap: _sendingWinner ? null : () => _setManualWinner(bid['id']),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'مقاول رقم: ${bid['contractor_id']}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              // Text(
              //   'الدرجة: ${(bid['predicted_score'] as double).toStringAsFixed(2)}',
              // ),
              Text('الشروط المطابقة: ${bid['technicalMatchedCount']}'),
              Text('السعر: ${bid['bidAmount']} ل.س'),
              Text('مدة التنفيذ: ${bid['completionTime']} يوم'),
              if (isWinner)
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Icon(Icons.emoji_events, color: Colors.amber),
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.indigo,
          title: const Text(
            'اختر العرض الفائز ',
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
        body: Stack(
          children: [
            if (_bids.isEmpty)
              const Center(child: Text('لا توجد عروض حالياً'))
            else
              ListView.builder(
                padding: const EdgeInsets.only(top: 12, bottom: 90),
                itemCount: _bids.length,
                itemBuilder: (context, i) => _buildBidCard(_bids[i]),
              ),
            if (_sendingWinner)
              Container(
                color: Colors.black38,
                child: const Center(child: CircularProgressIndicator()),
              ),
          ],
        ),
      ),
    );
  }
}
// class EvaluateBidsPage extends StatefulWidget {
//   final int tenderId;
//   final List<Bid> bids;

//   const EvaluateBidsPage({
//     super.key,
//     required this.tenderId,
//     required this.bids,
//   });

//   @override
//   State<EvaluateBidsPage> createState() => _EvaluateBidsPageState();
// }

// class _EvaluateBidsPageState extends State<EvaluateBidsPage> {
//   bool _sendingWinner = false;
//   List<Map<String, dynamic>> _bids = [];
//   int? _winnerBidId;

//   @override
//   void initState() {
//     super.initState();
//     _loadLocalBids();
//   }

//   void _loadLocalBids() {
//     _bids =
//         widget.bids.map((bid) {
//           return {
//             'id': bid.id,
//             'contractor_id': bid.contractorId,
//             'predicted_score': bid.predictedScore ?? 0.0,
//           };
//         }).toList();
//     final winnerBid = widget.bids.firstWhere(
//       (b) => b.id == widget.bids.map((b) => b.id).reduce((a, b) => a ?? b),
//       orElse: () => widget.bids.first,
//     );
//     _winnerBidId = winnerBid.id;

//     // _winnerBidId = widget.bids.firstWhere(
//     //   (b) => b.isWinner == true,
//     //   orElse: () => widget.bids.first,
//     // ).id;
//   }

//   Future<void> _setManualWinner(int bidId) async {
//     setState(() => _sendingWinner = true);
//     try {
//       await BidService.selectWinningBid(widget.tenderId, bidId);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم اختيار العرض الفائز بنجاح')),
//       );
//       Navigator.pop(context, bidId);
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ أثناء الحفظ: $e')));
//     } finally {
//       if (mounted) setState(() => _sendingWinner = false);
//     }
//   }

//   Widget _buildBidCard(Map<String, dynamic> bid) {
//     final isWinner = bid['id'] == _winnerBidId;
//     return InkWell(
//       onTap: _sendingWinner ? null : () => _setManualWinner(bid['id']),
//       borderRadius: BorderRadius.circular(12),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         child: ListTile(
//           title: Text('مقاول رقم: ${bid['contractor_id']}'),
//           subtitle: Text(
//             'الدرجة: ${(bid['predicted_score'] as double).toStringAsFixed(2)}',
//           ),
//           trailing:
//               isWinner
//                   ? const Icon(Icons.emoji_events, color: Colors.amber)
//                   : null,
//         ),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final indigo = Colors.indigo[800];

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         backgroundColor: Colors.grey.shade100,
//         appBar: AppBar(
//           backgroundColor: Colors.indigo,
//           title: const Text(
//             'اختر العرض الفائز ',
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
//         // appBar: AppBar(
//         //   title: const Text('اختر العرض الفائز'),
//         //   centerTitle: true,
//         //   backgroundColor: indigo,
//         // ),
//         body: Stack(
//           children: [
//             if (_bids.isEmpty)
//               const Center(child: Text('لا توجد عروض حالياً'))
//             else
//               ListView.builder(
//                 padding: const EdgeInsets.only(top: 12, bottom: 90),
//                 itemCount: _bids.length,
//                 itemBuilder: (context, i) => _buildBidCard(_bids[i]),
//               ),
//             if (_sendingWinner)
//               Container(
//                 color: Colors.black38,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
// class EvaluateBidsPage extends StatefulWidget {
//   final int tenderId;
//   final List<Bid>? bids; // استقبال العروض إذا كانت متوفرة

//   const EvaluateBidsPage({super.key, required this.tenderId, this.bids});

//   @override
//   State<EvaluateBidsPage> createState() => _EvaluateBidsPageState();
// }

// class _EvaluateBidsPageState extends State<EvaluateBidsPage> {
//   bool _loadingEvaluation = true;
//   bool _sendingWinner = false;
//   List<dynamic> _bids = [];
//   int? _winnerBidId;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     if (widget.bids != null) {
//       // إذا تم تمرير العروض، استخدمها مباشرة
//       _bids =
//           widget.bids!
//               .map(
//                 (bid) => {
//                   'id': bid.id,
//                   'contractor_id': bid.contractorId,
//                   'predicted_score': bid.predictedScore ?? 0.0,
//                 },
//               )
//               .toList();
//       _loadingEvaluation = false;
//     } else {
//       _evaluateBids(); // خلاف ذلك، جلب من السيرفر
//     }
//   }

//   /* جلب تقييم العروض من السيرفر */
//   Future<void> _evaluateBids() async {
//     setState(() {
//       _loadingEvaluation = true;
//       _errorMessage = null;
//     });

//     final result = await BidService.evaluateBids(widget.tenderId);

//     if (result['success'] == true) {
//       setState(() {
//         _bids = result['bids'];
//         _winnerBidId = result['winnerBidId'];
//       });
//     } else {
//       setState(() {
//         _errorMessage = result['message'] ?? 'تعذّر جلب البيانات';
//       });
//     }
//     setState(() => _loadingEvaluation = false);
//   }

//   /* إرسال العرض الفائز يدويًا */
//   Future<void> _setManualWinner(int bidId) async {
//     setState(() => _sendingWinner = true);
//     try {
//       await BidService.selectWinningBid(widget.tenderId, bidId);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم اختيار العرض الفائز بنجاح')),
//       );
//       Navigator.pop(context, bidId); // رجوع إلى BidList
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ أثناء الحفظ: $e')));
//     } finally {
//       if (mounted) setState(() => _sendingWinner = false);
//     }
//   }

//   /* بطاقة العرض */
//   Widget _buildBidCard(Map<String, dynamic> bid) {
//     final isWinner = bid['id'] == _winnerBidId;
//     return InkWell(
//       onTap: _sendingWinner ? null : () => _setManualWinner(bid['id']),
//       borderRadius: BorderRadius.circular(12),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         child: ListTile(
//           title: Text('مقاول رقم: ${bid['contractor_id']}'),
//           subtitle: Text(
//             'الدرجة: ${bid['predicted_score'].toStringAsFixed(2)}',
//           ),
//           trailing:
//               isWinner
//                   ? const Icon(Icons.emoji_events, color: Colors.amber)
//                   : null,
//         ),
//       ),
//     );
//   }

//   /* واجهة الصفحة */
//   @override
//   Widget build(BuildContext context) {
//     final indigo = Colors.indigo[800];

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('اختر العرض الفائز'),
//           centerTitle: true,
//           backgroundColor: indigo,
//         ),
//         body: Stack(
//           children: [
//             if (_loadingEvaluation)
//               const Center(child: CircularProgressIndicator())
//             else if (_errorMessage != null)
//               Center(
//                 child: Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               )
//             else if (_bids.isEmpty)
//               const Center(child: Text('لا توجد عروض حالياً'))
//             else
//               ListView.builder(
//                 padding: const EdgeInsets.only(top: 12, bottom: 90),
//                 itemCount: _bids.length,
//                 itemBuilder: (context, i) => _buildBidCard(_bids[i]),
//               ),
//             if (_sendingWinner)
//               Container(
//                 color: Colors.black38,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// class EvaluateBidsPage extends StatefulWidget {
//   final int tenderId;
//   const EvaluateBidsPage({super.key, required this.tenderId});

//   @override
//   State<EvaluateBidsPage> createState() => _EvaluateBidsPageState();
// }

// class _EvaluateBidsPageState extends State<EvaluateBidsPage> {
//   bool _loadingEvaluation = true; // ينتظر التقييم الآلي
//   bool _sendingWinner = false; // عند إرسال الفائز يدويًا
//   List<dynamic> _bids = [];
//   int? _winnerBidId;
//   String? _errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     _evaluateBids(); // يبدأ التقييم تلقائيًا
//   }

//   /* ❶ جلب تقييم العروض من السيرفر */
//   Future<void> _evaluateBids() async {
//     setState(() {
//       _loadingEvaluation = true;
//       _errorMessage = null;
//     });

//     final result = await BidService.evaluateBids(widget.tenderId);

//     if (result['success'] == true) {
//       setState(() {
//         _bids = result['bids'];
//         _winnerBidId = result['winnerBidId'];
//       });
//     } else {
//       setState(() {
//         _errorMessage = result['message'] ?? 'تعذّر جلب البيانات';
//       });
//     }
//     setState(() => _loadingEvaluation = false);
//   }

//   /* ❷ إرسال العرض الفائز يدويًا */
//   Future<void> _setManualWinner(int bidId) async {
//     setState(() => _sendingWinner = true);
//     try {
//       await BidService.selectWinningBid(widget.tenderId, bidId);
//       if (!mounted) return;
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('تم اختيار العرض الفائز بنجاح')),
//       );
//       Navigator.pop(context, bidId); // رجوع إلى BidList
//     } catch (e) {
//       if (!mounted) return;
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('خطأ أثناء الحفظ: $e')));
//     } finally {
//       if (mounted) setState(() => _sendingWinner = false);
//     }
//   }

//   /* ❸ بطاقة العرض مع InkWell */
//   Widget _buildBidCard(Map<String, dynamic> bid) {
//     final isWinner = bid['id'] == _winnerBidId;
//     return InkWell(
//       onTap: _sendingWinner ? null : () => _setManualWinner(bid['id']),
//       borderRadius: BorderRadius.circular(12),
//       child: Card(
//         margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//         child: ListTile(
//           title: Text('مقاول رقم: ${bid['contractor_id']}'),
//           subtitle: Text(
//             'الدرجة: ${bid['predicted_score'].toStringAsFixed(2)}',
//           ),
//           trailing:
//               isWinner
//                   ? const Icon(Icons.emoji_events, color: Colors.amber)
//                   : null,
//         ),
//       ),
//     );
//   }

//   /* ❹ واجهة الصفحة */
//   @override
//   Widget build(BuildContext context) {
//     final indigo = Colors.indigo[800];

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('اختر العرض الفائز'),
//           centerTitle: true,
//           backgroundColor: indigo,
//         ),
//         body: Stack(
//           children: [
//             if (_loadingEvaluation)
//               const Center(child: CircularProgressIndicator())
//             else if (_errorMessage != null)
//               Center(
//                 child: Text(
//                   _errorMessage!,
//                   style: const TextStyle(color: Colors.red),
//                 ),
//               )
//             else if (_bids.isEmpty)
//               const Center(child: Text('لا توجد عروض حالياً'))
//             else
//               ListView.builder(
//                 padding: const EdgeInsets.only(top: 12, bottom: 90),
//                 itemCount: _bids.length,
//                 itemBuilder: (context, i) => _buildBidCard(_bids[i]),
//               ),
//             if (_sendingWinner)
//               Container(
//                 color: Colors.black38,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:tendersmart/models/Bid.dart';
// import 'package:tendersmart/services/bid_service.dart';

// class EvaluateBidsPage extends StatefulWidget {
//   final int tenderId;
//   const EvaluateBidsPage({super.key, required this.tenderId});

//   @override
//   State<EvaluateBidsPage> createState() => _EvaluateBidsPageState();
// }

// class _EvaluateBidsPageState extends State<EvaluateBidsPage> {
//   late Future<List<Bid>> _futureBids;
//   bool _isLoading = false;

//   @override
//   void initState() {
//     super.initState();
//     _futureBids = BidService.fetchBids(widget.tenderId);
//   }

//   // void _selectWinner(Bid bid) async {
//   //   setState(() {
//   //     _isLoading = true;
//   //   });
//   //   try {
//   //     await BidService.(,bid.id); // دالة في السيرفيس ترسل العرض الفائز
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('تم اختيار العرض رقم ${bid.id} كفائز')),
//   //     );
//   //     Navigator.pop(context); // ارجع للصفحة السابقة بعد الاختيار
//   //   } catch (e) {
//   //     ScaffoldMessenger.of(context).showSnackBar(
//   //       SnackBar(content: Text('حدث خطأ أثناء اختيار العرض: $e')),
//   //     );
//   //   } finally {
//   //     setState(() {
//   //       _isLoading = false;
//   //     });
//   //   }
//   // }

//   void _selectWinner(Bid bid) async {
//     setState(() {
//       _isLoading = true;
//     });
//     try {
//       await BidService.selectWinningBid(widget.tenderId, bid.id!);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('تم اختيار العرض رقم ${bid.id} كفائز')),
//       );
//       Navigator.pop(context);
//     } catch (e) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء اختيار العرض: $e')));
//     } finally {
//       setState(() {
//         _isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final scheme = Theme.of(context).colorScheme;

//     return Directionality(
//       textDirection: TextDirection.rtl,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text('اختر العرض الفائز'),
//           centerTitle: true,
//           backgroundColor: scheme.primary,
//         ),
//         body: Stack(
//           children: [
//             FutureBuilder<List<Bid>>(
//               future: _futureBids,
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return const Center(child: CircularProgressIndicator());
//                 }
//                 if (snapshot.hasError) {
//                   return Center(child: Text('حدث خطأ: ${snapshot.error}'));
//                 }
//                 final bids = snapshot.data ?? [];
//                 if (bids.isEmpty) {
//                   return const Center(child: Text('لا توجد عروض حالياً'));
//                 }

//                 return ListView.builder(
//                   padding: const EdgeInsets.all(16),
//                   itemCount: bids.length,
//                   itemBuilder: (context, index) {
//                     final bid = bids[index];
//                     return InkWell(
//                       onTap: () => _selectWinner(bid),
//                       borderRadius: BorderRadius.circular(16),
//                       child: Container(
//                         margin: const EdgeInsets.only(bottom: 16),
//                         padding: const EdgeInsets.all(16),
//                         decoration: BoxDecoration(
//                           color: scheme.surface,
//                           borderRadius: BorderRadius.circular(16),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.05),
//                               blurRadius: 6,
//                               offset: const Offset(0, 3),
//                             ),
//                           ],
//                         ),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               'رقم المقاول: ${bid.contractorId}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: scheme.onSurface,
//                               ),
//                             ),
//                             const SizedBox(height: 8),
//                             Text(
//                               'السعر: ${bid.bidAmount} ل.س',
//                               style: TextStyle(color: scheme.onSurface),
//                             ),
//                             Text(
//                               'مدة التنفيذ: ${bid.completionTime} يوم',
//                               style: TextStyle(color: scheme.onSurface),
//                             ),
//                             Text(
//                               'التطابق الفني: ${bid.technicalMatchedCount}',
//                               style: TextStyle(color: scheme.onSurface),
//                             ),
//                           ],
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               },
//             ),
//             if (_isLoading)
//               Container(
//                 color: Colors.black45,
//                 child: const Center(child: CircularProgressIndicator()),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import '../services/bid_service.dart';

// class EvaluateBidsPage extends StatefulWidget {
//   final int tenderId;
//   const EvaluateBidsPage({super.key, required this.tenderId});

//   @override
//   State<EvaluateBidsPage> createState() => _EvaluateBidsPageState();
// }

// class _EvaluateBidsPageState extends State<EvaluateBidsPage> {
//   bool isLoading = false;
//   List<dynamic> bids = [];
//   int? winnerBidId;
//   String? errorMessage;

//   Future<void> evaluateBids() async {
//     setState(() {
//       isLoading = true;
//       errorMessage = null;
//     });

//     final result = await BidService.evaluateBids(widget.tenderId);

//     if (result['success'] == true) {
//       setState(() {
//         bids = result['bids'];
//         winnerBidId = result['winnerBidId'];
//       });
//     } else {
//       setState(() {
//         errorMessage = result['message'];
//       });
//     }

//     setState(() {
//       isLoading = false;
//     });
//   }

//   Widget buildBidCard(Map<String, dynamic> bid) {
//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
//       child: ListTile(
//         title: Text('مقاول رقم: ${bid['contractor_id']}'),
//         subtitle: Text('الدرجة: ${bid['predicted_score'].toStringAsFixed(2)}'),
//         trailing:
//             bid['id'] == winnerBidId
//                 ? const Icon(Icons.emoji_events, color: Colors.amber)
//                 : null,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('تقييم العروض')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             ElevatedButton(
//               onPressed: isLoading ? null : evaluateBids,
//               child: const Text('تقييم العروض الآن'),
//             ),
//             const SizedBox(height: 16),
//             if (isLoading) const Center(child: CircularProgressIndicator()),
//             if (errorMessage != null)
//               Text(errorMessage!, style: const TextStyle(color: Colors.red)),
//             if (bids.isNotEmpty)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: bids.length,
//                   itemBuilder: (context, index) => buildBidCard(bids[index]),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
// }
