import 'package:flutter/material.dart';
import 'package:save_eat/components/dashboard_stats_widget.dart';
import 'package:save_eat/components/day_date_widget.dart';


class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  // Add the mixin

  @override
  bool get wantKeepAlive => true; // Required override for preservation

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 20),

          DayDateWidget(),

          const SizedBox(height: 20),

          DashboardStatsWidget(
            title: "Today's Waste",
            primaryValue: 0.32,
            comparisonValue: 0.2,
            isPercentage: true,
          ),

          const SizedBox(height: 20),

          DashboardStatsWidget(
            title: "Monitored Tables",
            primaryValue: 24,
            comparisonValue: 23,
            isPercentage: false,
          ),

          const SizedBox(height: 20),

          Container(
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
                      "Weekly Waste Chart",
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
                  child: Text("-")
                ),
              ],
            ),
          ),


        ],
      ),
    );
  }
}