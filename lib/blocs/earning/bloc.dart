import 'dart:developer';
import 'package:driver/blocs/earning/state.dart';
import 'package:driver/repositories/earnings_repository.dart';
import 'package:driver/repositories/recent_orders_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'event.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  EarningsRepository earningsRepo = EarningsRepository();
  RecentOrdersRepository recentOrdersRepo = RecentOrdersRepository();
  EarningsBloc() : super(EarningsInitial()) {
    on<LoadEarningsEvent>(fetchEarnings);
    on<LoadEarningsEventPeriod>(fetchEarningsPeriod);
    on<RecentOrdersEvent>(fetchOrders);
  }
  void fetchEarnings(LoadEarningsEvent event , Emitter<EarningsState> emit)async {
    emit(EarningsLoading());
    try {
      final earningsData = await earningsRepo.getEarnings(
        startDate: event.startDate,
        endDate: event.endDate,
        groupBy: event.groupBy,);
      emit(EarningsLoaded(earningsData));
    } catch (e) {
      log("Error here $e");
      rethrow;
    }
  }

  void fetchEarningsPeriod(LoadEarningsEventPeriod event , Emitter<EarningsState> emit)async {
    try {
      final earningsData = await earningsRepo.getEarnings(
        startDate: event.startDate,
        endDate: event.endDate,
        groupBy: event.groupBy,);
      emit(EarningsLoaded(earningsData));
    } catch (e) {
      log("Error here $e");
      rethrow;
    }
  }

  void fetchOrders(RecentOrdersEvent event , Emitter<EarningsState> emit)async {
    emit(RecentOrdersLoading());
    try {
      final orderData = await recentOrdersRepo.getRecentOrders();
      log("Orders data here : ${orderData.bookings!.length}");
      emit(RecentOrdersLoaded(orderData));
    } catch (e) {
      log("Error here $e");
      rethrow;
    }
  }
}
