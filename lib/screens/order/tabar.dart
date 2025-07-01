import 'package:driver/screens/home/drawer.dart';
import 'package:driver/screens/order/completed_order.dart';
import 'package:driver/screens/order/in_progress_order.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils/const/app_color.dart';
import '../../utils/const/app_string.dart';
import '../home/home.dart';
import 'pending_order.dart';

class TabarScreen extends StatelessWidget {
  const TabarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer:CustomDrawer(userName: "userName", profileImage: AppImages.profile),
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: Builder(
            builder:
                (context) => Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed:
                    () => Scaffold.of(context).openDrawer(),
                color: Colors.black,
              ),
            ),
          ),
          title: Text("👋 Welcome back, Frank!"),
          bottom: TabBar(
            isScrollable: false,
            labelColor: AppColor.appColor,
            automaticIndicatorColorAdjustment: true,
            indicatorColor: AppColor.blue,
            labelStyle: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),
            unselectedLabelColor: AppColor.blue,
            unselectedLabelStyle:  TextStyle(fontWeight: FontWeight.w900,fontSize: 14),
            dividerColor: Colors.white,
            tabs: [
              Tab(text: AppStrings.statusPending),
              Tab(text: AppStrings.statusInProgress),
              Tab(text: AppStrings.statusCompleted),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            PendingOrdersScreen(),
            InProgressOrdersScreen(),
            CompletedOrdersScreen(),
          ],
        ),
      ),
    );
  }
}
