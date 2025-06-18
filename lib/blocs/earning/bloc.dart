import 'package:driver/blocs/earning/state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/EarningsModel.dart';
import 'event.dart';

class EarningsBloc extends Bloc<EarningsEvent, EarningsState> {
  EarningsBloc() : super(EarningsInitial()) {
    on<LoadEarningsEvent>((event, emit) async {
      emit(EarningsLoading());

      // Dummy map data
      await Future.delayed(Duration(seconds: 1)); // Simulate network delay

      final data = EarningsModel(
        totalEarnings: 2144.06,
        totalOrders: 123,
        totalOnlineTime: '23h 39m',
        weekStats: {
          'Mo': 1500,
          'Tu': 2200,
          'We': 700,
          'Th': 1600,
          'Fr': 2100,
          'Sa': 800,
          'Su': 1500,
        },
        recentOrders: [
          OrderModel(id: '#123', date: '17/06/2023', amount: 31.23),
          OrderModel(id: '#567', date: '17/06/2023', amount: 61.23),
        ],
      );

      emit(EarningsLoaded(data));
    });
  }
}
