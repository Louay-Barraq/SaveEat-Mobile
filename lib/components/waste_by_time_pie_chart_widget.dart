import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WasteTimePieChart extends StatelessWidget {
  final double breakfastValue;
  final double lunchValue;
  final double dinnerValue;

  const WasteTimePieChart({
    super.key,
    required this.breakfastValue,
    required this.lunchValue,
    required this.dinnerValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 300, // Reset to original height
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
          // Title box (unchanged)
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
                "Waste by Time of Day",
                style: TextStyle(
                  fontFamily: 'Inconsolata',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  // Pie Chart (smaller)
                  Expanded(
                    flex: 3, // Takes 70% of available space
                    child: PieChart(
                      PieChartData(
                        startDegreeOffset: -90,
                        centerSpaceRadius: 40, // Reduced from 60
                        sectionsSpace: 2,
                        sections: _buildSections(context),
                        pieTouchData: PieTouchData(enabled: true),
                        borderData: FlBorderData(show: false),
                      ),
                    ),
                  ),
                  // Legend (smaller)
                  Expanded(
                    flex: 2, // Takes 30% of available space
                    child: _buildLegend(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4), // Reduced padding
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _LegendItem(
            color: Colors.orange[400]!,
            text: 'Breakfast',
            value: breakfastValue,
          ),
          const SizedBox(height: 4),
          _LegendItem(
            color: Colors.green[400]!,
            text: 'Lunch',
            value: lunchValue,
          ),
          const SizedBox(height: 4),
          _LegendItem(
            color: Colors.blue[400]!,
            text: 'Dinner',
            value: dinnerValue,
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _buildSections(BuildContext context) {
    return [
      PieChartSectionData(
        value: breakfastValue,
        color: Colors.orange[400],
        title: '${breakfastValue.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 14, // Reduced from 16
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Inconsolata',
        ),
        radius: 50, // Reduced from 60
      ),
      PieChartSectionData(
        value: lunchValue,
        color: Colors.green[400],
        title: '${lunchValue.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Inconsolata',
        ),
        radius: 50,
      ),
      PieChartSectionData(
        value: dinnerValue,
        color: Colors.blue[400],
        title: '${dinnerValue.toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Inconsolata',
        ),
        radius: 50,
      ),
    ];
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String text;
  final double value;

  const _LegendItem({
    required this.color,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12, // Reduced from 16
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6), // Reduced from 8
        Text(
          '$text: ${value.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontFamily: 'Inconsolata',
            fontSize: 12, // Reduced from 14
          ),
        ),
      ],
    );
  }
}
