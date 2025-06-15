
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// views/earnings_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../blocs/earning/bloc.dart';
import '../../blocs/earning/event.dart';
import '../../blocs/earning/state.dart';


class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => EarningsBloc()..add(LoadEarningsEvent()),
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: SafeArea(
          child: BlocBuilder<EarningsBloc, EarningsState>(
            builder: (context, state) {
              if (state is EarningsLoading) {
                return Center(child: CircularProgressIndicator());
              } else if (state is EarningsLoaded) {
                final data = state.earnings;

                return Column(
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.green.shade600,
                        borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text("Earnings", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          const Text("Jun 19 - Jun 25", style: TextStyle(color: Colors.white)),
                          const SizedBox(height: 10),
                          Text("\$${data.totalEarnings}", style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              infoBox("Orders", data.totalOrders.toString()),
                              infoBox("Online", data.totalOnlineTime),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Bar Chart
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          ToggleButtons(
                            isSelected: [true, false, false],
                            borderRadius: BorderRadius.circular(20),
                            children: const [
                              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Day")),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Week")),
                              Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text("Month")),
                            ],
                            onPressed: (_) {},
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 150,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: data.weekStats.entries.map((e) {
                                final height = e.value / 20; // scale down for display
                                return Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Container(height: height, width: 12, color: Colors.blue),
                                      const SizedBox(height: 4),
                                      Text(e.key, style: const TextStyle(fontSize: 12)),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Recent Orders
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: const Text("Recent orders", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Expanded(
                      child: ListView.builder(
                        itemCount: data.recentOrders.length,
                        itemBuilder: (_, i) {
                          final order = data.recentOrders[i];
                          return ListTile(
                            leading: const Icon(Icons.receipt_long_outlined),
                            title: Text("Order ${order.id}"),
                            subtitle: Text(order.date),
                            trailing: Text("+ \$${order.amount}", style: const TextStyle(fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ),
                  ],
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget infoBox(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

