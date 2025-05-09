import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WasteTimePieChart extends StatefulWidget {
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
  State<WasteTimePieChart> createState() => _WasteTimePieChartState();
}

class _WasteTimePieChartState extends State<WasteTimePieChart>
    with SingleTickerProviderStateMixin {
  int? touchedIndex;
  late AnimationController _controller;
  late Animation<double> _pieOffsetAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _pieOffsetAnim = Tween<double>(begin: 0, end: 1)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSectionTouch(int? index) {
    setState(() {
      if (index != null && index >= 0 && index < 3) {
        touchedIndex = index;
        _controller.forward();
      } else {
        touchedIndex = null;
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final values = [
      widget.breakfastValue,
      widget.lunchValue,
      widget.dinnerValue
    ];
    final names = ['Breakfast', 'Lunch', 'Dinner'];
    final colors = [
      const Color(0xFFfbbc04), // Google yellow
      const Color(0xFF34a853), // Google green
      const Color(0xFF4285f4), // Google blue
    ];

    return GestureDetector(
      onLongPressUp: () => _onSectionTouch(null), // Always reset on release
      onTapUp: (_) => _onSectionTouch(null), // Also reset on tap release
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 340,
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
              child: AnimatedBuilder(
                animation: _pieOffsetAnim,
                builder: (context, child) {
                  return Row(
                    children: [
                      // Pie chart (centered or shifted left)
                      Expanded(
                        flex: touchedIndex == null ? 10 : 7,
                        child: Align(
                          alignment: touchedIndex == null
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: PieChart(
                            PieChartData(
                              startDegreeOffset: -90,
                              centerSpaceRadius: touchedIndex != null ? 30 : 40,
                              sectionsSpace: 2,
                              sections: _buildSections(colors, names, values),
                              pieTouchData: PieTouchData(
                                enabled: true,
                                touchCallback: (event, response) {
                                  final idx = response
                                      ?.touchedSection?.touchedSectionIndex;
                                  _onSectionTouch(idx);
                                },
                              ),
                              borderData: FlBorderData(show: false),
                            ),
                          ),
                        ),
                      ),
                      // Add horizontal space and details only if holding and animation is completed
                      if (touchedIndex != null &&
                          _controller.status == AnimationStatus.completed)
                        const SizedBox(width: 18),
                      if (touchedIndex != null &&
                          _controller.status == AnimationStatus.completed)
                        Expanded(
                          flex: 6,
                          child: AnimatedOpacity(
                            opacity: touchedIndex != null ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 200),
                            child: _buildCenterDisplay(names, values, colors),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
            // Legend below the chart
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    3,
                    (i) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _LegendItem(
                        color: colors[i],
                        text: names[i],
                        value: values[i],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> _buildSections(
      List<Color> colors, List<String> names, List<double> values) {
    return List.generate(3, (i) {
      final isTouched = touchedIndex == i;
      final baseColor = colors[i];
      final sectionColor = touchedIndex == null
          ? baseColor
          : (isTouched
              ? baseColor
              : Color.alphaBlend(Colors.white.withOpacity(0.7), baseColor));
      return PieChartSectionData(
        value: values[i],
        color: sectionColor,
        title: isTouched ? '' : '${values[i].toStringAsFixed(1)}%',
        titleStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontFamily: 'Inconsolata',
        ),
        radius: isTouched ? 60 : 50,
        titlePositionPercentageOffset: 0.6,
        showTitle: true,
        badgeWidget: null,
      );
    });
  }

  Widget _buildCenterDisplay(
      List<String> names, List<double> values, List<Color> colors) {
    if (touchedIndex == null) return const SizedBox.shrink();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: colors[touchedIndex!],
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              names[touchedIndex!],
              style: const TextStyle(
                fontFamily: 'Inconsolata',
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          '${values[touchedIndex!].toStringAsFixed(1)}%',
          style: const TextStyle(
            fontFamily: 'Inconsolata',
            fontWeight: FontWeight.w500,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
      ],
    );
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
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text(
          '$text: ${value.toStringAsFixed(1)}%',
          style: const TextStyle(
            fontFamily: 'Inconsolata',
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
