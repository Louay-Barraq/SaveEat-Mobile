import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DashboardStatsWidget extends StatelessWidget {
  final String title;
  final double primaryValue;
  final double comparisonValue;
  final bool isPercentage;

  const DashboardStatsWidget({
    super.key,
    required this.title,
    required this.primaryValue,
    required this.comparisonValue,
    required this.isPercentage,
  });

  Color _getBorderColor() {
    if (isPercentage) {
      // Ensure that the difference is a valid number and clamp between 0 and 1
      double diff = primaryValue - comparisonValue;
      double percentage =
          (diff.isNaN || diff.isInfinite) ? 0.0 : diff.clamp(0.0, 1.0);
      // Map percentage to a hue value (0 = red, 120 = green)
      double hue = (percentage * 120).clamp(0.0, 120.0);
      return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    } else {
      double percentage = (primaryValue - comparisonValue).clamp(0.0, 1.0);
      double hue = (percentage * 120).clamp(0.0, 120.0);
      return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    }
  }

  String _formatValue(double value, bool isComparisonValue) {
    final formatter = NumberFormat();
    if (isPercentage && isComparisonValue) {
      formatter
        ..minimumFractionDigits = 0
        ..maximumFractionDigits = 1;
      return '${value > 0 ? '+ ' : ''}${formatter.format(value * 100)} %';
    } else if (isPercentage && !isComparisonValue) {
      formatter
        ..minimumFractionDigits = 0
        ..maximumFractionDigits = 1;
      return '${formatter.format(value * 100)} %';
    } else {
      formatter.maximumFractionDigits = 0;
      return formatter.format(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 130,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
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
          // Title's box
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            height: 45,
            width: double.infinity,
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
            child: Center(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Inconsolata',
                  fontWeight: FontWeight.w400,
                  fontSize: 24,
                ),
              ),
            ),
          ),

          // Values containers
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Primary Value Container
                  Container(
                    height: 50,
                    width: 115,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFFFFFFF),
                        width: 0.5,
                        strokeAlign: BorderSide.strokeAlignOutside,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 6,
                          spreadRadius: 0,
                          color: Color(0x3F000000),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _formatValue(primaryValue, false),
                        style: const TextStyle(
                          fontFamily: 'Inconsolata',
                          fontWeight: FontWeight.w300,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),

                  // Comparison Container
                  Container(
                    height: 50,
                    width: 115,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _getBorderColor(),
                        width: 2,
                        strokeAlign: BorderSide.strokeAlignInside,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 6,
                          spreadRadius: 0,
                          color: Color(0x3F000000),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _formatValue(comparisonValue, true),
                        style: TextStyle(
                          fontFamily: 'Inconsolata',
                          fontWeight: FontWeight.w300,
                          fontSize: 26,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
