import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

@immutable
abstract class HomeEvent extends Equatable {
  const HomeEvent();
  @override
  List<Object> get props => [];
}

class HomeLoadedEvent extends HomeEvent {
  const HomeLoadedEvent();
  List<Object> get props => [];
}
class HomeAcceptJobEvent extends HomeEvent{
  final String bookingId;
  const HomeAcceptJobEvent(this.bookingId);
  List<Object> get props=>[bookingId];
}
class FetchLocationDetailsEvent extends HomeEvent {
  final double latitude;
  final double longitude;

  const FetchLocationDetailsEvent({required this.latitude, required this.longitude});
}

class DriverLocationUpdatedEvent extends HomeEvent {
  final String userId;
  final double latitude;
  final double longitude;
  final String? eta;
  final String? timestamp;
  DriverLocationUpdatedEvent({
    required this.userId,
    required this.latitude,
    required this.longitude,
    this.eta,
    this.timestamp,
  });
  @override
  List<Object> get props => [userId, latitude, longitude, eta ?? '', timestamp ?? ''];
}