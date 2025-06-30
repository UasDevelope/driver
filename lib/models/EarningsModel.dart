class EarningsModel {
  final double totalEarnings;
  final int totalOrders;
  final String totalOnlineTime;
  final Map<String, double> weekStats;
  final List<OrderModel> recentOrders;

  EarningsModel({
    required this.totalEarnings,
    required this.totalOrders,
    required this.totalOnlineTime,
    required this.weekStats,
    required this.recentOrders,
  });

  factory EarningsModel.fromJson(Map<String, dynamic> json) {
    return EarningsModel(
      totalEarnings: (json['totalEarnings'] as num).toDouble(),
      totalOrders: json['orders'],
      totalOnlineTime: json['onlineTime'],
      weekStats: Map<String, double>.from(json['weekStats']
          .map((key, value) => MapEntry(key, (value as num).toDouble()))),
      recentOrders: (json['recentOrders'] as List<dynamic>)
          .map((order) => OrderModel.fromJson(order as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalEarnings': totalEarnings,
      'orders': totalOrders,
      'onlineTime': totalOnlineTime,
      'weekStats': weekStats,
      'recentOrders': recentOrders.map((order) => order.toJson()).toList(),
    };
  }
}

class OrderModel {
  final String id;
  final String date;
  final double amount;

  OrderModel({
    required this.id,
    required this.date,
    required this.amount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      date: json['date'],
      amount: (json['amount'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'amount': amount,
    };
  }
}
