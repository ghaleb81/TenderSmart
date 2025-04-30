class Bid {
  final double bid_amount;
  final int completion_time_excepted;
  final int technical_matched_count;

  Bid({
    required this.bid_amount,
    required this.completion_time_excepted,
    required this.technical_matched_count,
  });
}
