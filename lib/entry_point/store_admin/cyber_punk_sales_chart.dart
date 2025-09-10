import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:greenbiller/core/colors.dart';
import 'package:greenbiller/entry_point/model/dashboard_model.dart';
import 'package:intl/intl.dart';

class CyberpunkSalesChart extends StatelessWidget {
  final List<SalesData> salesData;

  const CyberpunkSalesChart({Key? key, required this.salesData})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: Colors.pinkAccent.withOpacity(0.2), strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: Colors.cyanAccent.withOpacity(0.2), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              getTitlesWidget: (value, meta) {
                return Text(
                  "₹${value ~/ 1000}k",
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                );
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                if (value.toInt() < 0 || value.toInt() >= salesData.length) {
                  return const SizedBox.shrink();
                }
                final date = salesData[value.toInt()].day;
                return Text(DateFormat("dd/MM").format(date));
              },
            ),
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(color: accentColor, width: 2),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: salesData.asMap().entries.map((e) {
              return FlSpot(e.key.toDouble(), e.value.amount);
            }).toList(),
            isCurved: true,
            gradient: const LinearGradient(
              colors: [secondaryColor, accentColor],
            ),
            barWidth: 4,
            isStrokeCapRound: true,
            belowBarData: BarAreaData(
              show: true,
              gradient: LinearGradient(
                colors: [
                secondaryColor.withOpacity(0.3),
                 accentColor.withOpacity(0.1),
                ],
              ),
            ),
            dotData: FlDotData(show: true),
          ),
        ],
      ),
    );
  }
}
