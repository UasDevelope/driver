// models/earnings_model.dart

class EarningsModel {
  final double totalEarnings;
  final int totalOrders;
  final String totalOnlineTime;
  final Map<String, double> weekStats; // {'Mon': 1200, 'Tue': 2000, ...}
  final List<OrderModel> recentOrders;

  EarningsModel({
    required this.totalEarnings,
    required this.totalOrders,
    required this.totalOnlineTime,
    required this.weekStats,
    required this.recentOrders,
  });
}

class OrderModel {
  final String id;
  final String date;
  final double amount;

  OrderModel({required this.id, required this.date, required this.amount});
}
