import 'package:equatable/equatable.dart';

import '../../models/order.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  List<Object> get props => [];
}

class OrderInitalStat extends OrderState {
  const OrderInitalStat();
  List<Object> get props => [];
}

class OrderLoadingStat extends OrderState {
  const OrderLoadingStat();
}

class OrderLoadedStat extends OrderState {
  final List<orderModels> orderModel;
  const OrderLoadedStat({required this.orderModel});
  List<Object> get props => [];
}

class OrderErrorStat extends OrderState {
  OrderErrorStat();
  List<Object> get props => [];
}
