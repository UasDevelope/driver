import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class EarningsEvent extends Equatable {
  const EarningsEvent();
  @override
  List<Object?> get props=>[];
}

class LoadEarningsEvent extends EarningsEvent {
  final String? startDate;
  final String? endDate;
  final String groupBy;
  const LoadEarningsEvent({
    this.startDate,
    this.endDate,
    this.groupBy = 'day',
  });
  @override
  List<Object?> get props => [startDate, endDate, groupBy];

}

class LoadEarningsEventPeriod extends EarningsEvent {
  final String? startDate;
  final String? endDate;
  final String groupBy;

  const LoadEarningsEventPeriod ({
    this.startDate,
    this.endDate,
    this.groupBy = 'day',
  });
  @override
  List<Object?> get props => [startDate, endDate, groupBy];
}

class RecentOrdersEvent extends EarningsEvent{
  const RecentOrdersEvent();
}