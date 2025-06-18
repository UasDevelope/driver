import 'dart:developer';

import 'package:driver/blocs/order/event.dart';
import 'package:driver/blocs/order/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../dummy/order.dart';
import '../../models/order.dart';
import '../home/event.dart';
import '../home/state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(OrderInitalStat()) {
    on<OrderLoadedEvent>((event, emit) {
      emit(OrderLoadingStat());
      try {
        DummyMaps dummyMaps = DummyMaps();
        final data =
            dummyMaps.homeOffers.map((e) => orderModels.fromMap(e)).toList();
        emit(OrderLoadedStat(orderModel: data));
      } catch (e) {
        log("Error$e");
      }
    });
  }
}
