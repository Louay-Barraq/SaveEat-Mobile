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


        ],
      ),
    );
  }
}