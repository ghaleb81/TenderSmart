class Bid {
  final double bidAmount;
  final int completionTimeExcepted;
  final int technicalMatchedCount;

  Bid({
    required this.bidAmount,
    required this.completionTimeExcepted,
    required this.technicalMatchedCount,
  });
  factory Bid.fromJson(Map<String, dynamic> json) {
    return Bid(
      bidAmount: json['bid_amount'],
      completionTimeExcepted: json['completion_time'],
      technicalMatchedCount: json['technical_matched_count'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'bid_amount': bidAmount,
      'completion_time': completionTimeExcepted,
      'technical_matched_count': technicalMatchedCount,
    };
  }
}
