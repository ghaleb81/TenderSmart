class Bid {
  final String tenderId;
  final String? contractorId;
  final double bidAmount;
  final int completionTimeExcepted;
  final int technicalMatchedCount;
  final double? finalBidScore;

  Bid({
    required this.tenderId,
    this.contractorId,
    required this.bidAmount,
    required this.completionTimeExcepted,
    required this.technicalMatchedCount,
    this.finalBidScore,
  });
  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      tenderId: json['tender_id'],
      bidAmount: json['bid_amount'],
      completionTimeExcepted: json['completion_time'],
      technicalMatchedCount: json['technical_matched_count'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'contractor_id': contractorId,
      'tender_id': tenderId,
      'bid_amount': bidAmount,
      'completion_time': completionTimeExcepted,
      'technical_matched_count': technicalMatchedCount,
    };
  }
}
