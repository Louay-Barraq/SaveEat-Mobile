import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class OneInfoWidget extends StatelessWidget {
  final String title;
  final double percentageValue;
  final String timeValue;
  final int numberValue;
  final bool isPercentage;
  final bool isTime;

  const OneInfoWidget({
    super.key,
    required this.title,
    required this.percentageValue,
    required this.timeValue,
    required this.numberValue,
    required this.isPercentage,
    required this.isTime,
  });

  // This method returns the border color for the value's container.
  // - If isPercentage is false, it returns white.
  // - If isPercentage is true, it converts primaryValue (expected between 0 and 1)
  //   to a battery-level color from red (low percentage) to green (high percentage)
  Color _getBorderColor() {
    if (!isPercentage) {
      return Colors.white;
    } else {
      // Ensure that primaryValue is clamped between 0 and 1
      double percentage = percentageValue.clamp(0.0, 1.0);
      // Map percentage to a hue value (0 = red, 120 = green)
      double hue = percentage * 120;
      // Convert HSV to Color. Full saturation and brightness.
      return HSVColor.fromAHSV(1.0, hue, 1.0, 1.0).toColor();
    }
  }

  String _formatValue() {
    if (isPercentage) {
      // Format as percentage (0.67 → 67%)
      return '${(percentageValue * 100).toStringAsFixed(0)} %';
    } else if (isTime) {
      // Format as time-like string (e.g. 12.3456 and 34.5678 → "34:56")
      // final primary = primaryValue.toStringAsFixed(2).split('.')[1];
      // final secondary = secondaryValue.toStringAsFixed(2).split('.')[1];
      // return '$primary:$secondary';
      // OR THIS ONE : return DateFormat('HH:mm').format(DateTime.now());
      return timeValue;
    } else {
      return '$numberValue';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 130,
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
          // Title's box
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

          // Value's container
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              height: 50,
              width: 115,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: _getBorderColor(),
                  width: 2,
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
                  _formatValue(),
                  style: TextStyle(
                    fontFamily: 'Inconsolata',
                    fontWeight: (!isPercentage && !isTime) ? FontWeight.w400 : FontWeight.w300,
                    fontSize: 26,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
