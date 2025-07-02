import 'package:driver/blocs/earning/bloc.dart';
import 'package:driver/blocs/earning/state.dart';
import 'package:driver/blocs/order/state.dart';
import 'package:driver/models/EarningsModel.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:driver/utils/const/app_string.dart';
import 'package:driver/utils/const/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../blocs/earning/event.dart';
import '../../widgets/graph_widget.dart';
import '../../widgets/app_text.dart';
import '../home/drawer.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<EarningsBloc>().add(LoadEarningsEvent());
    context.read<EarningsBloc>().add(RecentOrdersEvent());
    return Scaffold(
      drawer: CustomDrawer(
        userName: AppStrings.welcomeMessage.replaceFirst('{name}', 'user'),
        profileImage: AppImages.profile,
      ),
      body: BlocBuilder<EarningsBloc, EarningsState>(
        buildWhen:
            (previous, current) =>
                current is EarningsLoading || current is EarningsLoaded,
        builder: (context, state) {
          if (state is EarningsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EarningsLoaded) {
            final earnings = (state).earnings;

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 230,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColor.appColor,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(40),
                            bottomRight: Radius.circular(40),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 80),
                          _buildAppBar(context),
                          const SizedBox(height: 15),
                          AppText(
                            text:
                                '${DateFormat('dd MMM').format(DateTime.now().subtract(Duration(days: 30)))} - ${DateFormat('dd MMM').format(DateTime.now())}',
                            color: Colors.white70,
                          ),
                          const SizedBox(height: 8),
                          if (earnings != null) ...[
                            AppText(
                              text: "\$ ${earnings.totalEarnings.toString()}",
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                            ),
                            const SizedBox(height: 8),
                            _buildStatsRow(earnings),
                            EarningsGraph(earnings: earnings),
                          ],
                          const SizedBox(height: 16),
                          RecentOrdersHeader(),
                          const SizedBox(height: 8),
                          BlocBuilder<EarningsBloc, EarningsState>(
                            buildWhen:
                                (previous, current) =>
                                    current is RecentOrdersLoading ||
                                    current is RecentOrdersLoaded,
                            builder: (context, state) {
                              if (state is RecentOrdersLoaded && state.orders.bookings!.isNotEmpty) {
                                return ListView.separated(

                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.symmetric(horizontal: 18),
                                  itemCount: state.orders.bookings!.length,
                                  separatorBuilder:(context, index) {
                                    return SizedBox(height: 8,);
                                  },
                                  itemBuilder: (context, index) {
                                    final order = state.orders.bookings![index];
                                    return Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(
                                        color: AppColor.white,
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                        border: Border.all(color: AppColor.grey.withOpacity(0.3)),
                                      ),
                                      child: Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 40,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              color: AppColor.light_grey.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            padding: const EdgeInsets.all(8),
                                            child: Image.asset(
                                              AppImages.orderlisticon,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                AppText(
                                                  text: order.locationName ?? '',
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                                const SizedBox(height: 4),
                                                AppText(
                                                  text: "Order ID #${order.id?.substring(order.id!.length - 3) ?? ''}",
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                AppText(
                                                  text: "Date: ${DateFormat('dd MMM yyyy').format(order.date!)}",
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                                AppText(
                                                  text: "Time: ${order.formattedTime} ",
                                                  fontSize: 12,
                                                  color: Colors.grey,
                                                  fontWeight: FontWeight.w400,
                                                ),
                                              ],
                                            ),
                                          ),
                                          AppText(
                                            text: "\$${order.price ?? '--'}",
                                            color: AppColor.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ],
                                      ),
                                    );

                                  },
                                );
                              }
                              if (state is OrderLoadingStat) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return const Center(
                                child: AppText(
                                  text: "Orders not found",
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          }

          return const Center(child: Text("No data found"));
        },
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        Builder(
          builder:
              (context) => Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColor.lightGreen,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: IconButton(
                  icon: Image.asset(AppImages.menuicon),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                  color: AppColor.black,
                ),
              ),
        ),
        const Spacer(),
        // Title
        AppText(
          text: AppStrings.earnings,
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        const Spacer(),
        // Notification Icon
        Container(
          height: 45,
          width: 45,
          margin: const EdgeInsets.only(right: 20),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: AppColor.lightGreen,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Image.asset(AppImages.notificationimg),
        ),
      ],
    );
  }

  Widget _buildStatsRow(EarningsModel earnings) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: InfoCard(title: 'Orders', value: earnings.orders.toString()),
          ),
          Expanded(
            child: InfoCard(title: 'Online Time', value: earnings.onlineTime),
          ),
        ],
      ),
    );
  }
}

class RecentOrdersHeader extends StatelessWidget {
  final VoidCallback? onSeeAllTap;

  const RecentOrdersHeader({super.key, this.onSeeAllTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const AppText(
            text: "Recent orders",
            // Optionally replace with AppStrings.recentOrders
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          GestureDetector(
            onTap: onSeeAllTap,
            child: AppText(
              text: "See all", // Optionally replace with AppStrings.seeAll
              color: AppColor.appColor,
            ),
          ),
        ],
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;

  const InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Color(0xffF8F7Fb),
        borderRadius: BorderRadius.circular(5),
        boxShadow: [
          BoxShadow(
            color: AppColor.light_grey2,
            blurRadius: 5,
            spreadRadius: -1,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            text: title,
            color: AppColor.black,
            fontWeight: FontWeight.w600,
          ),
          AppText(
            text: value,
            color: AppColor.blue,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ],
      ),
    );
  }
}
