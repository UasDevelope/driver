import 'package:driver/blocs/profile/profile_bloc.dart';
import 'package:driver/blocs/profile/profile_event.dart';
import 'package:driver/blocs/profile/profile_state.dart';
import 'package:driver/screens/home/drawer.dart';
import 'package:driver/utils/const/app_img.dart';
import 'package:driver/utils/const/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/api_const.dart';
import '../../utils/const/app_color.dart';
import 'orders_screen.dart';

class TabarScreen extends StatelessWidget {
  const TabarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<ProfileBloc>().add(GetProfileEvent());
    
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        drawer:
            CustomDrawer(userName: "userName", profileImage: AppImages.profile),
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          leading: Builder(
            builder: (context) => Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
                color: Colors.black,
              ),
            ),
          ),
          title: BlocBuilder<ProfileBloc, ProfileState>(
            builder: (context, state) {
              if (state is ProfileLoaded) {
                return Text("👋 Welcome back, ${state.profile.user.fullName}!");
              } else {
                return Text("👋 Welcome back!");
              }
            },
          ),
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppColor.appColor,
            automaticIndicatorColorAdjustment: true,
            indicatorColor: AppColor.blue,
            labelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            unselectedLabelColor: AppColor.blue,
            unselectedLabelStyle:
                TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
            dividerColor: Colors.white,
            tabs: [
              Tab(text: AppStrings.statusPending),
              Tab(text: AppStrings.statusSubmitted),
              Tab(text: AppStrings.statusRejected),
              Tab(text: AppStrings.statusInProgress),
              Tab(text: AppStrings.statusCompleted),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            OrdersScreen(
              endPoint: ApiConstants.pendingBookings,
              isPending: true,
            ),
            OrdersScreen(
              endPoint: ApiConstants.submittedBookings,
              isPending: false,
            ),
            OrdersScreen(
              endPoint: ApiConstants.rejectedBookings,
              isPending: false,
            ),
            OrdersScreen(
              endPoint: ApiConstants.inProgressBookings,
              isPending: false,
              isProgress: true,
            ),
            OrdersScreen(
                endPoint: ApiConstants.completedBookings, isPending: false),
          ],
        ),
      ),
    );
  }
}
