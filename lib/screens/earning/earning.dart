import 'package:driver/blocs/earning/bloc.dart';
import 'package:driver/blocs/earning/state.dart';
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
    // context.read<EarningsBloc>().add(RecentOrdersEvent());
    return Scaffold(
      drawer: CustomDrawer(
        userName: AppStrings.welcomeMessage.replaceFirst('{name}', 'user'),
        profileImage: AppImages.profile,
      ),
      body: BlocBuilder<EarningsBloc, EarningsState>(
        builder: (context, state) {
          final earningsLoaded = state is EarningsLoaded;
          final recentOrdersLoaded = state is RecentOrdersLoaded;
          final isLoading = state is EarningsLoading || state is RecentOrdersLoading;

          if (isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (earningsLoaded || recentOrdersLoaded) {
            final earnings = earningsLoaded ? (state).earnings : null;
            final orders = recentOrdersLoaded ? (state).orders : null;

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
                            text: '${DateFormat('dd MMM').format(DateTime.now().subtract(Duration(days: 30)))} - ${DateFormat('dd MMM').format(DateTime.now())}',
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
                          if (orders != null && orders.bookings != null && orders.bookings!.isNotEmpty)
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              padding: EdgeInsets.zero,
                              itemCount: orders.bookings!.length,
                              separatorBuilder: (_, __) => Container(
                                height: 1,
                                margin: const EdgeInsets.symmetric(vertical: 10),
                                color: AppColor.light_grey.withOpacity(0.1),
                              ),
                              itemBuilder: (context, index) {
                                final order = orders.bookings![index];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 4,
                                    horizontal: 16,
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        AppImages.orderlisticon,
                                        height: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      AppText(
                                        text: "${AppStrings.orderPrefix} #${order.id ?? ''}",
                                      ),
                                      const Spacer(),
                                      AppText(
                                        text: "\$${order.price ?? '--'}",
                                        color: AppColor.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            )
                          else
                            const Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text("No recent orders available."),
                              ),
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
