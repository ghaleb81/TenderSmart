// import 'dart:io';

// import 'package:tendersmart/models/Tender.dart';

// class Bid {
//   final int? contractorId; // contractor_id
//   final int tenderId; // tender_id
//   final double bidAmount; // bid_amount
//   final int completionTime; // completion_time
//   final int technicalMatchedCount; // technical_matched_count
//   final File? technicalProposalPdf; // technical_proposal_pdf
//   Tender? tenderBids;
//   final double? finalScore;
//   Bid({
//     required this.tenderId,
//     this.contractorId,
//     required this.bidAmount,
//     required this.completionTime,
//     required this.technicalMatchedCount,
//     this.finalScore,
//     this.tenderBids,
//     this.technicalProposalPdf,
//   });
//   // factory Bid.fromJson(Map<String, dynamic> json) {
//   //   return Bid(
//   //     // contractorId: json['contractor_id']?.toString(),
//   //     tenderId: json['tender_id'],
//   //     // bidAmount: (json['bid_amount'] as num?)?.toDouble() ?? 0.0,
//   //     bidAmount: json['bid_amount'] ?? 0.0,
//   //     completionTimeExcepted: json['completion_time'] ?? 0,
//   //     technicalMatchedCount: json['technical_matched_count'] ?? 0,
//   //     finalBidScore: json['final_bid_score'] ?? 0.0,
//   //     // finalBidScore: (json['final_bid_score'] as num?)?.toDouble(),
//   //     // tenderBids:
//   //     //     json['tender'] != null ? Tender.fromJson(json['tender']) : null,
//   //   );
//   // }
//   factory Bid.fromJson(Map<String, dynamic> json) => Bid(
//     // id: json['id'],
//     tenderId: json['tender_id'],
//     contractorId: json['contractor_id'],
//     bidAmount:
//         double.tryParse(json['bid_amount'].toString()) ??
//         0.0, //double.parse(json['bid_amount']),
//     completionTime: json['completion_time'],
//     technicalMatchedCount: json['technical_matched_count'],
//     finalScore: double.tryParse(json['final_bid_score'].toString()) ?? 0.0,
//     tenderBids: Tender.fromJson(json['tender']),
//   );

//   // Map<String, dynamic> toJson() {
//   //   return {
//   //     'contractor_id': contractorId,
//   //     'tender_id': tenderId,
//   //     'bid_amount': bidAmount,
//   //     'completion_time': completionTimeExcepted,
//   //     'technical_matched_count': technicalMatchedCount,
//   //     // 'final_bid_score': finalBidScore,
//   //     // 'tender': tenderBids?.toJson(),
//   //   };
//   // }
//   Map<String, String> toJson() => {
//     'contractor_id': contractorId.toString(),
//     'tender_id': tenderId.toString(),
//     'bid_amount': bidAmount.toStringAsFixed(2),
//     'completion_time': completionTime.toString(),
//     'technical_matched_count': technicalMatchedCount.toString(),
//   };
// }

// //   factory Bid.fromJson(Map<String, dynamic> json) {
// //     return Bid(
// //       contractorId: json['contractor_id'] ?? '',
// //       tenderId: json['tender_id'] ?? '',
// //       bidAmount: json['bid_amount'] ?? '',
// //       completionTimeExcepted: json['completion_time'] ?? '',
// //       technicalMatchedCount: json['technical_matched_count'] ?? '',
// //       tender_bids: json['']??''
// //     );
// //   }
// //   Map<String, dynamic> toJson() {
// //     return {
// //       'contractor_id': contractorId,
// //       'tender_id': tenderId,
// //       'bid_amount': bidAmount,
// //       'completion_time': completionTimeExcepted,
// //       'technical_matched_count': technicalMatchedCount,
// //     };
// //   }
// // }
import 'package:tendersmart/models/Tender.dart';

class Bid {
  final int? id;
  final int? contractorId; // contractor_id
  final int tenderId; // tender_id
  final double bidAmount; // bid_amount
  final int completionTime; // completion_time
  final int technicalMatchedCount; // technical_matched_count
  final String? technicalProposalPdf; // مسار ملف PDF كنص
  Tender? tenderBids;
  final double? finalScore;
  final double? predictedScore;

  Bid({
    this.id,
    required this.tenderId,
    this.contractorId,
    required this.bidAmount,
    required this.completionTime,
    required this.technicalMatchedCount,
    this.finalScore,
    this.tenderBids,
    this.technicalProposalPdf,
    this.predictedScore,
  });

  factory Bid.fromJson(Map<String, dynamic> json) => Bid(
    id: json['id'] ?? 0,
    tenderId: json['tender_id'] ?? 0,
    contractorId: json['contractor_id'],
    bidAmount: double.tryParse(json['bid_amount'].toString()) ?? 0.0,
    completionTime: json['completion_time'] ?? 0,
    technicalMatchedCount: json['technical_matched_count'] ?? 0,
    finalScore:
        json['final_bid_score'] != null
            ? double.tryParse(json['final_bid_score'].toString())
            : null,
    tenderBids: json['tender'] != null ? Tender.fromJson(json['tender']) : null,
    technicalProposalPdf: json['technical_proposal_pdf'],
    predictedScore: double.tryParse(json['bid_amount'].toString()) ?? 0.0,
  );

  Map<String, dynamic> toJson() => {
    'contractor_id': contractorId,
    'tender_id': tenderId,
    'bid_amount': bidAmount,
    'completion_time': completionTime,
    'technical_matched_count': technicalMatchedCount,
    'final_bid_score': finalScore,
    'technical_proposal_pdf': technicalProposalPdf,
    // إذا أردت تضمين tender:
    // 'tender': tenderBids?.toJson(),
  };
}
