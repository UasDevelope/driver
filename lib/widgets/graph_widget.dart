import 'package:driver/models/EarningsModel.dart';
import 'package:driver/utils/const/app_color.dart';
import 'package:driver/widgets/app_text.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/earning/bloc.dart';
import '../blocs/earning/event.dart';

class EarningsGraph extends StatefulWidget {
  final EarningsModel earnings;
  const EarningsGraph({super.key, required this.earnings});

  @override
  _EarningsGraphState createState() => _EarningsGraphState();
}

class _EarningsGraphState extends State<EarningsGraph> {
  String? selectedPeriod;
  final List<String> toggleOptions = ['Day', 'Week', 'Month'];

  @override
  void initState() {
    super.initState();
    selectedPeriod = 'Day';
    context.read<EarningsBloc>().add(
        LoadEarningsEventPeriod(groupBy: selectedPeriod.toString().toLowerCase()));
  }

  @override
  Widget build(BuildContext context) {
    final graphData = widget.earnings.earningsGraph;

    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: ToggleButtons(
              borderRadius: BorderRadius.circular(20),
              fillColor: Colors.black87,
              selectedColor: Colors.white,
              color: Colors.black87,
              isSelected: ['Day', 'Week', 'Month']
                  .map((e) => e == selectedPeriod)
                  .toList(),
              onPressed: (index) {
                final newPeriod = ['Day', 'Week', 'Month'][index]; // 1. Store new value
                setState(() {
                  selectedPeriod = newPeriod;
                });
                context.read<EarningsBloc>().add(
                  LoadEarningsEventPeriod(groupBy: newPeriod.toLowerCase()),
                );
              },

              children: ['Day', 'Week', 'Month']
                  .map(
                    (e) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(e),
                ),
              )
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2500,
                minY: 0,
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  verticalInterval: 1,
                  getDrawingVerticalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [4, 4], // dotted vertical lines
                  ),
                  drawHorizontalLine: true,
                  horizontalInterval: 500,
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: AppColor.light_grey2,
                    strokeWidth: 1,
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index >= 0 && index < graphData.length) {
                          return AppText(
                          text:   graphData[index].label == DateFormat('yyyy-MM-dd').format(DateTime.now())
                                ? 'Today'
                                : graphData[index].label,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 500,
                    ),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                barGroups: graphData.asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,

                    barRods: [
                      BarChartRodData(
                        toY: data.amount,
                        color: Colors.blueAccent,
                        width: 16,
                        borderRadius: BorderRadius.circular(6),
                      )
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
          // const SizedBox(height: 20),
          //
          // // Detail button
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Color(0xff0D0140),
          //       padding: const EdgeInsets.symmetric(vertical: 14),
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //     ),
          //     onPressed: () {
          //       // Detail logic
          //     },
          //     child: const Text(
          //       "Detail",
          //       style: TextStyle(color: Colors.white, fontSize: 16),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}