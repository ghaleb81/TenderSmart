class ReportSummary {
  final int totalTenders;
  final int totalBids;
  final double averageBidsPerTender;
  final double avgBidPrice;
  final double maxBidPrice;
  final double minBidPrice;
  final double avgFinalScore;
  final List<TopContractor> topContractors;
  final List<WinnerTender> winners;

  ReportSummary({
    required this.totalTenders,
    required this.totalBids,
    required this.averageBidsPerTender,
    required this.avgBidPrice,
    required this.maxBidPrice,
    required this.minBidPrice,
    required this.avgFinalScore,
    required this.topContractors,
    required this.winners,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalTenders: json['totalTenders'],
      totalBids: json['totalBids'],
      averageBidsPerTender: (json['averageBidsPerTender'] ?? 0).toDouble(),
      avgBidPrice: (json['avgBidPrice'] ?? 0).toDouble(),
      maxBidPrice: (json['maxBidPrice'] ?? 0).toDouble(),
      minBidPrice: (json['minBidPrice'] ?? 0).toDouble(),
      avgFinalScore: (json['avgFinalScore'] ?? 0).toDouble(),
      topContractors:
          (json['topContractors'] as List)
              .map((e) => TopContractor.fromJson(e))
              .toList(),
      winners:
          (json['winners'] as List)
              .map((e) => WinnerTender.fromJson(e))
              .toList(),
    );
  }
}

class TopContractor {
  final String name;
  final int bidsCount;

  TopContractor({required this.name, required this.bidsCount});

  factory TopContractor.fromJson(Map<String, dynamic> json) {
    return TopContractor(
      name: json['user']?['name'] ?? 'غير معروف',
      bidsCount: json['bids_count'] ?? 0,
    );
  }
}

class WinnerTender {
  final String tenderTitle;
  final String contractorName;
  final double score;

  WinnerTender({
    required this.tenderTitle,
    required this.contractorName,
    required this.score,
  });

  factory WinnerTender.fromJson(Map<String, dynamic> json) {
    return WinnerTender(
      tenderTitle: json['tender_title'] ?? '',
      contractorName: json['contractor_user_name'] ?? '',
      score: (json['score'] ?? 0).toDouble(),
    );
  }
}
