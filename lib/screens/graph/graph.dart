import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../widgets/graph_widget.dart';

class EarningsScreen extends StatelessWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffdfdfe),
      drawer: Drawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Container(
                  height: 180,
                  width: 400,
                  decoration: BoxDecoration(color: Color(0xff7FBD42),
                  borderRadius: BorderRadius.only(bottomLeft: Radius.circular(40),bottomRight: Radius.circular(40))
                  ),
                ),
                Column(
                  children: [
                    SizedBox(height: 40),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 45,
                          width: 45,
                          margin: EdgeInsets.only(left: 20),
                          decoration: BoxDecoration(
                            color: Color(0xff99ca68),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(Icons.menu, color: Colors.white),
                        ),
                        Text(
                          "Earnings",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          height: 45,
                          width: 45,
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Color(0xff99ca68),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(
                            Icons.notifications_none,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    const Text(
                      "Jun 19 - Jun 25",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "\$2,144.06",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        SizedBox(width: 20,),
                        InfoCard(title: "Orders", value: "123"),
                        SizedBox(width: 20,),
                        InfoCard(title: "Online", value: "23h 39m"),
                        SizedBox(width: 20,),
                      ],
                    ),
                    EarningsGraph(),
                    const SizedBox(height: 16),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: [
                          Text(
                            "Recent orders",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Spacer(),
                          Text("See all", style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    OrderItem(
                      date: "Saturday\n17/06/2023",
                      orderList: [
                        OrderDetail(orderId: "#123", price: "\$ 31.23"),
                        OrderDetail(orderId: "#567", price: "\$ 61.23"),
                      ],
                    ),
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

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      x: x,
      barRods: [BarChartRodData(toY: y, width: 12, color: Colors.blue)],
    );
  }
}

class InfoCard extends StatelessWidget {
  final String title;
  final String value;
  const InfoCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 10,bottom: 10,left: 10,right: 10),
        decoration: BoxDecoration(
          color: Color(0xffF8F7FB),
          borderRadius: BorderRadius.circular(5)
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(title, style:  TextStyle(color: Colors.black,fontWeight: FontWeight.w600)),
            Text(
              value,
              style: const TextStyle(
                color: Color(0xff223A82),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderItem extends StatelessWidget {
  final String date;
  final List<OrderDetail> orderList;
  const OrderItem({required this.date, required this.orderList});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Color(0xff7FBD42).withOpacity(0.4),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(date, style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
        SizedBox(height: 10,),
        ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.all(0),
            itemBuilder: (BuildContext context,index){
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4,horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.receipt_long_outlined, size: 18),
                    const SizedBox(width: 8),
                    Text("Order ${orderList[index].orderId}"),
                    const Spacer(),
                    Text(
                      orderList[index].price,
                      style: const TextStyle(
                        color: Color(0xff223A82),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }, separatorBuilder: (BuildContext context,index){
          return Container(
            height: 1,
            width: 300,
            margin: EdgeInsets.only(top: 10,bottom: 10),
            color: Color(0xffF7F9FC),
          );
        }, itemCount: orderList.length)
      ],
    );
  }
}

class OrderDetail {
  final String orderId;
  final String price;

  OrderDetail({required this.orderId, required this.price});
}
