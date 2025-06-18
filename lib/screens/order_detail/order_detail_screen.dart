import 'package:driver/utils/const/app_img.dart';
import 'package:driver/utils/const/app_string.dart';
import 'package:driver/utils/const/app_color.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../models/order_detail_model.dart';
import '../../widgets/graph_widget.dart';
import '../../widgets/app_text.dart';
import '../home/drawer.dart';

class OrderDetailsScreen extends StatelessWidget {
   OrderDetailsScreen({super.key});

  // Sample data - in a real app, this would come from an API or state management
  final OrderSummary orderSummary =  OrderSummary(
    period: "Jun 19 - Jun 25",
    totalEarnings: "\$2,144.06",
    stats: [
      OrderStat(title: AppStrings.orderPrefix, value: "123"),
      OrderStat(title: AppStrings.onlinePrefix, value: "23h 39m"),
    ],
    recentOrders: [
      OrderDay(
        date: "Saturday\n17/06/2023",
        orders: [
          Order(id: "123", price: "\$ 31.23"),
          Order(id: "567", price: "\$ 61.23"),
        ],
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(
        userName: AppStrings.welcomeMessage.replaceFirst('{name}', 'user'),
        profileImage: AppImages.profile,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 230,
                  width: 400,
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
                      text: orderSummary.period,
                      color: Colors.white70,
                    ),
                    const SizedBox(height: 8),
                    AppText(
                      text: orderSummary.totalEarnings,
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                    const SizedBox(height: 8),
                    _buildStatsRow(),
                    EarningsGraph(),
                    const SizedBox(height: 16),
                    _buildRecentOrdersHeader(),
                    const SizedBox(height: 8),
                    ...orderSummary.recentOrders.map((day) => OrderDayItem(day: day)).toList(),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 20),
        // Menu Button
        Builder(
          builder: (context) => Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              color: AppColor.lightGreen,
              borderRadius: BorderRadius.circular(15),
            ),
            child: IconButton(
              icon: Image.asset(AppImages.menuicon,),
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
          child: Image.asset(AppImages.notificationimg,),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const SizedBox(width: 20),
        ...orderSummary.stats.map((stat) => Expanded(
          child: InfoCard(title: stat.title, value: stat.value),
        )).toList(),
        const SizedBox(width: 20),
      ],
    );
  }

  Widget _buildRecentOrdersHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          AppText(
            text: "Recent orders", // Consider adding to AppStrings
            fontWeight: FontWeight.bold,
          ),
          const Spacer(),
          AppText(
            text: "See all", // Consider adding to AppStrings
            color: AppColor.appColor,
          ),
        ],
      ),
    );
  }
}

class OrderDayItem extends StatelessWidget {
  final OrderDay day;
  const OrderDayItem({required this.day});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColor.appColor.withOpacity(0.4),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  text: day.date,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.zero,
          itemCount: day.orders.length,
          separatorBuilder: (_, __) => Container(
            height: 1,
            width: 300,
            margin: const EdgeInsets.only(top: 10, bottom: 10),
            color: AppColor.light_grey.withOpacity(0.1),
          ),
          itemBuilder: (context, index) {
            final order = day.orders[index];
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
              child: Row(
                children: [
                  Image.asset(AppImages.orderlisticon,height: 20,),
                  const SizedBox(width: 8),
                  AppText(text: "${AppStrings.orderPrefix} #${order.id}"),
                  const Spacer(),
                  AppText(
                    text: order.price,
                    color: AppColor.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            );
          },
        ),
      ],
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