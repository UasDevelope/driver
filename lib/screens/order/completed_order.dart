import 'package:driver/api/api_const.dart';
import 'package:driver/blocs/order/bloc.dart';
import 'package:driver/blocs/order/event.dart';
import 'package:driver/blocs/order/state.dart';
import 'package:driver/screens/home/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../utils/const/app_img.dart';
import 'booking_card.dart';

class CompletedOrdersScreen extends StatelessWidget {
  const CompletedOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<OrderBloc>().add(
      OrderLoadedEvent(ApiConstants.completedBookings),
    );
    return Scaffold(
      drawer: CustomDrawer(userName: "Usama", profileImage: AppImages.profile),
      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  Widget _body() {
    return BlocBuilder<OrderBloc, OrderState>(
      builder: (context, state) {
        if (state is OrderLoadingStat) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is OrderLoadedStat) {
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: state.bookings.length,
            itemBuilder: (context, index) {
              final item = state.bookings[index];
              return BookingCard(item: item);
            },
          );
        }
        return const SizedBox();
      },
    );
  }
}
