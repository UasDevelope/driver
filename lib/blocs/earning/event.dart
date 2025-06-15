import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class EarningsEvent extends Equatable {
  const EarningsEvent();
  List<Object> get props=>[];
}

class LoadEarningsEvent extends EarningsEvent {
  const LoadEarningsEvent();
}