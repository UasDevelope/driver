import 'package:driver/models/recent_orders_model.dart';
import 'package:flutter/cupertino.dart';
import '../../models/EarningsModel.dart';

@immutable
abstract class EarningsState {
  const EarningsState();

  @override
  List<Object> get props => [];
}

class EarningsInitial extends EarningsState {
  const EarningsInitial();
}

class EarningsLoading extends EarningsState {
  const EarningsLoading();
}

class EarningsLoaded extends EarningsState {
  final EarningsModel earnings;
  const EarningsLoaded(this.earnings);
  @override
  List<Object> get props => [earnings];
}

class RecentOrdersInitial extends EarningsState {
  const RecentOrdersInitial();
}

class RecentOrdersLoading extends EarningsState {
  const RecentOrdersLoading();
}

class RecentOrdersLoaded extends EarningsState {
  final RecentOrdersModel orders;
  const RecentOrdersLoaded(this.orders);
  @override
  List<Object> get props => [orders];
}
