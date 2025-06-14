import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class EarningsGraph extends StatefulWidget {
  @override
  _EarningsGraphState createState() => _EarningsGraphState();
}

class _EarningsGraphState extends State<EarningsGraph> {
  String selectedPeriod = 'Day';

  final barData = {
    'Mo': 1500.0,
    'Tu': 2100.0,
    'We': 800.0,
    'Th': 1500.0,
    'Fr': 2100.0,
    'Sa': 800.0,
    'Su': 1500.0,
  };

  @override
  Widget build(BuildContext context) {
    final dayKeys = barData.keys.toList();

    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(blurRadius: 8, color: Colors.black12)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Toggle buttons
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
                setState(() {
                  selectedPeriod = ['Day', 'Week', 'Month'][index];
                });
              },
              children: ['Day', 'Week', 'Month']
                  .map((e) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Text(e),
              ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 20),

          // Bar chart
          AspectRatio(
            aspectRatio: 1.7,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 2500,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index >= 0 && index < dayKeys.length) {
                          return Text(
                            dayKeys[index],
                            style: TextStyle(fontWeight: FontWeight.w500),
                          );
                        }
                        return Text('');
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
                barGroups: barData.entries.toList().asMap().entries.map((entry) {
                  final index = entry.key;
                  final data = entry.value;
                  return BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: data.value,
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
          const SizedBox(height: 20),

          // Detail button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff0D0140),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                // Detail logic
              },
              child: const Text(
                "Detail",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }
}
