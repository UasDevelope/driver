import 'dart:developer';
import 'package:driver/api/api_const.dart';
import 'package:driver/blocs/order/event.dart';
import 'package:driver/blocs/order/state.dart';
import 'package:driver/repositories/orders_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order.dart';


class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrdersRepository ordersRepo = OrdersRepository();
  OrderBloc() : super(OrderInitialStat()) {
    on<OrderLoadedEvent>(fetchOrders);
  }
  void fetchOrders(OrderLoadedEvent event, Emitter<OrderState> emit)async{
    emit(OrderLoadingStat());
    try {
      List<SimpleBooking> bookings = await ordersRepo.getBookings(event.endPoint);
      emit(OrderLoadedStat(bookings: bookings));
    } catch (e) {
      log("Error$e");
    }
  }
}
