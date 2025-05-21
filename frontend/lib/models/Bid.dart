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
      bidAmount: json['bidAmount'],
      completionTimeExcepted: json['completionTimeExcepted'],
      technicalMatchedCount: json['technicalMatchedCount'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'bidAmount': bidAmount,
      'completionTimeExcepted': completionTimeExcepted,
      'technicalMatchedCount': technicalMatchedCount,
    };
  }
}
