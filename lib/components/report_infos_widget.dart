import 'package:flutter/material.dart';

class ReportInfosWidget extends StatelessWidget {
  final int tableNumber;
  final String reportTime;
  final double predictedPercentage;


  const ReportInfosWidget({
    super.key,
    required this.tableNumber,
    required this.reportTime,
    required this.predictedPercentage,
  });

  Color _getBorderColor() {
    // Ensure that primaryValue is clamped between 0 and 1
    double percentage = predictedPercentage.clamp(0.0, 1.0);
    // Map percentage to a hue value (0 = red, 120 = green)
    double hue = percentage * 120;
    // Convert HSV to Color. Full saturation and brightness.
    return HSVColor.fromAHSV(1.0, 120 - hue, 1.0, 1.0).toColor();
  }

  String _formatPercentageValue() {
    return '${(predictedPercentage * 100).toStringAsFixed(0)} %';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      height: 180,
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
      // Column that places the header on top of the two values' containers
      child: Column(
        children: [
          // Header's Container
          Container(
            margin: const EdgeInsets.only(right: 100),
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFEEEEEE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10),
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
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: "Table : ",
                      style: const TextStyle(
                        fontFamily: 'Inconsolata',
                        fontWeight: FontWeight.w400,
                        fontSize: 24,
                      ),
                    ),
                    TextSpan(
                      text: "$tableNumber",
                      style: const TextStyle(
                        fontFamily: 'Inconsolata',
                        fontWeight: FontWeight.w500,
                        fontSize: 24,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            // Row that contains the 2 values' boxes
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // The time container
                Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 25),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Color(0x3F000000),
                      ),
                    ],
                  ),
                  // Column that places the word "Time" on top of the value
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        child: Center(
                          child: Text(
                            "Time",
                            style: const TextStyle(
                              fontFamily: 'Inconsolata',
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          reportTime,
                          style: const TextStyle(
                            fontFamily: 'Inconsolata',
                            fontWeight: FontWeight.w200,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // The Percentage container
                Container(
                  // margin: const EdgeInsets.symmetric(horizontal: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  height: 100,
                  decoration: BoxDecoration(
                    color: Color(0xFFFFFFFF),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _getBorderColor(),
                      width: 3,
                      strokeAlign: BorderSide.strokeAlignOutside,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        offset: Offset(0, 2),
                        blurRadius: 4,
                        spreadRadius: 0,
                        color: Color(0x3F000000),
                      ),
                    ],
                  ),
                  // Column that places the word "Percentage" on top of the value
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 6),
                        child: Center(
                          child: Text(
                            "Percentage",
                            style: const TextStyle(
                              fontFamily: 'Inconsolata',
                              fontWeight: FontWeight.w500,
                              fontSize: 23,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          _formatPercentageValue(),
                          style: const TextStyle(
                            fontFamily: 'Inconsolata',
                            fontWeight: FontWeight.w200,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
