import 'package:equatable/equatable.dart';
import '../../models/order.dart';

abstract class OrderState extends Equatable {
  const OrderState();
  @override
  List<Object> get props => [];
}

class OrderInitialStat extends OrderState {
  const OrderInitialStat();
  @override
  List<Object> get props => [];
}
class OrderLoadingStat extends OrderState {
  const OrderLoadingStat();
}
class OrderLoadedStat extends OrderState {
  final List<OrdersModel> bookings;
  const OrderLoadedStat({required this.bookings});
  @override
  List<Object> get props => [bookings];
}
class OrderErrorStat extends OrderState {
  const OrderErrorStat();
  List<Object> get props => [];
}