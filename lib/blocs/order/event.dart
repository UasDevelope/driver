import 'package:equatable/equatable.dart';

abstract class OrderEvent extends Equatable {
  const OrderEvent();
  @override
  List<Object> get props => [];
}

class OrderLoadedEvent extends OrderEvent {
  final String endPoint;
  const OrderLoadedEvent(this.endPoint);
  @override
  List<Object> get props => [endPoint];
}
