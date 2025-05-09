import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class MonthlyWasteChart extends StatelessWidget {
  final List<double> weeklyData; // Values for 4 weeks (0-3)

  const MonthlyWasteChart({
    super.key,
    required this.weeklyData,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 300,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: const [
          BoxShadow(
            offset: Offset(0, 4),
            blurRadius: 4,
            spreadRadius: 0,
            color: Color(0x3F000000),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: 45,
            decoration: BoxDecoration(
              color: const Color(0xFFCCCCCC),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 4),
                  blurRadius: 4,
                  spreadRadius: 0,
                  color: Color(0x3F000000),
                ),
              ],
            ),
            child: const Center(
              child: Text(
                "Monthly Waste Chart",
                style: TextStyle(
                  fontFamily: 'Inconsolata',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          // Chart
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: _buildChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    final lineColor = Color.alphaBlend(const Color.fromARGB(179, 255, 255, 255),
        Colors.blue); // Match WeeklyWasteChart

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        minX: 0,
        maxX: 3,
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 40,
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() != value || value < 0 || value > 3) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    'Week ${value.toInt() + 1}',
                    style: const TextStyle(fontSize: 12),
                  ),
                );
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          horizontalInterval: 25,
          getDrawingHorizontalLine: (value) => FlLine(
            color: Color.alphaBlend(
                const Color.fromARGB(204, 255, 255, 255), Colors.grey),
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(
          show: true,
          border: Border.all(
              color: Color.alphaBlend(
                  const Color.fromARGB(179, 255, 255, 255), Colors.grey)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: weeklyData
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList(),
            isCurved: true,
            color: lineColor,
            barWidth: 4,
            belowBarData: BarAreaData(
              show: true,
              color: Color.alphaBlend(
                  const Color.fromARGB(77, 255, 255, 255), Colors.blue),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 4,
                color: Color.alphaBlend(
                    const Color.fromARGB(77, 255, 255, 255), Colors.blue),
                strokeWidth: 2,
                strokeColor: Colors.white,
              ),
            ),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                return LineTooltipItem(
                  '${spot.y.toStringAsFixed(1)}%',
                  const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
