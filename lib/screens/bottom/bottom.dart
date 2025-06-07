import 'package:driver/screens/bottom/widget/custom_bottom.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import '../../blocs/nav/bloc.dart';
import '../../blocs/nav/event.dart';
import '../../blocs/nav/state.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> screens = [
      Center(child: Text("Home")),
      Center(child: Text("Booking")),
      Center(child: Text("Chat")),
      Center(child: Text("Setting")),
    ];

    return BlocBuilder<NavBloc, NavState>(
      builder: (context, state) {
        int currentIndex = 0;
        if (state is ChangeIndexStat) currentIndex = state.index;

        return Scaffold(
          body: screens[currentIndex],
          bottomNavigationBar: CustomBottomNavBar(
            selectedIndex: currentIndex,
            onTap: (index) {
              context.read<NavBloc>().add(ChangeIndex(Index: index));
            },
          ),
        );
      },
    );
  }
}
