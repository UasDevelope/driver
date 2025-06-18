import 'package:flutter/cupertino.dart';

import '../../models/EarningsModel.dart';

@immutable
abstract class EarningsState {
  const EarningsState();
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

  EarningsLoaded(this.earnings);
  List<Object> get props => [earnings];
}
