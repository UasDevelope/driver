class OrderSummary {
  final String period;
  final String totalEarnings;
  final List<OrderStat> stats;
  final List<OrderDay> recentOrders;

  OrderSummary({
    required this.period,
    required this.totalEarnings,
    required this.stats,
    required this.recentOrders,
  });
}

class OrderStat {
  final String title;
  final String value;

  OrderStat({
    required this.title,
    required this.value,
  });
}

class OrderDay {
  final String date;
  final List<Order> orders;

  OrderDay({
    required this.date,
    required this.orders,
  });
}

class Order {
  final String id;
  final String price;

  Order({
    required this.id,
    required this.price,
  });
}