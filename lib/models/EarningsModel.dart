class EarningsModel {
  final double totalEarnings;
  final int orders;
  final String onlineTime;
  final List<EarningsGraphItem> earningsGraph;

  EarningsModel({
    required this.totalEarnings,
    required this.orders,
    required this.onlineTime,
    required this.earningsGraph,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      orders: json['orders'],
      onlineTime: json['onlineTime'],
      earningsGraph: (json['earningsGraph'] as List)
          .map((e) => EarningsGraphItem.fromJson(e))
          .toList(),
    );
  }
}

class EarningsGraphItem {
  final String label;
  final double amount;

  EarningsGraphItem({required this.label, required this.amount});

  factory EarningsGraphItem.fromJson(Map<String, dynamic> json) {
    return EarningsGraphItem(
      label: json['label'],
      amount: (json['amount'] as num).toDouble(),
    );
  }
}
