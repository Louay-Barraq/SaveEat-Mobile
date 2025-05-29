import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math' as math;

class WeeklyWasteChart extends StatelessWidget {
  final List<double> weeklyData; // Values for 7 days
  final List<String> labels; // Dynamic day labels

  const WeeklyWasteChart({
    super.key,
    required this.weeklyData,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 250, // Reduced height to prevent overflow
      width:
          MediaQuery.of(context).size.width - 32, // Explicit width constraint
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
          // Title box - matching DashboardStatsWidget style
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
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
                "Weekly Waste Chart",
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
              padding: const EdgeInsets.fromLTRB(8.0, 16.0, 8.0, 8.0),
              child: _buildChart(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // Clamp values between 0 and 100
    final clampedData = weeklyData
        .map((value) => math.min(math.max(value, 0), 100).toDouble())
        .toList();

    return LineChart(
      LineChartData(
        minY: 0,
        maxY: 100,
        minX: 0,
        maxX: 6,
        clipData: FlClipData.all(), // Clip data to prevent overflow
        titlesData: FlTitlesData(
          show: true,
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 25,
              reservedSize: 30, // Reduced from 40
              getTitlesWidget: (value, meta) => Text(
                '${value.toInt()}',
                style: const TextStyle(fontSize: 10), // Reduced from 12
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 25, // Reduced from 32
              interval: 1,
              getTitlesWidget: (value, meta) {
                if (value.toInt() != value ||
                    value < 0 ||
                    value >= labels.length) {
                  return const SizedBox.shrink();
                }

                final index = value.toInt();
                final label = index < labels.length ? labels[index] : '';

                return Padding(
                  padding: const EdgeInsets.only(top: 5.0), // Reduced from 8.0
                  child: Text(
                    label,
                    style: const TextStyle(fontSize: 10), // Reduced from 12
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
            spots: clampedData
                .asMap()
                .entries
                .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
                .toList(),
            isCurved: true,
            color: Color.alphaBlend(
                const Color.fromARGB(179, 255, 255, 255), Colors.blue),
            barWidth: 3, // Reduced from 4
            belowBarData: BarAreaData(
              show: true,
              color: Color.alphaBlend(
                  const Color.fromARGB(77, 255, 255, 255), Colors.blue),
            ),
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) =>
                  FlDotCirclePainter(
                radius: 3, // Reduced from 4
                color: Color.alphaBlend(
                    const Color.fromARGB(77, 255, 255, 255), Colors.blue),
                strokeWidth: 1, // Reduced from 2
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
                    fontSize: 12,
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
